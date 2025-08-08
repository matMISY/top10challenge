import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/tier.dart';
import '../services/game_service.dart';
import '../services/ads_service.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  final AdsService _adsService = AdsService();
  
  GameState _gameState = GameState();
  List<Level> _levels = [];
  List<Tier> _tiers = [];
  bool _isLoading = true;
  bool _isWatchingAd = false;
  Timer? _lifeRecoveryTimer;
  Timer? _uiUpdateTimer;

  GameState get gameState => _gameState;
  List<Level> get levels => _levels;
  List<Tier> get tiers => _tiers;
  bool get isLoading => _isLoading;
  bool get isWatchingAd => _isWatchingAd;
  GameService get gameService => _gameService;

  GameProvider() {
    _initialize();
  }

  @override
  void dispose() {
    _lifeRecoveryTimer?.cancel();
    _uiUpdateTimer?.cancel();
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
      await _gameService.loseLife();
      _gameState = await _gameService.getGameState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error losing life: $e');
    }
  }

  Future<void> useHint() async {
    try {
      await _gameService.useHint();
      _gameState = await _gameService.getGameState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error using hint: $e');
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

  Future<void> addHints(int count) async {
    _gameState = _gameState.copyWith(
      hints: (_gameState.hints + count).clamp(0, 99),
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
        hints: (_gameState.hints + 2).clamp(0, 99), // +2 indices par jour
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
}
