import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/level.dart';
import '../models/answer.dart';
import '../models/tier.dart';

class DataLoaderService {
  // Seed fixe pour garantir toujours le même ordre aléatoire
  static const int _shuffleSeed = 42;
  
  // Flag pour utiliser l'ordre personnalisé ou l'ordre déterministe original
  static bool useCustomOrder = true;

  /// Charge tous les quiz de tous les fichiers et les mélange de façon déterministe
  /// (Version mise à jour avec support des paliers)
  static Future<List<Level>> loadAllQuizzes() async {
    return await loadAllQuizzesWithTiers();
  }

  /// Charge les quiz dans l'ordre personnalisé depuis le fichier de configuration
  static Future<List<Level>> _loadCustomOrderedQuizzes() async {
    try {
      final String jsonString = await rootBundle.loadString('data/quiz_custom_order.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      if (!data.containsKey('custom_order_applied') || !data['custom_order_applied']) {
        debugPrint('Warning: Custom order not applied to quiz data');
      }
      
      final List<dynamic> quizzes = data['quizzes'] as List<dynamic>;
      List<Level> levels = [];
      
      for (int i = 0; i < quizzes.length; i++) {
        final quiz = quizzes[i] as Map<String, dynamic>;
        
        final List<dynamic> answersJson = quiz['answers'] as List<dynamic>;
        final List<Answer> answers = answersJson
            .map((answerJson) => Answer.fromJson(answerJson as Map<String, dynamic>))
            .toList();
        
        final level = Level(
          id: quiz['id'] as int? ?? (i + 1),
          title: quiz['title'] as String,
          hint: quiz['hint'] as String? ?? '',
          category: (quiz['theme'] ?? quiz['category']) as String,
          answers: answers,
          difficulty: quiz['difficulty'] as int,
          isUnlocked: false,
          isCompleted: false,
          tierId: quiz['tier_id'] as int,
          positionInTier: quiz['position_in_tier'] as int,
          pointsReward: quiz['difficulty'] as int,
        );
        
        levels.add(level);
      }
      
      debugPrint('Loaded ${levels.length} quizzes in custom order');
      return levels;
    } catch (e) {
      debugPrint('Error loading custom ordered quizzes: $e');
      // Fallback to original loading method
      return [];
    }
  }
  

  /// Charge les quiz depuis un fichier JSON générique
  static Future<List<Level>> _loadQuizzesFromFile(String filePath) async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      // Essayer différentes structures de données possibles
      List<dynamic> quizzes;
      if (data.containsKey('quizzes')) {
        quizzes = data['quizzes'] as List<dynamic>;
      } else if (data.containsKey('data')) {
        quizzes = data['data'] as List<dynamic>;
      } else {
        // Si c'est directement une liste
        quizzes = data as List<dynamic>;
      }
      
      List<Level> levels = [];
      
      for (int i = 0; i < quizzes.length; i++) {
        final quiz = quizzes[i] as Map<String, dynamic>;
        
        final List<dynamic> answersJson = quiz['answers'] as List<dynamic>;
        final List<Answer> answers = answersJson
            .map((answerJson) => Answer.fromJson(answerJson as Map<String, dynamic>))
            .toList();
        
        // Extraire la difficulté depuis le nouveau format
        int difficulty = 1; // Par défaut
        if (quiz['difficulty'] is Map) {
          final difficultyMap = quiz['difficulty'] as Map<String, dynamic>;
          difficulty = difficultyMap['p_difficulty'] ?? difficultyMap['score'] ?? 1;
        } else if (quiz['difficulty'] is int) {
          difficulty = quiz['difficulty'] as int;
        } else {
          difficulty = _calculateDifficulty(i, quizzes.length);
        }

        final level = Level(
          id: quiz['id'] as int? ?? (i + 1), // Utiliser l'ID existant ou générer
          title: quiz['title'] as String,
          hint: quiz['hint'] as String? ?? '', // Champ hint optionnel
          category: (quiz['theme'] ?? quiz['category']) as String,
          answers: answers,
          difficulty: difficulty,
          isUnlocked: false, // Sera défini plus tard
          isCompleted: false,
          tierId: 1, // Temporaire, sera réassigné
          positionInTier: 1, // Temporaire, sera réassigné
          pointsReward: difficulty, // Points = difficulté
        );
        
        levels.add(level);
      }
      
      return levels;
    } catch (e) {
      // Ne pas afficher d'erreur pour les fichiers optionnels qui n'existent pas
      if (e.toString().contains('Unable to load asset')) {
        debugPrint('Fichier optionnel non trouvé : $filePath');
      } else {
        debugPrint('Erreur lors du chargement du fichier $filePath: $e');
      }
      return [];
    }
  }

  /// Mélange une liste de façon déterministe (toujours le même résultat)
  static List<Level> _shuffleDeterministic(List<Level> levels) {
    final List<Level> shuffled = List.from(levels);
    final Random random = Random(_shuffleSeed);
    
    // Algorithme de Fisher-Yates avec seed fixe
    for (int i = shuffled.length - 1; i > 0; i--) {
      final int j = random.nextInt(i + 1);
      final Level temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    
    return shuffled;
  }
  
  static int _calculateDifficulty(int index, int total) {
    // Répartir la difficulté de 1 à 3 selon la position
    final double ratio = index / total;
    if (ratio < 0.33) return 1;
    if (ratio < 0.66) return 2;
    return 3;
  }

  // Nouvelles méthodes pour le système de paliers

  /// Charge la configuration des paliers
  static Future<List<Tier>> loadTiers() async {
    // Si l'ordre personnalisé est activé, générer les tiers dynamiquement
    if (useCustomOrder) {
      return await _loadCustomTiers();
    }
    
    // Sinon, utiliser la configuration statique des paliers
    try {
      final String jsonString = await rootBundle.loadString('assets/data/tiers_config.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> tiersJson = data['tiers'] as List<dynamic>;
      
      List<Tier> tiers = [];
      
      for (int i = 0; i < tiersJson.length; i++) {
        final tierConfig = tiersJson[i] as Map<String, dynamic>;
        final int tierId = tierConfig['id'];
        final minLevel = (tierId - 1) * 5 + 1;
        final maxLevel = tierId * 5;
        
        // Calculer le coût de déblocage basé sur les difficultés
        final List<int> difficulties = List<int>.from(tierConfig['difficulties']);
        final int calculatedUnlockCost = calculateTierUnlockCost(tierId, difficulties);

        final tier = Tier(
          id: tierId,
          name: tierConfig['name'],
          description: tierConfig['description'],
          levelIds: List.generate(5, (index) => minLevel + index),
          isUnlocked: tierId == 1, // Seul le premier palier est débloqué
          isCompleted: false,
          minLevel: minLevel,
          maxLevel: maxLevel,
          unlockCost: calculatedUnlockCost, // Utiliser le coût calculé dynamiquement
        );
        
        tiers.add(tier);
      }
      
      return tiers;
    } catch (e) {
      debugPrint('Erreur lors du chargement des paliers: $e');
      return _getDefaultTiers();
    }
  }

  /// Charge les tiers dynamiquement pour l'ordre personnalisé
  static Future<List<Tier>> _loadCustomTiers() async {
    try {
      final String jsonString = await rootBundle.loadString('data/quiz_custom_order.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      if (!data.containsKey('custom_order_applied') || !data['custom_order_applied']) {
        debugPrint('Custom order not applied, falling back to static tiers');
        return _getDefaultTiers();
      }
      
      final List<dynamic> quizzes = data['quizzes'] as List<dynamic>;
      
      // Calculer les difficultés par tier à partir des quiz
      Map<int, List<int>> tierDifficulties = {};
      for (final quiz in quizzes) {
        final tierId = quiz['tier_id'] as int;
        final difficulty = quiz['difficulty'] as int;
        
        if (!tierDifficulties.containsKey(tierId)) {
          tierDifficulties[tierId] = [];
        }
        tierDifficulties[tierId]!.add(difficulty);
      }
      
      // Créer les tiers dynamiquement
      // D'abord, récupérer les IDs de niveaux par tier
      Map<int, List<int>> tierLevelIds = {};
      for (final quiz in quizzes) {
        final tierId = quiz['tier_id'] as int;
        final quizId = quiz['id'] as int;
        
        if (!tierLevelIds.containsKey(tierId)) {
          tierLevelIds[tierId] = [];
        }
        tierLevelIds[tierId]!.add(quizId);
      }
      
      List<Tier> tiers = [];
      final sortedTierIds = tierDifficulties.keys.toList()..sort();
      
      for (final tierId in sortedTierIds) {
        final difficulties = tierDifficulties[tierId]!;
        final levelIds = tierLevelIds[tierId] ?? [];
        final int calculatedUnlockCost = calculateTierUnlockCost(tierId, difficulties);
        
        final tier = Tier(
          id: tierId,
          name: 'Palier $tierId',
          description: _getCustomTierDescription(tierId, difficulties),
          levelIds: levelIds, // Utiliser les vrais IDs des niveaux
          isUnlocked: tierId == 1,
          isCompleted: false,
          minLevel: (tierId - 1) * 5 + 1,
          maxLevel: tierId * 5,
          unlockCost: calculatedUnlockCost,
        );
        
        tiers.add(tier);
      }
      
      debugPrint('Generated ${tiers.length} dynamic tiers for custom order');
      return tiers;
    } catch (e) {
      debugPrint('Error loading custom tiers: $e');
      return _getDefaultTiers();
    }
  }

  /// Génère une description pour un tier personnalisé
  static String _getCustomTierDescription(int tierId, List<int> difficulties) {
    final avgDifficulty = difficulties.fold(0, (sum, diff) => sum + diff) / difficulties.length;
    if (avgDifficulty <= 1.5) {
      return 'Niveaux faciles';
    } else if (avgDifficulty <= 2.5) {
      return 'Niveaux moyens';
    } else if (avgDifficulty <= 3.5) {
      return 'Niveaux difficiles';
    } else {
      return 'Niveaux très difficiles';
    }
  }

  /// Charge tous les quiz et les organise en paliers selon la difficulté
  static Future<List<Level>> loadAllQuizzesWithTiers() async {
    final result = await loadAllQuizzesWithTiersAndUpdate();
    return result['levels'] as List<Level>;
  }

  /// Charge tous les quiz et retourne à la fois les niveaux et les tiers mis à jour
  static Future<Map<String, dynamic>> loadAllQuizzesWithTiersAndUpdate() async {
    final tiers = await loadTiers();
    
    // Essayer de charger l'ordre personnalisé en premier
    List<Level> allLevels = [];
    if (useCustomOrder) {
      allLevels = await _loadCustomOrderedQuizzes();
    }
    
    // Si l'ordre personnalisé n'est pas disponible, utiliser la méthode originale
    if (allLevels.isEmpty) {
      debugPrint('Custom order not available, falling back to deterministic shuffle');
      // Charger par ordre de difficulté croissante
      final difficultyFiles = await _loadLevelsByDifficulty();
      
      for (final difficultyGroup in difficultyFiles) {
        allLevels.addAll(difficultyGroup);
      }
    }
    
    debugPrint('Chargé ${allLevels.length} niveaux au total');
    
    // Si on utilise l'ordre personnalisé et qu'il a été chargé avec succès
    if (useCustomOrder && allLevels.isNotEmpty && allLevels.any((level) => level.tierId > 1)) {
      // Mettre à jour les levelIds dans les tiers et organiser les niveaux
      List<Level> organizedLevels = [];
      Map<int, List<int>> tierLevelIds = {};
      
      for (final level in allLevels) {
        final tier = tiers.firstWhere((t) => t.id == level.tierId, orElse: () => tiers.first);
        final organizedLevel = level.copyWith(
          isUnlocked: tier.isUnlocked,
          isCompleted: false,
        );
        organizedLevels.add(organizedLevel);
        
        // Collecter les IDs de niveau par tier
        if (!tierLevelIds.containsKey(level.tierId)) {
          tierLevelIds[level.tierId] = [];
        }
        tierLevelIds[level.tierId]!.add(level.id);
      }
      
      // Mettre à jour les tiers avec les vrais levelIds
      List<Tier> updatedTiers = [];
      for (final tier in tiers) {
        final levelIds = tierLevelIds[tier.id] ?? [];
        updatedTiers.add(tier.copyWith(levelIds: levelIds));
      }
      
      debugPrint('Using custom quiz order with ${organizedLevels.length} levels in ${updatedTiers.length} tiers');
      return {
        'levels': organizedLevels,
        'tiers': updatedTiers,
      };
    }
    
    // Sinon, utiliser la méthode originale d'assignation
    List<Level> organizedLevels = [];
    int levelIndex = 0;
    
    for (final tier in tiers) {
      final tierConfig = await _getTierConfig(tier.id);
      
      for (int positionInTier = 0; positionInTier < 5; positionInTier++) {
        if (levelIndex < allLevels.length) {
          final originalLevel = allLevels[levelIndex];
          final newLevelId = tier.minLevel + positionInTier;
          
          final organizedLevel = originalLevel.copyWith(
            id: newLevelId,
            tierId: tier.id,
            positionInTier: positionInTier + 1,
            difficulty: tierConfig['difficulties'][positionInTier],
            pointsReward: tierConfig['pointsRewards'][positionInTier],
            isUnlocked: tier.isUnlocked,
            isCompleted: false,
          );
          
          organizedLevels.add(organizedLevel);
          levelIndex++;
        }
      }
    }
    
    return {
      'levels': organizedLevels,
      'tiers': tiers,
    };
  }

  /// Charge les niveaux organisés par difficulté
  static Future<List<List<Level>>> _loadLevelsByDifficulty() async {
    List<List<Level>> levelsByDifficulty = [];
    
    // Fichiers organisés par difficulté (dans l'ordre croissant)
    final difficultyFilePatterns = [
      // Facile (difficulté 1-2) 
      ['quiz_facile.json'],
      
      // Moyen (difficulté 3)
      ['quiz_moyen.json'],
      
      // Difficile (difficulté 4)
      ['quiz_difficile.json'],
      
      // Très difficile (difficulté 5)
      ['quiz_tres_difficile.json'],
    ];
    
    // Essayer de charger aussi les nouveaux fichiers avec patterns automatiques
    final additionalPatterns = await _detectAdditionalFiles();
    
    // Fusionner les patterns existants avec les nouveaux
    for (int i = 0; i < additionalPatterns.length && i < 4; i++) {
      if (i < difficultyFilePatterns.length) {
        difficultyFilePatterns[i].addAll(additionalPatterns[i]);
      }
    }
    
    for (int difficulty = 0; difficulty < difficultyFilePatterns.length; difficulty++) {
      List<Level> difficultyLevels = [];
      
      for (String fileName in difficultyFilePatterns[difficulty]) {
        final filePath = 'data/$fileName';
        final levels = await _loadQuizzesFromFile(filePath);
        
        if (levels.isNotEmpty) {
          // Mélanger les niveaux de cette difficulté de façon déterministe
          final shuffledLevels = _shuffleDeterministic(levels);
          difficultyLevels.addAll(shuffledLevels);
          debugPrint('Chargé ${levels.length} niveaux de difficulté ${difficulty + 1} depuis $fileName');
        }
      }
      
      if (difficultyLevels.isNotEmpty) {
        levelsByDifficulty.add(difficultyLevels);
      }
    }
    
    return levelsByDifficulty;
  }

  /// Détecte automatiquement les nouveaux fichiers par patterns de noms
  static Future<List<List<String>>> _detectAdditionalFiles() async {
    List<List<String>> additionalFiles = [[], [], [], []]; // 4 niveaux de difficulté
    
    // Cette méthode pourrait être étendue pour scanner le dossier data/
    // Pour l'instant, on laisse la possibilité d'ajouter manuellement
    
    return additionalFiles;
  }

  /// Charge les niveaux pour un palier spécifique
  static Future<List<Level>> loadLevelsForTier(int tierId) async {
    final allLevels = await loadAllQuizzesWithTiers();
    return allLevels.where((level) => level.tierId == tierId).toList();
  }

  /// Calcule les points de récompense basés sur la difficulté
  static int calculatePointsReward(int difficulty) {
    return difficulty; // Points = difficulté
  }

  /// Calcule le coût de déblocage d'un palier basé sur la difficulté
  static int calculateTierUnlockCost(int tierId, List<int> difficulties) {
    if (tierId == 1) return 0; // Le premier palier est toujours gratuit
    
    // Calcul des points totaux disponibles dans ce palier
    int totalPoints = difficulties.fold(0, (sum, difficulty) => sum + difficulty);
    
    // Système d'écart progressif pour encourager la progression
    int allowedGap = _getAllowedGapForTier(tierId);
    
    // Coût = points max possibles - écart autorisé
    int cost = totalPoints - allowedGap;
    
    // Validation du coût minimum
    if (cost < 0) cost = 0;
    
    return cost;
  }
  
  /// Détermine l'écart de points autorisé selon le palier
  static int _getAllowedGapForTier(int tierId) {
    if (tierId <= 5) {
      return 2; // Encourager progression rapide pour les premiers paliers
    } else if (tierId <= 15) {
      return 1; // Progression normale
    } else {
      return 0; // Complétion obligatoire pour les paliers avancés
    }
  }

  /// Méthode privée pour obtenir la configuration d'un palier
  static Future<Map<String, dynamic>> _getTierConfig(int tierId) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/tiers_config.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> tiersJson = data['tiers'] as List<dynamic>;
      
      final tierConfig = tiersJson.firstWhere(
        (tier) => tier['id'] == tierId,
        orElse: () => tiersJson.first,
      );
      
      return tierConfig as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Erreur lors du chargement de la config du palier $tierId: $e');
      return _getDefaultTierConfig(tierId);
    }
  }

  /// Configuration par défaut pour un palier
  static Map<String, dynamic> _getDefaultTierConfig(int tierId) {
    return {
      'difficulties': [1, 1, 2, 2, 3],
      'pointsRewards': [1, 1, 2, 2, 3],
    };
  }

  /// Paliers par défaut en cas d'erreur
  static List<Tier> _getDefaultTiers() {
    return [
      Tier(
        id: 1,
        name: 'Palier 1',
        description: 'Premiers défis',
        levelIds: [1, 2, 3, 4, 5],
        isUnlocked: true,
        isCompleted: false,
        minLevel: 1,
        maxLevel: 5,
        unlockCost: 0,
      ),
    ];
  }
}