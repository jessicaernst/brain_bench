import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer with _$Answer {
  factory Answer({
    required String id,
    required String textEn,
    required String textDe,
    required bool isCorrect,
  }) = _Answer;

  factory Answer.create({
    required String textEn,
    required String textDe,
    required bool isCorrect,
  }) {
    return Answer(
      id: const Uuid().v4(),
      textEn: textEn,
      textDe: textDe,
      isCorrect: isCorrect,
    );
  }

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
