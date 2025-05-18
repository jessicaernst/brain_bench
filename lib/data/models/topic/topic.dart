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
  factory Topic({
    required String id,
    required String nameEn,
    String? nameDe,
    required String descriptionEn,
    String? descriptionDe,
    required String categoryId,
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
    required String nameEn,
    String? nameDe,
    required String descriptionEn,
    String? descriptionDe,
    required String categoryId,
  }) {
    return Topic(
      id: const Uuid().v4(),
      nameEn: nameEn,
      nameDe: nameDe,
      descriptionEn: descriptionEn,
      descriptionDe: descriptionDe,
      categoryId: categoryId,
    );
  }

  /// Creates a [Topic] object from a JSON map.
  ///
  /// This factory constructor is used to deserialize a [Topic] object from a
  /// JSON map.
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
