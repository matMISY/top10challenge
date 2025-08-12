import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:top10_challenge/providers/game_provider.dart';
import 'package:top10_challenge/widgets/money_time_progress_screen.dart';
import 'package:top10_challenge/models/game_state.dart';

class MockGameProvider extends ChangeNotifier implements GameProvider {
  GameState _gameState = GameState();
  bool _isActivationInProgress = false;
  
  @override
  GameState get gameState => _gameState;

  void setGameState(GameState newState) {
    _gameState = newState;
    notifyListeners();
  }

  void setActivationInProgress(bool inProgress) {
    _isActivationInProgress = inProgress;
    notifyListeners();
  }

  @override
  dynamic get moneyTimeService => MockMoneyTimeService(_isActivationInProgress);

  // Mock implementations of commonly used methods
  @override
  bool get isLoading => false;

  @override
  bool get isWatchingAd => false;

  @override
  List get levels => [];

  @override
  List get tiers => [];

  @override
  dynamic get gameService => null;

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

class MockMoneyTimeService {
  final bool _isActivationInProgress;

  MockMoneyTimeService(this._isActivationInProgress);

  bool get isActivationInProgress => _isActivationInProgress;
}

void main() {
  group('MoneyTimeProgressScreen', () {
    late MockGameProvider mockProvider;

    setUp(() {
      mockProvider = MockGameProvider();
    });

    Widget createTestWidget({
      required int targetAds,
      required int selectedDuration,
    }) {
      return MaterialApp(
        home: ChangeNotifierProvider<GameProvider>(
          create: (_) => mockProvider,
          child: MoneyTimeProgressScreen(
            targetAds: targetAds,
            selectedDuration: selectedDuration,
          ),
        ),
      );
    }

    testWidgets('displays header with correct information', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Verify header elements
      expect(find.text('ACTIVATION EN COURS'), findsOneWidget);
      expect(find.text('Money Time 30 minutes'), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on), findsOneWidget);
    });

    testWidgets('displays progress information correctly', (tester) async {
      // Setup: 1 ad watched out of 3
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 1,
        selectedMoneyTimeDuration: 30,
      ));

      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Verify progress display
      expect(find.text('Publicité'), findsOneWidget);
      expect(find.text('1 sur 3'), findsOneWidget);
      expect(find.text('terminée'), findsOneWidget);
    });

    testWidgets('updates progress when ads watched changes', (tester) async {
      // Setup: Start with 0 ads watched
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 0,
        selectedMoneyTimeDuration: 30,
      ));

      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Verify initial state
      expect(find.text('0 sur 3'), findsOneWidget);

      // Update to 2 ads watched
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 2,
        selectedMoneyTimeDuration: 30,
      ));
      await tester.pump();

      // Verify updated progress
      expect(find.text('2 sur 3'), findsOneWidget);
      expect(find.text('terminées'), findsOneWidget);
    });

    testWidgets('displays correct number of progress dots', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 5,
        selectedDuration: 60,
      ));

      // Should have 5 dots for 5 target ads
      final containers = find.byWidgetPredicate((widget) =>
          widget is AnimatedContainer &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle);
      
      expect(containers, findsNWidgets(5));
    });

    testWidgets('displays appropriate status message based on progress', (tester) async {
      // Test different status messages
      
      // 0 ads watched
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 0,
      ));
      mockProvider.setActivationInProgress(true);

      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      expect(find.text('Préparation de la première publicité...'), findsOneWidget);

      // 1 ad watched (in progress)
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 1,
      ));
      await tester.pump();

      expect(find.text('Chargement de la publicité suivante...'), findsOneWidget);
    });

    testWidgets('displays warning message', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      expect(find.text('Ne quittez pas l\'écran pendant l\'activation !'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('displays bottom information', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      expect(find.text('Restez sur cette page pendant que nous préparons votre Money Time'), findsOneWidget);
      expect(find.text('Sécurisé par Money Time'), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('prevents back navigation', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Verify PopScope is configured correctly
      expect(find.byType(PopScope), findsOneWidget);
      
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, false);
    });

    testWidgets('progress animation updates correctly', (tester) async {
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 0,
      ));

      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Update progress
      mockProvider.setGameState(GameState().copyWith(
        moneyTimeAdsWatched: 2,
      ));
      
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100)); // Allow animation to start

      // Verify CircularProgressIndicator is present and animating
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('animations are present and functional', (tester) async {
      await tester.pumpWidget(createTestWidget(
        targetAds: 3,
        selectedDuration: 30,
      ));

      // Verify animation controllers are working
      expect(find.byType(AnimatedBuilder), findsWidgets);
      expect(find.byType(Transform), findsWidgets);
      
      // Let animations run
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles different target ad counts', (tester) async {
      // Test with different ad counts
      final testCases = [
        {'targetAds': 2, 'duration': 15},
        {'targetAds': 3, 'duration': 30},
        {'targetAds': 5, 'duration': 60},
      ];

      for (final testCase in testCases) {
        await tester.pumpWidget(createTestWidget(
          targetAds: testCase['targetAds']!,
          selectedDuration: testCase['duration']!,
        ));

        // Verify correct information is displayed
        expect(find.text('Money Time ${testCase['duration']} minutes'), findsOneWidget);
        
        // Verify progress display
        mockProvider.setGameState(GameState().copyWith(
          moneyTimeAdsWatched: 0,
        ));
        await tester.pump();
        
        expect(find.text('0 sur ${testCase['targetAds']}'), findsOneWidget);
      }
    });
  });
}