import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/tier.dart';
import '../config/hint_config.dart';
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
    
    // Vérifier si le niveau n'est pas déjà complété
    final wasAlreadyCompleted = level.isCompleted;
    
    final updatedLevels = levels.map((l) {
      if (l.id == levelId) {
        return l.copyWith(isCompleted: true);
      }
      return l;
    }).toList();
    
    // Ne donner des récompenses que si le niveau n'était pas déjà complété
    int hintPointsGained = 0;
    int bonusPoints = 0;
    int bonusHints = 0;
    
    if (!wasAlreadyCompleted) {
      // Calculer les points d'indices gagnés selon la difficulté
      hintPointsGained = HintConfig.getPointsForDifficulty(level.difficulty);
      
      // Vérifier si c'est un niveau boss (5ème niveau du palier)
      final isBossLevel = level.positionInTier == 5;
      
      // Bonus pour les niveaux boss
      bonusPoints = isBossLevel ? 1 : 0;
      bonusHints = isBossLevel ? 5 : 0;
    }
    
    final updatedGameState = gameState.copyWith(
      completedLevels: wasAlreadyCompleted ? gameState.completedLevels : [...gameState.completedLevels, levelId],
      currentLevel: levelId + 1,
      hintPoints: (gameState.hintPoints + hintPointsGained + bonusHints).clamp(0, 999),
      totalPoints: gameState.totalPoints + (wasAlreadyCompleted ? 0 : level.pointsReward) + bonusPoints,
    );
    
    await saveLevels(updatedLevels);
    await saveGameState(updatedGameState);
    
    // Ajouter les points et vérifier les déblocages de paliers seulement si c'était la première complétion
    if (!wasAlreadyCompleted) {
      await _checkAndUnlockNewTiers();
      
      // Vérifier si le palier est complété
      await _checkTierCompletion(level.tierId);
    }
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

  Future<bool> useHintPoints(int levelId, int questionIndex, int hintLevel) async {
    final gameState = await getGameState();
    final levels = await getLevels();
    final cost = HintConfig.getHintCost(hintLevel);
    
    // Vérifier si le niveau est déjà complété
    final level = levels.firstWhere((l) => l.id == levelId, orElse: () => levels.first);
    final isLevelCompleted = level.isCompleted;
    
    // Si le niveau n'est pas complété, vérifier si le joueur a assez de points
    if (!isLevelCompleted && gameState.hintPoints < cost) {
      return false;
    }
    
    // Mettre à jour les niveaux d'indices pour cette question
    final updatedHintLevels = Map<int, Map<int, int>>.from(gameState.hintLevelsByLevel);
    if (!updatedHintLevels.containsKey(levelId)) {
      updatedHintLevels[levelId] = {};
    }
    updatedHintLevels[levelId]![questionIndex] = hintLevel;
    
    // Décrémenter les points seulement si le niveau n'est pas complété
    final updatedGameState = gameState.copyWith(
      hintPoints: isLevelCompleted ? gameState.hintPoints : gameState.hintPoints - cost,
      hintLevelsByLevel: updatedHintLevels,
    );
    
    await saveGameState(updatedGameState);
    return true;
  }
  
  Future<int> getHintLevelForQuestion(int levelId, int questionIndex) async {
    final gameState = await getGameState();
    return gameState.hintLevelsByLevel[levelId]?[questionIndex] ?? 0;
  }
  
  Future<void> clearHintLevelsForLevel(int levelId) async {
    final gameState = await getGameState();
    final updatedHintLevels = Map<int, Map<int, int>>.from(gameState.hintLevelsByLevel);
    updatedHintLevels.remove(levelId);
    
    final updatedGameState = gameState.copyWith(
      hintLevelsByLevel: updatedHintLevels,
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

  Future<void> saveRevealedHintsForLevel(int levelId, Map<int, String> hints) async {
    final gameState = await getGameState();
    final updatedRevealedHints = Map<int, Map<int, String>>.from(gameState.revealedHintsByLevel);
    updatedRevealedHints[levelId] = Map.from(hints);
    
    final updatedGameState = gameState.copyWith(
      revealedHintsByLevel: updatedRevealedHints,
    );
    
    await saveGameState(updatedGameState);
  }

  Future<Map<int, String>> getRevealedHintsForLevel(int levelId) async {
    final gameState = await getGameState();
    return Map<int, String>.from(gameState.revealedHintsByLevel[levelId] ?? {});
  }

  Future<void> clearRevealedHintsForLevel(int levelId) async {
    final gameState = await getGameState();
    final updatedRevealedHints = Map<int, Map<int, String>>.from(gameState.revealedHintsByLevel);
    updatedRevealedHints.remove(levelId);
    
    final updatedGameState = gameState.copyWith(
      revealedHintsByLevel: updatedRevealedHints,
    );
    
    await saveGameState(updatedGameState);
  }

  /// Récupère automatiquement les vies basé sur le temps écoulé
  Future<GameState> recoverLives() async {
    final gameState = await getGameState();
    final recoverableLives = gameState.getRecoverableLives();
    
    if (recoverableLives > 0) {
      final now = DateTime.now();
      // Ne pas récupérer au-delà de maxLives naturel (5), 
      // mais préserver les vies gagnées via publicités (jusqu'à 10)
      final maxRecoverable = gameState.lives > GameState.maxLives 
          ? gameState.lives  // Préserver les vies de publicité
          : GameState.maxLives;  // Récupération normale jusqu'à 5
      final newLives = (gameState.lives + recoverableLives).clamp(0, maxRecoverable);
      
      final updatedGameState = gameState.copyWith(
        lives: newLives,
        // Mettre à jour lastLifeLostTime pour éviter la récupération multiple
        lastLifeLostTime: newLives >= GameState.maxLives ? null : now,
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
    
    List<Tier> tiers;
    if (tiersJson != null) {
      final List<dynamic> tiersList = jsonDecode(tiersJson);
      tiers = tiersList.map((json) => Tier.fromJson(json)).toList();
    } else {
      tiers = await _getDefaultTiers();
    }
    
    // DIAGNOSTIC: Afficher les détails des tiers chargés
    debugPrint('🔍 [DIAGNOSTIC] Tiers chargés depuis le stockage:');
    for (final tier in tiers) {
      debugPrint('  - Tier ${tier.id}: "${tier.name}"');
      debugPrint('    * Coût: ${tier.unlockCost}');
      debugPrint('    * Niveaux: ${tier.levelIds}');
      debugPrint('    * Nombre de niveaux: ${tier.levelIds.length}');
      debugPrint('    * Débloqué: ${tier.isUnlocked}');
    }
    
    return tiers;
  }

  Future<void> saveTiers(List<Tier> tiers) async {
    final prefs = await SharedPreferences.getInstance();
    final tiersJson = jsonEncode(tiers.map((tier) => tier.toJson()).toList());
    await prefs.setString(_tiersKey, tiersJson);
  }

  Future<List<Tier>> _getDefaultTiers() async {
    return await DataLoaderService.loadTiers();
  }

  /// Charge les niveaux et tiers de manière synchronisée en préservant les états existants
  Future<void> loadLevelsAndTiersSync() async {
    final result = await DataLoaderService.loadAllQuizzesWithTiersAndUpdate();
    final newLevels = result['levels'] as List<Level>;
    final newTiers = result['tiers'] as List<Tier>;
    
    // Récupérer les niveaux existants pour préserver les états isCompleted et isUnlocked
    final existingLevels = await getLevels();
    final existingTiers = await getTiers();
    
    // Créer une map pour un accès rapide aux états existants
    final Map<int, Level> existingLevelMap = {
      for (final level in existingLevels) level.id: level
    };
    final Map<int, Tier> existingTierMap = {
      for (final tier in existingTiers) tier.id: tier
    };
    
    // Merger les nouveaux niveaux avec les états existants
    final mergedLevels = newLevels.map((newLevel) {
      final existingLevel = existingLevelMap[newLevel.id];
      if (existingLevel != null) {
        // Préserver isCompleted et isUnlocked de l'existant
        return newLevel.copyWith(
          isCompleted: existingLevel.isCompleted,
          isUnlocked: existingLevel.isUnlocked,
        );
      }
      return newLevel;
    }).toList();
    
    // Merger les nouveaux tiers avec les états existants
    final mergedTiers = newTiers.map((newTier) {
      final existingTier = existingTierMap[newTier.id];
      if (existingTier != null) {
        // Préserver isCompleted et isUnlocked de l'existant
        return newTier.copyWith(
          isCompleted: existingTier.isCompleted,
          isUnlocked: existingTier.isUnlocked,
        );
      }
      return newTier;
    }).toList();
    
    await saveLevels(mergedLevels);
    await saveTiers(mergedTiers);
    
    debugPrint('Synchronized ${mergedLevels.length} levels and ${mergedTiers.length} tiers (states preserved)');
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
    
    final cumulativeCost = _calculateCumulativeCost(tierId, tiers);
    return gameState.totalPoints >= cumulativeCost;
  }

  /// Calcule le coût cumulatif pour débloquer un tier
  int _calculateCumulativeCost(int targetTierId, List<Tier> allTiers) {
    int cumulativeCost = 0;
    
    // Trier les tiers par ID pour s'assurer de l'ordre correct
    final sortedTiers = allTiers.toList()..sort((a, b) => a.id.compareTo(b.id));
    
    debugPrint('🔍 [DIAGNOSTIC GAME] Calcul coût cumulatif pour Tier $targetTierId:');
    
    // Additionner les coûts de tous les tiers jusqu'au tier cible (inclus)
    for (final tier in sortedTiers) {
      if (tier.id <= targetTierId) {
        debugPrint('  - Tier ${tier.id}: coût individuel ${tier.unlockCost}, niveaux: ${tier.levelIds.length}');
        cumulativeCost += tier.unlockCost;
      } else {
        break; // Arrêter une fois qu'on dépasse le tier cible
      }
    }
    
    debugPrint('  - Coût cumulatif total: $cumulativeCost');
    return cumulativeCost;
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
      if (!gameState.unlockedTiers.contains(tier.id)) {
        // Utiliser le coût cumulatif au lieu du coût individuel
        final cumulativeCost = _calculateCumulativeCost(tier.id, tiers);
        if (gameState.totalPoints >= cumulativeCost) {
          debugPrint('🔓 Déblocage automatique du Tier ${tier.id} - Points: ${gameState.totalPoints} >= Coût cumulatif: $cumulativeCost');
          await unlockTier(tier.id);
        }
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

  /// Synchronise les niveaux débloqués avec les paliers débloqués
  /// Cette méthode assure que tous les niveaux appartenant à des paliers débloqués
  /// sont bien marqués comme isUnlocked = true
  Future<void> syncUnlockedLevelsWithTiers() async {
    final gameState = await getGameState();
    final levels = await getLevels();
    
    debugPrint('🔄 Synchronisation des niveaux avec les paliers débloqués: ${gameState.unlockedTiers}');
    
    bool needsUpdate = false;
    final updatedLevels = levels.map((level) {
      // Si le palier du niveau est débloqué mais le niveau ne l'est pas
      if (gameState.unlockedTiers.contains(level.tierId) && !level.isUnlocked) {
        debugPrint('🔓 Débloquage du niveau ${level.id} (palier ${level.tierId} débloqué)');
        needsUpdate = true;
        return level.copyWith(isUnlocked: true);
      }
      return level;
    }).toList();
    
    if (needsUpdate) {
      await saveLevels(updatedLevels);
      debugPrint('✅ Synchronisation des niveaux terminée');
    } else {
      debugPrint('✅ Synchronisation des niveaux: aucune mise à jour nécessaire');
    }
  }
}