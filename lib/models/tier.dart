class Tier {
  final int id;
  final String name;
  final String description;
  final List<int> levelIds;
  final bool isUnlocked;
  final bool isCompleted;
  final int minLevel;
  final int maxLevel;
  final int unlockCost;

  Tier({
    required this.id,
    required this.name,
    required this.description,
    required this.levelIds,
    this.isUnlocked = false,
    this.isCompleted = false,
    required this.minLevel,
    required this.maxLevel,
    required this.unlockCost,
  });

  Tier copyWith({
    int? id,
    String? name,
    String? description,
    List<int>? levelIds,
    bool? isUnlocked,
    bool? isCompleted,
    int? minLevel,
    int? maxLevel,
    int? unlockCost,
  }) {
    return Tier(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      levelIds: levelIds ?? this.levelIds,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      minLevel: minLevel ?? this.minLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'levelIds': levelIds,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'minLevel': minLevel,
      'maxLevel': maxLevel,
      'unlockCost': unlockCost,
    };
  }

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      levelIds: List<int>.from(json['levelIds'] ?? []),
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      minLevel: json['minLevel'],
      maxLevel: json['maxLevel'],
      unlockCost: json['unlockCost'],
    );
  }

  /// Retourne le nombre de niveaux complétés dans ce palier
  int getCompletedLevelsCount(List<int> completedLevels) {
    return levelIds.where((levelId) => completedLevels.contains(levelId)).length;
  }

  /// Retourne les points totaux gagnés dans ce palier
  int getTotalPointsEarned(List<int> completedLevels, Map<int, int> levelPointsMap) {
    int totalPoints = 0;
    for (int levelId in levelIds) {
      if (completedLevels.contains(levelId)) {
        totalPoints += levelPointsMap[levelId] ?? 0;
      }
    }
    return totalPoints;
  }

  /// Vérifie si tous les niveaux du palier sont complétés
  bool areAllLevelsCompleted(List<int> completedLevels) {
    return levelIds.every((levelId) => completedLevels.contains(levelId));
  }
}