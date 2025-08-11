import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level.dart';
import '../models/answer.dart';
import '../providers/game_provider.dart';
import '../services/search_service.dart';
import '../services/game_service.dart';
import '../widgets/answer_slot.dart';
import '../widgets/search_input.dart';
import '../utils/debug_config.dart';
import '../config/hint_config.dart';
import '../utils/hint_generator.dart';
import '../services/feedback_service.dart';
import '../config/feedback_config.dart';
import '../widgets/money_time_indicator.dart';
import '../widgets/money_time_shield_effect.dart';
import '../widgets/hint_explanation_dialog.dart';

class GameScreen extends StatefulWidget {
  final Level level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  final GameService _gameService = GameService();
  final List<String> _foundAnswers = [];
  List<String> _availableAnswers = [];
  bool _debugAnswersRevealed = false;
  Map<int, int> _hintLevels = {};  // Niveau d'indice pour chaque question

  @override
  void initState() {
    super.initState();
    _checkCanPlay();
    _availableAnswers = List.from(widget.level.answerNames);
    _loadSavedAnswers();
  }

  void _checkCanPlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider = context.read<GameProvider>();
      if (!gameProvider.gameState.canPlay()) {
        Navigator.of(context).pop();
        _showNoLivesMessage();
      }
    });
  }

  void _showNoLivesMessage() {
    FeedbackService.showNoLives(context);
  }

  Future<void> _loadSavedAnswers() async {
    final savedAnswers = await _gameService.getFoundAnswersForLevel(widget.level.id);
    
    // Charger les niveaux d'indices pour chaque question
    Map<int, int> loadedHintLevels = {};
    for (int i = 0; i < widget.level.answers.length; i++) {
      final hintLevel = await _gameService.getHintLevelForQuestion(widget.level.id, i);
      if (hintLevel > 0) {
        loadedHintLevels[i] = hintLevel;
      }
    }
    
    setState(() {
      _foundAnswers.clear();
      _foundAnswers.addAll(savedAnswers);
      _availableAnswers = widget.level.answerNames.where((answer) => !savedAnswers.contains(answer)).toList();
      _hintLevels = loadedHintLevels;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAnswerSubmitted(String answer) async {
    final correctAnswer = _searchService.getCorrectAnswer(answer, _availableAnswers);
    
    if (correctAnswer != null) {
      setState(() {
        _foundAnswers.add(correctAnswer);
        _availableAnswers.remove(correctAnswer);
        _searchController.clear();
      });

      _gameService.saveFoundAnswersForLevel(widget.level.id, _foundAnswers);

      // Afficher feedback de bonne réponse
      FeedbackService.showSuccess(context, 'Bonne réponse !\n$correctAnswer');

      if (_foundAnswers.length == 10) {
        _onLevelCompleted();
      }
    } else {
      // Vérifier si la réponse correspond à une réponse déjà trouvée
      final alreadyFoundAnswer = _searchService.getCorrectAnswer(answer, _foundAnswers);
      
      if (alreadyFoundAnswer != null) {
        // Réponse déjà validée, ne pas enlever de vie
        FeedbackService.showAlreadyFound(context);
        _searchController.clear();
      } else {
        // Réponse incorrecte, enlever une vie
        await context.read<GameProvider>().loseLife();
        
        final livesAfterLoss = context.read<GameProvider>().gameState.lives;
        if (livesAfterLoss <= 0) {
          _onGameOver();
        } else {
          FeedbackService.showWrongAnswer(context, livesAfterLoss);
        }
      }
    }
  }

  void _onLevelCompleted() {
    _gameService.clearFoundAnswersForLevel(widget.level.id);
    _gameService.clearRevealedHintsForLevel(widget.level.id);
    context.read<GameProvider>().completeLevel(widget.level.id);
    
    // Calculer les points gagnés
    final hintPointsGained = HintConfig.getPointsForDifficulty(widget.level.difficulty);
    final isBossLevel = widget.level.positionInTier == 5;
    final bonusHintPoints = isBossLevel ? 5 : 0;
    final levelPointsGained = widget.level.pointsReward + (isBossLevel ? 1 : 0);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Niveau terminé !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Félicitations ! Vous avez trouvé tous les joueurs.'),
              const SizedBox(height: 16),
              Text('Points d\'indice gagnés: +${hintPointsGained + bonusHintPoints}'),
              Text('Points de niveau gagnés: +$levelPointsGained'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  void _onGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final gameProvider = context.read<GameProvider>();
        final canWatchAd = gameProvider.canWatchAdForLife();
        final timeUntilNextLife = gameProvider.getFormattedTimeUntilNextLife();
        
        return AlertDialog(
          title: const Center(
            child: Text('Vous avez épuisé toutes vos vies 😔'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timeUntilNextLife != null) ...[
                Center(
                  child: Text(
                    'Prochaine vie dans : $timeUntilNextLife',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (canWatchAd) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.play_circle_filled, color: Colors.purple, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Regardez une publicité',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'pour gagner des vies et continuer !',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Retour'),
            ),
            if (canWatchAd) ...[
              ElevatedButton.icon(
                onPressed: () => _watchAdAndContinue(context, gameProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.play_circle_filled, size: 20),
                label: const Text('Regarder une pub'),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _resetLevel() async {
    await _gameService.clearFoundAnswersForLevel(widget.level.id);
    await _gameService.clearRevealedHintsForLevel(widget.level.id);
    setState(() {
      _foundAnswers.clear();
      _availableAnswers = List.from(widget.level.answerNames);
      _searchController.clear();
      _debugAnswersRevealed = false;
      _hintLevels.clear();
    });
    
    // Nettoyer les niveaux d'indices sauvegardés
    await _gameService.clearHintLevelsForLevel(widget.level.id);
  }

  void _debugRevealAnswers() {
    if (!DebugConfig.enableRevealAnswers) return;
    
    setState(() {
      _debugAnswersRevealed = !_debugAnswersRevealed;
    });
    
    FeedbackService.showWarning(
      context,
      _debugAnswersRevealed 
        ? '🐛 DEBUG: Réponses\nrévélées' 
        : '🐛 DEBUG: Réponses\ncachées',
      duration: FeedbackConfig.debugDuration,
    );
  }

  void _debugSkipLevel() {
    if (!DebugConfig.enableSkipLevel) return;
    
    // Remplir toutes les réponses automatiquement
    setState(() {
      _foundAnswers.clear();
      _foundAnswers.addAll(widget.level.answerNames);
      _availableAnswers.clear();
    });
    
    FeedbackService.showSuccess(context, '🐛 DEBUG: Niveau\ncomplété automatiquement', duration: FeedbackConfig.debugDuration);
    
    // Déclencher la completion du niveau après un petit délai
    Future.delayed(const Duration(milliseconds: 500), () {
      _onLevelCompleted();
    });
  }


  Future<void> _watchAdAndContinue(BuildContext context, GameProvider gameProvider) async {
    try {
      // Fermer le dialog de game over
      Navigator.of(context).pop();
      
      // Montrer un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Chargement de la publicité...'),
              ],
            ),
          );
        },
      );

      final success = await gameProvider.watchAdForLife();
      
      // Vérifier si le widget est toujours monté avant d'utiliser context
      if (!context.mounted) return;
      
      // Fermer le dialog de chargement
      Navigator.of(context).pop();
      
      if (success) {
        // Afficher le succès et continuer le jeu
        FeedbackService.showLifeGained(context, lives: 5);
      } else {
        // Échec de la pub, proposer les autres options
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('❌ Publicité indisponible'),
              content: const Text('Impossible de charger la publicité. Que voulez-vous faire ?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Retour'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetLevel();
                  },
                  child: const Text('Recommencer'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Vérifier si le widget est toujours monté avant d'utiliser context
      if (!context.mounted) return;
      
      // Fermer le dialog de chargement si ouvert
      Navigator.of(context).pop();
      
      FeedbackService.showAdError(context);
      
      // Revenir au dialog de game over
      _onGameOver();
    }
  }

  Future<void> _onHintRequested(int index) async {
    final gameProvider = context.read<GameProvider>();
    
    // Récupérer le niveau d'indice actuel pour cette question
    final currentHintLevel = _hintLevels[index] ?? 0;
    
    // Vérifier si on peut encore débloquer des indices
    if (currentHintLevel >= 3) {
      print('DEBUG: All hints already revealed for index $index');
      return;
    }
    
    // Calculer le coût du prochain niveau
    final nextLevel = currentHintLevel + 1;
    final cost = HintConfig.getHintCost(nextLevel);
    
    // Vérifier que le joueur a assez de points
    if (gameProvider.gameState.hintPoints < cost) {
      print('DEBUG: Not enough hint points. Has ${gameProvider.gameState.hintPoints}, needs $cost');
      FeedbackService.showInsufficientPoints(context, cost, () => _watchAdForHints());
      return;
    }
    
    // Utiliser les points d'indices
    final success = await gameProvider.useHintPoints(widget.level.id, index, nextLevel);
    
    if (success) {
      print('DEBUG: Hint level $nextLevel unlocked for index $index');
      
      // Mettre à jour le niveau d'indice localement
      setState(() {
        _hintLevels[index] = nextLevel;
      });
      
      // Vibration de confirmation
      HapticFeedback.lightImpact();
    } else {
      print('DEBUG: Failed to unlock hint');
    }
  }
  
  Future<void> _watchAdForHints() async {
    final gameProvider = context.read<GameProvider>();
    
    if (!gameProvider.canWatchAdForHints()) {
      final timeUntil = gameProvider.getFormattedTimeUntilNextHintAd();
      FeedbackService.showAdNotAvailable(context, timeUntil);
      return;
    }
    
    final success = await gameProvider.watchAdForHints();
    
    if (success) {
      final actualPointsGained = HintConfig.getPointsToGain(gameProvider.gameState.hintPoints, HintConfig.pointsPerAd);
      FeedbackService.showPointsGained(context, actualPointsGained);
    } else {
      FeedbackService.showError(context, 'Erreur lors de la\nvisualisation de\nla publicité');
    }
  }

  void _showHintExplanation(BuildContext context, int currentHintPoints) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HintExplanationDialog(
          currentHintPoints: currentHintPoints,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TOP10',
              style: GoogleFonts.bangers(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'CHALLENGE',
              style: GoogleFonts.bangers(
                fontSize: 18,
                color: Colors.amber.shade300,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2C5F5D),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return GestureDetector(
                onTap: () => _showHintExplanation(context, gameProvider.gameState.hintPoints),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${gameProvider.gameState.hintPoints}/${HintConfig.maxHintPoints}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Boutons de debug (visibles seulement si activés)
          if (DebugConfig.hasAnyDebugFeature) ...[
            if (DebugConfig.enableRevealAnswers)
              IconButton(
                onPressed: _debugRevealAnswers,
                icon: Icon(
                  _debugAnswersRevealed ? Icons.visibility_off : Icons.visibility,
                  color: _debugAnswersRevealed ? Colors.orange : Colors.white,
                ),
                tooltip: _debugAnswersRevealed ? 'Cacher les réponses' : 'Révéler les réponses',
              ),
            if (DebugConfig.enableSkipLevel)
              IconButton(
                onPressed: _debugSkipLevel,
                icon: const Icon(Icons.skip_next, color: Colors.green),
                tooltip: 'Passer le niveau (DEBUG)',
              ),
          ],
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.level.title,
                                style: GoogleFonts.baloo2(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(height: 8),
                              // Text(
                              //   widget.level.hint,
                              //   style: GoogleFonts.baloo2(
                              //     color: Colors.white70,
                              //     fontSize: 17,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Money Time Indicator (only visible when active)
                        Consumer<GameProvider>(
                          builder: (context, gameProvider, child) {
                            if (!gameProvider.gameState.isMoneyTimeActive()) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Center(
                                child: MoneyTimeIndicator(),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Trouvés: ${_foundAnswers.length}/10',
                              style: GoogleFonts.baloo2(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Lives counter with Money Time shield effect
                            MoneyTimeShieldEffect(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red.shade400, size: 18),
                                    const SizedBox(width: 6),
                                    Consumer<GameProvider>(
                                      builder: (context, gameProvider, child) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${gameProvider.gameState.lives}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (gameProvider.shouldShowLifeTimer()) ...[
                                              Text(
                                                gameProvider.getFormattedTimeUntilNextLife() ?? '',
                                                style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Layout vertical : une seule colonne pour plus d'espace
                        Column(
                          children: List.generate(10, (index) {
                              Answer? answerForPosition;
                              bool isFound = false;
                              
                              if (index < widget.level.answers.length) {
                                answerForPosition = widget.level.answers[index];
                                isFound = _foundAnswers.contains(answerForPosition.name);
                              }
                              
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Consumer<GameProvider>(
                                builder: (context, gameProvider, child) {
                                  final hintLevel = _hintLevels[index] ?? 0;
                                  final hintData = hintLevel > 0 && answerForPosition != null
                                      ? HintGenerator.generateHint(answerForPosition, hintLevel)
                                      : null;
                                  
                                  return AnswerSlot(
                                    index: index + 1,
                                    answer: answerForPosition,
                                    isFound: isFound,
                                    debugRevealAnswer: _debugAnswersRevealed,
                                    hintData: hintData,
                                    hintLevel: hintLevel,
                                    onHintRequested: () => _onHintRequested(index),
                                    canUseHint: HintGenerator.canUseHint(hintLevel, gameProvider.gameState.hintPoints, isLevelCompleted: widget.level.isCompleted),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SearchInput(
                  controller: _searchController,
                  availableAnswers: _availableAnswers,
                  onSubmitted: _onAnswerSubmitted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}