import 'package:flutter/foundation.dart';

/// Configuration pour les fonctionnalités de debug
class DebugConfig {
  /// Flag principal pour activer/désactiver toutes les fonctionnalités de debug
  /// Se base automatiquement sur kDebugMode (false en release)
  static const bool enableDebugFeatures = kDebugMode;
  
  /// Mode release détecté automatiquement
  static const bool isRelease = kReleaseMode;
  
  /// Mode profile détecté automatiquement  
  static const bool isProfile = kProfileMode;
  
  /// Flag spécifique pour le bouton de révélation des réponses
  static const bool enableRevealAnswers = enableDebugFeatures && true;
  
  /// Flag spécifique pour le bouton de passage automatique du niveau
  static const bool enableSkipLevel = enableDebugFeatures && true;
  
  /// Flag pour afficher des informations de debug dans les logs
  /// En mode profile, on peut garder quelques logs essentiels
  static const bool enableDebugLogs = enableDebugFeatures || (isProfile && false);
  
  /// Flag pour désactiver la validation des erreurs (utile pour les tests)
  static const bool disableErrorValidation = enableDebugFeatures && false;
  
  /// Flag pour masquer le bouton défi quotidien
  static const bool hideDailyChallenge = true;
  
  /// Vérifie si au moins une fonctionnalité de debug est activée
  static bool get hasAnyDebugFeature => 
      enableRevealAnswers || enableSkipLevel || enableDebugLogs;
      
  /// Affiche les informations de build (utile pour debugging)
  static void printBuildInfo() {
    if (enableDebugLogs) {
      debugPrint('🔧 Build Info:');
      debugPrint('  - Debug mode: $kDebugMode');
      debugPrint('  - Release mode: $kReleaseMode');
      debugPrint('  - Profile mode: $kProfileMode');
      debugPrint('  - Debug features: $enableDebugFeatures');
    }
  }
}