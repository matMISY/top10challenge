class HintConfig {
  // Points initiaux donnés au joueur lors de la première connexion
  static const int initialHintPoints = 50;
  
  // Limite maximale de points d'indice
  static const int maxHintPoints = 50;
  
  // Points gagnés par publicité récompensée
  static const int pointsPerAd = 12;
  
  // Cooldown en minutes entre deux publicités pour indices
  static const int adCooldownMinutes = 5;
  
  // Points gagnés en complétant un niveau
  static const int pointsPerEasyLevel = 6;
  static const int pointsPerMediumLevel = 9;
  static const int pointsPerHardLevel = 12;
  
  // Coûts des différents niveaux d'indices
  static const int hintLevel1Cost = 3;  // Indice de base (hint existant)
  static const int hintLevel2Cost = 4;  // Structure du nom
  static const int hintLevel3Cost = 5;  // Lettres partielles
  
  // Helper pour obtenir les points selon la difficulté
  static int getPointsForDifficulty(int difficulty) {
    switch (difficulty) {
      case 1:
        return pointsPerEasyLevel;
      case 2:
        return pointsPerMediumLevel;
      case 3:
        return pointsPerHardLevel;
      default:
        return pointsPerEasyLevel;
    }
  }
  
  // Helper pour obtenir le coût d'un niveau d'indice
  static int getHintCost(int level) {
    switch (level) {
      case 1:
        return hintLevel1Cost;
      case 2:
        return hintLevel2Cost;
      case 3:
        return hintLevel3Cost;
      default:
        return 0;
    }
  }
  
  // Helper pour formater le message de pub
  static String getAdRewardMessage() {
    return 'Regarder une pub pour +$pointsPerAd points d\'indices';
  }
  
  // Helper pour vérifier si on peut gagner plus de points
  static bool canGainMorePoints(int currentPoints) {
    return currentPoints < maxHintPoints;
  }
  
  // Helper pour calculer les points à gagner en respectant la limite
  static int getPointsToGain(int currentPoints, int pointsToAdd) {
    final maxPossible = maxHintPoints - currentPoints;
    return maxPossible < pointsToAdd ? maxPossible : pointsToAdd;
  }
}