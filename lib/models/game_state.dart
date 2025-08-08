class GameState {
  final int currentLevel;
  final int lives;
  final int hints;
  final List<int> completedLevels;
  final DateTime lastPlayedDate;
  final bool dailyChallengeCompleted;
  final Map<int, List<String>> foundAnswersByLevel;
  final DateTime? lastLifeLostTime;
  final int totalPoints;
  final List<int> unlockedTiers;
  final DateTime? lastAdWatchTime;

  static const int maxLives = 5;
  static const Duration lifeRecoveryDuration = Duration(minutes: 30);
  static const Duration adCooldownDuration = Duration(minutes: 30);

  GameState({
    this.currentLevel = 1,
    this.lives = 5,
    this.hints = 3,
    this.completedLevels = const [],
    DateTime? lastPlayedDate,
    this.dailyChallengeCompleted = false,
    this.foundAnswersByLevel = const {},
    this.lastLifeLostTime,
    this.totalPoints = 0,
    this.unlockedTiers = const [1],
    this.lastAdWatchTime,
  }) : lastPlayedDate = lastPlayedDate ?? DateTime.now();

  GameState copyWith({
    int? currentLevel,
    int? lives,
    int? hints,
    List<int>? completedLevels,
    DateTime? lastPlayedDate,
    bool? dailyChallengeCompleted,
    Map<int, List<String>>? foundAnswersByLevel,
    DateTime? lastLifeLostTime,
    int? totalPoints,
    List<int>? unlockedTiers,
    DateTime? lastAdWatchTime,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      lives: lives ?? this.lives,
      hints: hints ?? this.hints,
      completedLevels: completedLevels ?? this.completedLevels,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      dailyChallengeCompleted: dailyChallengeCompleted ?? this.dailyChallengeCompleted,
      foundAnswersByLevel: foundAnswersByLevel ?? this.foundAnswersByLevel,
      lastLifeLostTime: lastLifeLostTime ?? this.lastLifeLostTime,
      totalPoints: totalPoints ?? this.totalPoints,
      unlockedTiers: unlockedTiers ?? this.unlockedTiers,
      lastAdWatchTime: lastAdWatchTime ?? this.lastAdWatchTime,
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
      'lastLifeLostTime': lastLifeLostTime?.toIso8601String(),
      'totalPoints': totalPoints,
      'unlockedTiers': unlockedTiers,
      'lastAdWatchTime': lastAdWatchTime?.toIso8601String(),
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
      lastLifeLostTime: json['lastLifeLostTime'] != null 
        ? DateTime.parse(json['lastLifeLostTime']) 
        : null,
      totalPoints: json['totalPoints'] ?? 0,
      unlockedTiers: List<int>.from(json['unlockedTiers'] ?? [1]),
      lastAdWatchTime: json['lastAdWatchTime'] != null 
        ? DateTime.parse(json['lastAdWatchTime']) 
        : null,
    );
  }

  /// Calcule le nombre de vies récupérables basé sur le temps écoulé
  int getRecoverableLives() {
    if (lastLifeLostTime == null || lives >= maxLives) return 0;
    
    final now = DateTime.now();
    final timeSinceLastLoss = now.difference(lastLifeLostTime!);
    final recoveryPeriods = timeSinceLastLoss.inMinutes ~/ lifeRecoveryDuration.inMinutes;
    
    // Nombre maximum de vies récupérables = maxLives - vies actuelles
    final maxRecoverable = maxLives - lives;
    return recoveryPeriods.clamp(0, maxRecoverable);
  }

  /// Retourne le temps restant avant la prochaine récupération de vie
  Duration? getTimeUntilNextLife() {
    if (lastLifeLostTime == null || lives >= maxLives) return null;
    
    final now = DateTime.now();
    final timeSinceLastLoss = now.difference(lastLifeLostTime!);
    final nextRecoveryTime = lastLifeLostTime!.add(
      Duration(minutes: ((timeSinceLastLoss.inMinutes ~/ lifeRecoveryDuration.inMinutes) + 1) * lifeRecoveryDuration.inMinutes)
    );
    
    final timeUntilNext = nextRecoveryTime.difference(now);
    return timeUntilNext.isNegative ? null : timeUntilNext;
  }

  /// Retourne true si le joueur peut jouer (a au moins 1 vie ou peut récupérer des vies)
  bool canPlay() {
    return lives > 0 || getRecoverableLives() > 0;
  }

  /// Vérifie si le joueur peut regarder une pub pour gagner une vie
  bool canWatchAdForLife() {
    if (lives >= maxLives) return false;
    if (lastAdWatchTime == null) return true;
    
    final now = DateTime.now();
    final timeSinceLastAd = now.difference(lastAdWatchTime!);
    return timeSinceLastAd >= adCooldownDuration;
  }

  /// Retourne le temps restant avant de pouvoir regarder une nouvelle pub
  Duration? getTimeUntilNextAd() {
    if (lives >= maxLives || lastAdWatchTime == null) return null;
    
    final now = DateTime.now();
    final nextAdTime = lastAdWatchTime!.add(adCooldownDuration);
    final timeUntilNext = nextAdTime.difference(now);
    
    return timeUntilNext.isNegative ? null : timeUntilNext;
  }
}