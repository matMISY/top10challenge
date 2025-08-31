import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_selection_dialog.dart';
import 'package:lazypanda_top10_challenge/config/money_time_config.dart';

void main() {
  group('MoneyTimeSelectionDialog', () {
    Widget createTestWidget({required Function(int) onDurationSelected}) {
      return MaterialApp(
        home: Scaffold(
          body: MoneyTimeSelectionDialog(
            onDurationSelected: onDurationSelected,
          ),
        ),
      );
    }

    testWidgets('displays dialog header correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Verify header elements
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.text('Jouez sans perdre de vies !'), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on), findsOneWidget);
    });

    testWidgets('displays all available duration options', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Verify all duration options are shown
      for (int duration in MoneyTimeConfig.availableDurations) {
        expect(find.text('$duration minutes'), findsOneWidget);
        
        final adsRequired = MoneyTimeConfig.getAdsRequiredForDuration(duration);
        expect(find.text('$adsRequired publicité${adsRequired > 1 ? 's' : ''} à regarder'), findsOneWidget);
      }
    });

    testWidgets('default duration is pre-selected', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Find the default duration option and verify it's selected
      // The selected option should have a check icon
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('recommended badge is shown for default duration', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      expect(find.text('Recommandé'), findsOneWidget);
    });

    testWidgets('can select different duration options', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Initially, default should be selected
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap on a different duration (15 minutes)
      final fifteenMinOption = find.text('15 minutes');
      expect(fifteenMinOption, findsOneWidget);
      
      await tester.tap(fifteenMinOption);
      await tester.pump();

      // Still should have only one check icon (for the newly selected option)
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays info box with Money Time benefits', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      expect(find.text('Pendant Money Time :'), findsOneWidget);
      expect(find.text('• Vous ne perdez pas de vies\n• Vous pouvez continuer à jouer normalement\n• Les points et indices sont conservés'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('activation button triggers callback with selected duration', (tester) async {
      int? selectedDuration;
      
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (duration) {
          selectedDuration = duration;
        },
      ));

      // Select 60 minutes option
      await tester.tap(find.text('60 minutes'));
      await tester.pump();

      // Tap activation button
      await tester.tap(find.text('REGARDER LES PUBS'));
      await tester.pumpAndSettle();

      // Verify callback was called with correct duration
      expect(selectedDuration, 60);
    });

    testWidgets('cancel button closes dialog', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Tap cancel button
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Dialog should be closed (no longer find the title)
      expect(find.text('MONEY TIME'), findsNothing);
    });

    testWidgets('activation button shows loading state', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) async {
          // Simulate long-running activation
          await Future.delayed(const Duration(seconds: 1));
        },
      ));

      // Tap activation button
      await tester.tap(find.text('REGARDER LES PUBS'));
      await tester.pump(); // Trigger the loading state

      // Verify loading state
      expect(find.text('Lancement...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Cancel button should be disabled
      final cancelButton = find.text('Annuler');
      expect(tester.widget<TextButton>(cancelButton).onPressed, isNull);
    });

    testWidgets('animations are present', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Verify animation widgets (there might be more than one ScaleTransition)
      expect(find.byType(ScaleTransition), findsWidgets);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('visual styling is applied correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        onDurationSelected: (_) {},
      ));

      // Verify container decorations are present
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);

      // Verify dialog structure is present
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}