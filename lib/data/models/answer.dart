import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer with _$Answer {
  factory Answer({
    required String id,
    required String text,
    required bool isCorrect,
    @Default(false) bool isSelected,
  }) = _Answer;

  factory Answer.create({
    required String text,
    required bool isCorrect,
  }) {
    return Answer(
      id: const Uuid().v4(),
      text: text,
      isCorrect: isCorrect,
    );
  }

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
