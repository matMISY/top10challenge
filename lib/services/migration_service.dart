import 'package:flutter/foundation.dart';
import '../models/level.dart';
import '../models/tier.dart';
import 'game_service.dart';
import 'data_loader_service.dart';

class MigrationService {
  static const int _currentMigrationVersion = 1;

  /// Vérifie si une migration est nécessaire et l'exécute
  static Future<void> checkAndMigrate(GameService gameService) async {
    try {
      final currentVersion = await _getMigrationVersion(gameService);
      
      if (currentVersion < _currentMigrationVersion) {
        debugPrint('Migration nécessaire: version $currentVersion -> $_currentMigrationVersion');
        await _migrateToTierSystem(gameService);
        await _setMigrationVersion(gameService, _currentMigrationVersion);
        debugPrint('Migration terminée avec succès');
      }
    } catch (e) {
      debugPrint('Erreur lors de la migration: $e');
    }
  }

  /// Migre vers le système de paliers
  static Future<void> _migrateToTierSystem(GameService gameService) async {
    debugPrint('Début de la migration vers le système de paliers...');
    
    // 1. Sauvegarder l'état actuel
    final oldGameState = await gameService.getGameState();
    final oldLevels = await gameService.getLevels();
    
    debugPrint('État actuel: ${oldGameState.completedLevels.length} niveaux complétés');
    
    // 2. Charger les nouveaux niveaux organisés en paliers
    final newLevels = await DataLoaderService.loadAllQuizzesWithTiers();
    final tiers = await DataLoaderService.loadTiers();
    
    // 3. Calculer les points basés sur les niveaux complétés
    int totalPoints = 0;
    List<int> unlockedTiers = [1]; // Le premier palier est toujours débloqué
    
    // Calculer les points des niveaux complétés dans l'ancien système
    for (int levelId in oldGameState.completedLevels) {
      // Trouver le niveau correspondant dans l'ancien système
      final oldLevel = oldLevels.firstWhere(
        (l) => l.id == levelId,
        orElse: () => oldLevels.isNotEmpty ? oldLevels.first : Level(
          id: levelId,
          title: 'Niveau $levelId',
          hint: '',
          category: 'Migré',
          answers: [],
          difficulty: 1,
          tierId: 1,
          positionInTier: 1,
          pointsReward: 1,
        ),
      );
      
      // Attribuer les points basés sur la difficulté
      totalPoints += oldLevel.difficulty;
    }
    
    debugPrint('Points calculés: $totalPoints');
    
    // 4. Déterminer quels paliers peuvent être débloqués
    for (final tier in tiers) {
      if (totalPoints >= tier.unlockCost && !unlockedTiers.contains(tier.id)) {
        unlockedTiers.add(tier.id);
      }
    }
    
    debugPrint('Paliers débloqués: $unlockedTiers');
    
    // 5. Marquer les niveaux correspondants comme complétés dans le nouveau système
    List<Level> updatedLevels = [];
    List<int> newCompletedLevels = [];
    
    for (int i = 0; i < newLevels.length; i++) {
      final newLevel = newLevels[i];
      bool shouldBeCompleted = false;
      bool shouldBeUnlocked = unlockedTiers.contains(newLevel.tierId);
      
      // Si on a moins de niveaux complétés que de niveaux disponibles,
      // marquer les premiers comme complétés
      if (i < oldGameState.completedLevels.length) {
        shouldBeCompleted = true;
        newCompletedLevels.add(newLevel.id);
      }
      
      updatedLevels.add(newLevel.copyWith(
        isUnlocked: shouldBeUnlocked,
        isCompleted: shouldBeCompleted,
      ));
    }
    
    // 6. Marquer les paliers complétés comme complétés
    List<Tier> updatedTiers = [];
    for (final tier in tiers) {
      final tierLevels = updatedLevels.where((l) => l.tierId == tier.id).toList();
      final allTierLevelsCompleted = tierLevels.every((l) => l.isCompleted);
      
      updatedTiers.add(tier.copyWith(
        isUnlocked: unlockedTiers.contains(tier.id),
        isCompleted: allTierLevelsCompleted,
      ));
    }
    
    // 7. Créer le nouvel état de jeu
    final newGameState = oldGameState.copyWith(
      totalPoints: totalPoints,
      unlockedTiers: unlockedTiers,
      completedLevels: newCompletedLevels,
      currentLevel: newCompletedLevels.isNotEmpty 
          ? newCompletedLevels.last + 1 
          : 1,
    );
    
    // 8. Sauvegarder les nouvelles données
    await gameService.saveGameState(newGameState);
    await gameService.saveLevels(updatedLevels);
    await gameService.saveTiers(updatedTiers);
    
    debugPrint('Migration terminée:');
    debugPrint('- ${newCompletedLevels.length} niveaux marqués comme complétés');
    debugPrint('- ${unlockedTiers.length} paliers débloqués');
    debugPrint('- $totalPoints points attribués');
  }

  /// Récupère la version de migration actuelle
  static Future<int> _getMigrationVersion(GameService gameService) async {
    try {
      final gameState = await gameService.getGameState();
      // Pour l'instant, on utilise une logique simple: si totalPoints existe et > 0,
      // c'est qu'on a déjà migré
      return gameState.totalPoints > 0 ? _currentMigrationVersion : 0;
    } catch (e) {
      return 0;
    }
  }

  /// Définit la version de migration
  static Future<void> _setMigrationVersion(GameService gameService, int version) async {
    // Cette méthode pourrait sauvegarder une version dans les préférences
    // Pour l'instant, on considère que la migration est terminée si totalPoints > 0
    debugPrint('Migration version définie à: $version');
  }

  /// Réinitialise le système (pour les tests)
  static Future<void> resetMigration(GameService gameService) async {
    await gameService.resetGame();
    debugPrint('Migration réinitialisée');
  }
}