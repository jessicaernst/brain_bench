import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizResultInfoText extends ConsumerWidget {
  const QuizResultInfoText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizResultNotifierProvider);

    if (state.selectedView != SelectedView.none) {
      return const SizedBox.shrink();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: AutoHyphenatingText(
        AppLocalizations.of(context)!.quizToggleExplanation,
        textAlign: TextAlign.center,
      ),
    );
  }
}
