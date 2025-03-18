import 'package:brain_bench/presentation/results/widgets/answer_expandable.dart';
import 'package:brain_bench/presentation/results/widgets/answer_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

class AnswerCard extends ConsumerStatefulWidget {
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isCorrect,
  });

  final QuizAnswer answer;
  final bool isCorrect;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnswerCardState();
}

class _AnswerCardState extends ConsumerState<AnswerCard> {
  // ✅ Add a GlobalKey to each AnswerCard
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final quizResultState = ref.watch(quizResultNotifierProvider);
    final stateNotifier = ref.read(quizResultNotifierProvider.notifier);
    final bool isExpanded =
        quizResultState.expandedAnswers.contains(widget.answer.questionId);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ Use the key in the Column
    return Column(
      key: _cardKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnswerMainCard(
          answerText: widget.answer.questionText,
          isCorrect: widget.isCorrect,
          isExpanded: isExpanded,
          onTap: () {
            stateNotifier.toggleExplanation(widget.answer.questionId);
            // ✅ Ensure the card is visible after tapping
            if (!isExpanded) {
              _ensureCardIsVisible();
            }
          },
          isDarkMode: isDarkMode,
        ),
        AnswerExpandable(
          isExpanded: isExpanded,
          answer: widget.answer,
        ),
      ],
    );
  }

  // ✅ Helper method to ensure the card is visible
  void _ensureCardIsVisible() {
    Future.delayed(const Duration(milliseconds: 300), () {
      final RenderObject? renderObject =
          _cardKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject.attached) {
        Scrollable.ensureVisible(
          _cardKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
