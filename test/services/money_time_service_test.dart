import 'package:flutter_test/flutter_test.dart';
import 'package:top10_challenge/config/money_time_config.dart';

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
}