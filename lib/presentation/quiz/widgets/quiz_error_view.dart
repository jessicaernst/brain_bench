import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class QuizErrorView extends StatelessWidget {
  const QuizErrorView({
    super.key,
    required this.error,
    required this.stack,
    required this.localizations,
  });

  final Object error;
  final StackTrace stack;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          localizations.quizErrorLoadingQuestions,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
