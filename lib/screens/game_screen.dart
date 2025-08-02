import 'package:flutter/material.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vous n\'avez plus de vies ! Attendez qu\'elles se récupèrent.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _loadSavedAnswers() async {
    final savedAnswers = await _gameService.getFoundAnswersForLevel(widget.level.id);
    setState(() {
      _foundAnswers.clear();
      _foundAnswers.addAll(savedAnswers);
      _availableAnswers = widget.level.answerNames.where((answer) => !savedAnswers.contains(answer)).toList();
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

      if (_foundAnswers.length == 10) {
        _onLevelCompleted();
      }
    } else {
      // Vérifier si la réponse correspond à une réponse déjà trouvée
      final alreadyFoundAnswer = _searchService.getCorrectAnswer(answer, _foundAnswers);
      
      if (alreadyFoundAnswer != null) {
        // Réponse déjà validée, ne pas enlever de vie
        _showAlreadyFoundFeedback();
        _searchController.clear();
      } else {
        // Réponse incorrecte, enlever une vie
        context.read<GameProvider>().loseLife();
        
        if (context.read<GameProvider>().gameState.lives <= 0) {
          _onGameOver();
        } else {
          _showWrongAnswerFeedback();
        }
      }
    }
  }

  void _onLevelCompleted() {
    _gameService.clearFoundAnswersForLevel(widget.level.id);
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
        return AlertDialog(
          title: const Text('💔 Game Over'),
          content: const Text('Vous avez fait trop d\'erreurs. Réessayez !'),
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

  void _resetLevel() {
    _gameService.clearFoundAnswersForLevel(widget.level.id);
    setState(() {
      _foundAnswers.clear();
      _availableAnswers = List.from(widget.level.answerNames);
      _searchController.clear();
      _debugAnswersRevealed = false;
    });
  }

  void _debugRevealAnswers() {
    if (!DebugConfig.enableRevealAnswers) return;
    
    setState(() {
      _debugAnswersRevealed = !_debugAnswersRevealed;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _debugAnswersRevealed 
            ? '🐛 DEBUG: Réponses révélées' 
            : '🐛 DEBUG: Réponses cachées'
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🐛 DEBUG: Niveau complété automatiquement'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Déclencher la completion du niveau après un petit délai
    Future.delayed(const Duration(milliseconds: 500), () {
      _onLevelCompleted();
    });
  }

  void _showWrongAnswerFeedback() {
    final lives = context.read<GameProvider>().gameState.lives;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mauvaise réponse ! $lives ${lives > 1 ? 'vies restantes' : 'vie restante'}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAlreadyFoundFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cette réponse a déjà été trouvée !'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _useHint() {
    final gameProvider = context.read<GameProvider>();
    if (gameProvider.gameState.hints > 0) {
      gameProvider.useHint();
      
      final randomAnswer = _availableAnswers.first;
      setState(() {
        _foundAnswers.add(randomAnswer);
        _availableAnswers.remove(randomAnswer);
      });

      _gameService.saveFoundAnswersForLevel(widget.level.id, _foundAnswers);

      if (_foundAnswers.length == 10) {
        _onLevelCompleted();
      }
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
              return IconButton(
                onPressed: gameProvider.gameState.hints > 0 ? _useHint : null,
                icon: Badge(
                  label: Text('${gameProvider.gameState.hints}'),
                  child: const Icon(Icons.lightbulb),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              Answer? answerForPosition;
                              bool isFound = false;
                              
                              if (index < widget.level.answers.length) {
                                answerForPosition = widget.level.answers[index];
                                isFound = _foundAnswers.contains(answerForPosition.name);
                              }
                              
                              return AnswerSlot(
                                index: index + 1,
                                answer: answerForPosition,
                                isFound: isFound,
                                debugRevealAnswer: _debugAnswersRevealed,
                              );
                            },
                          ),
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