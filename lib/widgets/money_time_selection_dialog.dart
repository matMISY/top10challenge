import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/money_time_config.dart';

class MoneyTimeSelectionDialog extends StatefulWidget {
  final Function(int) onDurationSelected;

  const MoneyTimeSelectionDialog({
    super.key,
    required this.onDurationSelected,
  });

  @override
  State<MoneyTimeSelectionDialog> createState() => _MoneyTimeSelectionDialogState();
}

class _MoneyTimeSelectionDialogState extends State<MoneyTimeSelectionDialog>
    with TickerProviderStateMixin {
  int _selectedDuration = MoneyTimeConfig.defaultDuration;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isActivating = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));

    _scaleController.forward();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildDurationOptions(),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade600,
            Colors.deepPurple.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'MONEY TIME',
            style: GoogleFonts.bangers(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.playWithoutLosingLives,
            style: GoogleFonts.baloo2(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOptions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.chooseDuration,
            style: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          ...MoneyTimeConfig.availableDurations.map((duration) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDurationOption(duration),
            );
          }),
          const SizedBox(height: 16),
          _buildInfoBox(),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int duration) {
    final isSelected = _selectedDuration == duration;
    final adsRequired = MoneyTimeConfig.getAdsRequiredForDuration(duration);
    final isDefault = duration == MoneyTimeConfig.defaultDuration;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDuration = duration;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.purple.shade50 
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? Colors.purple.shade300 
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? Colors.purple.shade600 
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected 
                    ? Colors.purple.shade600 
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$duration minutes',
                        style: GoogleFonts.baloo2(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.purple.shade700 
                              : Colors.grey.shade700,
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, 
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.recommendedLabel,
                            style: GoogleFonts.baloo2(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.adsToWatch(adsRequired, adsRequired > 1 ? 's' : ''),
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.timer,
              color: isSelected 
                  ? Colors.purple.shade400 
                  : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.duringMoneyTime,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.moneyTimeBenefits,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: _isActivating ? null : () => _handleActivation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: _isActivating ? 0 : 4,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_isActivating)
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white,
                                Colors.white.withValues(alpha: 0.3),
                              ],
                              stops: [
                                _shimmerAnimation.value - 0.3,
                                _shimmerAnimation.value,
                                _shimmerAnimation.value + 0.3,
                              ],
                              transform: GradientRotation(0.5),
                            ).createShader(bounds);
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isActivating) ...[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.launching,
                              style: GoogleFonts.baloo2(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.play_circle_filled, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.watchAdsButton,
                              style: GoogleFonts.baloo2(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: TextButton(
              onPressed: _isActivating ? null : () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.baloo2(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isActivating ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleActivation(BuildContext context) async {
    setState(() {
      _isActivating = true;
    });

    // Small delay for UI feedback
    await Future.delayed(const Duration(milliseconds: 500));

    if (context.mounted) {
      Navigator.of(context).pop();
      widget.onDurationSelected(_selectedDuration);
    }
  }
}