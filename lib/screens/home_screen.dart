import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../utils/debug_config.dart';
import 'level_map_screen.dart';
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
                            ),
                            _buildStatCard(
                              icon: Icons.lightbulb,
                              value: '${gameProvider.gameState.hints}',
                              label: 'Indices',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        _buildMainButton(
                          context,
                          'JOUER',
                          Icons.play_arrow,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LevelMapScreen(),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        ],
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
}