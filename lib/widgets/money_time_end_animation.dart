import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../utils/my_colors.dart';

/// Animation widget displayed when Money Time ends
/// Shows a dramatic golden shield disappearing effect
class MoneyTimeEndAnimation extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const MoneyTimeEndAnimation({
    super.key,
    this.onComplete,
  });

  @override
  State<MoneyTimeEndAnimation> createState() => _MoneyTimeEndAnimationState();
}

class _MoneyTimeEndAnimationState extends State<MoneyTimeEndAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shieldOpacity;
  late Animation<double> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller for the overall sequence
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Pulse animation for the shield before it disappears
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Fade controller for the final fade out
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation - shield grows then shrinks
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInBack),
    ));

    // Pulse animation - multiple pulses before disappearing
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shield opacity - fades out with scale
    _shieldOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    // Text slide animation - slides up from bottom
    _textSlideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Fade animation for the entire widget
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    // Start with pulses
    for (int i = 0; i < 3; i++) {
      await _pulseController.forward();
      await _pulseController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    // Start main disappearing animation
    await _mainController.forward();
    
    // Final fade out
    await _fadeController.forward();
    
    // Call completion callback
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _pulseController,
        _fadeController,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text animation
                  Transform.translate(
                    offset: Offset(0, 100 * _textSlideAnimation.value),
                    child: Opacity(
                      opacity: 1.0 - _textSlideAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'MONEY TIME',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.goldLight,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.moneyTimeFinished,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Shield animation
                  Transform.scale(
                    scale: _scaleAnimation.value * _pulseAnimation.value,
                    child: Opacity(
                      opacity: _shieldOpacity.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              MyColors.goldLight.withValues(alpha: 0.8),
                              MyColors.goldAccent.withValues(alpha: 0.6),
                              MyColors.goldDark.withValues(alpha: 0.4),
                            ],
                            stops: const [0.3, 0.7, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.goldAccent.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Subtitle
                  Transform.translate(
                    offset: Offset(0, -50 * _textSlideAnimation.value),
                    child: Opacity(
                      opacity: 1.0 - _textSlideAnimation.value,
                      child: Text(
                        AppLocalizations.of(context)!.nextMoneyTimeIn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}