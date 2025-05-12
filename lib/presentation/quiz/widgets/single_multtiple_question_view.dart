import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
import 'package:brain_bench/core/shared_widgets/progress_bars/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/quiz/question_extensions.dart';
import 'package:brain_bench/presentation/quiz/widgets/answer_list_view.dart';
import 'package:flutter/material.dart';

class SingleMultipleQuestionView extends StatelessWidget {
  const SingleMultipleQuestionView({
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
    final String languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        const SizedBox(height: 8),
        ProgressIndicatorBarView(progress: progress),
        const SizedBox(height: 24),
        AutoHyphenatingText(
          currentQuestion.localizedQuestion(languageCode),
          textAlign: TextAlign.center,
          style: TextTheme.of(context).bodyMedium,
        ),
        const Spacer(),
        AnswerListView(
          question: currentQuestion,
          isMultipleChoice: isMultipleChoice,
          onAnswerSelected:
              (answerId) => answersNotifier.toggleAnswerSelection(
                answerId,
                isMultipleChoice,
              ),
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
