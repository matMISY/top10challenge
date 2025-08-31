import 'package:flutter_test/flutter_test.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';

void main() {
  group('GameState Money Time Tests', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState();
    });

    group('isMoneyTimeActive', () {
      test('should return false when moneyTimeEndTime is null', () {
        final state = gameState.copyWith(moneyTimeEndTime: null);
        expect(state.isMoneyTimeActive(), isFalse);
      });

      test('should return true when moneyTimeEndTime is in the future', () {
        final endTime = DateTime.now().add(const Duration(minutes: 30));
        final state = gameState.copyWith(moneyTimeEndTime: endTime);
        expect(state.isMoneyTimeActive(), isTrue);
      });

      test('should return false when moneyTimeEndTime is in the past', () {
        final endTime = DateTime.now().subtract(const Duration(minutes: 30));
        final state = gameState.copyWith(moneyTimeEndTime: endTime);
        expect(state.isMoneyTimeActive(), isFalse);
      });
    });

    group('getMoneyTimeRemaining', () {
      test('should return null when Money Time is not active', () {
        final state = gameState.copyWith(moneyTimeEndTime: null);
        expect(state.getMoneyTimeRemaining(), isNull);
      });

      test('should return correct duration when Money Time is active', () {
        final endTime = DateTime.now().add(const Duration(minutes: 15));
        final state = gameState.copyWith(moneyTimeEndTime: endTime);
        final remaining = state.getMoneyTimeRemaining();
        
        expect(remaining, isNotNull);
        expect(remaining!.inMinutes, equals(14)); // Allow for 1 minute margin
      });

      test('should return null when Money Time has expired', () {
        final endTime = DateTime.now().subtract(const Duration(minutes: 5));
        final state = gameState.copyWith(moneyTimeEndTime: endTime);
        expect(state.getMoneyTimeRemaining(), isNull);
      });
    });

    group('canActivateMoneyTime', () {
      test('should return true when never activated before', () {
        final state = gameState.copyWith(lastMoneyTimeActivation: null);
        expect(state.canActivateMoneyTime(), isTrue);
      });

      test('should return true when cooldown has passed', () {
        final lastActivation = DateTime.now().subtract(const Duration(hours: 5));
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);
        expect(state.canActivateMoneyTime(), isTrue);
      });

      test('should return false when still in cooldown', () {
        final lastActivation = DateTime.now().subtract(const Duration(hours: 2));
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);
        expect(state.canActivateMoneyTime(), isFalse);
      });

      test('should return false when exactly at cooldown duration', () {
        final lastActivation = DateTime.now().subtract(GameState.moneyTimeCooldownDuration);
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);
        // Should be true when exactly at cooldown duration
        expect(state.canActivateMoneyTime(), isTrue);
      });
    });

    group('getTimeUntilMoneyTimeAvailable', () {
      test('should return null when Money Time can be activated', () {
        final state = gameState.copyWith(lastMoneyTimeActivation: null);
        expect(state.getTimeUntilMoneyTimeAvailable(), isNull);
      });

      test('should return correct duration when in cooldown', () {
        final lastActivation = DateTime.now().subtract(const Duration(hours: 2));
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);
        final timeUntilAvailable = state.getTimeUntilMoneyTimeAvailable();
        
        expect(timeUntilAvailable, isNotNull);
        expect(timeUntilAvailable!.inHours, equals(1)); // 2 hours remaining in 4-hour cooldown
      });

      test('should return null when cooldown has just passed', () {
        final lastActivation = DateTime.now().subtract(const Duration(hours: 5));
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);
        expect(state.getTimeUntilMoneyTimeAvailable(), isNull);
      });
    });

    group('JSON Serialization', () {
      test('should serialize and deserialize Money Time fields correctly', () {
        final endTime = DateTime.now().add(const Duration(minutes: 30));
        final activationTime = DateTime.now().subtract(const Duration(hours: 2));
        
        final originalState = gameState.copyWith(
          moneyTimeEndTime: endTime,
          lastMoneyTimeActivation: activationTime,
          moneyTimeAdsWatched: 2,
          selectedMoneyTimeDuration: 60,
        );

        final json = originalState.toJson();
        final deserializedState = GameState.fromJson(json);

        expect(deserializedState.moneyTimeEndTime, equals(endTime));
        expect(deserializedState.lastMoneyTimeActivation, equals(activationTime));
        expect(deserializedState.moneyTimeAdsWatched, equals(2));
        expect(deserializedState.selectedMoneyTimeDuration, equals(60));
      });

      test('should handle null Money Time fields in JSON', () {
        final state = gameState.copyWith(
          moneyTimeEndTime: null,
          lastMoneyTimeActivation: null,
        );

        final json = state.toJson();
        final deserializedState = GameState.fromJson(json);

        expect(deserializedState.moneyTimeEndTime, isNull);
        expect(deserializedState.lastMoneyTimeActivation, isNull);
        expect(deserializedState.moneyTimeAdsWatched, equals(0));
        expect(deserializedState.selectedMoneyTimeDuration, equals(30));
      });

      test('should provide default values for missing Money Time fields in JSON', () {
        final json = gameState.toJson();
        // Remove Money Time fields to simulate old save data
        json.remove('moneyTimeEndTime');
        json.remove('lastMoneyTimeActivation');
        json.remove('moneyTimeAdsWatched');
        json.remove('selectedMoneyTimeDuration');

        final deserializedState = GameState.fromJson(json);

        expect(deserializedState.moneyTimeEndTime, isNull);
        expect(deserializedState.lastMoneyTimeActivation, isNull);
        expect(deserializedState.moneyTimeAdsWatched, equals(0));
        expect(deserializedState.selectedMoneyTimeDuration, equals(30));
      });
    });

    group('copyWith Money Time fields', () {
      test('should copy with new Money Time values', () {
        final endTime = DateTime.now().add(const Duration(minutes: 45));
        final activationTime = DateTime.now().subtract(const Duration(hours: 1));

        final newState = gameState.copyWith(
          moneyTimeEndTime: endTime,
          lastMoneyTimeActivation: activationTime,
          moneyTimeAdsWatched: 3,
          selectedMoneyTimeDuration: 45,
        );

        expect(newState.moneyTimeEndTime, equals(endTime));
        expect(newState.lastMoneyTimeActivation, equals(activationTime));
        expect(newState.moneyTimeAdsWatched, equals(3));
        expect(newState.selectedMoneyTimeDuration, equals(45));
      });

      test('should preserve existing values when not specified in copyWith', () {
        final endTime = DateTime.now().add(const Duration(minutes: 30));
        final activationTime = DateTime.now().subtract(const Duration(hours: 2));

        final stateWithMoneyTime = gameState.copyWith(
          moneyTimeEndTime: endTime,
          lastMoneyTimeActivation: activationTime,
          moneyTimeAdsWatched: 2,
          selectedMoneyTimeDuration: 60,
        );

        final newState = stateWithMoneyTime.copyWith(lives: 3);

        expect(newState.lives, equals(3));
        expect(newState.moneyTimeEndTime, equals(endTime));
        expect(newState.lastMoneyTimeActivation, equals(activationTime));
        expect(newState.moneyTimeAdsWatched, equals(2));
        expect(newState.selectedMoneyTimeDuration, equals(60));
      });
    });

    group('Edge Cases', () {
      test('should handle DateTime precision correctly', () {
        final now = DateTime.now();
        final endTime = now.add(const Duration(microseconds: 500));
        final state = gameState.copyWith(moneyTimeEndTime: endTime);

        expect(state.isMoneyTimeActive(), isTrue);
      });

      test('should handle boundary conditions for cooldown', () {
        // Almost at cooldown limit but not quite
        final cooldownMinusOne = Duration(
          milliseconds: GameState.moneyTimeCooldownDuration.inMilliseconds - 1,
        );
        final lastActivation = DateTime.now().subtract(cooldownMinusOne);
        final state = gameState.copyWith(lastMoneyTimeActivation: lastActivation);

        expect(state.canActivateMoneyTime(), isFalse);
      });
    });
  });
}