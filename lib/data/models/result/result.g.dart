// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResultImpl _$$ResultImplFromJson(Map<String, dynamic> json) => _$ResultImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      topicId: json['topicId'] as String,
      categoryId: json['categoryId'] as String,
      correct: (json['correct'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      isPassed: json['isPassed'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      quizAnswers: (json['quizAnswers'] as List<dynamic>)
          .map((e) => QuizAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ResultImplToJson(_$ResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'topicId': instance.topicId,
      'categoryId': instance.categoryId,
      'correct': instance.correct,
      'total': instance.total,
      'score': instance.score,
      'isPassed': instance.isPassed,
      'timestamp': instance.timestamp.toIso8601String(),
      'quizAnswers': instance.quizAnswers,
    };
