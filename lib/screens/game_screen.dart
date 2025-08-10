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

  void _onAnswerSubmitted(String answer) {
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
        context.read<GameProvider>().loseLife();
        
        if (context.read<GameProvider>().gameState.lives <= 0) {
          _onGameOver();
        } else {
          final lives = context.read<GameProvider>().gameState.lives;
          FeedbackService.showWrongAnswer(context, lives);
        }
      }
    }
  }

  void _onLevelCompleted() {
    _gameService.clearFoundAnswersForLevel(widget.level.id);
    _gameService.clearRevealedHintsForLevel(widget.level.id);
    context.read<GameProvider>().completeLevel(widget.level.id);
    
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
              Text('Indices gagnés: +${widget.level.difficulty}'),
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
        
        return AlertDialog(
          title: const Text('💔 Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vous avez fait trop d\'erreurs.'),
              if (canWatchAd) ...[
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.play_circle_filled, color: Colors.purple),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Regardez une pub pour gagner une vie et continuer !',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
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
              TextButton(
                onPressed: () => _watchAdAndContinue(context, gameProvider),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_filled, size: 16, color: Colors.purple),
                    SizedBox(width: 4),
                    Text('Pub + 1 vie', style: TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
            ],
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
        FeedbackService.showLifeGained(context);
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
      FeedbackService.showPointsGained(context, HintConfig.pointsPerAd);
    } else {
      FeedbackService.showError(context, 'Erreur lors de la\nvisualisation de\nla publicité');
    }
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
              return Container(
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
                      '${gameProvider.gameState.hintPoints}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                              const SizedBox(height: 8),
                              Text(
                                widget.level.hint,
                                style: GoogleFonts.baloo2(
                                  color: Colors.white70,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
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
                            Container(
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
                                    canUseHint: HintGenerator.canUseHint(hintLevel, gameProvider.gameState.hintPoints),
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