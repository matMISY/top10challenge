import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_shield_effect.dart';
import 'package:lazypanda_top10_challenge/providers/game_provider.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MoneyTimeShieldEffect Widget Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    tearDown(() {
      gameProvider.dispose();
    });

    testWidgets('should render child normally when Money Time is not active', (WidgetTester tester) async {
      // Arrange
      const childWidget = Text('Test Child');
      final gameState = GameState(
        moneyTimeEndTime: null,
      );
      gameProvider.updateGameStateForTest(gameState);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      expect(find.byType(Stack), findsNothing); // No shield effects
    });

    testWidgets('should add shield effects when Money Time is active', (WidgetTester tester) async {
      // Arrange
      const childWidget = Text('Test Child');
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
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget); // Shield effects present
      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('should have proper shield visual elements', (WidgetTester tester) async {
      // Arrange
      final childWidget = Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      );
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
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Transform), findsAtLeast(2)); // Scale and rotate transforms
      expect(find.byIcon(Icons.shield), findsOneWidget);
      
      // Check for multiple Container widgets (various shield layers)
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsAtLeast(3)); // Child + shield containers
    });

    testWidgets('should animate with pulse and rotation effects', (WidgetTester tester) async {
      // Arrange
      const childWidget = Text('Test Child');
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
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );
      
      // Pump initial frame
      await tester.pump();
      
      // Wait for animations to potentially start
      await tester.pump(Duration(milliseconds: 100));

      // Assert
      expect(find.byType(AnimatedBuilder), findsOneWidget);
      expect(find.byType(Transform), findsAtLeast(2)); // Scale and rotation transforms
    });

    testWidgets('should preserve child widget functionality', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      final childWidget = GestureDetector(
        onTap: () => tapped = true,
        child: const Text('Tappable Child'),
      );
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
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );

      // Tap the child widget
      await tester.tap(find.text('Tappable Child'));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should handle rapid Money Time state changes', (WidgetTester tester) async {
      // Arrange
      const childWidget = Text('Test Child');
      var gameState = GameState(moneyTimeEndTime: null);
      gameProvider.updateGameStateForTest(gameState);

      // Act - Start without Money Time
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<GameProvider>.value(
            value: gameProvider,
            child: MoneyTimeShieldEffect(
              child: childWidget,
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert - No shield initially
      expect(find.byType(Stack), findsNothing);

      // Act - Activate Money Time
      final endTime = DateTime.now().add(Duration(minutes: 15));
      gameState = gameState.copyWith(
        moneyTimeEndTime: endTime,
        selectedMoneyTimeDuration: 15,
      );
      gameProvider.updateGameStateForTest(gameState);
      await tester.pump();

      // Assert - Shield appears
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);

      // Act - Deactivate Money Time
      gameState = gameState.copyWith(moneyTimeEndTime: null);
      gameProvider.updateGameStateForTest(gameState);
      await tester.pump();

      // Assert - Shield disappears
      expect(find.byType(Stack), findsNothing);
    });
  });
}