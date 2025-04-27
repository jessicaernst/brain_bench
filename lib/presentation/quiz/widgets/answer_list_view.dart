import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/presentation/quiz/widgets/answer_row_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerListView extends StatelessWidget {
  const AnswerListView({
    super.key,
    required this.question,
    required this.isMultipleChoice,
    required this.onAnswerSelected,
  });

  final Question question;
  final bool isMultipleChoice;
  final Function(String answerId) onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final String languageCode = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
        horizontal: MediaQuery.of(context).size.width * 0.10,
      ),
      child: Consumer(builder: (context, ref, child) {
        // Get the list of answers from the AnswersNotifier
        final answers = ref.watch(answersNotifierProvider);

        return ListView(
          shrinkWrap: true,
          children: answers.map((answer) {
            final isSelected = answer.isSelected;

            return GestureDetector(
              onTap: () => onAnswerSelected(answer.id),
              child: AnswerRowView(
                selected: isSelected,
                answer: answer,
                isDarkMode: isDarkMode,
                languageCode: languageCode,
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
