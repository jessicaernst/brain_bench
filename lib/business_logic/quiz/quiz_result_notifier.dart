import 'package:brain_bench/data/models/quiz_answer.dart';
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

  void toggleView(SelectedView view) {
    state = state.copyWith(
      selectedView: state.selectedView == view ? SelectedView.none : view,
    );
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

class QuizResultState {
  final SelectedView selectedView;
  final Set<String> expandedAnswers;
  final List<QuizAnswer> quizAnswers;

  QuizResultState({
    required this.selectedView,
    required this.expandedAnswers,
    required this.quizAnswers,
  });

  QuizResultState copyWith({
    SelectedView? selectedView,
    Set<String>? expandedAnswers,
    List<QuizAnswer>? quizAnswers,
  }) {
    return QuizResultState(
      selectedView: selectedView ?? this.selectedView,
      expandedAnswers: expandedAnswers ?? this.expandedAnswers,
      quizAnswers: quizAnswers ?? this.quizAnswers,
    );
  }
}
