import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/level.dart';
import '../models/answer.dart';

class DataLoaderService {
  // Seed fixe pour garantir toujours le même ordre aléatoire
  static const int _shuffleSeed = 42;

  /// Charge tous les quiz de tous les fichiers et les mélange de façon déterministe
  static Future<List<Level>> loadAllQuizzes() async {
    List<Level> allLevels = [];
    
    // Liste des patterns de fichiers JSON à essayer de charger
    final List<String> possibleFiles = [
      'data/transfer_quizzes_flutter.json',
      'data/scorers_quizzes_flutter.json',
      'data/passeurs_championnats_flutter_quizzes_20250731_205039.json',
      'data/buteurs_coupes_clubs_flutter_quizzes_20250731_214537.json',
      'data/buteurs_coupe_internationales_flutter_quizzes_20250731_232018.json',
      // Ajouter d'autres patterns possibles
      'data/flutter_quizzes_20250731_214537.json',
      'data/flutter_quizzes_20250731_232018.json',
    ];
    
    // Charger tous les fichiers disponibles
    for (String filePath in possibleFiles) {
      final levels = await _loadQuizzesFromFile(filePath);
      if (levels.isNotEmpty) {
        allLevels.addAll(levels);
        debugPrint('Chargé ${levels.length} niveaux depuis $filePath');
      }
    }
    
    // Mélanger de façon déterministe (toujours le même ordre)
    allLevels = _shuffleDeterministic(allLevels);
    
    // Réassigner les IDs dans l'ordre mélangé et gérer les déblocages
    for (int i = 0; i < allLevels.length; i++) {
      allLevels[i] = allLevels[i].copyWith(
        id: i + 1,
        isUnlocked: i == 0, // Seul le premier niveau est débloqué
        isCompleted: false,
      );
    }
    
    return allLevels;
  }
  
  /// Méthode pour charger les quiz de transferts (rétro-compatibilité)
  static Future<List<Level>> loadTransferQuizzes() async {
    try {
      final String jsonString = await rootBundle.loadString('data/transfer_quizzes_flutter.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> quizzes = data['data'] as List<dynamic>;
      
      List<Level> levels = [];
      
      for (int i = 0; i < quizzes.length; i++) {
        final quiz = quizzes[i] as Map<String, dynamic>;
        
        final List<dynamic> answersJson = quiz['answers'] as List<dynamic>;
        final List<Answer> answers = answersJson
            .map((answerJson) => Answer.fromJson(answerJson as Map<String, dynamic>))
            .toList();
        
        final level = Level(
          id: quiz['id'] as int,
          title: quiz['title'] as String,
          hint: quiz['hint'] as String,
          category: quiz['theme'] as String,
          answers: answers,
          difficulty: _calculateDifficulty(i, quizzes.length),
          isUnlocked: i == 0, // Premier niveau débloqué
          isCompleted: false,
        );
        
        levels.add(level);
      }
      
      return levels;
    } catch (e) {
      debugPrint('Erreur lors du chargement des quiz de transferts: $e');
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
      if (data.containsKey('data')) {
        quizzes = data['data'] as List<dynamic>;
      } else if (data.containsKey('quizzes')) {
        quizzes = data['quizzes'] as List<dynamic>;
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
        
        final level = Level(
          id: quiz['id'] as int? ?? (i + 1), // Utiliser l'ID existant ou générer
          title: quiz['title'] as String,
          hint: quiz['hint'] as String,
          category: (quiz['theme'] ?? quiz['category']) as String,
          answers: answers,
          difficulty: quiz['difficulty'] as int? ?? _calculateDifficulty(i, quizzes.length),
          isUnlocked: false, // Sera défini plus tard
          isCompleted: false,
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
}