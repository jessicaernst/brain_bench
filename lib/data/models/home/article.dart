import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required String id,
    required String categoryId,
    required String title,
    required String description,
    required String imageUrl,
    required String htmlContent,
    required DateTime createdAt,
  }) = _Article;

  factory Article.create({
    required String categoryId,
    required String title,
    required String description,
    required String imageUrl,
    required String htmlContent,
  }) => Article(
    id: const Uuid().v4(),
    categoryId: categoryId,
    title: title,
    description: description,
    imageUrl: imageUrl,
    htmlContent: htmlContent,
    createdAt: DateTime.now(),
  );

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
