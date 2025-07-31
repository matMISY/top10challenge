import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/level.dart';
import '../models/answer.dart';
import '../providers/game_provider.dart';
import '../services/search_service.dart';
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
  final List<String> _foundAnswers = [];
  List<String> _availableAnswers = [];
  int _mistakes = 0;
  static const int _maxMistakes = 3;
  bool _debugAnswersRevealed = false;

  @override
  void initState() {
    super.initState();
    _availableAnswers = List.from(widget.level.answerNames);
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

      if (_foundAnswers.length == 10) {
        _onLevelCompleted();
      }
    } else {
      setState(() {
        _mistakes++;
      });
      
      context.read<GameProvider>().loseLife();
      
      if (_mistakes >= _maxMistakes) {
        _onGameOver();
      } else {
        _showWrongAnswerFeedback();
      }
    }
  }

  void _onLevelCompleted() {
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
              Text('Score: +${100 * widget.level.difficulty}'),
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
    setState(() {
      _foundAnswers.clear();
      _availableAnswers = List.from(widget.level.answerNames);
      _mistakes = 0;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mauvaise réponse ! ${_maxMistakes - _mistakes} essais restants'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
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

      if (_foundAnswers.length == 10) {
        _onLevelCompleted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Niveau ${widget.level.id}'),
        backgroundColor: const Color(0xFF6B73FF),
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B73FF),
              Color(0xFF9B59B6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.level.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.level.hint,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                        const SizedBox(width: 4),
                        Consumer<GameProvider>(
                          builder: (context, gameProvider, child) {
                            return Text(
                              '${gameProvider.gameState.lives}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Erreurs: $_mistakes/$_maxMistakes',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5, // Réduit pour donner plus de hauteur
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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