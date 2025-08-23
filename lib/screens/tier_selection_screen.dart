import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../models/tier.dart';
import '../extensions/tier_extensions.dart';
import 'tier_levels_screen.dart';

class TierSelectionScreen extends StatelessWidget {
  const TierSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tiers),
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
                    child: Text(AppLocalizations.of(context)!.error(snapshot.error.toString())),
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
    
    // Calculer le coût cumulatif (somme des coûts de tous les tiers précédents + actuel)
    final cumulativeCost = _calculateCumulativeCost(tier, gameProvider.tiers);
    final canUnlock = gameState.totalPoints >= cumulativeCost;
    
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
                ? () => _showUnlockDialog(context, tier, gameState.totalPoints, gameProvider, cumulativeCost)
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
                          tier.getLocalizedName(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tier.getLocalizedDescription(context),
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
                            '$cumulativeCost',
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
                            AppLocalizations.of(context)!.progress(completedLevels, totalLevels),
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

  void _showUnlockDialog(BuildContext context, Tier tier, int totalPoints, GameProvider gameProvider, int cumulativeCost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock_open, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Débloquer ${tier.getLocalizedName(context)}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tier.getLocalizedDescription(context)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Coût: $cumulativeCost points',
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

  /// Calcule le coût cumulatif pour débloquer un tier
  /// (somme de tous les coûts des tiers précédents + coût du tier actuel)
  int _calculateCumulativeCost(Tier targetTier, List<Tier> allTiers) {
    int cumulativeCost = 0;
    
    // Trier les tiers par ID pour s'assurer de l'ordre correct
    final sortedTiers = allTiers.toList()..sort((a, b) => a.id.compareTo(b.id));
    
    debugPrint('🔍 [DIAGNOSTIC UI] Calcul coût cumulatif pour Tier ${targetTier.id}:');
    debugPrint('  - Nombre de tiers disponibles: ${allTiers.length}');
    debugPrint('  - Coût individuel du tier ${targetTier.id}: ${targetTier.unlockCost}');
    debugPrint('  - Nombre de niveaux dans le tier: ${targetTier.levelIds.length}');
    
    // Additionner les coûts de tous les tiers jusqu'au tier cible (inclus)
    for (final tier in sortedTiers) {
      if (tier.id <= targetTier.id) {
        debugPrint('  - Ajout Tier ${tier.id}: ${tier.unlockCost} points (${tier.levelIds.length} niveaux)');
        cumulativeCost += tier.unlockCost;
      } else {
        break; // Arrêter une fois qu'on dépasse le tier cible
      }
    }
    
    debugPrint('  - Coût cumulatif final: $cumulativeCost');
    return cumulativeCost;
  }
}