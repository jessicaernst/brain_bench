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
  }) {
    // Find answers the user should have selected but missed
    final missedCorrectAnswers =
        correctAnswers.where((ans) => !givenAnswers.contains(ans)).toList();

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
      ).copyWith(incorrectAnswers: missedCorrectAnswers),
    ];

    _logger.info('✅ Added answer for question: $questionText');
    _logger.info('📊 Given Answers: $givenAnswers');
    _logger.info('📊 Correct Answers: $correctAnswers');
    _logger.info('📊 All Answers: $allAnswers');
    _logger.info('📊 Explanation: ${explanation ?? "None"}');
    _logger.info('📊 Amount of saved answers: ${state.length}');
  }

  /// Resets the stored answers
  void reset() {
    _logger.info('🔄 Resetting all saved answers.');
    state = [];
  }
}
