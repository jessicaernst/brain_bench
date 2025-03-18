import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'quiz_answers_notifier.dart';

part 'quiz_result_notifier.g.dart';

@riverpod
class QuizResultNotifier extends _$QuizResultNotifier {
  @override
  QuizResultState build() {
    final quizAnswers = ref.watch(quizAnswersNotifierProvider);
    return QuizResultState(
      selectedView: SelectedView.none,
      expandedAnswers: {},
      quizAnswers: quizAnswers,
    );
  }

  void toggleView(SelectedView newView, WidgetRef ref) {
    if (state.selectedView != SelectedView.none &&
        state.selectedView == newView) {
      // If we're currently in correct/incorrect and we tap the same button, go to none
      state = state.copyWith(selectedView: SelectedView.none);
    } else {
      // ✅ 1. Collapse all answer cards before switching view
      state = state.copyWith(expandedAnswers: {});

      // 🕒 2. Wait for animation (~300ms), then switch view
      Future.delayed(const Duration(milliseconds: 300), () {
        state = state.copyWith(selectedView: newView);
      });
    }
  }

  void toggleExplanation(String questionId) {
    final newExpandedAnswers = {...state.expandedAnswers};
    if (newExpandedAnswers.contains(questionId)) {
      newExpandedAnswers.remove(questionId);
    } else {
      newExpandedAnswers.add(questionId);
    }
    state = state.copyWith(expandedAnswers: newExpandedAnswers);
  }

  List<QuizAnswer> getFilteredAnswers() {
    if (state.selectedView == SelectedView.none) {
      return [];
    } else if (state.selectedView == SelectedView.correct) {
      return state.quizAnswers
          .where((answer) => answer.incorrectAnswers.isEmpty)
          .toList();
    } else {
      return state.quizAnswers
          .where((answer) => answer.incorrectAnswers.isNotEmpty)
          .toList();
    }
  }
}

enum SelectedView { none, correct, incorrect }
