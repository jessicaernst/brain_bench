import 'dart:convert';
import 'dart:io';

import 'package:brain_bench/data/models/home/article.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';

import 'article_repository.dart';

final _logger = Logger('ArticleMockRepositoryImpl');

/// Default asset path for the source articles JSON file.
const String _kDefaultArticlesAssetPath = 'lib/data/data_source/articles.json';

/// Implementation of the [ArticleRepository] using mock data.
/// This repository copies an initial set of articles from the app's assets
/// to the device's documents directory and then operates on that copy.
class ArticleMockRepositoryImpl implements ArticleRepository {
  /// Creates an instance of [ArticleMockRepositoryImpl].
  ///
  /// [articlesDocumentPath] is the path in the device's documents directory
  /// where the articles JSON file will be stored and managed.
  /// [articlesAssetPath] is the path to the source JSON file in the app's assets,
  /// used for the initial copy.
  ArticleMockRepositoryImpl({
    required this.articlesDocumentPath,
    this.articlesAssetPath = _kDefaultArticlesAssetPath,
  });

  /// The path to the articles JSON file in the device's documents directory.
  final String articlesDocumentPath;

  /// The path to the source articles JSON file in the app's assets.
  final String articlesAssetPath;

  Future<void> _ensureArticlesFileExists() async {
    final file = File(articlesDocumentPath);
    if (!await file.exists()) {
      _logger.info(
        'Artikeldatei nicht im Dokumentenverzeichnis unter $articlesDocumentPath gefunden. '
        'Kopiere von Asset: $articlesAssetPath',
      );
      final byteData = await rootBundle.load(articlesAssetPath);
      final bytes = byteData.buffer.asUint8List();
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      _logger.info(
        'Artikel-Asset erfolgreich nach $articlesDocumentPath kopiert.',
      );
    }
  }

  @override
  Future<List<Article>> getArticles() async {
    try {
      await _ensureArticlesFileExists();
      final file = File(articlesDocumentPath);
      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString);
      final List<dynamic> jsonList = jsonMap['articles'];
      return jsonList.map((e) => Article.fromJson(e)).toList();
    } catch (e) {
      _logger.severe('Fehler beim Laden der Artikel: $e');
      return [];
    }
  }

  @override
  Future<Article?> getArticleById(String id) async {
    final all = await getArticles();
    return all.firstWhereOrNull((e) => e.id == id);
  }

  @override
  Future<void> saveArticle(Article article) async {
    try {
      await _ensureArticlesFileExists();
      final file = File(articlesDocumentPath);
      Map<String, dynamic> jsonMap = {'articles': []};

      if (await file.exists()) {
        // Should exist after _ensureArticlesFileExists
        final content = await file.readAsString();
        jsonMap = json.decode(content);
      }

      final List articles = jsonMap['articles'];
      articles.removeWhere((e) => e['id'] == article.id);
      articles.add(article.toJson());

      await file.writeAsString(jsonEncode(jsonMap), flush: true);
    } catch (e) {
      _logger.severe('Fehler beim Speichern des Artikels: $e');
    }
  }
}
