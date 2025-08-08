import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../utils/debug_config.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'TOP10',
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
                  'CHALLENGE',
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
                              icon: Icons.favorite,
                              value: '${gameProvider.gameState.lives}',
                              label: 'Vies',
                              color: Colors.red,
                              gameProvider: gameProvider,
                            ),
                            _buildStatCard(
                              icon: Icons.star,
                              value: '${gameProvider.gameState.totalPoints}',
                              label: 'Points',
                              color: Colors.amber,
                            ),
                            _buildStatCard(
                              icon: Icons.lightbulb,
                              value: '${gameProvider.gameState.hints}',
                              label: 'Indices',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        
                        // Bouton publicité pour vies si nécessaire
                        if (gameProvider.gameState.lives < GameState.maxLives) ...[
                          const SizedBox(height: 16),
                          _buildAdButton(context, gameProvider),
                        ],
                        const SizedBox(height: 40),
                        _buildMainButton(
                          context,
                          'JOUER',
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
                            'Défi Quotidien',
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
                  'Niveau ${context.watch<GameProvider>().gameState.currentLevel}',
                  style: GoogleFonts.baloo2(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    GameProvider? gameProvider,
  }) {
    return SizedBox(
      width: 85, // Largeur réduite pour 3 cartes
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
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
            if (gameProvider != null && gameProvider.shouldShowLifeTimer()) ...[
              const SizedBox(height: 4),
              _buildNextLifeCountdown(gameProvider),
            ],
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
              isCompleted ? 'Déjà complété' : text,
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

  Widget _buildNextLifeCountdown(GameProvider gameProvider) {
    final formattedTime = gameProvider.getFormattedTimeUntilNextLife();
    
    if (formattedTime == null) {
      return Text(
        'Bientôt !',
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
      buttonText = 'Chargement...';
      buttonIcon = Icons.hourglass_empty;
      isEnabled = false;
    } else if (canWatchAd) {
      buttonText = 'Regarder une pub';
      buttonIcon = Icons.play_circle_filled;
      isEnabled = true;
    } else if (adCooldownTime != null) {
      buttonText = 'Pub dans $adCooldownTime';
      buttonIcon = Icons.timer;
      isEnabled = false;
    } else {
      buttonText = 'Pub indisponible';
      buttonIcon = Icons.tv_off;
      isEnabled = false;
    }

    return SizedBox(
      width: double.infinity,
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
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text('Vous avez gagné 1 vie !'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Publicité non disponible. Réessayez plus tard.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors du chargement de la publicité.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
