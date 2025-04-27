import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'question.freezed.dart';
part 'question.g.dart';

enum QuestionType { singleChoice, multipleChoice }

@freezed
class Question with _$Question {
  factory Question({
    required String id,
    required String topicId,
    required String question,
    required QuestionType type,
    required List<String> answerIds,
    String? explanation,
  }) = _Question;

  factory Question.create({
    required String topicId,
    required String question,
    required QuestionType type,
    required List<String> answerIds,
    String? explanation,
  }) {
    return Question(
      id: const Uuid().v4(),
      topicId: topicId,
      question: question,
      type: type,
      answerIds: answerIds,
      explanation: explanation,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
