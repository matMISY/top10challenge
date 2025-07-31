import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            ? Colors.green.shade600.withValues(alpha: 0.9)
            : debugRevealAnswer && hasAnswer
                ? Colors.orange.withValues(alpha: 0.6)
                : const Color(0xFF3A6B68).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFound 
              ? Colors.green.shade400
              : debugRevealAnswer && hasAnswer
                  ? Colors.orange
                  : Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isFound 
                    ? Colors.white 
                    : Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFound 
                      ? Colors.green.shade600
                      : Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: isFound 
                        ? Colors.green.shade700
                        : Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
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
                            style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              fontStyle: debugRevealAnswer && !isFound 
                                  ? FontStyle.italic 
                                  : FontStyle.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
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