// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      titleEn: json['titleEn'] as String,
      titleDe: json['titleDe'] as String?,
      descriptionEn: json['descriptionEn'] as String,
      descriptionDe: json['descriptionDe'] as String?,
      imageUrl: json['imageUrl'] as String,
      htmlContentEn: json['htmlContentEn'] as String,
      htmlContentDe: json['htmlContentDe'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'titleEn': instance.titleEn,
      'titleDe': instance.titleDe,
      'descriptionEn': instance.descriptionEn,
      'descriptionDe': instance.descriptionDe,
      'imageUrl': instance.imageUrl,
      'htmlContentEn': instance.htmlContentEn,
      'htmlContentDe': instance.htmlContentDe,
      'createdAt': instance.createdAt.toIso8601String(),
    };
