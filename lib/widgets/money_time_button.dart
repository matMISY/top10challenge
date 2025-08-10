import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../config/money_time_config.dart';
import '../services/feedback_service.dart';
import 'money_time_selection_dialog.dart';
import 'money_time_progress_screen.dart';

class MoneyTimeButton extends StatefulWidget {
  const MoneyTimeButton({super.key});

  @override
  State<MoneyTimeButton> createState() => _MoneyTimeButtonState();
}

class _MoneyTimeButtonState extends State<MoneyTimeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
    
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

  @override
  void dispose() {
    _updateTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final canActivate = gameProvider.gameState.canActivateMoneyTime();
        final isActive = gameProvider.gameState.isMoneyTimeActive();
        final timeUntilAvailable = gameProvider.gameState.getTimeUntilMoneyTimeAvailable();

        if (isActive) {
          return _buildActiveButton(gameProvider);
        } else if (canActivate) {
          return _buildAvailableButton(context, gameProvider);
        } else {
          return _buildCooldownButton(timeUntilAvailable);
        }
      },
    );
  }

  Widget _buildActiveButton(GameProvider gameProvider) {
    final remaining = gameProvider.gameState.getMoneyTimeRemaining();
    final formattedTime = remaining != null 
        ? MoneyTimeConfig.formatRemainingTime(remaining)
        : '00:00';

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade600,
                  Colors.orange.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(27),
              child: InkWell(
                borderRadius: BorderRadius.circular(27),
                onTap: () => _showActiveMoneyTimeInfo(context, remaining),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Money Time Actif',
                              style: GoogleFonts.baloo2(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Temps restant: $formattedTime',
                              style: GoogleFonts.baloo2(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          formattedTime,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildAvailableButton(BuildContext context, GameProvider gameProvider) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade600,
                  Colors.deepPurple.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(27),
              child: InkWell(
                borderRadius: BorderRadius.circular(27),
                onTap: () => _showSelectionDialog(context, gameProvider),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Money Time',
                              style: GoogleFonts.baloo2(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Jouez sans perdre de vies !',
                              style: GoogleFonts.baloo2(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
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

  Widget _buildCooldownButton(Duration? timeUntilAvailable) {
    final formattedCooldown = timeUntilAvailable != null 
        ? MoneyTimeConfig.formatCooldownTime(timeUntilAvailable)
        : '';

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Money Time',
                    style: GoogleFonts.baloo2(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Disponible dans $formattedCooldown',
                    style: GoogleFonts.baloo2(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formattedCooldown,
                style: GoogleFonts.robotoMono(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MoneyTimeSelectionDialog(
        onDurationSelected: (duration) async {
          await _activateMoneyTime(context, gameProvider, duration);
        },
      ),
    );
  }

  void _showActiveMoneyTimeInfo(BuildContext context, Duration? remaining) {
    final formattedTime = remaining != null 
        ? MoneyTimeConfig.formatRemainingTime(remaining)
        : '00:00';
    
    FeedbackService.showInfo(
      context, 
      'Money Time est actif !\n\nTemps restant: $formattedTime\n\nVous ne perdez pas de vies pendant cette période.',
    );
  }

  Future<void> _activateMoneyTime(BuildContext context, GameProvider gameProvider, int duration) async {
    try {
      final targetAds = MoneyTimeConfig.getAdsRequiredForDuration(duration);
      
      if (!context.mounted) return;
      
      // Start the activation process first
      final activationFuture = gameProvider.startMoneyTimeActivation(duration);
      
      // Show progress screen while activation is happening
      Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => MoneyTimeProgressScreen(
            targetAds: targetAds,
            selectedDuration: duration,
          ),
          fullscreenDialog: true,
        ),
      );
      
      // Wait for activation to complete
      final activationSuccess = await activationFuture;
      
      // The progress screen should automatically close based on the activation result
      // But let's ensure it closes if it hasn't already
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(activationSuccess);
      }
      
      if (!context.mounted) return;
      
      // Show appropriate feedback based on result
      if (activationSuccess) {
        // Success feedback will be shown by the GameProvider
        // We don't need to show additional feedback here
      } else {
        FeedbackService.showError(
          context,
          'Impossible d\'activer Money Time.\n\nVérifiez votre connexion et réessayez.',
        );
      }
    } catch (e) {
      debugPrint('Error activating Money Time: $e');
      
      // Ensure progress screen is closed
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(false);
      }
      
      if (!context.mounted) return;
      
      FeedbackService.showError(
        context,
        'Une erreur s\'est produite.\n\nRéessayez plus tard.',
      );
    }
  }
}