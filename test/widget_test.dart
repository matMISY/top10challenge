// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:top10_challenge/main.dart';

void main() {
  testWidgets('App starts with home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Top10ChallengeApp());
    
    // Wait for async initialization
    await tester.pumpAndSettle();

    // Verify that our app shows the TOP10 title
    expect(find.text('TOP10'), findsOneWidget);
    expect(find.text('CHALLENGE'), findsOneWidget);
  });
}
