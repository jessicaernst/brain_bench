import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:brain_bench/presentation/results/widgets/answer_card.dart';
import 'package:flutter/material.dart';

class QuizResultExpandedView extends StatelessWidget {
  const QuizResultExpandedView({
    super.key,
    required ScrollController scrollController,
    required this.filteredAnswers,
    required double defaultPadding,
  })  : _scrollController = scrollController,
        _defaultPadding = defaultPadding;

  final ScrollController _scrollController;
  final List<QuizAnswer> filteredAnswers;
  final double _defaultPadding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // ✅ Add the ScrollController to the ListView
      child: ListView.separated(
        controller: _scrollController,
        itemCount: filteredAnswers.length,
        separatorBuilder: (context, index) => SizedBox(height: _defaultPadding),
        itemBuilder: (context, index) {
          final answer = filteredAnswers[index];
          return AnswerCard(
            answer: answer,
            isCorrect: answer.incorrectAnswers.isEmpty,
          );
        },
      ),
    );
  }
}
