// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicImpl _$$TopicImplFromJson(Map<String, dynamic> json) => _$TopicImpl(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameDe: json['nameDe'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionDe: json['descriptionDe'] as String,
      categoryId: json['categoryId'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TopicImplToJson(_$TopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameEn': instance.nameEn,
      'nameDe': instance.nameDe,
      'descriptionEn': instance.descriptionEn,
      'descriptionDe': instance.descriptionDe,
      'categoryId': instance.categoryId,
      'progress': instance.progress,
    };
