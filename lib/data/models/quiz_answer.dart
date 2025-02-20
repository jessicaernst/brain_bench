import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'quiz_answer.freezed.dart';
part 'quiz_answer.g.dart';

@freezed
class QuizAnswer with _$QuizAnswer {
  factory QuizAnswer({
    required String id,
    required String topicId,
    required String categoryId,
    required String questionId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
    required List<String> incorrectAnswers,
  }) = _QuizAnswer;

  factory QuizAnswer.create({
    required String questionId,
    required String topicId,
    required String categoryId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
  }) {
    // Get all incorrect answers
    final incorrectAnswers =
        givenAnswers.where((ans) => !correctAnswers.contains(ans)).toList();

    return QuizAnswer(
      id: const Uuid().v4(),
      questionId: questionId,
      topicId: topicId,
      categoryId: categoryId,
      questionText: questionText,
      givenAnswers: givenAnswers,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
    );
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}
