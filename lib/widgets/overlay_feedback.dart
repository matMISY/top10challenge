import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FeedbackType {
  success,
  error,
  warning,
  info,
  points,
  lives,
}

class OverlayFeedback extends StatefulWidget {
  final String message;
  final FeedbackType type;
  final Duration duration;
  final VoidCallback? onComplete;
  final VoidCallback? onAction;
  final String? actionLabel;

  const OverlayFeedback({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(milliseconds: 1500),
    this.onComplete,
    this.onAction,
    this.actionLabel,
  });

  @override
  State<OverlayFeedback> createState() => _OverlayFeedbackState();
}

class _OverlayFeedbackState extends State<OverlayFeedback>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _shakeController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Haptic feedback
    switch (widget.type) {
      case FeedbackType.success:
      case FeedbackType.points:
      case FeedbackType.lives:
        HapticFeedback.lightImpact();
        break;
      case FeedbackType.error:
        HapticFeedback.heavyImpact();
        break;
      default:
        HapticFeedback.selectionClick();
    }

    // Démarrer l'animation d'entrée
    _fadeController.forward();
    
    if (widget.type == FeedbackType.error) {
      // Animation de shake pour les erreurs
      await _shakeController.forward();
    } else {
      // Animation de scale pour les autres types
      await _scaleController.forward();
    }

    // Attendre la durée spécifiée
    await Future.delayed(widget.duration);
    
    // Animation de sortie
    await _fadeController.reverse();
    
    // Appeler le callback si fourni
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    switch (widget.type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.error:
        return Icons.cancel;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.info:
        return Icons.info;
      case FeedbackType.points:
        return Icons.lightbulb;
      case FeedbackType.lives:
        return Icons.favorite;
    }
  }

  Color _getColor() {
    switch (widget.type) {
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.error:
        return Colors.red;
      case FeedbackType.warning:
        return Colors.orange;
      case FeedbackType.info:
        return Colors.blue;
      case FeedbackType.points:
        return Colors.amber;
      case FeedbackType.lives:
        return Colors.red.shade400;
    }
  }

  Color _getBackgroundColor() {
    return _getColor().withValues(alpha: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _fadeController, _shakeController]),
      builder: (context, child) {
        double shake = 0.0;
        double scale = 1.0;
        
        if (widget.type == FeedbackType.error) {
          // Animation de shake pour les erreurs
          shake = _shakeAnimation.value * 10 * (1 - _shakeAnimation.value);
          scale = 0.8 + (_shakeAnimation.value * 0.4); // Scale de 0.8 à 1.2
        } else {
          // Animation de scale normale
          scale = _scaleAnimation.value;
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(shake, 0),
            child: Transform.scale(
              scale: scale,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIcon(),
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.onAction != null && widget.actionLabel != null) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.onAction?.call();
                            widget.onComplete?.call();
                          },
                          icon: const Icon(Icons.play_circle_filled, size: 16),
                          label: Text(widget.actionLabel!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _getColor(),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}