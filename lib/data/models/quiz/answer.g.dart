// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
  id: json['id'] as String,
  textEn: json['textEn'] as String,
  textDe: json['textDe'] as String,
  isCorrect: json['isCorrect'] as bool,
);

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textEn': instance.textEn,
      'textDe': instance.textDe,
      'isCorrect': instance.isCorrect,
    };
