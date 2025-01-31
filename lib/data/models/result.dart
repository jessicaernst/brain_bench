import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'result.freezed.dart';
part 'result.g.dart';

@freezed
class Result with _$Result {
  factory Result({
    required String id,
    required String userId,
    required String topicId,
    required int correct,
    required int total,
    required double score,
    required DateTime timestamp,
  }) = _Result;

  factory Result.create({
    required String userId,
    required String topicId,
    required int correct,
    required int total,
    required double score,
  }) {
    return Result(
      id: const Uuid().v4(),
      userId: userId,
      topicId: topicId,
      correct: correct,
      total: total,
      score: score,
      timestamp: DateTime.now(),
    );
  }

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
