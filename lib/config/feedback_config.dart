class FeedbackConfig {
  // Durées des feedbacks overlay (en millisecondes)
  static const int defaultFeedbackDurationMs = 1500;
  static const int shortFeedbackDurationMs = 1000;
  static const int longFeedbackDurationMs = 3000;
  
  // Durées par type de feedback
  static const int successFeedbackDurationMs = defaultFeedbackDurationMs;
  static const int errorFeedbackDurationMs = defaultFeedbackDurationMs;
  static const int warningFeedbackDurationMs = defaultFeedbackDurationMs;
  static const int infoFeedbackDurationMs = defaultFeedbackDurationMs;
  static const int pointsFeedbackDurationMs = defaultFeedbackDurationMs;
  static const int livesFeedbackDurationMs = defaultFeedbackDurationMs;
  
  // Durées pour des cas spécifiques (si nécessaire)
  static const int gameOverFeedbackDurationMs = longFeedbackDurationMs;
  static const int levelCompletedFeedbackDurationMs = longFeedbackDurationMs;
  static const int debugFeedbackDurationMs = shortFeedbackDurationMs;
  
  // Getters pour faciliter l'utilisation
  static Duration get defaultDuration => Duration(milliseconds: defaultFeedbackDurationMs);
  static Duration get shortDuration => Duration(milliseconds: shortFeedbackDurationMs);
  static Duration get longDuration => Duration(milliseconds: longFeedbackDurationMs);
  
  static Duration get successDuration => Duration(milliseconds: successFeedbackDurationMs);
  static Duration get errorDuration => Duration(milliseconds: errorFeedbackDurationMs);
  static Duration get warningDuration => Duration(milliseconds: warningFeedbackDurationMs);
  static Duration get infoDuration => Duration(milliseconds: infoFeedbackDurationMs);
  static Duration get pointsDuration => Duration(milliseconds: pointsFeedbackDurationMs);
  static Duration get livesDuration => Duration(milliseconds: livesFeedbackDurationMs);
  
  static Duration get gameOverDuration => Duration(milliseconds: gameOverFeedbackDurationMs);
  static Duration get levelCompletedDuration => Duration(milliseconds: levelCompletedFeedbackDurationMs);
  static Duration get debugDuration => Duration(milliseconds: debugFeedbackDurationMs);
}