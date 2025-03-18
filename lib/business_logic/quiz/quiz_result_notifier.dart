import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
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
    if (state.selectedView == newView) return;

    // ✅ 1. Collapse all answer cards before switching view
    state = state.copyWith(expandedAnswers: {});

    // 🕒 2. Wait for animation (~300ms), then switch view
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(selectedView: newView);
    });
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
}

enum SelectedView { none, correct, incorrect }
