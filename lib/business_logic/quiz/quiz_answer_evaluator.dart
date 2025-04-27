import 'package:brain_bench/data/models/quiz/answer.dart'; // Make sure the path to your Answer model is correct

/// Represents the result of evaluating a list of answers.
///
/// Contains lists for correctly selected, incorrectly selected, and missed correct answers.
typedef AnswerEvaluationResult = ({
  List<Answer> correct,
  List<Answer> incorrect,
  List<Answer> missed
});

/// Evaluates a list of answers based on their selected and correct status.
///
/// Takes a list of [Answer] objects, where `isSelected` reflects the user's choice,
/// and returns a record containing three lists:
/// - `correct`: Answers that were correctly selected by the user.
/// - `incorrect`: Answers that were incorrectly selected by the user.
/// - `missed`: Correct answers that were *not* selected by the user.
AnswerEvaluationResult evaluateAnswers(List<Answer> answers) {
  // Filter for answers that were selected by the user AND are correct.
  final correctAnswers =
      answers.where((a) => a.isSelected && a.isCorrect).toList();

  // Filter for answers that were selected by the user BUT are incorrect.
  final incorrectAnswers =
      answers.where((a) => a.isSelected && !a.isCorrect).toList();

  // Filter for answers that were NOT selected by the user BUT ARE correct.
  final missedCorrectAnswers =
      answers.where((a) => !a.isSelected && a.isCorrect).toList();

  // Return the results as a record.
  return (
    correct: correctAnswers,
    incorrect: incorrectAnswers,
    missed: missedCorrectAnswers
  );
}
