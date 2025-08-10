import 'dart:async';
import 'package:flutter/foundation.dart';
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
  
  /// Dispose of the service and clean up resources
  void dispose() {
    debugPrint('🧹 MoneyTimeService: Disposing');
    cancelActivation();
    _cancelTimers();
  }
}