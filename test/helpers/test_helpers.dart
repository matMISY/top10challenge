import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top10challenge/providers/game_provider.dart';
import 'package:top10challenge/models/game_state.dart';

class TestHelpers {
  /// Create a test app wrapper with necessary providers
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Create a test app with theme data
  static Widget createThemedTestApp({required Widget child}) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Pump and settle with a specific duration
  static Future<void> pumpAndSettleWithDuration(
    WidgetTester tester,
    Duration duration,
  ) async {
    await tester.pump();
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  /// Find a widget by its text containing specific string
  static Finder findTextContaining(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        final String? textData = widget.data;
        return textData != null && textData.contains(text);
      }
      return false;
    });
  }

  /// Find a widget by its key string
  static Finder findByKeyString(String keyString) {
    return find.byKey(Key(keyString));
  }

  /// Verify that a finder has exactly the expected count
  static void expectFindsExactly(Finder finder, int expectedCount) {
    final int actualCount = finder.evaluate().length;
    expect(actualCount, expectedCount, 
      reason: 'Expected to find exactly $expectedCount widgets, but found $actualCount');
  }

  /// Verify that a widget exists and is visible
  static void expectWidgetVisible(Finder finder) {
    expect(finder, findsOneWidget);
    // Additional check for visibility could be added here if needed
  }

  /// Verify that a widget does not exist
  static void expectWidgetNotFound(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Mock Money Time activation for testing
  static GameState createActiveMoneyTimeState({
    int durationMinutes = 30,
    DateTime? customEndTime,
  }) {
    final endTime = customEndTime ?? DateTime.now().add(Duration(minutes: durationMinutes));
    
    return GameState(
      moneyTimeEndTime: endTime,
      lastMoneyTimeActivation: DateTime.now().subtract(Duration(minutes: 1)),
      selectedMoneyTimeDuration: durationMinutes,
      moneyTimeAdsWatched: 0,
    );
  }

  /// Mock Money Time in cooldown state
  static GameState createCooldownMoneyTimeState({
    Duration cooldownRemaining = const Duration(hours: 2),
  }) {
    final lastActivation = DateTime.now().subtract(Duration(hours: 4) - cooldownRemaining);
    
    return GameState(
      moneyTimeEndTime: null,
      lastMoneyTimeActivation: lastActivation,
      selectedMoneyTimeDuration: 30,
      moneyTimeAdsWatched: 0,
    );
  }

  /// Mock Money Time available state
  static GameState createAvailableMoneyTimeState() {
    return GameState(
      moneyTimeEndTime: null,
      lastMoneyTimeActivation: null,
      selectedMoneyTimeDuration: 30,
      moneyTimeAdsWatched: 0,
    );
  }

  /// Create a game state with specific lives and points
  static GameState createGameState({
    int lives = 5,
    int hintPoints = 50,
    int totalPoints = 100,
  }) {
    return GameState(
      lives: lives,
      hintPoints: hintPoints,
      totalPoints: totalPoints,
    );
  }

  /// Wait for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    await tester.pump();
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  /// Simulate time passing
  static Future<void> simulateTimePassage(
    WidgetTester tester,
    Duration duration,
  ) async {
    final int steps = 10;
    final Duration stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);
    
    for (int i = 0; i < steps; i++) {
      await tester.pump(stepDuration);
    }
    
    await tester.pumpAndSettle();
  }

  /// Check if an animation is running
  static bool hasActiveAnimations(WidgetTester tester) {
    final animatedBuilders = tester.widgetList<AnimatedBuilder>(find.byType(AnimatedBuilder));
    return animatedBuilders.isNotEmpty;
  }

  /// Verify golden color scheme is applied
  static void expectGoldenStyling(WidgetTester tester) {
    // This could check for specific golden colors in decorations
    // Implementation would depend on how you want to verify the styling
    
    // Example: check for containers with gradient decorations
    final containers = tester.widgetList<Container>(find.byType(Container));
    bool hasGradient = containers.any((container) {
      return container.decoration is BoxDecoration &&
          (container.decoration as BoxDecoration).gradient != null;
    });
    
    expect(hasGradient, isTrue, reason: 'Expected to find golden gradient styling');
  }
}

/// Extension methods for GameProvider to help with testing
extension GameProviderTestExtension on GameProvider {
  /// Update game state for testing purposes
  void updateGameStateForTest(GameState newGameState) {
    // This would need to be implemented in GameProvider as a test-only method
    // or you could create a test-specific subclass
    // For now, this is a placeholder
  }
}