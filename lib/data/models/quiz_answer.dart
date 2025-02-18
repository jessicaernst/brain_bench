import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'quiz_answer.freezed.dart';
part 'quiz_answer.g.dart';

@freezed
class QuizAnswer with _$QuizAnswer {
  factory QuizAnswer({
    required String id,
    required String questionId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
  }) = _QuizAnswer;

  factory QuizAnswer.create({
    required String questionId,
    required String answer,
    required String questionText,
    required bool isCorrect,
  }) {
    return QuizAnswer(
      id: const Uuid().v4(),
      questionId: questionId,
      questionText: questionText,
      givenAnswers: [answer],
      correctAnswers: isCorrect ? [answer] : [],
    );
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}
