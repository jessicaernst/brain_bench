import 'package:brain_bench/data/infrastructure/database_repository_providers.dart';
import 'package:brain_bench/data/models/home/article.dart';
import 'package:brain_bench/data/repositories/article_firebase_repository_impl.dart';
import 'package:brain_bench/data/repositories/article_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'article_providers.g.dart';

/// Returns an instance of [ArticleRepository] using [ArticleFirebaseRepositoryImpl].
@Riverpod(keepAlive: true)
ArticleRepository articleRepository(Ref ref) {
  // The ArticleFirebaseRepositoryImpl now takes FirebaseFirestore instance.
  // We get this instance from the firestoreProvider.
  return ArticleFirebaseRepositoryImpl(firestore: ref.watch(firestoreProvider));
}

/// Retrieves a list of articles from the [ArticleRepository].
/// Returns a [Future] that resolves to a list of [Article] objects.
@Riverpod()
Future<List<Article>> articles(Ref ref) async {
  final repo = ref.watch(articleRepositoryProvider);
  return repo.getArticles();
}

/// Retrieves an article by its [id] from the [ArticleRepository].
/// Returns a [Future] that resolves to an [Article] object, or `null` if no article is found.
@Riverpod()
Future<Article?> articleById(Ref ref, String id) async {
  final repo = ref.watch(articleRepositoryProvider);
  return repo.getArticleById(id);
}

/// Provides a shuffled list of articles.
///
/// This provider depends on [articlesProvider] and shuffles the list *once*.
@Riverpod(keepAlive: true)
Future<List<Article>> shuffledArticles(Ref ref) async {
  final articlesData = await ref.watch(articlesProvider.future);
  final shuffledList = List<Article>.from(articlesData)..shuffle();
  return shuffledList;
}
