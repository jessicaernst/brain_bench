import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_answers_notifier.g.dart';

final Logger _logger = Logger('QuizAnswersNotifier');

/// A Riverpod notifier that manages a list of [QuizAnswer] objects.
///
/// This notifier is responsible for storing and managing the answers given by
/// the user during a quiz. It keeps track of the question, the user's given
/// answers, the correct answers, and calculates the points earned for each
/// answer.
@Riverpod(keepAlive: true)
class QuizAnswersNotifier extends _$QuizAnswersNotifier {
  /// Builds the initial state of the notifier, which is an empty list of
  /// [QuizAnswer] objects.
  @override
  List<QuizAnswer> build() => [];

  /// Adds an answer to the state with all required information.
  ///
  /// This method takes various parameters to describe the answer, including
  /// the question, the user's given answers, the correct answers, and
  /// additional information like an explanation. It calculates the points
  /// earned for the answer and adds a new [QuizAnswer] object to the state.
  ///
  /// Parameters:
  ///   - [questionId]: The ID of the question.
  ///   - [topicId]: The ID of the topic.
  ///   - [categoryId]: The ID of the category.
  ///   - [questionText]: The text of the question.
  ///   - [givenAnswers]: A list of answers given by the user.
  ///   - [correctAnswers]: A list of correct answers for the question.
  ///   - [allAnswers]: A list of all possible answers for the question.
  ///   - [explanation]: An optional explanation for the question.
  ///   - [allCorrectAnswers]: A list of all correct answers for the question.
  void addAnswer({
    required String questionId,
    required String topicId,
    required String categoryId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
    required List<String> allAnswers,
    String? explanation,
    required List<String> allCorrectAnswers,
  }) {
    // Find answers the user should have selected but missed
    final missedCorrectAnswers =
        correctAnswers.where((ans) => !givenAnswers.contains(ans)).toList();

    // ✅ Calculate points earned
    int pointsEarned = 0;
    for (final givenAnswer in givenAnswers) {
      if (allCorrectAnswers.contains(givenAnswer)) {
        pointsEarned++;
      }
    }

    // ✅ Calculate possible points
    final possiblePoints = allCorrectAnswers.length;

    state = [
      ...state,
      QuizAnswer.create(
        questionId: questionId,
        topicId: topicId,
        categoryId: categoryId,
        questionText: questionText,
        givenAnswers: givenAnswers,
        correctAnswers: correctAnswers,
        allAnswers: allAnswers,
        explanation: explanation,
        pointsEarned: pointsEarned,
        possiblePoints: possiblePoints,
      ).copyWith(incorrectAnswers: missedCorrectAnswers),
    ];

    _logger.info('✅ Added answer for question: $questionText');
    _logger.info('📊 Given Answers: $givenAnswers');
    _logger.info('📊 Correct Answers: $correctAnswers');
    _logger.info('📊 All Answers: $allAnswers');
    _logger.info('📊 Explanation: ${explanation ?? "None"}');
    _logger.info('📊 Points Earned: $pointsEarned');
    _logger.info('📊 Possible Points: $possiblePoints');
    _logger.info('📊 Amount of saved answers: ${state.length}');
  }

  /// Resets the stored answers.
  ///
  /// This method clears the list of stored answers, effectively resetting the
  /// state of the notifier to its initial state (an empty list).
  void reset() {
    _logger.info('🔄 Resetting all saved answers.');
    state = [];
  }
}
