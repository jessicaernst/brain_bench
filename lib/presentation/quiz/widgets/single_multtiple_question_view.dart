import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/component_widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/presentation/quiz/widgets/answer_list_view.dart';
import 'package:flutter/material.dart';

class SingleMulttipleQuestionView extends StatelessWidget {
  const SingleMulttipleQuestionView({
    super.key,
    required this.progress,
    required this.currentQuestion,
    required this.isMultipleChoice,
    required this.answersNotifier,
    required this.localizations,
    required this.answers,
    required this.onAnswerSelected,
  });

  final double progress;
  final Question currentQuestion;
  final bool isMultipleChoice;
  final AnswersNotifier answersNotifier;
  final AppLocalizations localizations;
  final List<Answer> answers;
  final VoidCallback onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ProgressIndicatorBarView(progress: progress),
        const SizedBox(height: 24),
        Text(
          currentQuestion.question,
          textAlign: TextAlign.center,
          style: TextTheme.of(context).bodyMedium,
        ),
        const Spacer(),
        AnswerListView(
          question: currentQuestion,
          isMultipleChoice: isMultipleChoice,
          onAnswerSelected: (answerId) =>
              answersNotifier.toggleAnswerSelection(answerId, isMultipleChoice),
        ),
        const SizedBox(height: 24),
        Center(
          child: LightDarkSwitchBtn(
            title: localizations.submitAnswerBtnLbl,
            isActive: answers.any((answer) => answer.isSelected),
            onPressed: onAnswerSelected,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
