import 'package:flutter_test/flutter_test.dart';
import 'package:lazypanda_top10_challenge/config/money_time_config.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';

void main() {
  group('MoneyTimeConfig Tests', () {
    test('should have correct duration to ads mapping', () {
      expect(MoneyTimeConfig.durationToAds[15], equals(2));
      expect(MoneyTimeConfig.durationToAds[30], equals(3));
      expect(MoneyTimeConfig.durationToAds[60], equals(5));
    });

    test('should return correct ads required for duration', () {
      expect(MoneyTimeConfig.getAdsRequiredForDuration(15), equals(2));
      expect(MoneyTimeConfig.getAdsRequiredForDuration(30), equals(3));
      expect(MoneyTimeConfig.getAdsRequiredForDuration(60), equals(5));
      expect(MoneyTimeConfig.getAdsRequiredForDuration(99), equals(3)); // Default
    });

    test('should validate durations correctly', () {
      expect(MoneyTimeConfig.isValidDuration(15), isTrue);
      expect(MoneyTimeConfig.isValidDuration(30), isTrue);
      expect(MoneyTimeConfig.isValidDuration(60), isTrue);
      expect(MoneyTimeConfig.isValidDuration(99), isFalse);
    });

    test('should format duration display text correctly', () {
      expect(MoneyTimeConfig.getDurationDisplayText(15), equals('15 min (2 pubs)'));
      expect(MoneyTimeConfig.getDurationDisplayText(30), equals('30 min (3 pubs)'));
      expect(MoneyTimeConfig.getDurationDisplayText(60), equals('60 min (5 pubs)'));
    });

    test('should format remaining time correctly', () {
      final duration1 = Duration(minutes: 15, seconds: 30);
      expect(MoneyTimeConfig.formatRemainingTime(duration1), equals('15:30'));
      
      final duration2 = Duration(minutes: 5, seconds: 5);
      expect(MoneyTimeConfig.formatRemainingTime(duration2), equals('05:05'));
      
      final duration3 = Duration(seconds: 45);
      expect(MoneyTimeConfig.formatRemainingTime(duration3), equals('00:45'));
    });

    test('should format cooldown time correctly', () {
      final duration1 = Duration(hours: 2, minutes: 30);
      expect(MoneyTimeConfig.formatCooldownTime(duration1), equals('2h 30min'));
      
      final duration2 = Duration(hours: 1);
      expect(MoneyTimeConfig.formatCooldownTime(duration2), equals('1h'));
      
      final duration3 = Duration(minutes: 45);
      expect(MoneyTimeConfig.formatCooldownTime(duration3), equals('45min'));
    });

    test('should have correct constants', () {
      expect(MoneyTimeConfig.defaultDuration, equals(30));
      expect(MoneyTimeConfig.cooldownDuration, equals(Duration(hours: 4)));
      expect(MoneyTimeConfig.warningBeforeEnd, equals(Duration(minutes: 1)));
      expect(MoneyTimeConfig.maxConsecutiveAds, equals(5));
      expect(MoneyTimeConfig.timeBetweenAds, equals(Duration(seconds: 1)));
    });
  });

  group('GameState Money Time Logic Tests', () {
    group('Money Time State Management', () {
      test('should correctly identify active Money Time', () {
        final activeEndTime = DateTime.now().add(Duration(minutes: 15));
        final gameState = GameState(moneyTimeEndTime: activeEndTime);
        
        expect(gameState.isMoneyTimeActive(), isTrue);
        expect(gameState.getMoneyTimeRemaining(), isNotNull);
      });

      test('should correctly identify expired Money Time', () {
        final expiredEndTime = DateTime.now().subtract(Duration(minutes: 5));
        final gameState = GameState(moneyTimeEndTime: expiredEndTime);
        
        expect(gameState.isMoneyTimeActive(), isFalse);
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });

      test('should correctly identify inactive Money Time', () {
        final gameState = GameState();
        
        expect(gameState.isMoneyTimeActive(), isFalse);
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });
    });

    group('Money Time Cooldown Logic', () {
      test('should allow activation when no previous activation', () {
        final gameState = GameState();
        
        expect(gameState.canActivateMoneyTime(), isTrue);
        expect(gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });

      test('should prevent activation during cooldown', () {
        final recentActivation = DateTime.now().subtract(Duration(hours: 2));
        final gameState = GameState(lastMoneyTimeActivation: recentActivation);
        
        expect(gameState.canActivateMoneyTime(), isFalse);
        
        final timeUntilAvailable = gameState.getTimeUntilMoneyTimeAvailable();
        expect(timeUntilAvailable, isNotNull);
        expect(timeUntilAvailable!.inHours, equals(1)); // ~2 hours remaining of 4-hour cooldown
      });

      test('should allow activation after cooldown expires', () {
        final oldActivation = DateTime.now().subtract(Duration(hours: 5));
        final gameState = GameState(lastMoneyTimeActivation: oldActivation);
        
        expect(gameState.canActivateMoneyTime(), isTrue);
        expect(gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });
    });

    group('Money Time Remaining Calculation', () {
      test('should calculate remaining time correctly', () {
        final endTime = DateTime.now().add(Duration(minutes: 15, seconds: 30));
        final gameState = GameState(moneyTimeEndTime: endTime);
        
        final remaining = gameState.getMoneyTimeRemaining();
        expect(remaining, isNotNull);
        expect(remaining!.inMinutes, equals(15));
        expect(remaining.inSeconds % 60, greaterThanOrEqualTo(29));
      });

      test('should return null for expired Money Time', () {
        final expiredTime = DateTime.now().subtract(Duration(minutes: 1));
        final gameState = GameState(moneyTimeEndTime: expiredTime);
        
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });
    });

    group('Money Time Progress Tracking', () {
      test('should track activation progress correctly', () {
        final gameState = GameState(
          moneyTimeAdsWatched: 2,
          selectedMoneyTimeDuration: 30,
        );
        
        expect(gameState.moneyTimeAdsWatched, equals(2));
        expect(gameState.selectedMoneyTimeDuration, equals(30));
      });

      test('should reset progress correctly', () {
        final initialState = GameState(
          moneyTimeAdsWatched: 3,
          selectedMoneyTimeDuration: 60,
        );
        
        final resetState = initialState.copyWith(moneyTimeAdsWatched: 0);
        
        expect(resetState.moneyTimeAdsWatched, equals(0));
        expect(resetState.selectedMoneyTimeDuration, equals(60)); // Duration preserved
      });
    });

    group('JSON Serialization', () {
      test('should serialize Money Time fields correctly', () {
        final endTime = DateTime.now().add(Duration(minutes: 30));
        final activation = DateTime.now().subtract(Duration(hours: 1));
        
        final gameState = GameState(
          moneyTimeEndTime: endTime,
          lastMoneyTimeActivation: activation,
          moneyTimeAdsWatched: 2,
          selectedMoneyTimeDuration: 30,
        );
        
        final json = gameState.toJson();
        
        expect(json['moneyTimeEndTime'], equals(endTime.toIso8601String()));
        expect(json['lastMoneyTimeActivation'], equals(activation.toIso8601String()));
        expect(json['moneyTimeAdsWatched'], equals(2));
        expect(json['selectedMoneyTimeDuration'], equals(30));
      });

      test('should deserialize Money Time fields correctly', () {
        final endTime = DateTime.now().add(Duration(minutes: 30));
        final activation = DateTime.now().subtract(Duration(hours: 1));
        
        final json = <String, dynamic>{
          'moneyTimeEndTime': endTime.toIso8601String(),
          'lastMoneyTimeActivation': activation.toIso8601String(),
          'moneyTimeAdsWatched': 2,
          'selectedMoneyTimeDuration': 30,
          'currentLevel': 1,
          'lives': 5,
          'hintPoints': 50,
          'completedLevels': <int>[],
          'lastPlayedDate': DateTime.now().toIso8601String(),
          'dailyChallengeCompleted': false,
          'foundAnswersByLevel': <String, dynamic>{},
          'revealedHintsByLevel': <String, dynamic>{},
          'hintLevelsByLevel': <String, dynamic>{},
          'totalPoints': 0,
          'unlockedTiers': <int>[1],
        };
        
        final gameState = GameState.fromJson(json);
        
        expect(gameState.moneyTimeEndTime, equals(endTime));
        expect(gameState.lastMoneyTimeActivation, equals(activation));
        expect(gameState.moneyTimeAdsWatched, equals(2));
        expect(gameState.selectedMoneyTimeDuration, equals(30));
      });

      test('should handle null Money Time fields in JSON', () {
        final json = <String, dynamic>{
          'currentLevel': 1,
          'lives': 5,
          'hintPoints': 50,
          'completedLevels': <int>[],
          'lastPlayedDate': DateTime.now().toIso8601String(),
          'dailyChallengeCompleted': false,
          'foundAnswersByLevel': <String, dynamic>{},
          'revealedHintsByLevel': <String, dynamic>{},
          'hintLevelsByLevel': <String, dynamic>{},
          'totalPoints': 0,
          'unlockedTiers': <int>[1],
        };
        
        final gameState = GameState.fromJson(json);
        
        expect(gameState.moneyTimeEndTime, isNull);
        expect(gameState.lastMoneyTimeActivation, isNull);
        expect(gameState.moneyTimeAdsWatched, equals(0));
        expect(gameState.selectedMoneyTimeDuration, equals(30)); // Default
      });
    });
  });
}