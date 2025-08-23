import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/tier.dart';
import '../config/hint_config.dart';
import '../services/game_service.dart';
import '../services/ads_service.dart';
import '../services/money_time_service.dart';
import '../services/feedback_service.dart';
import '../widgets/money_time_end_animation.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  final AdsService _adsService = AdsService();
  late final MoneyTimeService _moneyTimeService;
  
  GameState _gameState = GameState();
  List<Level> _levels = [];
  List<Tier> _tiers = [];
  bool _isLoading = true;
  bool _isWatchingAd = false;
  Timer? _lifeRecoveryTimer;
  Timer? _uiUpdateTimer;
  Timer? _autoSaveTimer;
  BuildContext? _context; // Pour les feedbacks

  GameState get gameState => _gameState;
  List<Level> get levels => _levels;
  List<Tier> get tiers => _tiers;
  bool get isLoading => _isLoading;
  bool get isWatchingAd => _isWatchingAd;
  GameService get gameService => _gameService;
  MoneyTimeService get moneyTimeService => _moneyTimeService;

  GameProvider() {
    _moneyTimeService = MoneyTimeService(
      adsService: _adsService,
      gameProvider: this,
    );
    _initialize();
  }

  @override
  void dispose() {
    _lifeRecoveryTimer?.cancel();
    _uiUpdateTimer?.cancel();
    _autoSaveTimer?.cancel();
    _moneyTimeService.dispose();
    _adsService.dispose();
    super.dispose();
  }

  /// Initialise AdMob en arrière-plan sans bloquer l'interface
  void _initializeAdsInBackground() {
    Future.microtask(() async {
      try {
        final adsStopwatch = Stopwatch()..start();
        await _adsService.initialize();
        adsStopwatch.stop();
        debugPrint('✅ Ads service initialized in background (${adsStopwatch.elapsedMilliseconds}ms)');
      } catch (adsError) {
        debugPrint('❌ Ads service failed to initialize in background: $adsError');
      }
    });
  }

  Future<void> _initialize() async {
    try {
      final stopwatch = Stopwatch()..start();
      debugPrint('🚀 Starting GameProvider initialization...');
      
      // Initialiser seulement les services critiques
      debugPrint('📂 Initializing critical services...');
      
      // Game service (critique pour l'affichage)
      await _gameService.initializeWithMigration();
      debugPrint('✅ Game service initialized');
      
      // Initialiser AdMob en arrière-plan (non bloquant)
      debugPrint('📺 Starting AdMob initialization in background...');
      _initializeAdsInBackground();
      
      debugPrint('📊 Loading game data...');
      final dataStopwatch = Stopwatch()..start();
      
      // Forcer une synchronisation complète pour s'assurer que les levelIds sont remplis
      final syncStopwatch = Stopwatch()..start();
      await _gameService.loadLevelsAndTiersSync();
      syncStopwatch.stop();
      debugPrint('⏱️ loadLevelsAndTiersSync took ${syncStopwatch.elapsedMilliseconds}ms');
      
      final loadStopwatch = Stopwatch()..start();
      await loadGameData();
      loadStopwatch.stop();
      debugPrint('⏱️ loadGameData took ${loadStopwatch.elapsedMilliseconds}ms');
      
      dataStopwatch.stop();
      debugPrint('✅ Game data loaded in ${dataStopwatch.elapsedMilliseconds}ms');
      
      // Récupérer les vies automatiquement au démarrage
      debugPrint('❤️ Recovering lives...');
      await _recoverLivesIfNeeded();
      debugPrint('✅ Lives recovered');
      
      // Démarrer le timer de récupération des vies
      debugPrint('⏰ Starting life recovery timer...');
      _startLifeRecoveryTimer();
      debugPrint('✅ Life recovery timer started');
      
      // Démarrer le timer de mise à jour de l'interface
      debugPrint('🔄 Starting UI update timer...');
      _startUIUpdateTimer();
      debugPrint('✅ UI update timer started');
      
      // Démarrer le timer d'auto-sauvegarde
      debugPrint('💾 Starting auto-save timer...');
      _startAutoSaveTimer();
      debugPrint('✅ Auto-save timer started');
      
      // Initialiser MoneyTimeService state
      debugPrint('💰 Initializing MoneyTimeService state...');
      _moneyTimeService.initializeFromState();
      debugPrint('✅ MoneyTimeService state initialized');
      
      // Vérifier la santé du Money Time
      debugPrint('🏥 Checking Money Time health...');
      await checkMoneyTimeHealth();
      debugPrint('✅ Money Time health check completed');
      
      _isLoading = false;
      notifyListeners();
      
      stopwatch.stop();
      debugPrint('🎉 GameProvider initialization complete in ${stopwatch.elapsedMilliseconds}ms!');
    } catch (e) {
      debugPrint('❌ Error initializing GameProvider: $e');
      debugPrint('📋 Stack trace: ${StackTrace.current}');
      _isLoading = false;
      notifyListeners();
      rethrow; // Re-throw to see the error in Flutter
    }
  }

  Future<void> loadGameData() async {
    _gameState = await _gameService.getGameState();
    _levels = await _gameService.getLevels();
    _tiers = await _gameService.getTiers();
    
    // Vérifier si les tiers ont leurs levelIds (nécessaire pour l'affichage)
    bool needsSync = _levels.isEmpty || _tiers.isEmpty || 
                     _tiers.any((tier) => tier.levelIds.isEmpty && _levels.any((level) => level.tierId == tier.id));
    
    if (needsSync) {
      debugPrint('GameProvider: Synchronizing levels and tiers...');
      // Charger et synchroniser les niveaux et tiers
      await _gameService.loadLevelsAndTiersSync();
      _levels = await _gameService.getLevels();
      _tiers = await _gameService.getTiers();
      debugPrint('GameProvider: Loaded ${_levels.length} levels in ${_tiers.length} tiers');
    }
  }

  Future<void> completeLevel(int levelId) async {
    try {
      await _gameService.completeLevel(levelId);
      await loadGameData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing level: $e');
    }
  }

  Future<void> loseLife() async {
    try {
      debugPrint('💔 GameProvider: Attempting to lose life');
      
      // Check if Money Time is active
      if (_gameState.isMoneyTimeActive()) {
        final remaining = _gameState.getMoneyTimeRemaining();
        debugPrint('💰 GameProvider: Money Time is active, preventing life loss. Remaining: $remaining');
        
        // Don't lose life, just show feedback
        if (_context != null) {
          FeedbackService.showMoneyTimeProtection(_context!);
        }
        
        // Double-check Money Time health after preventing life loss
        await checkMoneyTimeHealth();
        return;
      }
      
      debugPrint('💔 GameProvider: Money Time not active, proceeding with life loss');
      
      // Original life loss logic
      await _gameService.loseLife();
      _gameState = await _gameService.getGameState();
      
      debugPrint('💔 GameProvider: Life lost successfully. Lives remaining: ${_gameState.lives}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ GameProvider: Error losing life: $e');
      debugPrint('📋 Stack trace: ${StackTrace.current}');
      
      // Try to recover game state in case of error
      try {
        _gameState = await _gameService.getGameState();
        notifyListeners();
      } catch (recoveryError) {
        debugPrint('❌ GameProvider: Failed to recover game state: $recoveryError');
      }
    }
  }

  Future<bool> useHintPoints(int levelId, int questionIndex, int hintLevel) async {
    try {
      final success = await _gameService.useHintPoints(levelId, questionIndex, hintLevel);
      if (success) {
        _gameState = await _gameService.getGameState();
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('Error using hint points: $e');
      return false;
    }
  }
  
  Future<int> getHintLevelForQuestion(int levelId, int questionIndex) async {
    try {
      return await _gameService.getHintLevelForQuestion(levelId, questionIndex);
    } catch (e) {
      debugPrint('Error getting hint level: $e');
      return 0;
    }
  }
  
  Future<void> clearHintLevelsForLevel(int levelId) async {
    try {
      await _gameService.clearHintLevelsForLevel(levelId);
      _gameState = await _gameService.getGameState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing hint levels: $e');
    }
  }

  Future<void> resetGame() async {
    try {
      await _gameService.resetGame();
      await _initialize();
    } catch (e) {
      debugPrint('Error resetting game: $e');
    }
  }

  Level? getLevelById(int id) {
    try {
      return _levels.firstWhere((level) => level.id == id);
    } catch (e) {
      return null;
    }
  }

  bool isLevelUnlocked(int id) {
    final level = getLevelById(id);
    return level?.isUnlocked ?? false;
  }

  bool isLevelCompleted(int id) {
    final level = getLevelById(id);
    return level?.isCompleted ?? false;
  }

  int getCompletedLevelsCount() {
    return _levels.where((level) => level.isCompleted).length;
  }


  Future<void> addLives(int count) async {
    _gameState = _gameState.copyWith(
      lives: (_gameState.lives + count).clamp(0, GameState.maxLivesWithAds),
    );
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  Future<void> addHintPoints(int points) async {
    final actualPointsToAdd = HintConfig.getPointsToGain(_gameState.hintPoints, points);
    _gameState = _gameState.copyWith(
      hintPoints: (_gameState.hintPoints + actualPointsToAdd).clamp(0, HintConfig.maxHintPoints),
    );
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  Future<void> markDailyChallengeCompleted() async {
    _gameState = _gameState.copyWith(
      dailyChallengeCompleted: true,
      lastPlayedDate: DateTime.now(),
    );
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  bool canPlayDailyChallenge() {
    final now = DateTime.now();
    final lastPlayed = _gameState.lastPlayedDate;
    
    if (now.day != lastPlayed.day || 
        now.month != lastPlayed.month || 
        now.year != lastPlayed.year) {
      return true;
    }
    
    return !_gameState.dailyChallengeCompleted;
  }

  Future<void> checkDailyReset() async {
    final now = DateTime.now();
    final lastPlayed = _gameState.lastPlayedDate;
    
    if (now.day != lastPlayed.day || 
        now.month != lastPlayed.month || 
        now.year != lastPlayed.year) {
      _gameState = _gameState.copyWith(
        dailyChallengeCompleted: false,
        lives: 5,
        hintPoints: (_gameState.hintPoints + HintConfig.getPointsToGain(_gameState.hintPoints, 10)).clamp(0, HintConfig.maxHintPoints), // +10 points d'indices par jour
        lastPlayedDate: now,
      );
      await _gameService.saveGameState(_gameState);
      notifyListeners();
    }
  }

  /// Démarre le timer de récupération des vies (vérifie toutes les minutes)
  void _startLifeRecoveryTimer() {
    _lifeRecoveryTimer?.cancel();
    _lifeRecoveryTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _recoverLivesIfNeeded();
    });
  }

  /// Récupère les vies automatiquement si possible
  Future<void> _recoverLivesIfNeeded() async {
    try {
      final updatedGameState = await _gameService.recoverLives();
      if (updatedGameState.lives != _gameState.lives) {
        _gameState = updatedGameState;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error recovering lives: $e');
    }
  }

  /// Force la récupération des vies (utile pour les tests ou boutons manuels)
  Future<void> forceRecoverLives() async {
    await _recoverLivesIfNeeded();
  }

  /// Démarre le timer de mise à jour de l'interface (optimisé pour éviter le clignotement)
  void _startUIUpdateTimer() {
    _uiUpdateTimer?.cancel();
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Ne mettre à jour que si nécessaire pour les timers (vies et pubs)
      if (_shouldUpdateTimers()) {
        // Throttle les mises à jour pour éviter le clignotement
        final now = DateTime.now();
        if (_lastUIUpdate == null || 
            now.difference(_lastUIUpdate!) >= const Duration(seconds: 1)) {
          _lastUIUpdate = now;
          // Cette notification sera utilisée principalement pour les écrans
          // qui affichent les timers (écran principal)
          notifyListeners();
        }
      }
    });
  }
  
  /// Détermine si on doit mettre à jour les timers
  bool _shouldUpdateTimers() {
    // Mise à jour si on a besoin du timer des vies
    if (_gameState.lives < GameState.maxLives && _gameState.getTimeUntilNextLife() != null) {
      return true;
    }
    
    // Mise à jour si on a besoin du timer des pubs
    if (_gameState.lives < GameState.maxLives && 
        !canWatchAdForLife() && 
        getFormattedTimeUntilNextAd() != null) {
      return true;
    }
    
    return false;
  }
  
  DateTime? _lastUIUpdate;

  /// Retourne le temps formaté jusqu'à la prochaine vie
  String? getFormattedTimeUntilNextLife() {
    final timeUntilNext = _gameState.getTimeUntilNextLife();
    if (timeUntilNext == null) return null;
    
    final minutes = timeUntilNext.inMinutes;
    final seconds = timeUntilNext.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Retourne true si le timer de vie suivante doit être affiché
  bool shouldShowLifeTimer() {
    return _gameState.lives < GameState.maxLives && 
           _gameState.getTimeUntilNextLife() != null;
  }

  /// Regarde une publicité pour gagner une vie
  Future<bool> watchAdForLife() async {
    if (!_gameState.canWatchAdForLife() || _isWatchingAd) {
      debugPrint('Cannot watch ad: cooldown not ready or already watching');
      return false;
    }

    _isWatchingAd = true;
    notifyListeners();

    try {
      // Vérifier si une pub est disponible
      if (!_adsService.isRewardedAdReady) {
        debugPrint('No rewarded ad ready, trying to preload...');
        await _adsService.preloadRewardedAd();
        
        // Attendre un peu pour le chargement
        await Future.delayed(const Duration(seconds: 2));
        
        if (!_adsService.isRewardedAdReady) {
          debugPrint('Failed to load rewarded ad');
          return false;
        }
      }

      // Afficher la pub
      final bool rewardEarned = await _adsService.showRewardedAd();
      
      if (rewardEarned) {
        // Récompenser le joueur
        final now = DateTime.now();
        _gameState = _gameState.copyWith(
          lives: (_gameState.lives + GameState.livesPerAd).clamp(0, GameState.maxLivesWithAds), // Permet de dépasser le max avec les pubs
          lastAdWatchTime: now,
        );
        
        await _gameService.saveGameState(_gameState);
        debugPrint('✅ Player rewarded with 5 lifes from ad');
        
        return true;
      } else {
        debugPrint('❌ No reward earned from ad');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error watching ad: $e');
      return false;
    } finally {
      _isWatchingAd = false;
      notifyListeners();
    }
  }

  /// Vérifie si une pub peut être regardée pour gagner une vie
  bool canWatchAdForLife() {
    return _gameState.canWatchAdForLife() && !_isWatchingAd && _adsService.isRewardedAdReady;
  }

  /// Retourne le temps formaté jusqu'à la prochaine pub
  String? getFormattedTimeUntilNextAd() {
    final timeUntilNext = _gameState.getTimeUntilNextAd();
    if (timeUntilNext == null) return null;
    
    final minutes = timeUntilNext.inMinutes;
    final seconds = timeUntilNext.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  // =============================================
  // MÉTHODES POUR LES PUBLICITÉS D'INDICES
  // =============================================
  
  /// Regarde une publicité pour gagner des points d'indices
  Future<bool> watchAdForHints() async {
    if (!_gameState.canWatchAdForHints() || _isWatchingAd) {
      debugPrint('Cannot watch ad for hints: cooldown not ready or already watching');
      return false;
    }

    _isWatchingAd = true;
    notifyListeners();

    try {
      // Vérifier si une pub est disponible
      if (!_adsService.isRewardedAdReady) {
        debugPrint('No rewarded ad ready for hints, trying to preload...');
        await _adsService.preloadRewardedAd();
        
        // Attendre un peu pour le chargement
        await Future.delayed(const Duration(seconds: 2));
        
        if (!_adsService.isRewardedAdReady) {
          debugPrint('Failed to load rewarded ad for hints');
          return false;
        }
      }

      // Afficher la pub
      final bool rewardEarned = await _adsService.showRewardedAd();
      
      if (rewardEarned) {
        // Récompenser le joueur avec des points d'indices
        final now = DateTime.now();
        final actualPointsToAdd = HintConfig.getPointsToGain(_gameState.hintPoints, HintConfig.pointsPerAd);
        _gameState = _gameState.copyWith(
          hintPoints: (_gameState.hintPoints + actualPointsToAdd).clamp(0, HintConfig.maxHintPoints),
          lastHintAdWatchTime: now,
        );
        
        await _gameService.saveGameState(_gameState);
        debugPrint('✅ Player rewarded with $actualPointsToAdd hint points from ad');
        
        return true;
      } else {
        debugPrint('❌ No reward earned from hint ad');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error watching hint ad: $e');
      return false;
    } finally {
      _isWatchingAd = false;
      notifyListeners();
    }
  }

  /// Vérifie si une pub peut être regardée pour gagner des points d'indices
  bool canWatchAdForHints() {
    return _gameState.canWatchAdForHints() && !_isWatchingAd && _adsService.isRewardedAdReady;
  }

  /// Retourne le temps formaté jusqu'à la prochaine pub pour indices
  String? getFormattedTimeUntilNextHintAd() {
    final timeUntilNext = _gameState.getTimeUntilNextHintAd();
    if (timeUntilNext == null) return null;
    
    final minutes = timeUntilNext.inMinutes;
    final seconds = timeUntilNext.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // ========================================
  // PERSISTENCE AND AUTO-SAVE METHODS
  // ========================================

  /// Start auto-save timer for critical state preservation
  void _startAutoSaveTimer() {
    _autoSaveTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        await _performAutoSave();
      } catch (error) {
        debugPrint('❌ GameProvider: Auto-save failed: $error');
      }
    });
  }

  /// Perform automatic save if needed
  Future<void> _performAutoSave() async {
    // Only auto-save if Money Time is active or in activation progress
    if (_gameState.isMoneyTimeActive() || _moneyTimeService.isActivationInProgress) {
      debugPrint('💾 GameProvider: Auto-saving state (Money Time active)');
      await _emergencySaveState();
      
      // Also perform periodic health check
      _moneyTimeService.checkTimerHealth();
    }
  }

  /// Emergency save state with error handling
  Future<void> _emergencySaveState() async {
    try {
      await _gameService.saveGameState(_gameState);
      debugPrint('✅ GameProvider: Emergency save completed');
    } catch (error) {
      debugPrint('❌ GameProvider: Emergency save failed: $error');
      // Try again after a delay
      Future.delayed(Duration(seconds: 5), () async {
        try {
          await _gameService.saveGameState(_gameState);
          debugPrint('✅ GameProvider: Emergency save retry succeeded');
        } catch (retryError) {
          debugPrint('❌ GameProvider: Emergency save retry failed: $retryError');
        }
      });
    }
  }

  /// Robust save state with fallback mechanisms
  Future<bool> _robustSaveState() async {
    int retries = 3;
    Duration delay = Duration(milliseconds: 500);

    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        await _gameService.saveGameState(_gameState);
        debugPrint('✅ GameProvider: Robust save succeeded on attempt ${attempt + 1}');
        return true;
      } catch (error) {
        debugPrint('❌ GameProvider: Save attempt ${attempt + 1} failed: $error');
        
        if (attempt < retries - 1) {
          await Future.delayed(delay);
          delay *= 2; // Exponential backoff
        }
      }
    }
    
    debugPrint('❌ GameProvider: All save attempts failed');
    return false;
  }

  /// Force save critical Money Time state
  Future<void> forceSaveMoneyTimeState() async {
    debugPrint('🚨 GameProvider: Force saving Money Time state');
    final success = await _robustSaveState();
    
    if (!success) {
      debugPrint('🚨 GameProvider: Critical - Money Time state could not be saved!');
      // In a real app, you might want to show a critical error dialog here
    }
  }

  // ========================================
  // MONEY TIME METHODS
  // ========================================

  /// Set context for feedback messages (should be called from UI)
  void setContext(BuildContext? context) {
    _context = context;
  }

  /// Update Money Time progress during activation
  Future<void> updateMoneyTimeProgress(int adsWatched, int duration) async {
    _gameState = _gameState.copyWith(
      moneyTimeAdsWatched: adsWatched,
      selectedMoneyTimeDuration: duration,
    );
    
    // Use robust save for critical Money Time progress
    await _robustSaveState();
    notifyListeners();
  }

  /// Activate Money Time with given end time
  Future<void> activateMoneyTime(DateTime endTime) async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: endTime,
      lastMoneyTimeActivation: DateTime.now(),
      moneyTimeAdsWatched: 0,
    );
    
    // Critical save - Money Time activation is a key state change
    await forceSaveMoneyTimeState();
    
    // Show feedback if context is available
    if (_context != null) {
      FeedbackService.showMoneyTimeActivated(_context!, _gameState.selectedMoneyTimeDuration);
    }
    
    notifyListeners();
  }

  /// Activate free Money Time for first-time users
  Future<void> activateFreeMoneyTime(DateTime endTime) async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: endTime,
      hasUsedFreeMoneyTime: true,
      selectedMoneyTimeDuration: 30,
    );
    
    // Critical save - Free Money Time activation is a key state change
    await forceSaveMoneyTimeState();
    
    // Show feedback if context is available
    if (_context != null) {
      FeedbackService.showMoneyTimeActivated(_context!, 30);
    }
    
    notifyListeners();
  }

  /// Show Money Time warning (1 minute before end)
  void showMoneyTimeWarning() {
    if (_context != null) {
      FeedbackService.showMoneyTimeWarning(_context!);
    }
  }

  /// End Money Time
  Future<void> endMoneyTime() async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: null,
    );
    
    // Critical save - Money Time ending is important for cooldown
    await forceSaveMoneyTimeState();
    
    // Show end animation if context is available
    if (_context != null) {
      _showMoneyTimeEndAnimation();
    }
    
    notifyListeners();
  }

  /// Show Money Time end animation
  void _showMoneyTimeEndAnimation() {
    if (_context == null) return;
    
    // Create overlay for the animation
    final overlay = Overlay.of(_context!);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => MoneyTimeEndAnimation(
        onComplete: () {
          overlayEntry.remove();
          // Show standard feedback after animation
          FeedbackService.showMoneyTimeEnded(_context!);
        },
      ),
    );
    
    overlay.insert(overlayEntry);
  }

  /// Reset Money Time progress during activation
  void resetMoneyTimeProgress() {
    _gameState = _gameState.copyWith(
      moneyTimeAdsWatched: 0,
    );
    notifyListeners();
  }

  /// Start Money Time activation process (convenience method)
  /// Returns true if successfully activated, false otherwise
  Future<bool> startMoneyTimeActivation(int durationMinutes) async {
    try {
      debugPrint('🎯 GameProvider: Starting Money Time activation for $durationMinutes minutes');
      
      if (!_gameState.canActivateMoneyTime()) {
        final timeUntilAvailable = _gameState.getTimeUntilMoneyTimeAvailable();
        if (_context != null && timeUntilAvailable != null) {
          FeedbackService.showError(
            _context!,
            'Money Time disponible dans\n${_formatCooldownTime(timeUntilAvailable)}',
          );
        }
        return false;
      }

      final success = await _moneyTimeService.startActivationProcess(durationMinutes);
      
      if (!success && _context != null) {
        FeedbackService.showError(
          _context!,
          'Impossible de démarrer\nMoney Time.\nVérifiez votre connexion.',
        );
      }
      
      return success;
    } catch (error) {
      debugPrint('❌ GameProvider: Error starting Money Time activation: $error');
      if (_context != null) {
        FeedbackService.showError(
          _context!,
          'Erreur lors de l\'activation\nMoney Time',
        );
      }
      return false;
    }
  }

  /// Cancel Money Time activation if in progress
  void cancelMoneyTimeActivation() {
    try {
      debugPrint('❌ GameProvider: Cancelling Money Time activation');
      _moneyTimeService.cancelActivation();
      
      if (_context != null) {
        FeedbackService.showInfo(
          _context!,
          'Activation Money Time\nannulée',
        );
      }
    } catch (error) {
      debugPrint('❌ GameProvider: Error cancelling Money Time activation: $error');
    }
  }

  /// Check Money Time health and restore if needed
  Future<void> checkMoneyTimeHealth() async {
    try {
      final isActive = _gameState.isMoneyTimeActive();
      final remaining = _gameState.getMoneyTimeRemaining();
      
      debugPrint('🏥 GameProvider: Money Time health check - Active: $isActive, Remaining: $remaining');
      
      // Validate state consistency first
      if (!_moneyTimeService.validateState()) {
        debugPrint('⚠️ GameProvider: Invalid Money Time state detected, attempting recovery');
        await _recoverFromInvalidState();
        return;
      }
      
      if (isActive && remaining != null) {
        // Money Time should be active but service might not have timers
        if (remaining.isNegative) {
          debugPrint('⚠️ GameProvider: Money Time expired, ending it');
          await endMoneyTime();
        } else {
          // Ensure service is properly initialized
          debugPrint('🔄 GameProvider: Reinitializing Money Time service');
          _moneyTimeService.initializeFromState();
        }
      } else if (isActive && remaining == null) {
        // Inconsistent state - Money Time marked as active but no end time
        debugPrint('⚠️ GameProvider: Inconsistent Money Time state, cleaning up');
        await endMoneyTime();
      }
      
      // Check for edge case: activation stuck
      if (_moneyTimeService.isActivationInProgress) {
        final info = getMoneyTimeActivationInfo();
        if (info['currentAdsWatched'] >= info['targetAds']) {
          debugPrint('⚠️ GameProvider: Activation appears stuck, cleaning up');
          _moneyTimeService.cancelActivation();
        }
      }
    } catch (error) {
      debugPrint('❌ GameProvider: Error during Money Time health check: $error');
      await _handleHealthCheckError(error);
    }
  }

  /// Recover from invalid Money Time state
  Future<void> _recoverFromInvalidState() async {
    try {
      debugPrint('🔄 GameProvider: Attempting to recover from invalid state');
      
      // Cancel any ongoing activation
      _moneyTimeService.cancelActivation();
      
      // If Money Time claims to be active but has invalid data, clean it up
      if (_gameState.isMoneyTimeActive()) {
        final remaining = _gameState.getMoneyTimeRemaining();
        
        if (remaining == null || remaining.isNegative || _gameState.selectedMoneyTimeDuration <= 0) {
          debugPrint('🧹 GameProvider: Cleaning up invalid active Money Time');
          await endMoneyTime();
        } else {
          debugPrint('🔄 GameProvider: Reinitializing valid Money Time');
          _moneyTimeService.initializeFromState();
        }
      }
      
      // Reset any invalid progress
      if (_gameState.moneyTimeAdsWatched < 0 || _gameState.selectedMoneyTimeDuration <= 0) {
        debugPrint('🧹 GameProvider: Resetting invalid Money Time progress');
        resetMoneyTimeProgress();
      }
      
      debugPrint('✅ GameProvider: Recovery from invalid state completed');
    } catch (error) {
      debugPrint('❌ GameProvider: Error during state recovery: $error');
      // Last resort - force reset all Money Time data
      await _forceResetMoneyTime();
    }
  }

  /// Handle health check errors
  Future<void> _handleHealthCheckError(dynamic error) async {
    debugPrint('🚨 GameProvider: Handling health check error: $error');
    
    try {
      // Save current state before attempting recovery
      await _emergencySaveState();
      
      // Try to clean up Money Time state
      if (_gameState.isMoneyTimeActive()) {
        debugPrint('🧹 GameProvider: Ending Money Time due to health check error');
        await endMoneyTime();
      }
      
      // Reset service state
      _moneyTimeService.cancelActivation();
      
    } catch (recoveryError) {
      debugPrint('❌ GameProvider: Error during health check recovery: $recoveryError');
      await _forceResetMoneyTime();
    }
  }

  /// Force reset all Money Time state as last resort
  Future<void> _forceResetMoneyTime() async {
    debugPrint('🚨 GameProvider: Force resetting Money Time state');
    
    try {
      _gameState = _gameState.copyWith(
        moneyTimeEndTime: null,
        moneyTimeAdsWatched: 0,
        selectedMoneyTimeDuration: 30, // Reset to default
      );
      
      await _robustSaveState();
      notifyListeners();
      
      debugPrint('✅ GameProvider: Force reset completed');
    } catch (error) {
      debugPrint('❌ GameProvider: Error during force reset: $error');
    }
  }

  /// Handle app lifecycle changes for Money Time
  Future<void> handleAppLifecycleChange(AppLifecycleState state) async {
    try {
      debugPrint('🔄 GameProvider: App lifecycle changed to: $state');
      
      // Let MoneyTimeService handle its own lifecycle
      _moneyTimeService.handleAppLifecycleChange(state);
      
      switch (state) {
        case AppLifecycleState.resumed:
          // App came back to foreground
          debugPrint('▶️ GameProvider: App resumed, checking Money Time health');
          await checkMoneyTimeHealth();
          
          // Perform health check on timers
          _moneyTimeService.checkTimerHealth();
          break;
        case AppLifecycleState.paused:
          // App going to background - save state robustly
          debugPrint('⏸️ GameProvider: App paused, saving state');
          await forceSaveMoneyTimeState();
          break;
        case AppLifecycleState.inactive:
          // App briefly inactive (e.g., during ad display)
          debugPrint('⏸️ GameProvider: App inactive');
          break;
        case AppLifecycleState.detached:
          // App being terminated - final save
          debugPrint('⏹️ GameProvider: App detached, performing final save');
          await forceSaveMoneyTimeState();
          break;
        case AppLifecycleState.hidden:
          // App hidden
          debugPrint('🫥 GameProvider: App hidden');
          break;
      }
    } catch (error) {
      debugPrint('❌ GameProvider: Error handling app lifecycle change: $error');
    }
  }

  /// Helper method to format cooldown time
  String _formatCooldownTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      } else {
        return '${hours}h';
      }
    } else {
      return '${minutes}min';
    }
  }

  /// Get Money Time activation progress info
  Map<String, dynamic> getMoneyTimeActivationInfo() {
    return {
      'isInProgress': _moneyTimeService.isActivationInProgress,
      'currentAdsWatched': _moneyTimeService.currentAdsWatched,
      'targetAds': _moneyTimeService.targetAds,
      'selectedDuration': _moneyTimeService.selectedDuration,
      'progressPercentage': _moneyTimeService.targetAds > 0 
          ? (_moneyTimeService.currentAdsWatched / _moneyTimeService.targetAds * 100).round() 
          : 0,
    };
  }

  /// Test method to update game state directly (only for testing)
  @visibleForTesting
  void updateGameStateForTest(GameState newGameState) {
    _gameState = newGameState;
    notifyListeners();
  }
}
