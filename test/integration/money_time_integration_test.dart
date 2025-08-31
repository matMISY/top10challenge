import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_indicator.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_shield_effect.dart';
import 'package:lazypanda_top10_challenge/providers/game_provider.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Money Time Integration Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    tearDown(() {
      gameProvider.dispose();
    });

    testWidgets('Money Time components work together correctly', (WidgetTester tester) async {
      // Arrange - Create a test widget that includes both components
      final testWidget = ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: Column(
          children: [
            const MoneyTimeIndicator(),
            MoneyTimeShieldEffect(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ],
        ),
      );

      // Act - Start with Money Time inactive
      final gameState = GameState(moneyTimeEndTime: null);
      gameProvider.updateGameStateForTest(gameState);

      await tester.pumpWidget(TestHelpers.createTestApp(child: testWidget));
      await tester.pump();

      // Assert - No Money Time components should be visible
      expect(find.text('MONEY TIME'), findsNothing);
      expect(find.byType(Stack), findsNothing); // No shield stack

      // Act - Activate Money Time
      final endTime = DateTime.now().add(Duration(minutes: 30));
      final activeGameState = gameState.copyWith(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(activeGameState);
      await tester.pump();

      // Assert - Both components should be active
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget); // Shield stack appears
      expect(find.byIcon(Icons.shield), findsAtLeast(1)); // Shield icons present

      // Test that original content is still accessible
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('Money Time timing synchronization test', (WidgetTester tester) async {
      // Arrange - Create Money Time state with short duration for testing
      final endTime = DateTime.now().add(Duration(seconds: 10));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 1, // 1 minute for faster test
      );
      gameProvider.updateGameStateForTest(gameState);

      final testWidget = ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: const MoneyTimeIndicator(),
      );

      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: testWidget));
      await tester.pump();

      // Assert - Should show Money Time active
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.textContaining('00:'), findsOneWidget); // Should show seconds

      // Simulate time passing
      await TestHelpers.simulateTimePassage(tester, Duration(seconds: 2));

      // Should still be active but with different time
      expect(find.text('MONEY TIME'), findsOneWidget);
    });

    testWidgets('Money Time visual consistency test', (WidgetTester tester) async {
      // Arrange - Create active Money Time state
      final endTime = DateTime.now().add(Duration(minutes: 15));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 15,
      );
      gameProvider.updateGameStateForTest(gameState);

      final testWidget = ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: Column(
          children: [
            const MoneyTimeIndicator(),
            const SizedBox(height: 20),
            MoneyTimeShieldEffect(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Lives: 5'),
              ),
            ),
          ],
        ),
      );

      // Act
      await tester.pumpWidget(TestHelpers.createTestApp(child: testWidget));
      await tester.pump();
      await TestHelpers.waitForAnimations(tester);

      // Assert - Check visual consistency
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.text('Lives: 5'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsAtLeast(1));

      // Verify both components use similar golden styling
      TestHelpers.expectGoldenStyling(tester);
    });

    testWidgets('Money Time performance test', (WidgetTester tester) async {
      // Arrange - Create multiple Money Time components
      final endTime = DateTime.now().add(Duration(minutes: 30));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(gameState);

      final testWidget = ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: Column(
          children: List.generate(5, (index) => 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const MoneyTimeIndicator(),
                  const Spacer(),
                  MoneyTimeShieldEffect(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Text('$index'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act & Assert - Should handle multiple components without performance issues
      await tester.pumpWidget(TestHelpers.createTestApp(child: testWidget));
      await tester.pump();

      // Verify all components are rendered
      expect(find.text('MONEY TIME'), findsNWidgets(5));
      expect(find.byType(MoneyTimeShieldEffect), findsNWidgets(5));

      // Test rapid state changes
      for (int i = 0; i < 3; i++) {
        gameProvider.updateGameStateForTest(gameState.copyWith(moneyTimeEndTime: null));
        await tester.pump();
        
        gameProvider.updateGameStateForTest(gameState);
        await tester.pump();
      }

      // Should still work correctly
      expect(find.text('MONEY TIME'), findsNWidgets(5));
    });

    testWidgets('Money Time state edge cases', (WidgetTester tester) async {
      // Arrange
      final testWidget = ChangeNotifierProvider<GameProvider>.value(
        value: gameProvider,
        child: const Column(
          children: [
            MoneyTimeIndicator(),
            MoneyTimeShieldEffect(
              child: Text('Test Child'),
            ),
          ],
        ),
      );

      await tester.pumpWidget(TestHelpers.createTestApp(child: testWidget));
      
      // Test 1: Expired Money Time (past end time)
      final expiredGameState = GameState(
        moneyTimeEndTime: DateTime.now().subtract(Duration(minutes: 1)),
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(expiredGameState);
      await tester.pump();

      // Should not show Money Time as active
      expect(find.text('MONEY TIME'), findsNothing);

      // Test 2: Very short remaining time
      final shortTimeState = GameState(
        moneyTimeEndTime: DateTime.now().add(Duration(seconds: 5)),
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(shortTimeState);
      await tester.pump();

      // Should still show Money Time
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.textContaining('00:0'), findsOneWidget); // Should show seconds

      // Test 3: Null end time
      final nullTimeState = GameState(
        moneyTimeEndTime: null,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(nullTimeState);
      await tester.pump();

      // Should not show Money Time
      expect(find.text('MONEY TIME'), findsNothing);
      expect(find.text('Test Child'), findsOneWidget); // Child should remain
    });
  });
}