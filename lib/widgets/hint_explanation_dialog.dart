import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../config/hint_config.dart';

class HintExplanationDialog extends StatelessWidget {
  final int currentHintPoints;

  const HintExplanationDialog({
    super.key,
    required this.currentHintPoints,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2C5F5D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.amber.shade300.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      title: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: Colors.amber.shade300,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.hintPoints,
              style: GoogleFonts.baloo2(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points actuels
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade700.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade300.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.amber.shade300,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.yourCurrentPoints,
                          style: GoogleFonts.baloo2(
                            color: Colors.amber.shade100,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$currentHintPoints / ${HintConfig.maxHintPoints}',
                          style: GoogleFonts.baloo2(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Comment utiliser
            Text(
              AppLocalizations.of(context)!.howToUse,
              style: GoogleFonts.baloo2(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.howToUseDescription,
              style: GoogleFonts.baloo2(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            
            // Coûts des indices
            Text(
              AppLocalizations.of(context)!.hintCosts,
              style: GoogleFonts.baloo2(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildHintLevelRow(
              context,
              level: 1,
              cost: HintConfig.hintLevel1Cost,
              description: AppLocalizations.of(context)!.descriptiveHint,
              icon: Icons.help_outline,
            ),
            const SizedBox(height: 8),
            _buildHintLevelRow(
              context,
              level: 2,
              cost: HintConfig.hintLevel2Cost,
              description: AppLocalizations.of(context)!.nameStructure,
              icon: Icons.text_fields,
            ),
            const SizedBox(height: 8),
            _buildHintLevelRow(
              context,
              level: 3,
              cost: HintConfig.hintLevel3Cost,
              description: AppLocalizations.of(context)!.partialLetters,
              icon: Icons.font_download,
            ),
            const SizedBox(height: 16),
            
            // Comment obtenir plus de points
            Text(
              AppLocalizations.of(context)!.getMorePoints,
              style: GoogleFonts.baloo2(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildEarnPointsRow(
              context,
              icon: Icons.play_circle_filled,
              iconColor: Colors.purple,
              title: AppLocalizations.of(context)!.rewardedAd,
              points: HintConfig.pointsPerAd,
            ),
            const SizedBox(height: 8),
            _buildEarnPointsRow(
              context,
              icon: Icons.emoji_events,
              iconColor: Colors.green,
              title: AppLocalizations.of(context)!.completeLevel,
              points: '6-12',
              subtitle: AppLocalizations.of(context)!.accordingToDifficulty,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.amber.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            AppLocalizations.of(context)!.understood,
            style: GoogleFonts.baloo2(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHintLevelRow(
    BuildContext context, {
    required int level,
    required int cost,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.amber.shade700.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.amber.shade300,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Niveau $level',
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.baloo2(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade700.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$cost pts',
              style: GoogleFonts.baloo2(
                color: Colors.amber.shade300,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnPointsRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required dynamic points,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.baloo2(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade700.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+$points',
              style: GoogleFonts.baloo2(
                color: Colors.green.shade300,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}