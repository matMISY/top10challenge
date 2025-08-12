import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../models/tier.dart';
import '../models/level.dart';
import '../models/game_state.dart';
import 'game_screen.dart';

class TierLevelsScreen extends StatelessWidget {
  final Tier tier;

  const TierLevelsScreen({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tier.name),
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
        child: _TierLevelsContent(tier: tier),
      ),
    );
  }

}

class _TierLevelsContent extends StatefulWidget {
  final Tier tier;
  
  const _TierLevelsContent({required this.tier});
  
  @override
  State<_TierLevelsContent> createState() => _TierLevelsContentState();
}

class _TierLevelsContentState extends State<_TierLevelsContent> {
  List<Level> _cachedTierLevels = [];
  GameProvider? _gameProvider;
  final int _lastLivesCount = -1;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (_gameProvider != gameProvider || _cachedTierLevels.isEmpty) {
      _gameProvider = gameProvider;
      _updateTierLevels();
    }
  }
  
  void _updateTierLevels() {
    if (_gameProvider != null) {
      final newTierLevels = _gameProvider!.levels
          .where((level) => widget.tier.levelIds.contains(level.id))
          .toList()
        ..sort((a, b) => a.positionInTier.compareTo(b.positionInTier));
      
      // Mettre à jour le cache même si la référence des objets a changé
      _cachedTierLevels = newTierLevels;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Mettre à jour le cache à chaque rebuild pour refléter les changements d'état des niveaux
        _updateTierLevels();
        
        return Column(
          children: [
            _buildTierHeader(gameProvider, _cachedTierLevels),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _cachedTierLevels.length,
                itemBuilder: (context, index) {
                  final level = _cachedTierLevels[index];
                  return _LevelCard(
                    key: ValueKey('level_${level.id}_${level.isCompleted}_${gameProvider.gameState.lives}'),
                    level: level,
                    gameProvider: gameProvider,
                    isBoss: index == 4,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildTierHeader(GameProvider gameProvider, List<Level> tierLevels) {
    final completedCount = tierLevels.where((level) => level.isCompleted).length;
    final totalCount = tierLevels.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.tier.description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B73FF),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.progress(completedCount, totalCount),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (widget.tier.isCompleted)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final GameProvider gameProvider;
  final bool isBoss;

  const _LevelCard({
    super.key,
    required this.level,
    required this.gameProvider,
    required this.isBoss,
  });

  @override
  Widget build(BuildContext context) {
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
                          ? isBoss
                              ? [Colors.purple.shade400, Colors.purple.shade600]
                              : [Colors.blue.shade400, Colors.blue.shade600]
                      : isUnlocked && !canPlay
                          ? [Colors.red.shade400, Colors.red.shade600]
                          : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                border: isBoss
                    ? Border.all(color: Colors.amber, width: 3)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.star
                          : isUnlocked && canPlay
                              ? isBoss ? Icons.emoji_events : Icons.play_arrow
                          : isUnlocked && !canPlay
                              ? Icons.favorite_border
                              : Icons.lock,
                      size: isBoss ? 36 : 32,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.levelPosition(level.positionInTier),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.levelId(level.id.toString()),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isUnlocked || isCompleted) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getDifficultyText(level.difficulty, context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${level.pointsReward + (isBoss ? 1 : 0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
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
        return AppLocalizations.of(context)!.difficultyVeryEasy;
      case 2:
        return AppLocalizations.of(context)!.difficultyEasy;
      case 3:
        return AppLocalizations.of(context)!.difficultyMedium;
      case 4:
        return AppLocalizations.of(context)!.difficultyHard;
      case 5:
        return AppLocalizations.of(context)!.difficultyVeryHard;
      case 6:
        return AppLocalizations.of(context)!.difficultyExpert;
      case 7:
        return AppLocalizations.of(context)!.difficultyMaster;
      case 8:
        return AppLocalizations.of(context)!.difficultyLegend;
      case 9:
        return AppLocalizations.of(context)!.difficultyMythic;
      case 10:
        return AppLocalizations.of(context)!.difficultyDivine;
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