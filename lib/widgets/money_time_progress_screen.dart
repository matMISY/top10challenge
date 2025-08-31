import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';

class MoneyTimeProgressScreen extends StatefulWidget {
  final int targetAds;
  final int selectedDuration;

  const MoneyTimeProgressScreen({
    super.key,
    required this.targetAds,
    required this.selectedDuration,
  });

  @override
  State<MoneyTimeProgressScreen> createState() => _MoneyTimeProgressScreenState();
}

class _MoneyTimeProgressScreenState extends State<MoneyTimeProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutQuart,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
    
    // Listen for Money Time activation completion
    _listenForActivationCompletion();
  }
  
  void _listenForActivationCompletion() {
    // We'll check if Money Time becomes active (which means activation completed successfully)
    Future.delayed(Duration(seconds: 1), _checkActivationStatus);
  }
  
  void _checkActivationStatus() {
    if (!mounted) return;
    
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    // If Money Time is now active, activation was successful
    if (gameProvider.gameState.isMoneyTimeActive()) {
      // Close the progress screen with success result
      Navigator.of(context).pop(true);
      return;
    }
    
    // If activation is no longer in progress and Money Time is not active, it failed
    if (!gameProvider.moneyTimeService.isActivationInProgress) {
      // Close the progress screen with failure result
      Navigator.of(context).pop(false);
      return;
    }
    
    // Still in progress, check again in 1 second
    Future.delayed(Duration(seconds: 1), _checkActivationStatus);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back navigation during activation process
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade900,
                Colors.deepPurple.shade800,
                Colors.indigo.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                final currentAds = gameProvider.moneyTimeService.currentAdsWatched;
                final progress = widget.targetAds > 0 ? currentAds / widget.targetAds : 0.0;
                
                // Update progress animation when ads count changes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _progressController.animateTo(progress);
                });

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildProgressIndicator(currentAds, progress),
                      const SizedBox(height: 48),
                      _buildStatusMessage(currentAds),
                      const SizedBox(height: 32),
                      _buildWarningMessage(),
                      const Spacer(),
                      _buildBottomInfo(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.activationInProgress,
                style: GoogleFonts.bangers(
                  color: Colors.white,
                  fontSize: 28,
                  letterSpacing: 1.5,
                  shadows: [
                    const Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.moneyTimeMinutes(widget.selectedDuration),
                style: GoogleFonts.baloo2(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(int currentAds, double progress) {
    return Column(
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                // Progress circle
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber.shade400,
                        ),
                      ),
                    );
                  },
                ),
                // Center content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.advertisement,
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.adsCompleted(currentAds, widget.targetAds),
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.completed(currentAds > 1 ? 's' : ''),
                      style: GoogleFonts.baloo2(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Progress dots
        _buildProgressDots(currentAds),
      ],
    );
  }

  Widget _buildProgressDots(int currentAds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.targetAds, (index) {
        final isCompleted = index < currentAds;
        final isCurrent = index == currentAds;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isCurrent ? 16 : 12,
          height: isCurrent ? 16 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted 
                ? Colors.amber.shade400
                : isCurrent
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
            boxShadow: (isCompleted || isCurrent) ? [
              BoxShadow(
                color: (isCompleted ? Colors.amber.shade400 : Colors.white)
                    .withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
        );
      }),
    );
  }

  Widget _buildStatusMessage(int currentAds) {
    String message;
    IconData icon;
    
    if (currentAds == 0) {
      message = 'Préparation de la première publicité...';
      icon = Icons.hourglass_empty;
    } else if (currentAds < widget.targetAds) {
      message = 'Chargement de la publicité suivante...';
      icon = Icons.refresh;
    } else {
      message = 'Activation du Money Time...';
      icon = Icons.check_circle;
    }

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentAds < widget.targetAds) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ] else ...[
                Icon(icon, color: Colors.white, size: 20),
              ],
              const SizedBox(width: 12),
              Text(
                message,
                style: GoogleFonts.baloo2(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade400.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: Colors.orange.shade300,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.doNotLeaveScreen,
              style: GoogleFonts.baloo2(
                color: Colors.orange.shade200,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.stayOnPage,
          style: GoogleFonts.baloo2(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield,
              color: Colors.white.withValues(alpha: 0.5),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.securedByMoneyTime,
              style: GoogleFonts.baloo2(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}