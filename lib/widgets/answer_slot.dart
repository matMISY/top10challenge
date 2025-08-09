import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/answer.dart';

class AnswerSlot extends StatefulWidget {
  final int index;
  final Answer? answer;
  final bool isFound;
  final bool debugRevealAnswer;
  final String? revealedHint;
  final VoidCallback? onHintRequested;
  final bool canUseHint;

  const AnswerSlot({
    super.key,
    required this.index,
    this.answer,
    this.isFound = false,
    this.debugRevealAnswer = false,
    this.revealedHint,
    this.onHintRequested,
    this.canUseHint = false,
  });

  @override
  State<AnswerSlot> createState() => _AnswerSlotState();
}

class _AnswerSlotState extends State<AnswerSlot> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isLongPressing = false;
  static const Duration _longPressDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _longPressDuration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isLongPressing) {
        _onHintReveal();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHintReveal() {
    if (widget.canUseHint && widget.onHintRequested != null) {
      HapticFeedback.mediumImpact();
      widget.onHintRequested!();
    }
    _resetAnimation();
  }

  void _resetAnimation() {
    setState(() {
      _isLongPressing = false;
    });
    _animationController.reset();
  }

  void _onLongPressStart() {
    if (_canShowHint()) {
      setState(() {
        _isLongPressing = true;
      });
      _animationController.forward();
    }
  }

  void _onLongPressEnd() {
    if (_isLongPressing) {
      _resetAnimation();
    }
  }

  bool _canShowHint() {
    return widget.canUseHint && 
           widget.onHintRequested != null && 
           !widget.isFound && 
           widget.revealedHint == null;
  }

  Color _getBackgroundColor() {
    if (widget.isFound) {
      return Colors.green.shade600.withValues(alpha: 0.9);
    } else if (widget.debugRevealAnswer && widget.answer != null) {
      return Colors.orange.withValues(alpha: 0.6);
    } else if (widget.revealedHint != null) {
      return Colors.amber.shade700.withValues(alpha: 0.8);
    } else {
      return const Color(0xFF3A6B68).withValues(alpha: 0.4);
    }
  }

  Color _getBorderColor() {
    if (widget.isFound) {
      return Colors.green.shade400;
    } else if (widget.debugRevealAnswer && widget.answer != null) {
      return Colors.orange;
    } else if (widget.revealedHint != null) {
      return Colors.amber.shade400;
    } else {
      return Colors.white.withValues(alpha: 0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswer = widget.answer != null;
    final shouldShowAnswer = widget.isFound || widget.debugRevealAnswer;
    final hasRevealedHint = widget.revealedHint != null;
    
    return GestureDetector(
      onLongPressStart: (_) => _onLongPressStart(),
      onLongPressEnd: (_) => _onLongPressEnd(),
      onLongPressCancel: () => _onLongPressEnd(),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 60,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getBorderColor(),
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
            child: Stack(
              children: [
                // Animation de progression pendant l'appui long
                if (_isLongPressing && _canShowHint())
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            color: Colors.amber.shade200.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Bordure animée
                if (_isLongPressing && _canShowHint())
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.amber.shade300.withValues(alpha: 0.9),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: widget.isFound 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.isFound 
                                ? Colors.green.shade600
                                : Colors.white.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.index}',
                            style: TextStyle(
                              color: widget.isFound 
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (hasAnswer && widget.answer!.nationality.isNotEmpty) ...[
                              widget.answer!.getFlagWidget(size: 20),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: shouldShowAnswer && hasAnswer
                                  ? Text(
                                      widget.answer!.name,
                                      style: GoogleFonts.baloo2(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                        fontStyle: widget.debugRevealAnswer && !widget.isFound 
                                            ? FontStyle.italic 
                                            : FontStyle.normal,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : hasRevealedHint
                                      ? Text(
                                          widget.revealedHint!,
                                          style: GoogleFonts.baloo2(
                                            color: Colors.amber.shade100,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.2,
                                            fontStyle: FontStyle.italic,
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
                      if (widget.isFound)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        )
                      else if (widget.debugRevealAnswer && hasAnswer)
                        const Icon(
                          Icons.bug_report,
                          color: Colors.orange,
                          size: 16,
                        )
                      else if (hasRevealedHint)
                        Icon(
                          Icons.lightbulb,
                          color: Colors.amber.shade200,
                          size: 16,
                        ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}