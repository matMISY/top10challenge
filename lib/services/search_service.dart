import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/players_database.dart';
import '../utils/string_utils.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final PlayersDatabase _database = PlayersDatabase();
  List<String> _allPlayerNames = [];
  bool _isLoaded = false;

  Future<void> _loadPlayerNames() async {
    if (_isLoaded) return;
    
    try {
      final String jsonString = await rootBundle.loadString('all_player_names.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      _allPlayerNames = List<String>.from(data['player_names']);
      _isLoaded = true;
    } catch (e) {
      // En cas d'erreur, utiliser une liste vide (fallback sur l'ancien système)
      _allPlayerNames = [];
      _isLoaded = true;
    }
  }

  Future<List<String>> getSuggestions(String query, List<String> availableAnswers) async {
    if (query.length < 2) return [];

    // Charger la liste des joueurs si pas encore fait
    await _loadPlayerNames();

    final normalizedQuery = query.toLowerCase().trim();
    final suggestions = <String>[];

    // Chercher dans toute la liste des joueurs en ignorant les accents
    for (final playerName in _allPlayerNames) {
      if (StringUtils.matchesIgnoringAccents(playerName, query)) {
        suggestions.add(playerName);
      }
    }

    // Fallback: si aucune suggestion trouvée ou liste vide, utiliser l'ancien système
    if (suggestions.isEmpty) {
      for (final answer in availableAnswers) {
        final player = _database.getPlayer(answer);
        if (player != null && player.matches(query)) {
          suggestions.add(answer);
        } else if (StringUtils.matchesIgnoringAccents(answer, query)) {
          suggestions.add(answer);
        }
      }
    }

    // Trier les suggestions par pertinence (en ignorant les accents)
    suggestions.sort((a, b) {
      final aStartsWith = StringUtils.startsWithIgnoringAccents(a, query);
      final bStartsWith = StringUtils.startsWithIgnoringAccents(b, query);
      
      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;
      
      return a.length.compareTo(b.length);
    });

    // Limiter à 8 suggestions maximum
    return suggestions.take(8).toList();
  }

  bool isValidAnswer(String input, List<String> availableAnswers) {
    for (final answer in availableAnswers) {
      final player = _database.getPlayer(answer);
      if (player != null && player.matches(input)) {
        return true;
      }
      if (StringUtils.matchesIgnoringAccents(answer, input)) {
        return true;
      }
    }
    
    return false;
  }

  String? getCorrectAnswer(String input, List<String> availableAnswers) {
    for (final answer in availableAnswers) {
      final player = _database.getPlayer(answer);
      if (player != null && player.matches(input)) {
        return answer;
      }
      if (StringUtils.matchesIgnoringAccents(answer, input)) {
        return answer;
      }
    }
    
    return null;
  }
}