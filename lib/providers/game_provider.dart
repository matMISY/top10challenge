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
    _moneyTimeService.dispose();
    _adsService.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      debugPrint('🚀 Starting GameProvider initialization...');
      
      // Initialiser avec migration automatique
      debugPrint('📂 Initializing game service...');
      await _gameService.initializeWithMigration();
      debugPrint('✅ Game service initialized');
      
      // Initialiser le service de publicités avec gestion d'erreur
      try {
        debugPrint('📺 Initializing ads service...');
        await _adsService.initialize();
        debugPrint('✅ Ads service initialized');
      } catch (adsError) {
        debugPrint('❌ Ads service failed to initialize: $adsError');
        // Continue without ads
      }
      
      debugPrint('📊 Loading game data...');
      await loadGameData();
      debugPrint('✅ Game data loaded');
      
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
      
      // Initialiser MoneyTimeService state
      debugPrint('💰 Initializing MoneyTimeService state...');
      _moneyTimeService.initializeFromState();
      debugPrint('✅ MoneyTimeService state initialized');
      
      _isLoading = false;
      notifyListeners();
      debugPrint('🎉 GameProvider initialization complete!');
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
    
    if (_levels.isEmpty) {
      _levels = await _gameService.getLevels();
      await _gameService.saveLevels(_levels);
    }
    
    if (_tiers.isEmpty) {
      _tiers = await _gameService.getTiers();
      await _gameService.saveTiers(_tiers);
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
      // Check if Money Time is active
      if (_gameState.isMoneyTimeActive()) {
        // Don't lose life, just show feedback
        if (_context != null) {
          FeedbackService.showInfo(
            _context!,
            'Money Time actif -\nPas de vie perdue! 💰',
          );
        }
        return;
      }
      
      // Original life loss logic
      await _gameService.loseLife();
      _gameState = await _gameService.getGameState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error losing life: $e');
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
      lives: (_gameState.lives + count).clamp(0, 10),
    );
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  Future<void> addHintPoints(int points) async {
    _gameState = _gameState.copyWith(
      hintPoints: (_gameState.hintPoints + points).clamp(0, 999),
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
        hintPoints: (_gameState.hintPoints + 10).clamp(0, 999), // +10 points d'indices par jour
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
          lives: (_gameState.lives + 5).clamp(0, 10), // Permet de dépasser le max avec les pubs
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
        _gameState = _gameState.copyWith(
          hintPoints: (_gameState.hintPoints + HintConfig.pointsPerAd).clamp(0, 999),
          lastHintAdWatchTime: now,
        );
        
        await _gameService.saveGameState(_gameState);
        debugPrint('✅ Player rewarded with ${HintConfig.pointsPerAd} hint points from ad');
        
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
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  /// Activate Money Time with given end time
  Future<void> activateMoneyTime(DateTime endTime) async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: endTime,
      lastMoneyTimeActivation: DateTime.now(),
      moneyTimeAdsWatched: 0,
    );
    
    // Show feedback if context is available
    if (_context != null) {
      final durationText = _gameState.selectedMoneyTimeDuration;
      FeedbackService.showSuccess(
        _context!,
        'Money Time activé\npour $durationText minutes! 💰',
      );
    }
    
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  /// Show Money Time warning (1 minute before end)
  void showMoneyTimeWarning() {
    if (_context != null) {
      FeedbackService.showWarning(
        _context!,
        'Money Time termine\ndans 1 minute!',
      );
    }
  }

  /// End Money Time
  Future<void> endMoneyTime() async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: null,
    );
    
    // Show feedback if context is available
    if (_context != null) {
      FeedbackService.showInfo(
        _context!,
        'Money Time terminé.\nProchain disponible\ndans 4h',
      );
    }
    
    await _gameService.saveGameState(_gameState);
    notifyListeners();
  }

  /// Reset Money Time progress during activation
  void resetMoneyTimeProgress() {
    _gameState = _gameState.copyWith(
      moneyTimeAdsWatched: 0,
    );
    notifyListeners();
  }

}
