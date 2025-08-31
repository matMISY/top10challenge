import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'package:flag/flag.dart';
import '../providers/game_provider.dart';
import '../providers/locale_provider.dart';
import '../models/game_state.dart';
import '../utils/debug_config.dart';
import '../services/feedback_service.dart';
import '../widgets/money_time_button.dart';
import '../config/hint_config.dart';
import 'tier_selection_screen.dart';
import 'daily_challenge_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Bouton de langue en haut à droite
              Positioned(
                top: 20,
                right: 20,
                child: _buildLanguageButton(context),
              ),
              // Contenu principal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: GoogleFonts.bangers(
                    fontSize: 72,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.challengeSubtitle,
                  style: GoogleFonts.bangers(
                    fontSize: 28,
                    color: Colors.amber.shade300,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 60),
                Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard(
                              context: context,
                              icon: Icons.favorite,
                              value: '${gameProvider.gameState.lives}/${GameState.maxLivesWithAds}',
                              label: AppLocalizations.of(context)!.lives,
                              color: Colors.red,
                              gameProvider: gameProvider,
                            ),
                            _buildStatCard(
                              context: context,
                              icon: Icons.star,
                              value: '${gameProvider.gameState.totalPoints}',
                              label: AppLocalizations.of(context)!.points,
                              color: Colors.amber,
                            ),
                            _buildStatCard(
                              context: context,
                              icon: Icons.lightbulb,
                              value: '${gameProvider.gameState.hintPoints}/${HintConfig.maxHintPoints}',
                              label: AppLocalizations.of(context)!.hints,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        
                        // Bouton publicité pour vies si nécessaire
                        if (gameProvider.gameState.lives < GameState.maxLives) ...[
                          const SizedBox(height: 16),
                          _buildAdButton(context, gameProvider),
                        ],
                        // Bouton publicité pour indices
                        const SizedBox(height: 12),
                        _buildHintAdButton(context, gameProvider),
                        
                        // Bouton Money Time
                        const SizedBox(height: 16),
                        const MoneyTimeButton(),
                        const SizedBox(height: 40),
                        _buildMainButton(
                          context,
                          AppLocalizations.of(context)!.play,
                          Icons.play_arrow,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TierSelectionScreen(),
                            ),
                          ),
                        ),
                        if (!DebugConfig.hideDailyChallenge) ...[
                          const SizedBox(height: 20),
                          _buildSecondaryButton(
                            context,
                            AppLocalizations.of(context)!.dailyChallenge,
                            Icons.calendar_today,
                            gameProvider.gameState.dailyChallengeCompleted
                                ? null
                                : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DailyChallengeScreen(),
                                      ),
                                    ),
                            isCompleted: gameProvider.gameState.dailyChallengeCompleted,
                          ),
                        ],
                      ],
                    );
                  },
                ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of(context)!.level(context.watch<GameProvider>().gameState.currentLevel),
                      style: GoogleFonts.baloo2(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    GameProvider? gameProvider,
  }) {
    return SizedBox(
      width: 85, // Largeur réduite pour 3 cartes
      height: 110, // Hauteur fixe pour toutes les cases
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.baloo2(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // Zone réservée pour le timer (vide pour les autres cases)
            SizedBox(
              height: 16, // Hauteur fixe réservée au timer
              child: gameProvider != null && gameProvider.shouldShowLifeTimer()
                  ? _buildNextLifeCountdown(context, gameProvider)
                  : null, // Zone vide mais même hauteur pour les autres cases
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF2C5F5D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback? onPressed, {
    bool isCompleted = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted 
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check : icon, 
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? AppLocalizations.of(context)!.alreadyCompleted : text,
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextLifeCountdown(BuildContext context, GameProvider gameProvider) {
    final formattedTime = gameProvider.getFormattedTimeUntilNextLife();
    
    if (formattedTime == null) {
      return Text(
        AppLocalizations.of(context)!.comingSoon,
        style: GoogleFonts.baloo2(
          color: Colors.amber,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    
    return Text(
      formattedTime,
      style: GoogleFonts.baloo2(
        color: Colors.amber,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAdButton(BuildContext context, GameProvider gameProvider) {
    final canWatchAd = gameProvider.canWatchAdForLife();
    final isWatching = gameProvider.isWatchingAd;
    final adCooldownTime = gameProvider.getFormattedTimeUntilNextAd();
    
    String buttonText;
    IconData buttonIcon;
    bool isEnabled;
    
    if (isWatching) {
      buttonText = AppLocalizations.of(context)!.loading;
      buttonIcon = Icons.hourglass_empty;
      isEnabled = false;
    } else if (canWatchAd) {
      buttonText = AppLocalizations.of(context)!.adForLives(GameState.livesPerAd);
      buttonIcon = Icons.play_circle_filled;
      isEnabled = true;
    } else if (adCooldownTime != null) {
      buttonText = AppLocalizations.of(context)!.nextAdIn(adCooldownTime);
      buttonIcon = Icons.timer;
      isEnabled = false;
    } else {
      buttonText = AppLocalizations.of(context)!.adNotAvailable;
      buttonIcon = Icons.tv_off;
      isEnabled = false;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 45,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _watchAdForLife(context, gameProvider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? Colors.purple.withValues(alpha: 0.8)
              : Colors.grey.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: isEnabled ? 4 : 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWatching) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ] else ...[
              Icon(buttonIcon, size: 18),
            ],
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: GoogleFonts.baloo2(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.favorite, size: 16, color: Colors.red),
            const Text('+5', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _watchAdForLife(BuildContext context, GameProvider gameProvider) async {
    try {
      final success = await gameProvider.watchAdForLife();
      
      // Vérifier si le widget est toujours monté avant d'utiliser context
      if (!context.mounted) return;
      
      if (success) {
        FeedbackService.showLives(context, AppLocalizations.of(context)!.livesGained(GameState.livesPerAd));
      } else {
        FeedbackService.showWarning(context, AppLocalizations.of(context)!.adNotAvailableTryLater);
      }
    } catch (e) {
      // Vérifier si le widget est toujours monté avant d'utiliser context
      if (!context.mounted) return;
      
      FeedbackService.showAdError(context);
    }
  }
  
  Widget _buildHintAdButton(BuildContext context, GameProvider gameProvider) {
    final canWatchAd = gameProvider.canWatchAdForHints();
    final isWatching = gameProvider.isWatchingAd;
    final adCooldownTime = gameProvider.getFormattedTimeUntilNextHintAd();
    
    String buttonText;
    IconData buttonIcon;
    bool isEnabled;
    
    if (isWatching) {
      buttonText = AppLocalizations.of(context)!.loading;
      buttonIcon = Icons.hourglass_empty;
      isEnabled = false;
    } else if (canWatchAd) {
      buttonText = AppLocalizations.of(context)!.adForHints;
      buttonIcon = Icons.lightbulb;
      isEnabled = true;
    } else if (adCooldownTime != null) {
      buttonText = AppLocalizations.of(context)!.nextAdIn(adCooldownTime);
      buttonIcon = Icons.schedule;
      isEnabled = false;
    } else {
      buttonText = AppLocalizations.of(context)!.adNotAvailable;
      buttonIcon = Icons.not_interested;
      isEnabled = false;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 45,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _watchAdForHints(context, gameProvider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? Colors.amber.withValues(alpha: 0.8)
              : Colors.grey.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: isEnabled ? 3 : 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWatching) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(buttonIcon, size: 18),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _watchAdForHints(BuildContext context, GameProvider gameProvider) async {
    try {
      final success = await gameProvider.watchAdForHints();
      
      // Vérifier si le widget est toujours monté avant d'utiliser context
      if (!context.mounted) return;
      
      if (success) {
        FeedbackService.showPointsGained(context, 12);
      } else {
        FeedbackService.showError(context, AppLocalizations.of(context)!.adError);
      }
    } catch (e) {
      debugPrint('Error watching hint ad: $e');
      if (!context.mounted) return;
      
      FeedbackService.showError(context, AppLocalizations.of(context)!.hintsAdError);
    }
  }
  
  Widget _buildLanguageButton(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => localeProvider.toggleLocale(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flag.fromCode(
                      localeProvider.isFrench ? FlagsCode.FR : FlagsCode.GB,
                      height: 20,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      localeProvider.isFrench ? 'FR' : 'EN',
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
