// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      questionEn: json['questionEn'] as String,
      questionDe: json['questionDe'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanationEn: json['explanationEn'] as String?,
      explanationDe: json['explanationDe'] as String?,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'questionEn': instance.questionEn,
      'questionDe': instance.questionDe,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'answers': instance.answers,
      'explanationEn': instance.explanationEn,
      'explanationDe': instance.explanationDe,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.singleChoice: 'singleChoice',
  QuestionType.multipleChoice: 'multipleChoice',
};
