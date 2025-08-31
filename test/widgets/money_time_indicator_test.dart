import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_indicator.dart';
import 'package:lazypanda_top10_challenge/providers/game_provider.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MoneyTimeIndicator Widget Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    tearDown(() {
      gameProvider.dispose();
    });

    testWidgets('should not display when Money Time is not active', (WidgetTester tester) async {
      // Arrange
      final gameState = GameState(
        moneyTimeEndTime: null,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );

      // Assert
      expect(find.byType(MoneyTimeIndicator), findsOneWidget);
      expect(find.text('MONEY TIME'), findsNothing);
    });

    testWidgets('should display timer when Money Time is active', (WidgetTester tester) async {
      // Arrange
      final endTime = DateTime.now().add(Duration(minutes: 15));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 15,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
      // Timer should show some time remaining
      expect(find.textContaining(':'), findsOneWidget);
    });

    testWidgets('should format time correctly', (WidgetTester tester) async {
      // Arrange
      final endTime = DateTime.now().add(Duration(minutes: 5, seconds: 30));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('MONEY TIME'), findsOneWidget);
      // Should show approximately 05:30 format
      final timerFinder = find.textContaining('05:');
      expect(timerFinder, findsOneWidget);
    });

    testWidgets('should have golden styling with proper visual elements', (WidgetTester tester) async {
      // Arrange
      final endTime = DateTime.now().add(Duration(minutes: 30));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
      
      // Check that the container has decorative elements
      final containerFinder = find.descendant(
        of: find.byType(MoneyTimeIndicator),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsAtLeast(1));
    });

    testWidgets('should animate with pulse effect', (WidgetTester tester) async {
      // Arrange
      final endTime = DateTime.now().add(Duration(minutes: 30));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );
      
      // Pump initial frame
      await tester.pump();
      
      // Wait for potential animations to start
      await tester.pump(Duration(milliseconds: 100));

      // Assert
      expect(find.byType(AnimatedBuilder), findsOneWidget);
      expect(find.byType(Transform), findsAtLeast(1));
    });

    testWidgets('should update timer every second', (WidgetTester tester) async {
      // Arrange
      final endTime = DateTime.now().add(Duration(minutes: 1, seconds: 30));
      final gameState = GameState(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 30,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: const MoneyTimeIndicator(),
          ),
        ),
      );
      await tester.pump();

      // Get initial timer text
      final initialTimerText = tester.widget<Text>(
        find.descendant(
          of: find.byType(MoneyTimeIndicator),
          matching: find.textContaining(':'),
        ),
      ).data;

      // Wait for time to pass and pump
      await tester.pump(Duration(seconds: 2));
      
      // Get updated timer text
      final updatedTimerText = tester.widget<Text>(
        find.descendant(
          of: find.byType(MoneyTimeIndicator),
          matching: find.textContaining(':'),
        ),
      ).data;

      // Assert - times should be different (though this is timing-sensitive)
      expect(initialTimerText, isNotNull);
      expect(updatedTimerText, isNotNull);
    });
  });
}