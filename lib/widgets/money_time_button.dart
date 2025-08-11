import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        final canActivateFree = gameProvider.gameState.canActivateFreeMoneyTime();

        if (isActive) {
          return _buildActiveButton(gameProvider);
        } else if (canActivateFree) {
          return _buildFreeMoneyTimeButton(context, gameProvider);
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
            width: MediaQuery.of(context).size.width * 0.75,
            height: 45,
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
                              AppLocalizations.of(context)!.moneyTimeActive,
                              style: GoogleFonts.baloo2(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)!.timeRemaining(formattedTime),
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

  Widget _buildFreeMoneyTimeButton(BuildContext context, GameProvider gameProvider) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade500,
                  Colors.teal.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.3),
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
                onTap: () => _activateFreeMoneyTime(context, gameProvider),
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
                          Icons.card_giftcard,
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
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.freeMoneyTime,
                                  style: GoogleFonts.baloo2(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.newLabel,
                                    style: GoogleFonts.baloo2(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)!.thirtyMinWithoutAds,
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

  Widget _buildAvailableButton(BuildContext context, GameProvider gameProvider) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 45,
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
      width: MediaQuery.of(context).size.width * 0.75,
      height: 45,
      decoration: BoxDecoration(
        // Fond plus visible mais toujours discret
        color: Colors.grey.shade200.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.5,
        ),
        // Ajout d'une ombre très subtile pour plus de profondeur
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Fond de l'icône plus visible
                color: Colors.grey.shade300.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule,
                // Couleur d'icône beaucoup plus foncée pour meilleur contraste
                color: Colors.grey.shade700,
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
                      // Texte principal beaucoup plus foncé pour meilleure lisibilité
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Disponible dans $formattedCooldown',
                    style: GoogleFonts.baloo2(
                      // Texte secondaire plus foncé mais toujours distinguable
                      color: Colors.grey.shade700,
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
                // Fond du timer plus contrasté
                color: Colors.grey.shade300.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                // Bordure subtile pour délimiter la zone du timer
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 0.5,
                ),
              ),
              child: Text(
                formattedCooldown,
                style: GoogleFonts.robotoMono(
                  // Timer en couleur foncée pour excellente lisibilité
                  color: Colors.grey.shade800,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
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
          AppLocalizations.of(context)!.errorActivatingMoneyTime,
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
        AppLocalizations.of(context)!.errorOccurred,
      );
    }
  }

  Future<void> _activateFreeMoneyTime(BuildContext context, GameProvider gameProvider) async {
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.card_giftcard,
                color: Colors.green.shade600,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Money Time Gratuit',
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.enjoy30MinFree,
                style: GoogleFonts.baloo2(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noLifeLossFor30Min,
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.uniqueWelcomeOffer,
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.immediateActivation,
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.activateNowQuestion,
                style: GoogleFonts.baloo2(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context)!.later,
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                AppLocalizations.of(context)!.activate,
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        // Activate free Money Time
        final success = await gameProvider.moneyTimeService.activateFreeMoneyTime();
        
        if (!context.mounted) return;
        
        if (success) {
          FeedbackService.showSuccess(
            context,
            AppLocalizations.of(context)!.freeMoneyTimeActivated,
          );
        } else {
          FeedbackService.showError(
            context,
            AppLocalizations.of(context)!.cannotActivateFreeMoneyTime,
          );
        }
      }
    } catch (e) {
      debugPrint('Error activating free Money Time: $e');
      
      if (!context.mounted) return;
      
      FeedbackService.showError(
        context,
        AppLocalizations.of(context)!.errorOccurred,
      );
    }
  }
}