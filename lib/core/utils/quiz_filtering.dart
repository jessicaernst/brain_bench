import 'package:brain_bench/business_logic/quiz/quiz_state.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';

/// Record type to hold the categorized lists of answers after filtering.
typedef FilteredAnswers = ({
  List<Answer> correct,
  List<Answer> incorrect,
  List<Answer> missed
});

/// Filters a list of all current answers based on the IDs stored in the QuizState.
///
/// Returns a record containing separate lists for correct, incorrect, and missed answers.
FilteredAnswers filterAnswers(
    QuizState quizState, List<Answer> allCurrentAnswers) {
  // Create Sets for efficient lookup
  final correctIds = quizState.correctAnswers.toSet();
  final incorrectIds = quizState.incorrectAnswers.toSet();
  final missedIds = quizState.missedCorrectAnswers.toSet();

  // Filter the full Answer objects using the IDs
  final correctAnswersList = allCurrentAnswers
      .where((answer) => correctIds.contains(answer.id))
      .toList();
  final incorrectAnswersList = allCurrentAnswers
      .where((answer) => incorrectIds.contains(answer.id))
      .toList();
  final missedCorrectAnswersList = allCurrentAnswers
      .where((answer) => missedIds.contains(answer.id))
      .toList();

  return (
    correct: correctAnswersList,
    incorrect: incorrectAnswersList,
    missed: missedCorrectAnswersList
  );
}
