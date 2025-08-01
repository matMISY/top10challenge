import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/tier.dart';
import 'data_loader_service.dart';
import 'migration_service.dart';

class GameService {
  static const String _gameStateKey = 'game_state';
  static const String _levelsKey = 'levels';
  static const String _tiersKey = 'tiers';

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
    
    final level = levels.firstWhere((l) => l.id == levelId);
    
    final updatedLevels = levels.map((l) {
      if (l.id == levelId) {
        return l.copyWith(isCompleted: true);
      }
      return l;
    }).toList();
    
    final updatedGameState = gameState.copyWith(
      completedLevels: [...gameState.completedLevels, levelId],
      currentLevel: levelId + 1,
      hints: (gameState.hints + level.difficulty).clamp(0, 99),
      totalPoints: gameState.totalPoints + level.pointsReward,
    );
    
    await saveLevels(updatedLevels);
    await saveGameState(updatedGameState);
    
    // Ajouter les points et vérifier les déblocages de paliers
    await _checkAndUnlockNewTiers();
    
    // Vérifier si le palier est complété
    await _checkTierCompletion(level.tierId);
  }

  Future<void> loseLife() async {
    final gameState = await getGameState();
    final now = DateTime.now();
    final updatedGameState = gameState.copyWith(
      lives: (gameState.lives - 1).clamp(0, 5),
      lastLifeLostTime: now,
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

  Future<void> saveFoundAnswersForLevel(int levelId, List<String> foundAnswers) async {
    final gameState = await getGameState();
    final updatedFoundAnswers = Map<int, List<String>>.from(gameState.foundAnswersByLevel);
    updatedFoundAnswers[levelId] = List.from(foundAnswers);
    
    final updatedGameState = gameState.copyWith(
      foundAnswersByLevel: updatedFoundAnswers,
    );
    
    await saveGameState(updatedGameState);
  }

  Future<List<String>> getFoundAnswersForLevel(int levelId) async {
    final gameState = await getGameState();
    return gameState.foundAnswersByLevel[levelId] ?? [];
  }

  Future<void> clearFoundAnswersForLevel(int levelId) async {
    final gameState = await getGameState();
    final updatedFoundAnswers = Map<int, List<String>>.from(gameState.foundAnswersByLevel);
    updatedFoundAnswers.remove(levelId);
    
    final updatedGameState = gameState.copyWith(
      foundAnswersByLevel: updatedFoundAnswers,
    );
    
    await saveGameState(updatedGameState);
  }

  /// Récupère automatiquement les vies basé sur le temps écoulé
  Future<GameState> recoverLives() async {
    final gameState = await getGameState();
    final recoverableLives = gameState.getRecoverableLives();
    
    if (recoverableLives > 0) {
      final updatedGameState = gameState.copyWith(
        lives: (gameState.lives + recoverableLives).clamp(0, GameState.maxLives),
      );
      await saveGameState(updatedGameState);
      return updatedGameState;
    }
    
    return gameState;
  }

  Future<List<Level>> _getDefaultLevels() async {
    return await DataLoaderService.loadAllQuizzes();
  }

  /// Initialise le jeu avec migration automatique
  Future<void> initializeWithMigration() async {
    await MigrationService.checkAndMigrate(this);
  }

  // Nouvelles méthodes pour la gestion des paliers

  Future<List<Tier>> getTiers() async {
    final prefs = await SharedPreferences.getInstance();
    final tiersJson = prefs.getString(_tiersKey);
    
    if (tiersJson != null) {
      final List<dynamic> tiersList = jsonDecode(tiersJson);
      return tiersList.map((json) => Tier.fromJson(json)).toList();
    }
    
    return await _getDefaultTiers();
  }

  Future<void> saveTiers(List<Tier> tiers) async {
    final prefs = await SharedPreferences.getInstance();
    final tiersJson = jsonEncode(tiers.map((tier) => tier.toJson()).toList());
    await prefs.setString(_tiersKey, tiersJson);
  }

  Future<List<Tier>> _getDefaultTiers() async {
    return await DataLoaderService.loadTiers();
  }

  Future<void> unlockTier(int tierId) async {
    final gameState = await getGameState();
    final tiers = await getTiers();
    
    if (!gameState.unlockedTiers.contains(tierId)) {
      final updatedGameState = gameState.copyWith(
        unlockedTiers: [...gameState.unlockedTiers, tierId],
      );
      
      final updatedTiers = tiers.map((tier) {
        if (tier.id == tierId) {
          return tier.copyWith(isUnlocked: true);
        }
        return tier;
      }).toList();
      
      await saveGameState(updatedGameState);
      await saveTiers(updatedTiers);
      
      // Débloquer tous les niveaux du palier
      await _unlockTierLevels(tierId);
    }
  }

  Future<void> _unlockTierLevels(int tierId) async {
    final levels = await getLevels();
    final updatedLevels = levels.map((level) {
      if (level.tierId == tierId) {
        return level.copyWith(isUnlocked: true);
      }
      return level;
    }).toList();
    await saveLevels(updatedLevels);
  }

  Future<bool> canUnlockTier(int tierId) async {
    final gameState = await getGameState();
    final tiers = await getTiers();
    
    final tier = tiers.firstWhere((t) => t.id == tierId, orElse: () => tiers.first);
    return gameState.totalPoints >= tier.unlockCost;
  }

  Future<bool> isTierUnlocked(int tierId) async {
    final gameState = await getGameState();
    return gameState.unlockedTiers.contains(tierId);
  }

  Future<void> addPoints(int points) async {
    final gameState = await getGameState();
    final updatedGameState = gameState.copyWith(
      totalPoints: gameState.totalPoints + points,
    );
    await saveGameState(updatedGameState);
    
    // Vérifier si de nouveaux paliers peuvent être débloqués
    await _checkAndUnlockNewTiers();
  }

  Future<void> _checkAndUnlockNewTiers() async {
    final gameState = await getGameState();
    final tiers = await getTiers();
    
    for (final tier in tiers) {
      if (!gameState.unlockedTiers.contains(tier.id) && 
          gameState.totalPoints >= tier.unlockCost) {
        await unlockTier(tier.id);
      }
    }
  }

  Future<void> _checkTierCompletion(int tierId) async {
    final gameState = await getGameState();
    final tiers = await getTiers();
    final levels = await getLevels();
    
    final tier = tiers.firstWhere((t) => t.id == tierId);
    final tierLevels = levels.where((l) => l.tierId == tierId).toList();
    
    // Vérifier si tous les niveaux du palier sont complétés
    final allCompleted = tierLevels.every((level) => 
        gameState.completedLevels.contains(level.id));
    
    if (allCompleted && !tier.isCompleted) {
      final updatedTiers = tiers.map((t) {
        if (t.id == tierId) {
          return t.copyWith(isCompleted: true);
        }
        return t;
      }).toList();
      
      await saveTiers(updatedTiers);
    }
  }
}