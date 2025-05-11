import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/presentation/quiz/controller/quiz_page_controller.dart';
import 'package:brain_bench/presentation/quiz/widgets/quiz_content.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizBodyView');

class QuizBodyView extends StatelessWidget {
  const QuizBodyView({
    super.key,
    required this.questions,
    required this.localizations,
    required this.languageCode,
    required this.controller,
    required this.isMountedCheck,
    required this.buildContext,
  });

  final List<Question> questions;
  final AppLocalizations localizations;
  final String languageCode;
  final QuizPageController controller;
  final bool Function() isMountedCheck;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      _logger.warning(
        'Questions provider returned data, but the list is empty.',
      );
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.quizErrorNoQuestions,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return QuizContent(
      questions: questions,
      localizations: localizations,
      languageCode: languageCode,
      showResultBottomSheet:
          () => controller.prepareAndShowResultBottomSheet(
            buildContext,
            isMountedCheck,
            languageCode,
          ),
    );
  }
}
