// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      categoryProgress:
          (json['categoryProgress'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      isTopicDone: (json['isTopicDone'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, bool>.from(e as Map)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'profileImageUrl': instance.profileImageUrl,
      'themeMode': instance.themeMode,
      'language': instance.language,
      'categoryProgress': instance.categoryProgress,
      'isTopicDone': instance.isTopicDone,
    };
