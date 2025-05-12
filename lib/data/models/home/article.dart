import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required String id,
    required String categoryId,
    required String titleEn,
    String? titleDe,
    required String descriptionEn,
    String? descriptionDe,
    required String imageUrl,
    required String htmlContentEn,
    String? htmlContentDe,
    required DateTime createdAt,
  }) = _Article;

  factory Article.create({
    required String categoryId,
    required String titleEn,
    String? titleDe,
    required String descriptionEn,
    String? descriptionDe,
    required String imageUrl,
    required String htmlContentEn,
    String? htmlContentDe,
  }) => Article(
    id: const Uuid().v4(),
    categoryId: categoryId,
    titleEn: titleEn,
    titleDe: titleDe,
    descriptionEn: descriptionEn,
    descriptionDe: descriptionDe,
    imageUrl: imageUrl,
    htmlContentEn: htmlContentEn,
    htmlContentDe: htmlContentDe,
    createdAt: DateTime.now(),
  );

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
