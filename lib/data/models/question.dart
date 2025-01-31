import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'answer.dart';

part 'question.freezed.dart';
part 'question.g.dart';

enum QuestionType { singleChoice, multipleChoice }

@freezed
class Question with _$Question {
  factory Question({
    required String id,
    required String topicId,
    required String questionEn,
    required String questionDe,
    required QuestionType type,
    required List<Answer> answers,
    String? explanationEn,
    String? explanationDe,
  }) = _Question;

  factory Question.create({
    required String topicId,
    required String questionEn,
    required String questionDe,
    required QuestionType type,
    required List<Answer> answers,
    String? explanationEn,
    String? explanationDe,
  }) {
    return Question(
      id: const Uuid().v4(),
      topicId: topicId,
      questionEn: questionEn,
      questionDe: questionDe,
      type: type,
      answers: answers,
      explanationEn: explanationEn,
      explanationDe: explanationDe,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
