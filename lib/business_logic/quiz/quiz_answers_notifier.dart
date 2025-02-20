import 'package:brain_bench/data/models/quiz_answer.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_answers_notifier.g.dart';

final Logger _logger = Logger('QuizAnswersNotifier');

@Riverpod(keepAlive: true)
class QuizAnswersNotifier extends _$QuizAnswersNotifier {
  @override
  List<QuizAnswer> build() => [];

  void addAnswer(
    String questionId,
    String topicId,
    String categoryId,
    String questionText,
    List<String> givenAnswers,
    List<String> correctAnswers,
  ) {
    state = [
      ...state,
      QuizAnswer.create(
        questionId: questionId,
        topicId: topicId,
        categoryId: categoryId,
        questionText: questionText,
        givenAnswers: givenAnswers,
        correctAnswers: correctAnswers,
      ),
    ];

    _logger.info('✅ Added answer for question: $questionText');
    _logger.info('📊 Given Answers: $givenAnswers');
    _logger.info('📊 Amount of saved answers: ${state.length}');
  }

  void reset() {
    state = [];
  }
}
