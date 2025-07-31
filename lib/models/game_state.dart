class GameState {
  final int currentLevel;
  final int lives;
  final int score;
  final int hints;
  final List<int> completedLevels;
  final DateTime lastPlayedDate;
  final bool dailyChallengeCompleted;

  GameState({
    this.currentLevel = 1,
    this.lives = 5,
    this.score = 0,
    this.hints = 3,
    this.completedLevels = const [],
    DateTime? lastPlayedDate,
    this.dailyChallengeCompleted = false,
  }) : lastPlayedDate = lastPlayedDate ?? DateTime.now();

  GameState copyWith({
    int? currentLevel,
    int? lives,
    int? score,
    int? hints,
    List<int>? completedLevels,
    DateTime? lastPlayedDate,
    bool? dailyChallengeCompleted,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      lives: lives ?? this.lives,
      score: score ?? this.score,
      hints: hints ?? this.hints,
      completedLevels: completedLevels ?? this.completedLevels,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      dailyChallengeCompleted: dailyChallengeCompleted ?? this.dailyChallengeCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'lives': lives,
      'score': score,
      'hints': hints,
      'completedLevels': completedLevels,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'dailyChallengeCompleted': dailyChallengeCompleted,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentLevel: json['currentLevel'] ?? 1,
      lives: json['lives'] ?? 5,
      score: json['score'] ?? 0,
      hints: json['hints'] ?? 3,
      completedLevels: List<int>.from(json['completedLevels'] ?? []),
      lastPlayedDate: DateTime.parse(json['lastPlayedDate'] ?? DateTime.now().toIso8601String()),
      dailyChallengeCompleted: json['dailyChallengeCompleted'] ?? false,
    );
  }
}