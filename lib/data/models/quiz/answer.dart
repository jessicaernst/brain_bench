import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer with _$Answer {
  const factory Answer({
    required String id,
    required String textEn,
    required String textDe,
    required bool isCorrect,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isSelected,
  }) = _Answer;

  /// Factory for creating a new Answer with a random UUID (for client-side creation).
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

  /// Factory for creating an Answer from JSON.
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
