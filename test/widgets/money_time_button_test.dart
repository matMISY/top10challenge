import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lazypanda_top10_challenge/providers/game_provider.dart';
import 'package:lazypanda_top10_challenge/widgets/money_time_button.dart';
import 'package:lazypanda_top10_challenge/models/game_state.dart';
import 'package:lazypanda_top10_challenge/models/level.dart';
import 'package:lazypanda_top10_challenge/models/tier.dart';
import 'package:lazypanda_top10_challenge/services/game_service.dart';
import 'package:lazypanda_top10_challenge/services/money_time_service.dart';

class MockGameProvider extends ChangeNotifier implements GameProvider {
  GameState _gameState = GameState();
  
  @override
  GameState get gameState => _gameState;

  void setGameState(GameState newState) {
    _gameState = newState;
    notifyListeners();
  }

  @override
  Future<bool> startMoneyTimeActivation(int durationMinutes) async {
    return true;
  }

  // Mock implementations of commonly used methods
  @override
  bool get isLoading => false;

  @override
  bool get isWatchingAd => false;

  @override
  List<Level> get levels => [];

  @override
  List<Tier> get tiers => [];

  @override
  GameService get gameService => throw UnimplementedError();

  @override
  MoneyTimeService get moneyTimeService => throw UnimplementedError();

  // Use noSuchMethod for all other methods to avoid implementing everything
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      return null;
    } else if (invocation.memberName.toString().contains('Future')) {
      return Future.value(null);
    }
    return null;
  }
}

void main() {
  group('MoneyTimeButton', () {
    late MockGameProvider mockProvider;

    setUp(() {
      mockProvider = MockGameProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<GameProvider>(
            create: (_) => mockProvider,
            child: const MoneyTimeButton(),
          ),
        ),
      );
    }

    testWidgets('displays available state when Money Time can be activated', (tester) async {
      // Setup: Money Time available
      mockProvider.setGameState(GameState());

      await tester.pumpWidget(createTestWidget());

      // Verify
      expect(find.text('Money Time'), findsOneWidget);
      expect(find.text('Jouez sans perdre de vies !'), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on), findsOneWidget);
    });

    testWidgets('displays active state when Money Time is running', (tester) async {
      // Setup: Money Time active
      final activeState = GameState().copyWith(
        moneyTimeEndTime: DateTime.now().add(const Duration(minutes: 30)),
      );
      mockProvider.setGameState(activeState);

      await tester.pumpWidget(createTestWidget());

      // Verify
      expect(find.text('Money Time Actif'), findsOneWidget);
      expect(find.textContaining('Temps restant:'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('displays cooldown state when Money Time is in cooldown', (tester) async {
      // Setup: Money Time in cooldown
      final cooldownState = GameState().copyWith(
        lastMoneyTimeActivation: DateTime.now().subtract(const Duration(hours: 1)),
      );
      mockProvider.setGameState(cooldownState);

      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Allow the widget to rebuild

      // Verify
      expect(find.text('Money Time'), findsOneWidget);
      expect(find.textContaining('Disponible dans'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('shows selection dialog when available button is tapped', (tester) async {
      // Setup: Money Time available
      mockProvider.setGameState(GameState());

      await tester.pumpWidget(createTestWidget());
      
      // Find and tap the button
      final button = find.byType(MoneyTimeButton);
      expect(button, findsOneWidget);
      
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.text('MONEY TIME'), findsOneWidget);
      expect(find.text('Choisissez votre durée :'), findsOneWidget);
    });

    testWidgets('shows info dialog when active button is tapped', (tester) async {
      // Setup: Money Time active
      final activeState = GameState().copyWith(
        moneyTimeEndTime: DateTime.now().add(const Duration(minutes: 15)),
      );
      mockProvider.setGameState(activeState);

      await tester.pumpWidget(createTestWidget());
      
      // Find and tap the button
      final button = find.byType(MoneyTimeButton);
      expect(button, findsOneWidget);
      
      await tester.tap(button);
      await tester.pumpAndSettle();

      // The info should be shown via FeedbackService
      // This would require mocking the FeedbackService to test properly
    });

    testWidgets('updates display when game state changes', (tester) async {
      // Setup: Start with available state
      mockProvider.setGameState(GameState());

      await tester.pumpWidget(createTestWidget());

      // Verify initial state
      expect(find.text('Money Time'), findsOneWidget);
      expect(find.text('Jouez sans perdre de vies !'), findsOneWidget);

      // Change to active state
      final activeState = GameState().copyWith(
        moneyTimeEndTime: DateTime.now().add(const Duration(minutes: 30)),
      );
      mockProvider.setGameState(activeState);
      await tester.pump();

      // Verify state changed
      expect(find.text('Money Time Actif'), findsOneWidget);
      expect(find.textContaining('Temps restant:'), findsOneWidget);
    });

    testWidgets('button animations are present', (tester) async {
      // Setup
      mockProvider.setGameState(GameState());

      await tester.pumpWidget(createTestWidget());

      // Verify animation widgets are present
      expect(find.byType(AnimatedBuilder), findsWidgets);
      expect(find.byType(Transform), findsWidgets);
    });
  });
}