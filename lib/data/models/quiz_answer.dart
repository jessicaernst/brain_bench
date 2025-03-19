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
    required List<String> allAnswers,
    String? explanation,
    @Default(0) int pointsEarned,
    @Default(0) int possiblePoints,
  }) = _QuizAnswer;

  factory QuizAnswer.create({
    required String questionId,
    required String topicId,
    required String categoryId,
    required String questionText,
    required List<String> givenAnswers,
    required List<String> correctAnswers,
    required List<String> allAnswers,
    String? explanation,
    required int pointsEarned,
    required int possiblePoints,
  }) {
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
      allAnswers: allAnswers,
      explanation: explanation,
      pointsEarned: pointsEarned,
      possiblePoints: possiblePoints,
    );
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}
