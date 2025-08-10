import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/my_colors.dart';

/// Shield effect widget that wraps the lives counter during Money Time
/// Provides golden shield protection visual with pulsation animation
class MoneyTimeShieldEffect extends StatefulWidget {
  final Widget child;
  
  const MoneyTimeShieldEffect({
    super.key,
    required this.child,
  });

  @override
  State<MoneyTimeShieldEffect> createState() => _MoneyTimeShieldEffectState();
}

class _MoneyTimeShieldEffectState extends State<MoneyTimeShieldEffect>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation (every 5 seconds)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Very slow rotation for shield (subtle movement)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _startPulseCycle();
  }

  void _startPulseCycle() {
    // Pulse every 5 seconds as specified in the specs
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _pulseController.forward().then((_) {
          _pulseController.reverse().then((_) {
            if (mounted) {
              _startPulseCycle();
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final isMoneyTimeActive = gameProvider.gameState.isMoneyTimeActive();
        
        if (!isMoneyTimeActive) {
          // No shield effect, return child directly
          return widget.child;
        }

        return AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _rotationAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect - enhanced
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        // Primary glow
                        BoxShadow(
                          color: MyColors.goldAccent.withValues(alpha: _glowAnimation.value * 0.8),
                          blurRadius: 25,
                          spreadRadius: 12,
                        ),
                        // Secondary glow for depth
                        BoxShadow(
                          color: MyColors.goldLight.withValues(alpha: _glowAnimation.value * 0.4),
                          blurRadius: 35,
                          spreadRadius: 18,
                        ),
                        // Inner rim glow
                        BoxShadow(
                          color: MyColors.goldDark.withValues(alpha: _glowAnimation.value * 0.3),
                          blurRadius: 15,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  
                  // Rotating shield border
                  Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MyColors.goldAccent.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        gradient: SweepGradient(
                          colors: [
                            MyColors.goldAccent.withValues(alpha: 0.2),
                            MyColors.goldLight.withValues(alpha: 0.6),
                            MyColors.goldAccent.withValues(alpha: 0.9),
                            MyColors.goldDark.withValues(alpha: 0.4),
                            MyColors.goldAccent.withValues(alpha: 0.2),
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Inner shield background
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.goldAccent.withValues(alpha: 0.15),
                      border: Border.all(
                        color: MyColors.goldLight.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  
                  // Floating particles
                  ...List.generate(6, (index) {
                    final angle = (index / 6) * 2 * 3.14159 + (_rotationAnimation.value * 2 * 3.14159 * 0.3);
                    final radius = 35.0;
                    final x = radius * math.cos(angle);
                    final y = radius * math.sin(angle);
                    
                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: MyColors.goldLight.withValues(alpha: _glowAnimation.value * 0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.goldAccent.withValues(alpha: _glowAnimation.value * 0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  
                  // Shield icon overlay (subtle)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: MyColors.goldDark.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Original child widget
                  widget.child,
                ],
              ),
            );
          },
        );
      },
    );
  }
}