import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_answers_notifier.g.dart';

final Logger _logger = Logger('QuizAnswersNotifier');

@Riverpod(keepAlive: true)
class QuizAnswersNotifier extends _$QuizAnswersNotifier {
  @override
  List<QuizAnswer> build() => [];

  /// Adds an answer to the state with all required information
  void addAnswer({
    required String questionId,
    required String topicId,
    required String categoryId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
    required List<String> allAnswers,
    String? explanation,
    required List<String> allCorrectAnswers, // Add allCorrectAnswers
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
        pointsEarned: pointsEarned, // Pass pointsEarned here
        possiblePoints: possiblePoints, // Pass possiblePoints here
      ).copyWith(incorrectAnswers: missedCorrectAnswers),
    ];

    _logger.info('✅ Added answer for question: $questionText');
    _logger.info('📊 Given Answers: $givenAnswers');
    _logger.info('📊 Correct Answers: $correctAnswers');
    _logger.info('📊 All Answers: $allAnswers');
    _logger.info('📊 Explanation: ${explanation ?? "None"}');
    _logger.info('📊 Points Earned: $pointsEarned'); // Log points earned
    _logger.info('📊 Possible Points: $possiblePoints'); // Log possible points
    _logger.info('📊 Amount of saved answers: ${state.length}');
  }

  /// Resets the stored answers
  void reset() {
    _logger.info('🔄 Resetting all saved answers.');
    state = [];
  }
}
