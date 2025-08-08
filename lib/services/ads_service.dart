import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static const String _rewardedAdUnitIdAndroid = 'ca-app-pub-8151525710763823/3134015862'; // ID de production
  static const String _rewardedAdUnitIdIOS = 'ca-app-pub-8151525710763823/3134015862'; // ID de production
  
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  final Completer<bool> _initCompleter = Completer<bool>();

  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  /// Initialise le service de publicités
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      await _loadRewardedAd();
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete(true);
      }
      debugPrint('🎯 AdsService initialized successfully');
    } catch (e) {
      debugPrint('❌ AdsService initialization failed: $e');
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete(false);
      }
    }
  }

  /// Attend que le service soit initialisé
  Future<bool> waitForInitialization() async {
    return await _initCompleter.future;
  }

  /// Charge une publicité récompensée
  Future<void> _loadRewardedAd() async {
    try {
      final String adUnitId = defaultTargetPlatform == TargetPlatform.android
          ? _rewardedAdUnitIdAndroid
          : _rewardedAdUnitIdIOS;

      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('🎯 Rewarded ad loaded successfully');
            _rewardedAd = ad;
            _isRewardedAdReady = true;
            
            // Configurer les callbacks
            _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) {
                debugPrint('🎯 Rewarded ad showed full screen content');
              },
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                debugPrint('🎯 Rewarded ad dismissed');
                ad.dispose();
                _isRewardedAdReady = false;
                _rewardedAd = null;
                // Précharger la suivante
                _loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                debugPrint('❌ Rewarded ad failed to show: $error');
                ad.dispose();
                _isRewardedAdReady = false;
                _rewardedAd = null;
                // Précharger la suivante
                _loadRewardedAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('❌ Rewarded ad failed to load: $error');
            _isRewardedAdReady = false;
            _rewardedAd = null;
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Error loading rewarded ad: $e');
      _isRewardedAdReady = false;
      _rewardedAd = null;
    }
  }

  /// Vérifie si une publicité récompensée est prête
  bool get isRewardedAdReady => _isRewardedAdReady && _rewardedAd != null;

  /// Affiche une publicité récompensée
  /// Retourne true si la récompense a été gagnée, false sinon
  Future<bool> showRewardedAd() async {
    if (!isRewardedAdReady) {
      debugPrint('❌ No rewarded ad ready to show');
      return false;
    }

    final Completer<bool> rewardCompleter = Completer<bool>();
    bool rewardEarned = false;

    // Configurer temporairement les callbacks pour cette pub spécifique
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        debugPrint('🎯 Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('🎯 Rewarded ad dismissed');
        // Compléter avec le résultat de la récompense
        if (!rewardCompleter.isCompleted) {
          debugPrint('Completing with reward status: $rewardEarned');
          rewardCompleter.complete(rewardEarned);
        }
        
        ad.dispose();
        _isRewardedAdReady = false;
        _rewardedAd = null;
        // Précharger la suivante
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('❌ Rewarded ad failed to show: $error');
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(false);
        }
        ad.dispose();
        _isRewardedAdReady = false;
        _rewardedAd = null;
        // Précharger la suivante
        _loadRewardedAd();
      },
    );

    try {
      await _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
          rewardEarned = true;
        },
      );
    } catch (e) {
      debugPrint('❌ Error showing rewarded ad: $e');
      if (!rewardCompleter.isCompleted) {
        rewardCompleter.complete(false);
      }
    }

    return await rewardCompleter.future;
  }

  /// Précharge une nouvelle publicité récompensée si nécessaire
  Future<void> preloadRewardedAd() async {
    if (!_isRewardedAdReady) {
      await _loadRewardedAd();
    }
  }

  /// Nettoie les ressources
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
  }
}