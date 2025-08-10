import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/level.dart';
import '../models/game_state.dart';
import 'game_screen.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveaux'),
        backgroundColor: const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B73FF),
              Color(0xFF9B59B6),
            ],
          ),
        ),
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: gameProvider.levels.length,
              itemBuilder: (context, index) {
                final level = gameProvider.levels[index];
                return _buildLevelCard(context, level, gameProvider);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, Level level, GameProvider gameProvider) {
    final isUnlocked = level.isUnlocked;
    final isCompleted = level.isCompleted;
    final canPlay = gameProvider.gameState.canPlay();
    
    return GestureDetector(
      onTap: isUnlocked && canPlay
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(level: level),
                ),
              )
          : isUnlocked && !canPlay
              ? () => _showNoLivesDialog(context, gameProvider)
              : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCompleted
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : isUnlocked && canPlay
                          ? [Colors.blue.shade400, Colors.blue.shade600]
                      : isUnlocked && !canPlay
                          ? [Colors.red.shade400, Colors.red.shade600]
                          : [Colors.grey.shade400, Colors.grey.shade600],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.star
                          : isUnlocked && canPlay
                              ? Icons.play_arrow
                          : isUnlocked && !canPlay
                              ? Icons.favorite_border
                              : Icons.lock,
                      size: 32,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${level.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isUnlocked || isCompleted)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getDifficultyText(level.difficulty),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        return 'Expert';
    }
  }

  void _showNoLivesDialog(BuildContext context, GameProvider gameProvider) {
    final timeUntilNext = gameProvider.gameState.getTimeUntilNextLife();
    final canWatchAd = gameProvider.canWatchAdForLife();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text('Plus de vies !'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Vous n\'avez plus de vies pour jouer.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              if (timeUntilNext != null) ...[
                const Center(
                  child: Text(
                    'Prochaine vie dans :',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _formatDuration(timeUntilNext),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                const Center(
                  child: Text(
                    'Les vies se récupèrent automatiquement !',
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    '1 vie toutes les ${GameState.lifeRecoveryDuration.inMinutes} minutes.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (canWatchAd) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.play_circle_filled, color: Colors.purple, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Regardez une publicité',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'pour gagner des vies !',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            if (canWatchAd) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await gameProvider.watchAdForLife();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vies ajoutées ! Bon jeu !'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.play_circle_filled, size: 20),
                label: const Text('Regarder une pub'),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}