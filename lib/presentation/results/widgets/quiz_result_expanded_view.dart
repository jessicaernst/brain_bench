import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/presentation/results/widgets/answer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';

class QuizResultExpandedView extends ConsumerWidget {
  const QuizResultExpandedView({
    super.key,
    required ScrollController scrollController,
    required this.filteredAnswers,
    required double defaultPadding,
    required this.expandedAnswers,
  }) : _scrollController = scrollController,
       _defaultPadding = defaultPadding;

  final ScrollController _scrollController;
  final List<QuizAnswer> filteredAnswers;
  final double _defaultPadding; // Wird für den Separator verwendet
  final Set<String> expandedAnswers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quizResultNotifierProvider.notifier);

    final double bottomPadding = MediaQuery.of(context).size.height * 0.2;

    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: bottomPadding),
        // ------------------------------------
        itemCount: filteredAnswers.length,
        separatorBuilder: (context, index) => SizedBox(height: _defaultPadding),
        itemBuilder: (context, index) {
          final answer = filteredAnswers[index];
          final bool isCurrentlyExpanded = expandedAnswers.contains(
            answer.questionId,
          );
          return AnswerCard(
            key: ValueKey(answer.questionId),
            answer: answer,
            isCorrect: answer.pointsEarned == answer.possiblePoints,
            isExpanded: isCurrentlyExpanded,
            onToggle: () => notifier.toggleExplanation(answer.questionId),
          );
        },
      ),
    );
  }
}
