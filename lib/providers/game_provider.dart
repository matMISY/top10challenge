import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../services/game_service.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  
  GameState _gameState = GameState();
  List<Level> _levels = [];
  bool _isLoading = true;

  GameState get gameState => _gameState;
  List<Level> get levels => _levels;
  bool get isLoading => _isLoading;

  GameProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _gameState = await _gameService.getGameState();
      _levels = await _gameService.getLevels();
      
      if (_levels.isEmpty) {
        _levels = await _gameService.getLevels();
        await _gameService.saveLevels(_levels);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeLevel(int levelId) async {
    try {
      await _gameService.completeLevel(levelId);
      _gameState = await _gameService.getGameState();
      _levels = await _gameService.getLevels();
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
}