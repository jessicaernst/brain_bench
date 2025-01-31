import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  factory Topic({
    required String id,
    required String name,
    required String description,
    required String categoryId,
    @Default(0.0) double progress,
  }) = _Topic;

  // Custom factory for generating a new Topic object with a unique ID.
  factory Topic.create({
    required String name,
    required String description,
    required String categoryId,
  }) {
    return Topic(
      id: const Uuid().v4(),
      name: name,
      description: description,
      categoryId: categoryId,
    );
  }

  // Custom factory for deserializing a JSON object into a Topic object.
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
