/// Configuration pour les fonctionnalités de debug
class DebugConfig {
  /// Flag principal pour activer/désactiver toutes les fonctionnalités de debug
  static const bool enableDebugFeatures = true; // Mettre à false pour la production
  
  /// Flag spécifique pour le bouton de révélation des réponses
  static const bool enableRevealAnswers = enableDebugFeatures && true;
  
  /// Flag spécifique pour le bouton de passage automatique du niveau
  static const bool enableSkipLevel = enableDebugFeatures && true;
  
  /// Flag pour afficher des informations de debug dans les logs
  static const bool enableDebugLogs = enableDebugFeatures && true;
  
  /// Flag pour désactiver la validation des erreurs (utile pour les tests)
  static const bool disableErrorValidation = enableDebugFeatures && false;
  
  /// Vérifie si au moins une fonctionnalité de debug est activée
  static bool get hasAnyDebugFeature => 
      enableRevealAnswers || enableSkipLevel || enableDebugLogs;
}