import 'package:brain_bench/data/models/home/article.dart';
import 'package:brain_bench/data/repositories/article_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ArticleFirebaseRepository');

class ArticleFirebaseRepositoryImpl implements ArticleRepository {
  final FirebaseFirestore _firestore;

  ArticleFirebaseRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Article> get _articlesCollection => _firestore
      .collection('articles')
      .withConverter<Article>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            _logger.warning(
              'Document ${snapshot.id} has null data in fromFirestore for Article.',
            );
            throw StateError(
              'Firestore document data is null for Article ${snapshot.id}',
            );
          }
          return Article.fromJson(data);
        },
        toFirestore: (article, _) => article.toJson(),
      );

  @override
  Future<List<Article>> getArticles() async {
    try {
      final querySnapshot = await _articlesCollection.get();
      final articles = querySnapshot.docs.map((doc) => doc.data()).toList();
      _logger.fine('getArticles: Found ${articles.length} articles.');
      return articles;
    } catch (e, stack) {
      _logger.severe('Error in getArticles: $e', e, stack);
      return [];
    }
  }

  @override
  Future<Article?> getArticleById(String id) async {
    try {
      final docSnapshot = await _articlesCollection.doc(id).get();
      if (docSnapshot.exists) {
        _logger.fine('Article found: $id');
        return docSnapshot.data();
      } else {
        _logger.fine('Article not found: $id');
        return null;
      }
    } catch (e, stack) {
      _logger.severe('Error in getArticleById for $id: $e', e, stack);
      return null;
    }
  }

  @override
  Future<void> saveArticle(Article article) async {
    try {
      // Using set() will overwrite the document if it exists, or create it if not.
      // This matches the behavior of the mock repository's saveArticle.
      await _articlesCollection.doc(article.id).set(article);
      _logger.info('📰 Article saved/updated: ${article.id}');
    } catch (e, stack) {
      _logger.severe('Error in saveArticle for ${article.id}: $e', e, stack);
    }
  }
}
