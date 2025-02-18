// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      givenAnswers: (json['givenAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswers: (json['correctAnswers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'givenAnswers': instance.givenAnswers,
      'correctAnswers': instance.correctAnswers,
    };
