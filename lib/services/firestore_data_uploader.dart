import 'package:brain_bench/data/infrastructure/database_repository_providers.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/home/article.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/article_repository.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_mock_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_data_uploader.g.dart';

// The mock user ID from QuizMockDatabaseRepository, in case we need it here
// or to be consistent if results are loaded specifically for this user.
const String _mockUserIdForResultsUpload = 'mock-user-1234';

@riverpod
FirestoreDataUploader firestoreDataUploader(Ref ref) {
  // This provider depends on 'firestoreProvider',
  // which provides the FirebaseFirestore instance.
  // Ensure 'firestoreProvider' is correctly imported and available.
  final firestore = ref.watch(firestoreProvider);
  return FirestoreDataUploader(firestore: firestore);
}

class FirestoreDataUploader {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('FirestoreDataUploader');

  FirestoreDataUploader({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<void> uploadAllDataToFirestore(
    QuizMockDatabaseRepository mockDbRepo,
    UserMockRepositoryImpl userRepo,
    ArticleRepository articleMockRepo,
  ) async {
    _logger.info('Starting data upload to Firestore...');

    try {
      // Ensure JSON files are present in the documents directory
      _logger.info('Copying asset files to the documents directory...');
      await mockDbRepo.copyAssetsToDocuments();
      _logger.info('Asset files copied successfully.');

      // 0. Upload users
      _logger.info('Uploading users...');
      final List<AppUser> users = await userRepo.getAllUsers();
      if (users.isNotEmpty) {
        final WriteBatch userBatch = _firestore.batch();
        for (final user in users) {
          final userDocRef = _firestore.collection('users').doc(user.uid);
          userBatch.set(userDocRef, user.toJson());
        }
        await userBatch.commit();
        _logger.info('${users.length} users uploaded successfully.');
      } else {
        _logger.info('No users found to upload.');
      }

      // 1. Upload categories
      _logger.info('Uploading categories...');
      final List<Category> categories = await mockDbRepo.getCategories();
      final WriteBatch categoryBatch = _firestore.batch();
      for (final category in categories) {
        final catDocRef = _firestore.collection('categories').doc(category.id);
        categoryBatch.set(catDocRef, category.toJson());
      }
      await categoryBatch.commit();
      _logger.info('${categories.length} categories uploaded successfully.');

      // 2. Upload topics
      _logger.info('Uploading topics...');
      final List<Topic> allTopics = [];
      for (final category in categories) {
        final List<Topic> topics = await mockDbRepo.getTopics(category.id);
        allTopics.addAll(topics);
      }
      final WriteBatch topicBatch = _firestore.batch();
      for (final topic in allTopics) {
        final topicDocRef = _firestore.collection('topics').doc(topic.id);
        topicBatch.set(topicDocRef, topic.toJson());
      }
      await topicBatch.commit();
      _logger.info('${allTopics.length} topics uploaded successfully.');

      // 3. Upload questions and answers
      _logger.info('Uploading questions and answers...');
      final List<Question> allQuestions = [];
      final Set<String> allAnswerIds = {};

      for (final topic in allTopics) {
        final List<Question> questions = await mockDbRepo.getQuestions(
          topic.id,
        );
        allQuestions.addAll(questions);
        for (final question in questions) {
          allAnswerIds.addAll(question.answerIds);
        }
      }

      final WriteBatch questionBatch = _firestore.batch();
      for (final question in allQuestions) {
        final qDocRef = _firestore.collection('questions').doc(question.id);
        questionBatch.set(qDocRef, question.toJson());
      }
      await questionBatch.commit();
      _logger.info('${allQuestions.length} questions uploaded successfully.');

      if (allAnswerIds.isNotEmpty) {
        _logger.info('Uploading ${allAnswerIds.length} unique answers...');
        final List<Answer> allAnswers = await mockDbRepo.getAnswers(
          allAnswerIds.toList(),
        );
        final WriteBatch answerBatch = _firestore.batch();
        for (final answer in allAnswers) {
          final ansDocRef = _firestore.collection('answers').doc(answer.id);
          answerBatch.set(ansDocRef, answer.toJson());
        }
        await answerBatch.commit();
        _logger.info('${allAnswers.length} answers uploaded successfully.');
      } else {
        _logger.info('No answers found to upload.');
      }

      // 4. Upload results
      _logger.info('Uploading results...');
      final List<Result> results = await mockDbRepo.getResults(
        _mockUserIdForResultsUpload,
      );
      if (results.isNotEmpty) {
        final WriteBatch resultBatch = _firestore.batch();
        for (final result in results) {
          // Firestore generates an ID for each result, as results typically don't have a predefined ID
          final resultDocRef = _firestore.collection('results').doc();
          resultBatch.set(resultDocRef, result.toJson());
        }
        await resultBatch.commit();
        _logger.info('${results.length} results uploaded successfully.');
      } else {
        _logger.info('No results found to upload.');
      }

      // 5. Upload articles
      _logger.info('Uploading articles...');
      final List<Article> articles = await articleMockRepo.getArticles();
      if (articles.isNotEmpty) {
        final WriteBatch articleBatch = _firestore.batch();
        for (final article in articles) {
          final articleDocRef = _firestore
              .collection('articles')
              .doc(article.id);
          articleBatch.set(articleDocRef, article.toJson());
        }
        await articleBatch.commit();
        _logger.info('${articles.length} articles uploaded successfully.');
      } else {
        _logger.info('No articles found to upload.');
      }

      _logger.info('Firestore data upload completed successfully!');
    } catch (e, s) {
      _logger.severe('Error uploading data to Firestore.', e, s);
      rethrow; // Rethrow the error so the UI can handle it
    }
  }

  /// Uploads only the articles from the provided [articleMockRepo] to Firestore.
  ///
  /// This is useful when only the article data needs to be updated or initially uploaded,
  /// without affecting other datasets.
  Future<void> uploadArticlesToFirestore(
    ArticleRepository articleMockRepo,
  ) async {
    _logger.info('Starting article upload to Firestore...');
    try {
      // Upload articles
      _logger.info('Uploading articles...');
      final List<Article> articles = await articleMockRepo.getArticles();
      if (articles.isNotEmpty) {
        final WriteBatch articleBatch = _firestore.batch();
        for (final article in articles) {
          final articleDocRef = _firestore
              .collection('articles')
              .doc(article.id);
          articleBatch.set(articleDocRef, article.toJson());
        }
        await articleBatch.commit();
        _logger.info('${articles.length} articles uploaded successfully.');
      } else {
        _logger.info('No articles found to upload.');
      }
      _logger.info('Article upload completed successfully!');
    } catch (e, s) {
      _logger.severe('Error uploading articles to Firestore.', e, s);
      rethrow;
    }
  }
}
