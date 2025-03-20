import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'quiz_answer.freezed.dart';
part 'quiz_answer.g.dart';

/// Represents a single answer given by the user in a quiz.
///
/// This class contains information about the answer, such as the question,
/// the user's given answers, the correct answers, the points earned, and
/// additional information like an explanation.
@freezed
class QuizAnswer with _$QuizAnswer {
  /// Creates a [QuizAnswer] object.
  ///
  /// Parameters:
  ///   - [id]: The unique ID of the answer.
  ///   - [topicId]: The ID of the topic the question belongs to.
  ///   - [categoryId]: The ID of the category the question belongs to.
  ///   - [questionId]: The ID of the question.
  ///   - [questionText]: The text of the question.
  ///   - [givenAnswers]: A list of answers given by the user.
  ///   - [correctAnswers]: A list of correct answers for the question.
  ///   - [incorrectAnswers]: A list of incorrect answers given by the user.
  ///   - [allAnswers]: A list of all possible answers for the question.
  ///   - [explanation]: An optional explanation for the question.
  ///   - [pointsEarned]: The points earned for this answer. Defaults to 0.
  ///   - [possiblePoints]: The maximum possible points for this answer. Defaults to 0.
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

  /// Creates a [QuizAnswer] object with a new unique ID.
  ///
  /// This factory constructor is used to create a new [QuizAnswer] object.
  /// It automatically generates a unique ID using [Uuid].
  ///
  /// Parameters:
  ///   - [questionId]: The ID of the question.
  ///   - [topicId]: The ID of the topic the question belongs to.
  ///   - [categoryId]: The ID of the category the question belongs to.
  ///   - [questionText]: The text of the question.
  ///   - [givenAnswers]: A list of answers given by the user.
  ///   - [correctAnswers]: A list of correct answers for the question.
  ///   - [allAnswers]: A list of all possible answers for the question.
  ///   - [explanation]: An optional explanation for the question.
  ///   - [pointsEarned]: The points earned for this answer.
  ///   - [possiblePoints]: The maximum possible points for this answer.
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

  /// Creates a [QuizAnswer] object from a JSON map.
  ///
  /// This factory constructor is used to deserialize a [QuizAnswer] object
  /// from a JSON map.
  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}
