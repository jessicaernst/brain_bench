import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

/// Represents a topic within a category.
///
/// This class contains information about a topic, such as its ID, name,
/// description, the category it belongs to, its progress, and whether it is
/// marked as done.
@freezed
class Topic with _$Topic {
  /// Creates a [Topic] object.
  ///
  /// Parameters:
  ///   - [id]: The unique ID of the topic.
  ///   - [name]: The name of the topic.
  ///   - [description]: The description of the topic.
  ///   - [categoryId]: The ID of the category the topic belongs to.
  ///   - [progress]: The progress of the topic (a value between 0.0 and 1.0).
  ///   - [isDone]: Whether the topic is marked as done.
  factory Topic({
    required String id,
    required String name,
    required String description,
    required String categoryId,
    @Default(0.0) double progress,
    @Default(false) bool isDone,
  }) = _Topic;

  /// Creates a [Topic] object with a new unique ID.
  ///
  /// This factory constructor is used to create a new [Topic] object.
  /// It automatically generates a unique ID using [Uuid].
  ///
  /// Parameters:
  ///   - [name]: The name of the topic.
  ///   - [description]: The description of the topic.
  ///   - [categoryId]: The ID of the category the topic belongs to.
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

  /// Creates a [Topic] object from a JSON map.
  ///
  /// This factory constructor is used to deserialize a [Topic] object from a
  /// JSON map.
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
