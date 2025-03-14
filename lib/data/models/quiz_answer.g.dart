// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      categoryId: json['categoryId'] as String,
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      givenAnswers: (json['givenAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswers: (json['correctAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      incorrectAnswers: (json['incorrectAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allAnswers: (json['allAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'categoryId': instance.categoryId,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'givenAnswers': instance.givenAnswers,
      'correctAnswers': instance.correctAnswers,
      'incorrectAnswers': instance.incorrectAnswers,
      'allAnswers': instance.allAnswers,
      'explanation': instance.explanation,
    };
