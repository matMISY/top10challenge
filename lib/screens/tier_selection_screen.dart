import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/tier.dart';
import '../models/game_state.dart';
import 'tier_levels_screen.dart';

class TierSelectionScreen extends StatelessWidget {
  const TierSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paliers'),
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
        child: Selector<GameProvider, ({int totalPoints, List<int> unlockedTiers, List<int> completedLevels})>(
          selector: (context, gameProvider) => (
            totalPoints: gameProvider.gameState.totalPoints,
            unlockedTiers: gameProvider.gameState.unlockedTiers,
            completedLevels: gameProvider.gameState.completedLevels,
          ),
          builder: (context, gameState, child) {
            final gameProvider = context.read<GameProvider>();
            return FutureBuilder<List<Tier>>(
              future: gameProvider.gameService.getTiers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                }
                
                final tiers = snapshot.data ?? [];
                
                return Column(
                  children: [
                    _buildPointsHeader(gameState.totalPoints),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tiers.length,
                        itemBuilder: (context, index) {
                          final tier = tiers[index];
                          return _buildTierCard(context, tier, gameState, gameProvider);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPointsHeader(int totalPoints) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '$totalPoints Points',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B73FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(BuildContext context, Tier tier, ({int totalPoints, List<int> unlockedTiers, List<int> completedLevels}) gameState, GameProvider gameProvider) {
    final isUnlocked = gameState.unlockedTiers.contains(tier.id);
    final canUnlock = gameState.totalPoints >= tier.unlockCost;
    final completedLevels = tier.getCompletedLevelsCount(gameState.completedLevels);
    final totalLevels = tier.levelIds.length;
    final progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: isUnlocked
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TierLevelsScreen(tier: tier),
                  ),
                )
            : canUnlock
                ? () => _showUnlockDialog(context, tier, gameState.totalPoints, gameProvider)
                : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isUnlocked
                  ? [Colors.green.shade400, Colors.green.shade600]
                  : canUnlock
                      ? [Colors.blue.shade400, Colors.blue.shade600]
                      : [Colors.grey.shade400, Colors.grey.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isUnlocked
                        ? Icons.lock_open
                        : canUnlock
                            ? Icons.lock_outline
                            : Icons.lock,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tier.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tier.unlockCost}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (isUnlocked) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progression: $completedLevels/$totalLevels niveaux',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (tier.isCompleted)
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
            ],
          ),
        ),
      ),
    );
  }

  void _showUnlockDialog(BuildContext context, Tier tier, int totalPoints, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock_open, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Débloquer ${tier.name}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tier.description),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Coût: ${tier.unlockCost} points',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Vos points: $totalPoints',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await gameProvider.gameService.unlockTier(tier.id);
                await gameProvider.loadGameData();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Débloquer'),
            ),
          ],
        );
      },
    );
  }
}