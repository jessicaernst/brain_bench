import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:brain_bench/data/models/quiz_answer.dart'; // Importiere QuizAnswer

part 'result.freezed.dart';
part 'result.g.dart';

/// Represents the result of a quiz taken by a user.
///
/// This class contains information about the quiz, such as the user's ID,
/// the topic and category of the quiz, the number of correct answers, the
/// total number of questions, the score, the timestamp, and a list of
/// [QuizAnswer] objects.
@freezed
class Result with _$Result {
  /// Creates a [Result] object.
  ///
  /// Parameters:
  ///   - [id]: The unique ID of the result.
  ///   - [userId]: The ID of the user who took the quiz.
  ///   - [topicId]: The ID of the topic the quiz belongs to.
  ///   - [categoryId]: The ID of the category the quiz belongs to.
  ///   - [correct]: The number of correct answers.
  ///   - [total]: The total number of questions in the quiz.
  ///   - [score]: The score achieved in the quiz (as a percentage).
  ///   - [timestamp]: The timestamp when the quiz was completed.
  ///   - [quizAnswers]: A list of [QuizAnswer] objects representing the answers given in the quiz.
  factory Result({
    required String id,
    required String userId,
    required String topicId,
    required String categoryId,
    required int correct,
    required int total,
    required double score,
    required DateTime timestamp,
    required List<QuizAnswer> quizAnswers,
  }) = _Result;

  /// Creates a [Result] object with a new unique ID and the current timestamp.
  ///
  /// This factory constructor is used to create a new [Result] object when a
  /// quiz is completed. It automatically generates a unique ID using [Uuid]
  /// and sets the timestamp to the current time.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user who took the quiz.
  ///   - [topicId]: The ID of the topic the quiz belongs to.
  ///   - [categoryId]: The ID of the category the quiz belongs to.
  ///   - [correct]: The number of correct answers.
  ///   - [total]: The total number of questions in the quiz.
  ///   - [score]: The score achieved in the quiz (as a percentage).
  ///   - [quizAnswers]: A list of [QuizAnswer] objects representing the answers given in the quiz.
  factory Result.create({
    required String userId,
    required String topicId,
    required String categoryId,
    required int correct,
    required int total,
    required double score,
    required List<QuizAnswer> quizAnswers,
  }) {
    return Result(
      id: const Uuid().v4(),
      userId: userId,
      topicId: topicId,
      categoryId: categoryId,
      correct: correct,
      total: total,
      score: score,
      timestamp: DateTime.now(),
      quizAnswers: quizAnswers,
    );
  }

  /// Creates a [Result] object from a JSON map.
  ///
  /// This factory constructor is used to deserialize a [Result] object from a
  /// JSON map.
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
