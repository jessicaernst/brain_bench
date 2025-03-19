import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/data/models/quiz_answer.dart';

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

  bool get shouldShowExplanationText =>
      selectedView != SelectedView.none || expandedAnswers.isNotEmpty;
}
