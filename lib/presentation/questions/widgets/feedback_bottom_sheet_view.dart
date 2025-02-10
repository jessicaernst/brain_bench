import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackBottomSheetView extends StatelessWidget {
  const FeedbackBottomSheetView({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
    required this.btnLbl,
    required this.onBtnPressed,
  });

  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;
  final String btnLbl;
  final VoidCallback onBtnPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Dynamische Höhe
          children: [
            Text(
              localizations.feedBackBottomSheetTitle,
              style: TextTheme.of(context).bodyLarge,
            ),
            const SizedBox(height: 16),
            if (correctAnswers.isNotEmpty) ...[
              Text(localizations.feedbackBSheetCorrectAnswers,
                  style: TextTheme.of(context).bodyLarge),
              ...correctAnswers.map((a) => Text('- ${a.text}',
                  style: const TextStyle(color: Colors.green))),
              const SizedBox(height: 8),
            ],
            if (incorrectAnswers.isNotEmpty) ...[
              Text(localizations.feedbackBSheetWrongAnswers,
                  style: TextTheme.of(context).bodyLarge),
              ...incorrectAnswers.map((a) => Text('- ${a.text}',
                  style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 8),
            ],
            if (missedCorrectAnswers.isNotEmpty) ...[
              Text(localizations.feedbackBSheetMissedCorrectAnswers,
                  style: TextTheme.of(context).bodyLarge),
              ...missedCorrectAnswers.map((a) => Text('- ${a.text}',
                  style: const TextStyle(color: Colors.orange))),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 48),
            Center(
              child: LightDarkSwitchBtn(
                title: btnLbl,
                isActive: true,
                onPressed: onBtnPressed,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
