class GameState {
  final int currentLevel;
  final int lives;
  final int hints;
  final List<int> completedLevels;
  final DateTime lastPlayedDate;
  final bool dailyChallengeCompleted;
  final Map<int, List<String>> foundAnswersByLevel;

  GameState({
    this.currentLevel = 1,
    this.lives = 5,
    this.hints = 3,
    this.completedLevels = const [],
    DateTime? lastPlayedDate,
    this.dailyChallengeCompleted = false,
    this.foundAnswersByLevel = const {},
  }) : lastPlayedDate = lastPlayedDate ?? DateTime.now();

  GameState copyWith({
    int? currentLevel,
    int? lives,
    int? hints,
    List<int>? completedLevels,
    DateTime? lastPlayedDate,
    bool? dailyChallengeCompleted,
    Map<int, List<String>>? foundAnswersByLevel,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      lives: lives ?? this.lives,
      hints: hints ?? this.hints,
      completedLevels: completedLevels ?? this.completedLevels,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      dailyChallengeCompleted: dailyChallengeCompleted ?? this.dailyChallengeCompleted,
      foundAnswersByLevel: foundAnswersByLevel ?? this.foundAnswersByLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'lives': lives,
      'hints': hints,
      'completedLevels': completedLevels,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'dailyChallengeCompleted': dailyChallengeCompleted,
      'foundAnswersByLevel': foundAnswersByLevel.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    Map<int, List<String>> foundAnswersByLevel = {};
    if (json['foundAnswersByLevel'] != null) {
      final Map<String, dynamic> foundAnswersMap = json['foundAnswersByLevel'];
      foundAnswersByLevel = foundAnswersMap.map((key, value) => 
        MapEntry(int.parse(key), List<String>.from(value ?? [])));
    }
    
    return GameState(
      currentLevel: json['currentLevel'] ?? 1,
      lives: json['lives'] ?? 5,
      hints: json['hints'] ?? 3,
      completedLevels: List<int>.from(json['completedLevels'] ?? []),
      lastPlayedDate: DateTime.parse(json['lastPlayedDate'] ?? DateTime.now().toIso8601String()),
      dailyChallengeCompleted: json['dailyChallengeCompleted'] ?? false,
      foundAnswersByLevel: foundAnswersByLevel,
    );
  }
}