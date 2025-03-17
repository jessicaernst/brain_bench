import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/presentation/results/widgets/answer_card.dart';
import 'package:brain_bench/presentation/quiz/widgets/toggle_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizResultPage extends HookConsumerWidget {
  const QuizResultPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizResultNotifierProvider);
    final notifier = ref.read(quizResultNotifierProvider.notifier);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.quizResultsAppBarTitle,
        onBack: () {
          ref.read(quizAnswersNotifierProvider.notifier).reset();
          ref.read(quizViewModelProvider.notifier).resetQuiz(ref);

          context.go(
            '/categories/details/topics',
            extra: categoryId,
          );
        },
      ),
      body: state.quizAnswers.isEmpty
          ? Center(child: Text(localizations.quizResultsNotSaved))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButton(
                        isSelected: state.selectedView == SelectedView.correct,
                        icon: Icons.thumb_up,
                        isCorrect: true,
                        onTap: () => notifier.toggleView(SelectedView.correct),
                      ),
                      const SizedBox(width: 48),
                      ToggleButton(
                        isSelected:
                            state.selectedView == SelectedView.incorrect,
                        icon: Icons.thumb_down,
                        isCorrect: false,
                        onTap: () =>
                            notifier.toggleView(SelectedView.incorrect),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.quizAnswers
                        .where((answer) =>
                            state.selectedView == SelectedView.correct
                                ? answer.incorrectAnswers.isEmpty
                                : state.selectedView == SelectedView.incorrect
                                    ? answer.incorrectAnswers.isNotEmpty
                                    : false)
                        .length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final filteredAnswers = state.quizAnswers
                          .where((answer) =>
                              state.selectedView == SelectedView.correct
                                  ? answer.incorrectAnswers.isEmpty
                                  : state.selectedView == SelectedView.incorrect
                                      ? answer.incorrectAnswers.isNotEmpty
                                      : false)
                          .toList();

                      final answer = filteredAnswers[index];

                      return AnswerCard(
                        answer: answer,
                        isCorrect: answer.incorrectAnswers.isEmpty,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
