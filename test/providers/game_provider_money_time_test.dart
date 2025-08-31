import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';
import 'package:lazypanda_top10_challenge/providers/game_provider.dart';
import 'package:lazypanda_top10_challenge/config/money_time_config.dart';

/// Integration tests for GameProvider Money Time functionality
/// Tests the interaction between GameProvider and MoneyTimeService
void main() {
  group('GameProvider Money Time Integration Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    tearDown(() {
      gameProvider.dispose();
    });

    group('Money Time State Management', () {
      testWidgets('should prevent life loss when Money Time is active', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Set up game state with active Money Time
        final endTime = DateTime.now().add(Duration(minutes: 15));
        await gameProvider.activateMoneyTime(endTime);
        
        // Initial lives
        final initialLives = gameProvider.gameState.lives;
        
        // Try to lose a life
        await gameProvider.loseLife();
        
        // Lives should remain the same
        expect(gameProvider.gameState.lives, equals(initialLives));
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
      });

      testWidgets('should allow life loss when Money Time is not active', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Ensure Money Time is not active
        expect(gameProvider.gameState.isMoneyTimeActive(), isFalse);
        
        // Get initial lives (should be 5)
        final initialLives = gameProvider.gameState.lives;
        expect(initialLives, equals(5));
        
        // Lose a life
        await gameProvider.loseLife();
        
        // Lives should decrease
        expect(gameProvider.gameState.lives, equals(initialLives - 1));
      });
    });

    group('Money Time Activation', () {
      testWidgets('should correctly update Money Time progress', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        await gameProvider.updateMoneyTimeProgress(2, 30);
        
        expect(gameProvider.gameState.moneyTimeAdsWatched, equals(2));
        expect(gameProvider.gameState.selectedMoneyTimeDuration, equals(30));
      });

      testWidgets('should activate Money Time correctly', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        final endTime = DateTime.now().add(Duration(minutes: 30));
        await gameProvider.activateMoneyTime(endTime);
        
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
        expect(gameProvider.gameState.moneyTimeEndTime, equals(endTime));
        expect(gameProvider.gameState.lastMoneyTimeActivation, isNotNull);
        expect(gameProvider.gameState.moneyTimeAdsWatched, equals(0));
      });

      testWidgets('should end Money Time correctly', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // First activate Money Time
        final endTime = DateTime.now().add(Duration(minutes: 30));
        await gameProvider.activateMoneyTime(endTime);
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
        
        // Then end it
        await gameProvider.endMoneyTime();
        
        expect(gameProvider.gameState.isMoneyTimeActive(), isFalse);
        expect(gameProvider.gameState.moneyTimeEndTime, isNull);
      });
    });

    group('Money Time Health Checks', () {
      testWidgets('should handle expired Money Time', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // First activate Money Time then simulate it expiring
        final expiredTime = DateTime.now().subtract(Duration(minutes: 5));
        await gameProvider.activateMoneyTime(expiredTime);
        
        // Run health check
        await gameProvider.checkMoneyTimeHealth();
        
        // Should clean up expired Money Time
        expect(gameProvider.gameState.isMoneyTimeActive(), isFalse);
        expect(gameProvider.gameState.moneyTimeEndTime, isNull);
      });

      testWidgets('should handle health checks on valid Money Time', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Set up valid active Money Time
        final endTime = DateTime.now().add(Duration(minutes: 15));
        await gameProvider.activateMoneyTime(endTime);
        
        // Verify it's active
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
        
        // Run health check
        await gameProvider.checkMoneyTimeHealth();
        
        // Should remain active and untouched
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
        expect(gameProvider.gameState.moneyTimeEndTime, isNotNull);
      });
    });

    group('Money Time Cooldown', () {
      testWidgets('should respect cooldown period after activation', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // First activate Money Time (this sets lastMoneyTimeActivation)
        final endTime = DateTime.now().add(Duration(minutes: 30));
        await gameProvider.activateMoneyTime(endTime);
        
        // End the Money Time immediately 
        await gameProvider.endMoneyTime();
        
        // Should now be in cooldown
        expect(gameProvider.gameState.canActivateMoneyTime(), isFalse);
        
        final timeUntilAvailable = gameProvider.gameState.getTimeUntilMoneyTimeAvailable();
        expect(timeUntilAvailable, isNotNull);
        expect(timeUntilAvailable!.inHours, greaterThanOrEqualTo(3)); // Most of 4-hour cooldown remaining
      });

      testWidgets('should allow activation when no previous activation exists', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Fresh state should allow activation
        expect(gameProvider.gameState.canActivateMoneyTime(), isTrue);
        expect(gameProvider.gameState.getTimeUntilMoneyTimeAvailable(), isNull);
      });
    });

    group('Money Time Activation Progress', () {
      test('should return correct activation info', () {
        // Mock service state through GameProvider
        final info = gameProvider.getMoneyTimeActivationInfo();
        
        expect(info, isA<Map<String, dynamic>>());
        expect(info.containsKey('isInProgress'), isTrue);
        expect(info.containsKey('currentAdsWatched'), isTrue);
        expect(info.containsKey('targetAds'), isTrue);
        expect(info.containsKey('selectedDuration'), isTrue);
        expect(info.containsKey('progressPercentage'), isTrue);
      });
    });

    group('App Lifecycle Handling', () {
      testWidgets('should handle app resume correctly', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Set up active Money Time
        final endTime = DateTime.now().add(Duration(minutes: 15));
        await gameProvider.activateMoneyTime(endTime);
        
        // Simulate app resume
        await gameProvider.handleAppLifecycleChange(AppLifecycleState.resumed);
        
        // Should still be active
        expect(gameProvider.gameState.isMoneyTimeActive(), isTrue);
      });

      testWidgets('should handle app pause correctly', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Simulate app pause
        await gameProvider.handleAppLifecycleChange(AppLifecycleState.paused);
        
        // Should complete without errors
        // (This mainly tests that the method doesn't throw)
      });
    });

    group('Error Handling', () {
      testWidgets('should handle loseLife errors gracefully', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // This test verifies that loseLife doesn't throw even in edge cases
        // The method has try-catch blocks that should handle errors
        expect(() => gameProvider.loseLife(), returnsNormally);
      });

      testWidgets('should handle Money Time activation errors', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        // Try to activate with invalid duration
        final result = await gameProvider.startMoneyTimeActivation(999);
        expect(result, isFalse);
      });
    });

    group('GameState Consistency', () {
      testWidgets('should maintain consistent state after operations', (WidgetTester tester) async {
        // Wait for initialization
        await tester.pumpAndSettle();

        final initialState = gameProvider.gameState;
        
        // Perform various operations
        await gameProvider.updateMoneyTimeProgress(1, 15);
        gameProvider.resetMoneyTimeProgress();  // This is void, don't await
        
        // State should be consistent
        expect(gameProvider.gameState.moneyTimeAdsWatched, equals(0));
        expect(gameProvider.gameState.selectedMoneyTimeDuration, equals(15));
      });
    });
  });
}