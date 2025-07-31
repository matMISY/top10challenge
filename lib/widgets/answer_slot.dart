import 'package:flutter/material.dart';
import '../models/answer.dart';

class AnswerSlot extends StatelessWidget {
  final int index;
  final Answer? answer;
  final bool isFound;
  final bool debugRevealAnswer;

  const AnswerSlot({
    super.key,
    required this.index,
    this.answer,
    this.isFound = false,
    this.debugRevealAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnswer = answer != null;
    final shouldShowAnswer = isFound || debugRevealAnswer;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isFound 
            ? Colors.green.withValues(alpha: 0.8)
            : debugRevealAnswer && hasAnswer
                ? Colors.orange.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFound 
              ? Colors.green 
              : debugRevealAnswer && hasAnswer
                  ? Colors.orange
                  : Colors.white30,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isFound ? Colors.white : Colors.white30,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: isFound ? Colors.green : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  if (hasAnswer && answer!.nationality.isNotEmpty) ...[
                    answer!.getFlagWidget(size: 20),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: shouldShowAnswer && hasAnswer
                        ? Text(
                            answer!.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.2, // Hauteur de ligne réduite pour compacité
                              // Style différent pour le debug
                              fontStyle: debugRevealAnswer && !isFound 
                                  ? FontStyle.italic 
                                  : FontStyle.normal,
                            ),
                            maxLines: 2, // Permettre 2 lignes maximum
                            overflow: TextOverflow.ellipsis, // Tronquer après 2 lignes si nécessaire
                          )
                        : Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (isFound)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              )
            else if (debugRevealAnswer && hasAnswer)
              const Icon(
                Icons.bug_report,
                color: Colors.orange,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}