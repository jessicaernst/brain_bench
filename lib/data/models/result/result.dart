import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'result.freezed.dart';
part 'result.g.dart';

@freezed
class Result with _$Result {
  @JsonSerializable(explicitToJson: true)
  const factory Result({
    required String id,
    required String userId,
    required String topicId,
    required String categoryId,
    required int correct,
    required int total,
    required double score,
    required bool isPassed,
    required DateTime timestamp,
    required List<QuizAnswer> quizAnswers,
  }) = _Result;

  factory Result.create({
    required String userId,
    required String topicId,
    required String categoryId,
    required int correct,
    required int total,
    required double score,
    required bool isPassed,
    required List<QuizAnswer> quizAnswers,
  }) => Result(
    id: const Uuid().v4(),
    userId: userId,
    topicId: topicId,
    categoryId: categoryId,
    correct: correct,
    total: total,
    score: score,
    isPassed: isPassed,
    timestamp: DateTime.now(),
    quizAnswers: quizAnswers,
  );

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
