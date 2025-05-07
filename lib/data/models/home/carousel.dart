import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'carousel.freezed.dart';
part 'carousel.g.dart';

@freezed
class Carousel with _$Carousel {
  const factory Carousel({
    required String id,
    required String categoryId,
    required String title,
    required String description,
    required String imageUrl,
  }) = _Carousel;

  factory Carousel.create({
    required String categoryId,
    required String title,
    required String description,
    required String imageUrl,
  }) =>
      Carousel(
        id: const Uuid().v4(),
        categoryId: categoryId,
        title: title,
        description: description,
        imageUrl: imageUrl,
      );

  factory Carousel.fromJson(Map<String, dynamic> json) =>
      _$CarouselFromJson(json);
}
