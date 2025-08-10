import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../utils/my_colors.dart';
import '../config/money_time_config.dart';

/// Compact timer indicator for Money Time displayed during gameplay
/// Shows remaining time with golden styling and subtle pulsation
class MoneyTimeIndicator extends StatefulWidget {
  const MoneyTimeIndicator({super.key});

  @override
  State<MoneyTimeIndicator> createState() => _MoneyTimeIndicatorState();
}

class _MoneyTimeIndicatorState extends State<MoneyTimeIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    
    // Initialize pulse animation (every 5 seconds as specified)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Initialize shimmer animation (continuous subtle shine)
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Start the pulse cycle
    _startPulseCycle();
    
    // Start timer to update UI every second for real-time countdown
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Force UI rebuild every second to update timers
        });
      }
    });
  }

  void _startPulseCycle() {
    // Pulse every 5 seconds
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
    _updateTimer?.cancel();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (!gameProvider.gameState.isMoneyTimeActive()) {
          return const SizedBox.shrink();
        }

        final remaining = gameProvider.gameState.getMoneyTimeRemaining();
        if (remaining == null) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    // Main container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyColors.goldLight.withValues(alpha: 0.95),
                            MyColors.goldAccent.withValues(alpha: 0.9),
                            MyColors.goldDark.withValues(alpha: 0.9),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          // Outer golden glow
                          BoxShadow(
                            color: MyColors.goldAccent.withValues(alpha: 0.6),
                            blurRadius: 20,
                            spreadRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                          // Inner shadow for depth
                          BoxShadow(
                            color: MyColors.goldDark.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                          // Subtle dark shadow for contrast
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: MyColors.goldLight.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shield,
                              size: 18,
                              color: MyColors.goldDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MONEY TIME',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                MoneyTimeConfig.formatRemainingTime(remaining),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Shimmer overlay
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(_shimmerAnimation.value * 150, 0),
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}