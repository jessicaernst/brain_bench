import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/buttons/light_dark_switch_btn.dart';
import 'package:brain_bench/core/shared_widgets/progress_bars/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/quiz/question_extensions.dart';
import 'package:brain_bench/presentation/quiz/widgets/answer_list_view.dart';
import 'package:flutter/material.dart';

class QuizQuestionDisplay extends StatelessWidget {
  const QuizQuestionDisplay({
    super.key,
    required this.progress,
    required this.currentQuestion,
    required this.isMultipleChoice,
    required this.answersNotifier,
    required this.localizations,
    required this.currentAnswers,
    required this.onSubmit,
  });

  final double progress;
  final Question currentQuestion;
  final bool isMultipleChoice;
  final AnswersNotifier answersNotifier;
  final AppLocalizations localizations;
  final List<Answer> currentAnswers;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ProgressIndicatorBarView(progress: progress),
          const SizedBox(height: 24),
          Text(
            currentQuestion.localizedQuestion(languageCode),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
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
            // AnswerListView fetches its own answers via provider
          ),
          const SizedBox(height: 24),
          Center(
            child: LightDarkSwitchBtn(
              title: localizations.submitAnswerBtnLbl,
              // Determine isActive based on the passed currentAnswers
              isActive: currentAnswers.any((answer) => answer.isSelected),
              // Use the passed onSubmit callback
              onPressed: onSubmit,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
