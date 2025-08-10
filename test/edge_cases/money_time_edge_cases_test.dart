import 'package:flutter_test/flutter_test.dart';
import 'package:top10_challenge/models/game_state.dart';
import 'package:top10_challenge/config/money_time_config.dart';

void main() {
  group('Money Time Edge Cases Tests', () {
    group('GameState Edge Cases', () {
      test('should handle null end time with active flag false', () {
        final gameState = GameState(moneyTimeEndTime: null);
        
        expect(gameState.isMoneyTimeActive(), isFalse);
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });

      test('should handle expired end time', () {
        final expiredTime = DateTime.now().subtract(Duration(minutes: 10));
        final gameState = GameState(moneyTimeEndTime: expiredTime);
        
        expect(gameState.isMoneyTimeActive(), isFalse);
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });

      test('should handle end time exactly now', () {
        final nowTime = DateTime.now();
        final gameState = GameState(moneyTimeEndTime: nowTime);
        
        // Should be considered inactive when time is exactly now
        expect(gameState.isMoneyTimeActive(), isFalse);
        expect(gameState.getMoneyTimeRemaining(), isNull);
      });

      test('should handle end time 1 second in future', () {
        final futureTime = DateTime.now().add(Duration(seconds: 1));
        final gameState = GameState(moneyTimeEndTime: futureTime);
        
        expect(gameState.isMoneyTimeActive(), isTrue);
        final remaining = gameState.getMoneyTimeRemaining();
        expect(remaining, isNotNull);
        expect(remaining!.inSeconds, equals(0)); // Less than 1 second shows as 0
      });

      test('should handle very far future end time', () {
        final farFuture = DateTime.now().add(Duration(days: 365));
        final gameState = GameState(moneyTimeEndTime: farFuture);
        
        expect(gameState.isMoneyTimeActive(), isTrue);
        final remaining = gameState.getMoneyTimeRemaining();
        expect(remaining, isNotNull);
        expect(remaining!.inDays, equals(364)); // Almost a year
      });

      test('should handle negative ads watched', () {
        final gameState = GameState(moneyTimeAdsWatched: -1);
        
        expect(gameState.moneyTimeAdsWatched, equals(-1));
        // This is invalid but should not crash
      });

      test('should handle excessive ads watched', () {
        final gameState = GameState(moneyTimeAdsWatched: 999);
        
        expect(gameState.moneyTimeAdsWatched, equals(999));
        // This is invalid but should not crash
      });

      test('should handle zero or negative duration', () {
        final gameState1 = GameState(selectedMoneyTimeDuration: 0);
        final gameState2 = GameState(selectedMoneyTimeDuration: -30);
        
        expect(gameState1.selectedMoneyTimeDuration, equals(0));
        expect(gameState2.selectedMoneyTimeDuration, equals(-30));
        // These are invalid but should not crash
      });
    });

    group('Cooldown Edge Cases', () {
      test('should handle cooldown exactly at boundary', () {
        final exactCooldownTime = DateTime.now().subtract(Duration(hours: 4));
        final gameState = GameState(lastMoneyTimeActivation: exactCooldownTime);
        
        // At exactly 4 hours, should be available
        expect(gameState.canActivateMoneyTime(), isTrue);
        expect(gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });

      test('should handle cooldown 1 second before boundary', () {
        final almostDone = DateTime.now().subtract(Duration(hours: 4, seconds: -1));
        final gameState = GameState(lastMoneyTimeActivation: almostDone);
        
        expect(gameState.canActivateMoneyTime(), isFalse);
        final remaining = gameState.getTimeUntilMoneyTimeAvailable();
        expect(remaining, isNotNull);
        expect(remaining!.inSeconds, equals(0)); // Less than 1 second shows as 0
      });

      test('should handle very old activation time', () {
        final veryOld = DateTime.now().subtract(Duration(days: 365));
        final gameState = GameState(lastMoneyTimeActivation: veryOld);
        
        expect(gameState.canActivateMoneyTime(), isTrue);
        expect(gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });

      test('should handle future activation time (clock change)', () {
        final future = DateTime.now().add(Duration(hours: 1));
        final gameState = GameState(lastMoneyTimeActivation: future);
        
        // Should still work - negative cooldown means available
        expect(gameState.canActivateMoneyTime(), isTrue);
        expect(gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });
    });

    group('Time Calculation Edge Cases', () {
      test('should handle microsecond precision remaining time', () {
        final preciseTime = DateTime.now().add(Duration(microseconds: 500));
        final gameState = GameState(moneyTimeEndTime: preciseTime);
        
        if (gameState.isMoneyTimeActive()) {
          final remaining = gameState.getMoneyTimeRemaining();
          expect(remaining, isNotNull);
          // Should handle sub-second precision gracefully
        }
      });

      test('should handle leap second scenarios', () {
        // Create a time that would be affected by leap seconds
        final baseTime = DateTime.utc(2023, 12, 31, 23, 59, 59);
        final endTime = baseTime.add(Duration(seconds: 5));
        final gameState = GameState(moneyTimeEndTime: endTime);
        
        // Should handle gracefully without errors
        expect(() => gameState.isMoneyTimeActive(), returnsNormally);
        expect(() => gameState.getMoneyTimeRemaining(), returnsNormally);
      });

      test('should handle daylight saving time changes', () {
        // This is tricky to test but we ensure the methods don't crash
        final gameState = GameState(
          moneyTimeEndTime: DateTime.now().add(Duration(hours: 2)),
          lastMoneyTimeActivation: DateTime.now().subtract(Duration(hours: 2)),
        );
        
        expect(() => gameState.isMoneyTimeActive(), returnsNormally);
        expect(() => gameState.getMoneyTimeRemaining(), returnsNormally);
        expect(() => gameState.canActivateMoneyTime(), returnsNormally);
        expect(() => gameState.getTimeUntilMoneyTimeAvailable(), returnsNormally);
      });
    });

    group('JSON Serialization Edge Cases', () {
      test('should handle extreme date values in JSON', () {
        final extremeDate = DateTime.utc(9999, 12, 31);
        final gameState = GameState(
          moneyTimeEndTime: extremeDate,
          lastMoneyTimeActivation: extremeDate,
        );
        
        expect(() => gameState.toJson(), returnsNormally);
        
        final json = gameState.toJson();
        expect(() => GameState.fromJson(json), returnsNormally);
      });

      test('should handle malformed date strings in JSON', () {
        final json = <String, dynamic>{
          'moneyTimeEndTime': 'invalid-date',
          'lastMoneyTimeActivation': 'also-invalid',
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
        
        // Should handle malformed dates gracefully
        expect(() => GameState.fromJson(json), throwsA(isA<FormatException>()));
      });

      test('should handle missing Money Time fields in JSON', () {
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
          // Money Time fields are missing
        };
        
        final gameState = GameState.fromJson(json);
        
        expect(gameState.moneyTimeEndTime, isNull);
        expect(gameState.lastMoneyTimeActivation, isNull);
        expect(gameState.moneyTimeAdsWatched, equals(0));
        expect(gameState.selectedMoneyTimeDuration, equals(30)); // Default
      });

      test('should handle null Money Time values in JSON', () {
        final json = <String, dynamic>{
          'moneyTimeEndTime': null,
          'lastMoneyTimeActivation': null,
          'moneyTimeAdsWatched': null,
          'selectedMoneyTimeDuration': null,
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

    group('MoneyTimeConfig Edge Cases', () {
      test('should handle invalid duration requests', () {
        expect(MoneyTimeConfig.getAdsRequiredForDuration(0), equals(3)); // Default
        expect(MoneyTimeConfig.getAdsRequiredForDuration(-1), equals(3)); // Default
        expect(MoneyTimeConfig.getAdsRequiredForDuration(999), equals(3)); // Default
      });

      test('should validate duration correctly for edge cases', () {
        expect(MoneyTimeConfig.isValidDuration(0), isFalse);
        expect(MoneyTimeConfig.isValidDuration(-1), isFalse);
        expect(MoneyTimeConfig.isValidDuration(14), isFalse);
        expect(MoneyTimeConfig.isValidDuration(16), isFalse);
        expect(MoneyTimeConfig.isValidDuration(999), isFalse);
      });

      test('should format zero or negative remaining time', () {
        final zeroDuration = Duration.zero;
        expect(MoneyTimeConfig.formatRemainingTime(zeroDuration), equals('00:00'));
        
        // Note: Duration can't be negative, but if it could be:
        final almostZero = Duration(microseconds: 1);
        expect(MoneyTimeConfig.formatRemainingTime(almostZero), equals('00:00'));
      });

      test('should format very large remaining time', () {
        final hugeDuration = Duration(days: 365, hours: 23, minutes: 59, seconds: 59);
        final result = MoneyTimeConfig.formatRemainingTime(hugeDuration);
        
        // Should handle gracefully without overflow
        expect(result, isA<String>());
        expect(result.length, greaterThan(0));
      });

      test('should format zero cooldown time', () {
        final zeroDuration = Duration.zero;
        expect(MoneyTimeConfig.formatCooldownTime(zeroDuration), equals('0min'));
      });

      test('should format very large cooldown time', () {
        final hugeDuration = Duration(days: 999);
        final result = MoneyTimeConfig.formatCooldownTime(hugeDuration);
        
        // Should handle gracefully
        expect(result, isA<String>());
        expect(result.contains('h') || result.contains('min'), isTrue);
      });
    });

    group('Concurrency Edge Cases', () {
      test('should handle rapid state changes', () {
        var gameState = GameState();
        
        // Simulate rapid state changes
        for (int i = 0; i < 100; i++) {
          gameState = gameState.copyWith(
            moneyTimeAdsWatched: i % 10,
            selectedMoneyTimeDuration: [15, 30, 60][i % 3],
          );
        }
        
        expect(() => gameState.toJson(), returnsNormally);
        expect(() => GameState.fromJson(gameState.toJson()), returnsNormally);
      });

      test('should handle multiple simultaneous operations', () {
        final gameState = GameState();
        
        // Simulate multiple operations happening simultaneously
        expect(() {
          gameState.isMoneyTimeActive();
          gameState.getMoneyTimeRemaining();
          gameState.canActivateMoneyTime();
          gameState.getTimeUntilMoneyTimeAvailable();
        }, returnsNormally);
      });
    });

    group('Memory Edge Cases', () {
      test('should handle creation of many GameState instances', () {
        final states = <GameState>[];
        
        // Create many instances to test memory handling
        for (int i = 0; i < 1000; i++) {
          states.add(GameState(
            moneyTimeEndTime: DateTime.now().add(Duration(minutes: i)),
            moneyTimeAdsWatched: i % 10,
            selectedMoneyTimeDuration: [15, 30, 60][i % 3],
          ));
        }
        
        expect(states.length, equals(1000));
        
        // Test that they all work correctly
        for (final state in states.take(10)) { // Test first 10 to avoid timeout
          expect(() => state.isMoneyTimeActive(), returnsNormally);
        }
      });
    });
  });
}