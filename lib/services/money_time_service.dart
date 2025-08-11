import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../config/money_time_config.dart';
import '../services/ads_service.dart';
import '../providers/game_provider.dart';

/// Service responsible for managing Money Time feature
/// Handles activation sequence, timer management, and integration with ads
class MoneyTimeService {
  final AdsService _adsService;
  final GameProvider _gameProvider;
  
  // Timers for Money Time management
  Timer? _warningTimer;
  Timer? _endTimer;
  Timer? _countdownTimer;
  
  // Activation process state
  int _currentAdsWatched = 0;
  int _targetAds = 0;
  int _selectedDuration = MoneyTimeConfig.defaultDuration;
  bool _isActivationInProgress = false;
  
  // Completion for activation process
  Completer<bool>? _activationCompleter;
  
  MoneyTimeService({
    required AdsService adsService,
    required GameProvider gameProvider,
  }) : _adsService = adsService,
       _gameProvider = gameProvider;
  
  /// Check if an activation is currently in progress
  bool get isActivationInProgress => _isActivationInProgress;
  
  /// Get current ads watched during activation
  int get currentAdsWatched => _currentAdsWatched;
  
  /// Get target ads for current activation
  int get targetAds => _targetAds;
  
  /// Get selected duration for current activation
  int get selectedDuration => _selectedDuration;
  
  /// Activate free Money Time for first-time users
  /// Returns true if successfully activated, false if not eligible or failed
  Future<bool> activateFreeMoneyTime() async {
    if (!_gameProvider.gameState.canActivateFreeMoneyTime()) {
      debugPrint('❌ MoneyTimeService: Not eligible for free Money Time');
      return false;
    }
    
    debugPrint('🎁 MoneyTimeService: Activating free Money Time (30 minutes)');
    
    final endTime = DateTime.now().add(Duration(minutes: 30));
    
    // Mark the free Money Time as used and activate it
    await _gameProvider.activateFreeMoneyTime(endTime);
    
    // Schedule timers for 30 minutes
    _selectedDuration = 30;
    _scheduleWarning();
    _scheduleEnd();
    _startCountdownTimer();
    
    debugPrint('✅ MoneyTimeService: Free Money Time activated successfully');
    return true;
  }

  /// Start the Money Time activation process
  /// Returns true if successfully activated, false if failed or cancelled
  Future<bool> startActivationProcess(int durationMinutes) async {
    if (_isActivationInProgress) {
      debugPrint('⚠️ MoneyTimeService: Activation already in progress');
      return false;
    }
    
    if (!MoneyTimeConfig.isValidDuration(durationMinutes)) {
      debugPrint('❌ MoneyTimeService: Invalid duration: $durationMinutes');
      return false;
    }
    
    if (!_gameProvider.gameState.canActivateMoneyTime()) {
      debugPrint('❌ MoneyTimeService: Money Time is in cooldown');
      return false;
    }
    
    debugPrint('🚀 MoneyTimeService: Starting activation for $durationMinutes minutes');
    
    _selectedDuration = durationMinutes;
    _targetAds = MoneyTimeConfig.getAdsRequiredForDuration(durationMinutes);
    _currentAdsWatched = 0;
    _isActivationInProgress = true;
    _activationCompleter = Completer<bool>();
    
    // Update game state with activation progress
    await _gameProvider.updateMoneyTimeProgress(_currentAdsWatched, _selectedDuration);
    
    // Start the ad watching sequence
    _watchAdsSequentially();
    
    return await _activationCompleter!.future;
  }
  
  /// Cancel the current activation process
  void cancelActivation() {
    if (!_isActivationInProgress) return;
    
    debugPrint('❌ MoneyTimeService: Activation cancelled');
    _resetActivation();
    
    if (_activationCompleter != null && !_activationCompleter!.isCompleted) {
      _activationCompleter!.complete(false);
    }
  }
  
  /// Watch ads sequentially during activation
  Future<void> _watchAdsSequentially() async {
    try {
      while (_currentAdsWatched < _targetAds && _isActivationInProgress) {
        debugPrint('📺 MoneyTimeService: Showing ad ${_currentAdsWatched + 1} of $_targetAds');
        
        // Ensure ad is ready
        if (!_adsService.isRewardedAdReady) {
          debugPrint('⏳ MoneyTimeService: Preloading ad...');
          await _adsService.preloadRewardedAd();
          
          // Wait a bit for ad to load
          await Future.delayed(MoneyTimeConfig.timeBetweenAds);
          
          // Check if ad is still not ready after timeout
          if (!_adsService.isRewardedAdReady) {
            debugPrint('❌ MoneyTimeService: Failed to load ad');
            _failActivation();
            return;
          }
        }
        
        // Show the ad
        final adWatched = await _adsService.showRewardedAd();
        
        if (!_isActivationInProgress) {
          // Activation was cancelled during ad
          debugPrint('❌ MoneyTimeService: Activation cancelled during ad');
          return;
        }
        
        if (!adWatched) {
          debugPrint('❌ MoneyTimeService: User did not complete ad');
          _failActivation();
          return;
        }
        
        // Ad was successfully watched
        _currentAdsWatched++;
        await _gameProvider.updateMoneyTimeProgress(_currentAdsWatched, _selectedDuration);
        debugPrint('✅ MoneyTimeService: Ad completed. Progress: $_currentAdsWatched/$_targetAds');
        
        // Small delay between ads if not the last one
        if (_currentAdsWatched < _targetAds) {
          await Future.delayed(MoneyTimeConfig.timeBetweenAds);
        }
      }
      
      if (_isActivationInProgress && _currentAdsWatched >= _targetAds) {
        // All ads watched successfully, activate Money Time
        await _activateMoneyTime();
      }
    } catch (error) {
      debugPrint('❌ MoneyTimeService: Error during ad sequence: $error');
      _failActivation();
    }
  }
  
  /// Activate Money Time after all ads are watched
  Future<void> _activateMoneyTime() async {
    if (!_isActivationInProgress) return;
    
    debugPrint('🎉 MoneyTimeService: Activating Money Time for $_selectedDuration minutes');
    
    final endTime = DateTime.now().add(Duration(minutes: _selectedDuration));
    
    await _gameProvider.activateMoneyTime(endTime);
    
    // Schedule timers
    _scheduleWarning();
    _scheduleEnd();
    _startCountdownTimer();
    
    // Complete activation
    _resetActivation();
    
    if (_activationCompleter != null && !_activationCompleter!.isCompleted) {
      _activationCompleter!.complete(true);
    }
    
    debugPrint('✅ MoneyTimeService: Money Time activated successfully');
  }
  
  /// Fail the activation process
  void _failActivation() {
    debugPrint('❌ MoneyTimeService: Activation failed');
    _resetActivation();
    
    if (_activationCompleter != null && !_activationCompleter!.isCompleted) {
      _activationCompleter!.complete(false);
    }
  }
  
  /// Reset activation state
  void _resetActivation() {
    _currentAdsWatched = 0;
    _targetAds = 0;
    _isActivationInProgress = false;
    _activationCompleter = null;
    _gameProvider.resetMoneyTimeProgress();
  }
  
  /// Schedule warning notification 1 minute before end
  void _scheduleWarning() {
    if (_selectedDuration <= 1) return; // No warning for very short durations
    
    final warningTime = Duration(minutes: _selectedDuration - 1);
    _warningTimer = Timer(warningTime, () {
      debugPrint('⚠️ MoneyTimeService: Showing warning - 1 minute remaining');
      _gameProvider.showMoneyTimeWarning();
    });
  }
  
  /// Schedule Money Time end
  void _scheduleEnd() {
    _endTimer = Timer(Duration(minutes: _selectedDuration), () {
      debugPrint('⏰ MoneyTimeService: Money Time ended');
      _endMoneyTime();
    });
  }
  
  /// Start countdown timer for UI updates
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_gameProvider.gameState.isMoneyTimeActive()) {
        timer.cancel();
        _countdownTimer = null;
      }
    });
  }
  
  /// End Money Time
  void _endMoneyTime() {
    _cancelTimers();
    _gameProvider.endMoneyTime();
  }
  
  /// Cancel all active timers
  void _cancelTimers() {
    _warningTimer?.cancel();
    _warningTimer = null;
    _endTimer?.cancel();
    _endTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }
  
  /// Check if life loss should be prevented (Money Time is active)
  bool shouldPreventLifeLoss() {
    return _gameProvider.gameState.isMoneyTimeActive();
  }
  
  /// Initialize timers when app starts and Money Time is already active
  void initializeFromState() {
    if (_gameProvider.gameState.isMoneyTimeActive()) {
      final remaining = _gameProvider.gameState.getMoneyTimeRemaining();
      if (remaining != null) {
        debugPrint('🔄 MoneyTimeService: Restoring Money Time timers');
        _selectedDuration = _gameProvider.gameState.selectedMoneyTimeDuration;
        
        // Schedule warning if more than 1 minute remaining
        if (remaining.inMinutes > 0) {
          final warningIn = remaining - MoneyTimeConfig.warningBeforeEnd;
          if (warningIn.isNegative || warningIn.inSeconds <= 0) {
            // Warning time has passed, no need to schedule
          } else {
            _warningTimer = Timer(warningIn, () {
              _gameProvider.showMoneyTimeWarning();
            });
          }
        }
        
        // Schedule end
        _endTimer = Timer(remaining, () {
          _endMoneyTime();
        });
        
        // Start countdown timer
        _startCountdownTimer();
      }
    }
  }
  
  /// Pause timers (e.g., when app goes to background)
  void pauseTimers() {
    debugPrint('⏸️ MoneyTimeService: Pausing timers');
    _cancelTimers();
  }

  /// Resume timers (e.g., when app comes to foreground)
  void resumeTimers() {
    debugPrint('▶️ MoneyTimeService: Resuming timers');
    if (_gameProvider.gameState.isMoneyTimeActive()) {
      debugPrint('🔄 MoneyTimeService: Re-initializing timers after resume');
      initializeFromState();
    }
  }

  /// Handle app lifecycle changes
  void handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Don't pause timers - let them continue in background
        // This ensures Money Time ends at the correct time even if app is backgrounded
        debugPrint('⏸️ MoneyTimeService: App backgrounded but timers continue');
        break;
      case AppLifecycleState.resumed:
        // Check for drift and re-sync timers
        _handleAppResumed();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App might be closing - ensure state is saved
        debugPrint('🔚 MoneyTimeService: App lifecycle ending');
        break;
    }
  }

  /// Handle app resuming from background
  void _handleAppResumed() {
    debugPrint('▶️ MoneyTimeService: Handling app resume');
    
    if (_gameProvider.gameState.isMoneyTimeActive()) {
      final remaining = _gameProvider.gameState.getMoneyTimeRemaining();
      
      if (remaining == null || remaining.isNegative) {
        // Money Time expired while app was in background
        debugPrint('⏰ MoneyTimeService: Money Time expired while in background');
        _endMoneyTime();
      } else {
        // Money Time still active - check if timers are still running
        debugPrint('⏰ MoneyTimeService: Money Time still active, remaining: $remaining');
        
        // Re-sync timers in case there was any drift
        _cancelTimers();
        
        // Recalculate and reschedule timers
        _selectedDuration = _gameProvider.gameState.selectedMoneyTimeDuration;
        
        // Schedule warning if more than 1 minute remaining
        if (remaining.inMinutes > 0) {
          final warningIn = remaining - MoneyTimeConfig.warningBeforeEnd;
          if (!warningIn.isNegative && warningIn.inSeconds > 0) {
            _warningTimer = Timer(warningIn, () {
              _gameProvider.showMoneyTimeWarning();
            });
            debugPrint('⚠️ MoneyTimeService: Warning scheduled in ${warningIn.inSeconds}s');
          }
        }
        
        // Schedule end
        _endTimer = Timer(remaining, () {
          _endMoneyTime();
        });
        debugPrint('⏰ MoneyTimeService: End scheduled in ${remaining.inSeconds}s');
        
        // Start countdown timer
        _startCountdownTimer();
      }
    }
  }

  /// Check for timer health and consistency
  void checkTimerHealth() {
    try {
      if (_gameProvider.gameState.isMoneyTimeActive()) {
        final remaining = _gameProvider.gameState.getMoneyTimeRemaining();
        
        if (remaining == null || remaining.isNegative) {
          debugPrint('🚨 MoneyTimeService: Timer health check failed - expired state');
          _endMoneyTime();
          return;
        }
        
        // Check if timers are still active
        final hasEndTimer = _endTimer?.isActive ?? false;
        final hasCountdownTimer = _countdownTimer?.isActive ?? false;
        
        if (!hasEndTimer || !hasCountdownTimer) {
          debugPrint('⚠️ MoneyTimeService: Timer health check - missing timers, reinitializing');
          initializeFromState();
        }
      }
    } catch (error) {
      debugPrint('❌ MoneyTimeService: Error during timer health check: $error');
      _handleCriticalError(error);
    }
  }

  /// Handle critical errors that could break Money Time
  void _handleCriticalError(dynamic error) {
    debugPrint('🚨 MoneyTimeService: Handling critical error: $error');
    
    try {
      // Cancel all timers to prevent weird states
      _cancelTimers();
      
      // If Money Time is active, try to preserve it
      if (_gameProvider.gameState.isMoneyTimeActive()) {
        final remaining = _gameProvider.gameState.getMoneyTimeRemaining();
        
        if (remaining != null && !remaining.isNegative) {
          debugPrint('🔄 MoneyTimeService: Attempting recovery of active Money Time');
          // Wait a bit and try to reinitialize
          Future.delayed(Duration(seconds: 2), () {
            try {
              initializeFromState();
              debugPrint('✅ MoneyTimeService: Recovery successful');
            } catch (recoveryError) {
              debugPrint('❌ MoneyTimeService: Recovery failed: $recoveryError');
              _emergencyEndMoneyTime();
            }
          });
        } else {
          // Money Time is expired/invalid, clean it up
          debugPrint('🧹 MoneyTimeService: Ending invalid Money Time state');
          _emergencyEndMoneyTime();
        }
      }
      
      // Reset activation state in case it's stuck
      if (_isActivationInProgress) {
        debugPrint('🧹 MoneyTimeService: Cleaning up stuck activation');
        _resetActivation();
      }
    } catch (handlingError) {
      debugPrint('❌ MoneyTimeService: Error while handling critical error: $handlingError');
      // Last resort - force clean state
      _forceCleanState();
    }
  }

  /// Emergency end Money Time without normal cleanup
  void _emergencyEndMoneyTime() {
    debugPrint('🚨 MoneyTimeService: Emergency end Money Time');
    try {
      _cancelTimers();
      _gameProvider.endMoneyTime();
    } catch (error) {
      debugPrint('❌ MoneyTimeService: Error during emergency end: $error');
    }
  }

  /// Force clean state as last resort
  void _forceCleanState() {
    debugPrint('🚨 MoneyTimeService: Force cleaning state');
    try {
      _cancelTimers();
      _isActivationInProgress = false;
      _currentAdsWatched = 0;
      _targetAds = 0;
      _activationCompleter = null;
    } catch (error) {
      debugPrint('❌ MoneyTimeService: Error during force clean: $error');
    }
  }

  /// Validate Money Time state consistency
  bool validateState() {
    try {
      final gameState = _gameProvider.gameState;
      
      // Check for impossible states
      if (gameState.isMoneyTimeActive()) {
        final remaining = gameState.getMoneyTimeRemaining();
        if (remaining == null) {
          debugPrint('⚠️ MoneyTimeService: Invalid state - active but no remaining time');
          return false;
        }
        
        if (remaining.isNegative) {
          debugPrint('⚠️ MoneyTimeService: Invalid state - negative remaining time');
          return false;
        }
        
        if (gameState.selectedMoneyTimeDuration <= 0) {
          debugPrint('⚠️ MoneyTimeService: Invalid state - invalid duration');
          return false;
        }
      }
      
      // Check activation state consistency
      if (_isActivationInProgress) {
        if (_targetAds <= 0 || _currentAdsWatched < 0 || _currentAdsWatched > _targetAds) {
          debugPrint('⚠️ MoneyTimeService: Invalid activation state');
          return false;
        }
      }
      
      return true;
    } catch (error) {
      debugPrint('❌ MoneyTimeService: Error during state validation: $error');
      return false;
    }
  }

  /// Dispose of the service and clean up resources
  void dispose() {
    debugPrint('🧹 MoneyTimeService: Disposing');
    cancelActivation();
    _cancelTimers();
  }
}