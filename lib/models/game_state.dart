class GameState {
  final int currentLevel;
  final int lives;
  final int hintPoints;  // Remplace hints - points d'indices disponibles
  final List<int> completedLevels;
  final DateTime lastPlayedDate;
  final bool dailyChallengeCompleted;
  final Map<int, List<String>> foundAnswersByLevel;
  final Map<int, Map<int, String>> revealedHintsByLevel;
  final Map<int, Map<int, int>> hintLevelsByLevel;  // Nouveau: niveau d'indice atteint par question
  final DateTime? lastLifeLostTime;
  final int totalPoints;
  final List<int> unlockedTiers;
  final DateTime? lastAdWatchTime;
  final DateTime? lastHintAdWatchTime;  // Nouveau: cooldown séparé pour les pubs d'indices
  
  // Money Time fields
  final DateTime? moneyTimeEndTime;
  final DateTime? lastMoneyTimeActivation;
  final int moneyTimeAdsWatched;  // Compteur temporaire (0-5)
  final int selectedMoneyTimeDuration;  // 15, 30 ou 60 minutes

  static const int maxLives = 5;
  static const Duration lifeRecoveryDuration = Duration(minutes: 5);
  static const Duration adCooldownDuration = Duration(minutes: 2);
  static const Duration hintAdCooldownDuration = Duration(minutes: 5);
  static const Duration moneyTimeCooldownDuration = Duration(hours: 4);

  GameState({
    this.currentLevel = 1,
    this.lives = 5,
    this.hintPoints = 50,  // 50 points initiaux
    this.completedLevels = const [],
    DateTime? lastPlayedDate,
    this.dailyChallengeCompleted = false,
    this.foundAnswersByLevel = const {},
    this.revealedHintsByLevel = const {},
    this.hintLevelsByLevel = const {},
    this.lastLifeLostTime,
    this.totalPoints = 0,
    this.unlockedTiers = const [1],
    this.lastAdWatchTime,
    this.lastHintAdWatchTime,
    this.moneyTimeEndTime,
    this.lastMoneyTimeActivation,
    this.moneyTimeAdsWatched = 0,
    this.selectedMoneyTimeDuration = 30,
  }) : lastPlayedDate = lastPlayedDate ?? DateTime.now();

  GameState copyWith({
    int? currentLevel,
    int? lives,
    int? hintPoints,
    List<int>? completedLevels,
    DateTime? lastPlayedDate,
    bool? dailyChallengeCompleted,
    Map<int, List<String>>? foundAnswersByLevel,
    Map<int, Map<int, String>>? revealedHintsByLevel,
    Map<int, Map<int, int>>? hintLevelsByLevel,
    DateTime? lastLifeLostTime,
    int? totalPoints,
    List<int>? unlockedTiers,
    DateTime? lastAdWatchTime,
    DateTime? lastHintAdWatchTime,
    DateTime? moneyTimeEndTime,
    DateTime? lastMoneyTimeActivation,
    int? moneyTimeAdsWatched,
    int? selectedMoneyTimeDuration,
  }) {
    return GameState(
      currentLevel: currentLevel ?? this.currentLevel,
      lives: lives ?? this.lives,
      hintPoints: hintPoints ?? this.hintPoints,
      completedLevels: completedLevels ?? this.completedLevels,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      dailyChallengeCompleted: dailyChallengeCompleted ?? this.dailyChallengeCompleted,
      foundAnswersByLevel: foundAnswersByLevel ?? this.foundAnswersByLevel,
      revealedHintsByLevel: revealedHintsByLevel ?? this.revealedHintsByLevel,
      hintLevelsByLevel: hintLevelsByLevel ?? this.hintLevelsByLevel,
      lastLifeLostTime: lastLifeLostTime ?? this.lastLifeLostTime,
      totalPoints: totalPoints ?? this.totalPoints,
      unlockedTiers: unlockedTiers ?? this.unlockedTiers,
      lastAdWatchTime: lastAdWatchTime ?? this.lastAdWatchTime,
      lastHintAdWatchTime: lastHintAdWatchTime ?? this.lastHintAdWatchTime,
      moneyTimeEndTime: moneyTimeEndTime ?? this.moneyTimeEndTime,
      lastMoneyTimeActivation: lastMoneyTimeActivation ?? this.lastMoneyTimeActivation,
      moneyTimeAdsWatched: moneyTimeAdsWatched ?? this.moneyTimeAdsWatched,
      selectedMoneyTimeDuration: selectedMoneyTimeDuration ?? this.selectedMoneyTimeDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'lives': lives,
      'hintPoints': hintPoints,
      'completedLevels': completedLevels,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'dailyChallengeCompleted': dailyChallengeCompleted,
      'foundAnswersByLevel': foundAnswersByLevel.map((key, value) => MapEntry(key.toString(), value)),
      'revealedHintsByLevel': revealedHintsByLevel.map((levelKey, hintMap) => 
        MapEntry(levelKey.toString(), hintMap.map((indexKey, hint) => MapEntry(indexKey.toString(), hint)))),
      'hintLevelsByLevel': hintLevelsByLevel.map((levelKey, hintMap) => 
        MapEntry(levelKey.toString(), hintMap.map((indexKey, level) => MapEntry(indexKey.toString(), level)))),
      'lastLifeLostTime': lastLifeLostTime?.toIso8601String(),
      'totalPoints': totalPoints,
      'unlockedTiers': unlockedTiers,
      'lastAdWatchTime': lastAdWatchTime?.toIso8601String(),
      'lastHintAdWatchTime': lastHintAdWatchTime?.toIso8601String(),
      'moneyTimeEndTime': moneyTimeEndTime?.toIso8601String(),
      'lastMoneyTimeActivation': lastMoneyTimeActivation?.toIso8601String(),
      'moneyTimeAdsWatched': moneyTimeAdsWatched,
      'selectedMoneyTimeDuration': selectedMoneyTimeDuration,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    Map<int, List<String>> foundAnswersByLevel = {};
    if (json['foundAnswersByLevel'] != null) {
      final Map<String, dynamic> foundAnswersMap = json['foundAnswersByLevel'];
      foundAnswersByLevel = foundAnswersMap.map((key, value) => 
        MapEntry(int.parse(key), List<String>.from(value ?? [])));
    }
    
    Map<int, Map<int, String>> revealedHintsByLevel = {};
    if (json['revealedHintsByLevel'] != null) {
      final Map<String, dynamic> revealedHintsMap = json['revealedHintsByLevel'];
      revealedHintsByLevel = revealedHintsMap.map((levelKey, hintMapData) {
        final Map<String, dynamic> hintMap = hintMapData as Map<String, dynamic>;
        return MapEntry(
          int.parse(levelKey), 
          hintMap.map((indexKey, hint) => MapEntry(int.parse(indexKey), hint.toString()))
        );
      });
    }
    
    Map<int, Map<int, int>> hintLevelsByLevel = {};
    if (json['hintLevelsByLevel'] != null) {
      final Map<String, dynamic> hintLevelsMap = json['hintLevelsByLevel'];
      hintLevelsByLevel = hintLevelsMap.map((levelKey, hintMapData) {
        final Map<String, dynamic> hintMap = hintMapData as Map<String, dynamic>;
        return MapEntry(
          int.parse(levelKey), 
          hintMap.map((indexKey, level) => MapEntry(int.parse(indexKey), int.parse(level.toString())))
        );
      });
    }
    
    // Migration de l'ancien système hints vers hintPoints
    int hintPoints = json['hintPoints'] ?? (json['hints'] != null ? json['hints'] * 3 : 50);
    
    return GameState(
      currentLevel: json['currentLevel'] ?? 1,
      lives: json['lives'] ?? 5,
      hintPoints: hintPoints,
      completedLevels: List<int>.from(json['completedLevels'] ?? []),
      lastPlayedDate: DateTime.parse(json['lastPlayedDate'] ?? DateTime.now().toIso8601String()),
      dailyChallengeCompleted: json['dailyChallengeCompleted'] ?? false,
      foundAnswersByLevel: foundAnswersByLevel,
      revealedHintsByLevel: revealedHintsByLevel,
      hintLevelsByLevel: hintLevelsByLevel,
      lastLifeLostTime: json['lastLifeLostTime'] != null 
        ? DateTime.parse(json['lastLifeLostTime']) 
        : null,
      totalPoints: json['totalPoints'] ?? 0,
      unlockedTiers: List<int>.from(json['unlockedTiers'] ?? [1]),
      lastAdWatchTime: json['lastAdWatchTime'] != null 
        ? DateTime.parse(json['lastAdWatchTime']) 
        : null,
      lastHintAdWatchTime: json['lastHintAdWatchTime'] != null 
        ? DateTime.parse(json['lastHintAdWatchTime']) 
        : null,
      moneyTimeEndTime: json['moneyTimeEndTime'] != null 
        ? DateTime.parse(json['moneyTimeEndTime']) 
        : null,
      lastMoneyTimeActivation: json['lastMoneyTimeActivation'] != null 
        ? DateTime.parse(json['lastMoneyTimeActivation']) 
        : null,
      moneyTimeAdsWatched: json['moneyTimeAdsWatched'] ?? 0,
      selectedMoneyTimeDuration: json['selectedMoneyTimeDuration'] ?? 30,
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
    if (lives >= 10) return false; // Maximum absolu de 10 vies avec pubs
    if (lastAdWatchTime == null) return true;
    
    final now = DateTime.now();
    final timeSinceLastAd = now.difference(lastAdWatchTime!);
    return timeSinceLastAd >= adCooldownDuration;
  }

  /// Retourne le temps restant avant de pouvoir regarder une nouvelle pub
  Duration? getTimeUntilNextAd() {
    if (lives >= 10 || lastAdWatchTime == null) return null;
    
    final now = DateTime.now();
    final nextAdTime = lastAdWatchTime!.add(adCooldownDuration);
    final timeUntilNext = nextAdTime.difference(now);
    
    return timeUntilNext.isNegative ? null : timeUntilNext;
  }
  
  /// Vérifie si le joueur peut regarder une pub pour gagner des points d'indices
  bool canWatchAdForHints() {
    if (lastHintAdWatchTime == null) return true;
    
    final now = DateTime.now();
    final timeSinceLastAd = now.difference(lastHintAdWatchTime!);
    return timeSinceLastAd >= hintAdCooldownDuration;
  }
  
  /// Retourne le temps restant avant de pouvoir regarder une nouvelle pub pour indices
  Duration? getTimeUntilNextHintAd() {
    if (lastHintAdWatchTime == null) return null;
    
    final now = DateTime.now();
    final nextAdTime = lastHintAdWatchTime!.add(hintAdCooldownDuration);
    final timeUntilNext = nextAdTime.difference(now);
    
    return timeUntilNext.isNegative ? null : timeUntilNext;
  }
  
  /// Vérifie si le Money Time est actuellement actif
  bool isMoneyTimeActive() {
    if (moneyTimeEndTime == null) return false;
    return DateTime.now().isBefore(moneyTimeEndTime!);
  }
  
  /// Retourne la durée restante du Money Time
  Duration? getMoneyTimeRemaining() {
    if (!isMoneyTimeActive()) return null;
    return moneyTimeEndTime!.difference(DateTime.now());
  }
  
  /// Vérifie si le joueur peut activer le Money Time
  bool canActivateMoneyTime() {
    if (lastMoneyTimeActivation == null) return true;
    final cooldown = DateTime.now().difference(lastMoneyTimeActivation!);
    return cooldown >= moneyTimeCooldownDuration;
  }
  
  /// Retourne le temps restant avant de pouvoir réactiver le Money Time
  Duration? getTimeUntilMoneyTimeAvailable() {
    if (canActivateMoneyTime()) return null;
    final nextAvailable = lastMoneyTimeActivation!.add(moneyTimeCooldownDuration);
    return nextAvailable.difference(DateTime.now());
  }
}
