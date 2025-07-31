import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import 'data_loader_service.dart';

class GameService {
  static const String _gameStateKey = 'game_state';
  static const String _levelsKey = 'levels';

  Future<GameState> getGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final gameStateJson = prefs.getString(_gameStateKey);
    
    if (gameStateJson != null) {
      return GameState.fromJson(jsonDecode(gameStateJson));
    }
    
    return GameState();
  }

  Future<void> saveGameState(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameStateKey, jsonEncode(gameState.toJson()));
  }

  Future<List<Level>> getLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final levelsJson = prefs.getString(_levelsKey);
    
    if (levelsJson != null) {
      final List<dynamic> levelsList = jsonDecode(levelsJson);
      return levelsList.map((json) => Level.fromJson(json)).toList();
    }
    
    return await _getDefaultLevels();
  }

  Future<void> saveLevels(List<Level> levels) async {
    final prefs = await SharedPreferences.getInstance();
    final levelsJson = jsonEncode(levels.map((level) => level.toJson()).toList());
    await prefs.setString(_levelsKey, levelsJson);
  }

  Future<void> completeLevel(int levelId) async {
    final gameState = await getGameState();
    final levels = await getLevels();
    
    final updatedLevels = levels.map((level) {
      if (level.id == levelId) {
        return level.copyWith(isCompleted: true);
      }
      if (level.id == levelId + 1) {
        return level.copyWith(isUnlocked: true);
      }
      return level;
    }).toList();
    
    final updatedGameState = gameState.copyWith(
      completedLevels: [...gameState.completedLevels, levelId],
      score: gameState.score + (100 * levels.firstWhere((l) => l.id == levelId).difficulty),
      currentLevel: levelId + 1,
    );
    
    await saveLevels(updatedLevels);
    await saveGameState(updatedGameState);
  }

  Future<void> loseLife() async {
    final gameState = await getGameState();
    final updatedGameState = gameState.copyWith(
      lives: (gameState.lives - 1).clamp(0, 5),
    );
    await saveGameState(updatedGameState);
  }

  Future<void> useHint() async {
    final gameState = await getGameState();
    final updatedGameState = gameState.copyWith(
      hints: (gameState.hints - 1).clamp(0, 99),
    );
    await saveGameState(updatedGameState);
  }

  Future<void> resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameStateKey);
    await prefs.remove(_levelsKey);
  }

  Future<List<Level>> _getDefaultLevels() async {
    return await DataLoaderService.loadAllQuizzes();
  }
}