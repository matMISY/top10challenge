import 'package:flutter/material.dart';
import '../widgets/overlay_feedback.dart';
import '../config/feedback_config.dart';

class FeedbackService {
  static OverlayEntry? _currentOverlay;

  static void show(
    BuildContext context, {
    required String message,
    required FeedbackType type,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Supprimer l'overlay précédent s'il existe
    _currentOverlay?.remove();
    
    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: OverlayFeedback(
              message: message,
              type: type,
              duration: duration ?? const Duration(milliseconds: 1500),
              onAction: onAction,
              actionLabel: actionLabel,
              onComplete: () {
                _currentOverlay?.remove();
                _currentOverlay = null;
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  static void clear() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  // Méthodes de convenance pour les différents types de feedback
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.success, duration: duration ?? FeedbackConfig.successDuration);
  }

  static void showError(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.error, duration: duration ?? FeedbackConfig.errorDuration);
  }

  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.warning, duration: duration ?? FeedbackConfig.warningDuration);
  }

  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.info, duration: duration ?? FeedbackConfig.infoDuration);
  }

  static void showPoints(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.points, duration: duration ?? FeedbackConfig.pointsDuration);
  }

  static void showLives(BuildContext context, String message, {Duration? duration}) {
    show(context, message: message, type: FeedbackType.lives, duration: duration ?? FeedbackConfig.livesDuration);
  }

  // Méthodes spécifiques au gameplay
  static void showWrongAnswer(BuildContext context, int livesRemaining) {
    showError(
      context, 
      'Mauvaise réponse !\n$livesRemaining ${livesRemaining > 1 ? 'vies restantes' : 'vie restante'}'
    );
  }

  static void showAlreadyFound(BuildContext context) {
    showWarning(context, 'Cette réponse a\ndéjà été trouvée !');
  }

  static void showNoLives(BuildContext context) {
    showError(context, 'Plus de vies !\nAttendez qu\'elles\nse récupèrent.');
  }

  static void showLifeGained(BuildContext context) {
    showLives(context, 'Vous avez gagné\n1 vie !\nContinuez à jouer !');
  }

  static void showPointsGained(BuildContext context, int points) {
    showPoints(context, '✨ +$points points\nd\'indices gagnés !');
  }

  static void showInsufficientPoints(BuildContext context, int needed, VoidCallback onWatchAd) {
    show(
      context, 
      message: 'Points insuffisants\n(besoin de $needed points)',
      type: FeedbackType.warning,
      duration: FeedbackConfig.warningDuration,
      onAction: onWatchAd,
      actionLabel: 'Voir une pub',
    );
  }

  static void showAdNotAvailable(BuildContext context, String? timeUntil) {
    showWarning(
      context,
      timeUntil != null 
        ? 'Prochaine pub\ndisponible dans\n$timeUntil'
        : 'Publicité non\ndisponible'
    );
  }

  static void showAdError(BuildContext context) {
    showError(context, 'Erreur lors du\nchargement de\nla publicité');
  }

  // Money Time specific feedback methods
  static void showMoneyTimeActivated(BuildContext context, int durationMinutes) {
    showSuccess(
      context, 
      '🛡️ MONEY TIME ACTIVÉ!\n$durationMinutes minutes\nsans perdre de vies!',
      duration: FeedbackConfig.longDuration
    );
  }

  static void showMoneyTimeWarning(BuildContext context) {
    showWarning(
      context, 
      '⏰ MONEY TIME\ntermine dans\n1 minute!',
      duration: Duration(milliseconds: 2500)
    );
  }

  static void showMoneyTimeEnded(BuildContext context) {
    showInfo(
      context, 
      '⏱️ Money Time terminé\nProchain disponible\ndans 4h',
      duration: FeedbackConfig.longDuration
    );
  }

  static void showMoneyTimeProtection(BuildContext context) {
    showInfo(
      context, 
      '🛡️ Money Time actif\nPas de vie perdue!',
      duration: FeedbackConfig.shortDuration
    );
  }
}