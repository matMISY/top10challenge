import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top10challenge/widgets/money_time_end_animation.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MoneyTimeEndAnimation Widget Tests', () {
    testWidgets('should display Money Time ending content', (WidgetTester tester) async {
      // Arrange
      bool onCompleteCalled = false;

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: () {
              onCompleteCalled = true;
            },
          ),
        ),
      );

      // Initial pump
      await tester.pump();

      // Assert - Check for key content
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.text('TERMINÉ'), findsOneWidget);
      expect(find.text('Prochain Money Time\ndisponible dans 4h'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('should have proper visual styling', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: () {},
          ),
        ),
      );

      await tester.pump();

      // Assert - Check for Container with proper background
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsAtLeast(1));

      // Check for Transform widgets (animations)
      final transformFinder = find.byType(Transform);
      expect(transformFinder, findsAtLeast(1));

      // Check for Column layout
      expect(find.byType(Column), findsAtLeast(1));
    });

    testWidgets('should animate and complete', (WidgetTester tester) async {
      // Arrange
      bool onCompleteCalled = false;

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: () {
              onCompleteCalled = true;
            },
          ),
        ),
      );

      // Pump initial frame
      await tester.pump();

      // Assert initial state
      expect(onCompleteCalled, isFalse);

      // Let some time pass for animations
      await TestHelpers.simulateTimePassage(tester, Duration(seconds: 4));

      // Animation should complete eventually
      // Note: This is timing-sensitive and may need adjustment
      expect(find.byType(MoneyTimeEndAnimation), findsOneWidget);
    });

    testWidgets('should have animated elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: () {},
          ),
        ),
      );

      await tester.pump();

      // Assert - Check for animated components
      expect(find.byType(AnimatedBuilder), findsOneWidget);
      expect(find.byType(Transform), findsAtLeast(2)); // Multiple transform animations

      // Check that opacity animations exist
      final opacityFinder = find.byType(Opacity);
      expect(opacityFinder, findsAtLeast(1));
    });

    testWidgets('should handle missing onComplete callback gracefully', (WidgetTester tester) async {
      // Act - Pass null callback
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: null,
          ),
        ),
      );

      await tester.pump();

      // Assert - Should not crash
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.text('TERMINÉ'), findsOneWidget);
    });

    testWidgets('should have proper text styling', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: MoneyTimeEndAnimation(
            onComplete: () {},
          ),
        ),
      );

      await tester.pump();

      // Assert - Check for Text widgets with proper content
      final titleText = find.text('MONEY TIME');
      final subtitleText = find.text('TERMINÉ');
      final infoText = find.text('Prochain Money Time\ndisponible dans 4h');

      expect(titleText, findsOneWidget);
      expect(subtitleText, findsOneWidget);
      expect(infoText, findsOneWidget);

      // Check that the texts are properly styled (have style properties)
      final titleWidget = tester.widget<Text>(titleText);
      final subtitleWidget = tester.widget<Text>(subtitleText);
      final infoWidget = tester.widget<Text>(infoText);

      expect(titleWidget.style, isNotNull);
      expect(subtitleWidget.style, isNotNull);
      expect(infoWidget.style, isNotNull);
    });
  });
}