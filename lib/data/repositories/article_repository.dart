import 'package:brain_bench/data/models/home/article.dart';

/// An abstract class representing an article repository.
abstract class ArticleRepository {
  /// Retrieves a list of articles.
  Future<List<Article>> getArticles();

  /// Retrieves an article by its ID.
  /// Returns `null` if no article is found with the given ID.
  Future<Article?> getArticleById(String id);

  /// Saves an article.
  Future<void> saveArticle(Article article);
}
