import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/gen/assets.gen.dart';
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
        child: Column(
          children: [
            Assets.images.sadHam.image(width: 200, height: 200),
            const SizedBox(height: 48),
            Text(
              localizations.quizErrorLoadingQuestions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
