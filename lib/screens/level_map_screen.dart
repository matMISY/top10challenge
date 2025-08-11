import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.levels),
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
                          _getDifficultyText(level.difficulty, context),
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

  String _getDifficultyText(int difficulty, BuildContext context) {
    switch (difficulty) {
      case 1:
        return AppLocalizations.of(context)!.difficultyEasy;
      case 2:
        return AppLocalizations.of(context)!.difficultyMedium;
      case 3:
        return AppLocalizations.of(context)!.difficultyHard;
      default:
        return AppLocalizations.of(context)!.difficultyExpert;
    }
  }

  void _showNoLivesDialog(BuildContext context, GameProvider gameProvider) {
    final timeUntilNext = gameProvider.gameState.getTimeUntilNextLife();
    final canWatchAd = gameProvider.canWatchAdForLife();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.noMoreLives),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.noMoreLivesToPlay,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              if (timeUntilNext != null) ...[
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.nextLifeIn(_formatDuration(timeUntilNext)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.livesRecoverAutomatically,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.oneLifeEveryMinutes(GameState.lifeRecoveryDuration.inMinutes),
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
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_filled, color: Colors.purple, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.watchAnAd,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.toGetLives,
                              style: const TextStyle(fontSize: 13),
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
              child: Text(AppLocalizations.of(context)!.close),
            ),
            if (canWatchAd) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await gameProvider.watchAdForLife();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.livesAdded),
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
                label: Text(AppLocalizations.of(context)!.watchAnAdButton),
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