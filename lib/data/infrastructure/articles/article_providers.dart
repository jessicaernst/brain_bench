import 'package:brain_bench/data/models/home/article.dart';
import 'package:brain_bench/data/repositories/article_mock_repository_impl.dart';
import 'package:brain_bench/data/repositories/article_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'article_providers.g.dart';

/// Returns an instance of [ArticleRepository] using [ArticleMockRepositoryImpl] as the implementation.
/// The [ArticleMockRepositoryImpl] is initialized with the path to the articles JSON file
/// in the documents directory, after potentially copying it from assets.
@Riverpod(keepAlive: true)
Future<ArticleRepository> articleRepository(Ref ref) async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  // Define a specific filename for the articles in the documents directory
  final articlesDocumentPath =
      '${documentsDirectory.path}/articles_local_copy.json';

  // The asset path is 'lib/data/data_source/articles.json' by default in ArticleMockRepositoryImpl
  // or can be overridden here if needed.
  final repository = ArticleMockRepositoryImpl(
    articlesDocumentPath: articlesDocumentPath,
  );

  // The _ensureArticlesFileExists method in the repository will handle the copy
  // when getArticles or saveArticle is first called.
  return repository;
}

/// Retrieves a list of articles from the [ArticleRepository].
/// Returns a [Future] that resolves to a list of [Article] objects.
@Riverpod()
Future<List<Article>> articles(Ref ref) async {
  final repo = await ref.watch(articleRepositoryProvider.future);
  return repo.getArticles();
}

/// Retrieves an article by its [id] from the [ArticleRepository].
/// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
@Riverpod()
Future<Article?> articleById(Ref ref, String id) async {
  final repo = await ref.watch(articleRepositoryProvider.future);
  return repo.getArticleById(id);
}

/// Provides a shuffled list of articles.
///
/// This provider depends on [articlesProvider] and shuffles the list *once*.
@Riverpod(keepAlive: true)
Future<List<Article>> shuffledArticles(Ref ref) async {
  final articles = await ref.watch(articlesProvider.future);
  final shuffledList = List<Article>.from(articles)..shuffle();
  return shuffledList;
}
