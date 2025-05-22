import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizFirebaseRepository');

class QuizFirebaseRepositoryImpl implements DatabaseRepository {
  final FirebaseFirestore _firestore;

  QuizFirebaseRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Collection getters with converters
  CollectionReference<Category> get _categoriesCollection => _firestore
      .collection('categories')
      .withConverter<Category>(
        fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
        toFirestore: (category, _) => category.toJson(),
      );

  CollectionReference<Topic> get _topicsCollection => _firestore
      .collection('topics')
      .withConverter<Topic>(
        fromFirestore: (snapshot, _) => Topic.fromJson(snapshot.data()!),
        toFirestore: (topic, _) => topic.toJson(),
      );

  CollectionReference<Question> get _questionsCollection => _firestore
      .collection('questions')
      .withConverter<Question>(
        fromFirestore: (snapshot, _) => Question.fromJson(snapshot.data()!),
        toFirestore: (question, _) => question.toJson(),
      );

  CollectionReference<Answer> get _answersCollection => _firestore
      .collection('answers')
      .withConverter<Answer>(
        fromFirestore: (snapshot, _) => Answer.fromJson(snapshot.data()!),
        toFirestore: (answer, _) => answer.toJson(),
      );

  CollectionReference<Result> get _resultsCollection => _firestore
      .collection('results')
      .withConverter<Result>(
        fromFirestore: (snapshot, _) => Result.fromJson(snapshot.data()!),
        toFirestore: (result, _) => result.toJson(),
      );

  @override
  Future<List<Category>> getCategories() async {
    try {
      final querySnapshot = await _categoriesCollection.get();
      final categories = querySnapshot.docs.map((doc) => doc.data()).toList();
      _logger.fine('getCategories: Found ${categories.length} categories.');
      return categories;
    } catch (e, stack) {
      _logger.severe('Error in getCategories: $e', e, stack);
      // Rethrow the exception to allow the caller to handle it.
      rethrow;
    }
  }

  @override
  Future<List<Topic>> getTopics(String categoryId) async {
    try {
      final querySnapshot =
          await _topicsCollection
              .where('categoryId', isEqualTo: categoryId)
              .get();
      final topics = querySnapshot.docs.map((doc) => doc.data()).toList();
      _logger.fine('getTopics: Found ${topics.length} topics for $categoryId.');
      return topics;
    } catch (e, stack) {
      _logger.severe('Error in getTopics for $categoryId: $e', e, stack);
      // Rethrow the exception.
      rethrow;
    }
  }

  @override
  Future<List<Question>> getQuestions(String topicId) async {
    try {
      final querySnapshot =
          await _questionsCollection.where('topicId', isEqualTo: topicId).get();
      final questions = querySnapshot.docs.map((doc) => doc.data()).toList();
      _logger.fine(
        'getQuestions: Found ${questions.length} questions for $topicId.',
      );
      return questions;
    } catch (e, stack) {
      _logger.severe('Error in getQuestions for $topicId: $e', e, stack);
      // Rethrow the exception.
      rethrow;
    }
  }

  @override
  Future<List<Answer>> getAnswers(List<String> answerIds) async {
    if (answerIds.isEmpty) {
      return [];
    }
    try {
      final List<Answer> allAnswers = [];
      final List<List<String>> chunks = [];
      for (var i = 0; i < answerIds.length; i += 30) {
        chunks.add(
          answerIds.sublist(
            i,
            i + 30 > answerIds.length ? answerIds.length : i + 30,
          ),
        );
      }

      for (final chunk in chunks) {
        if (chunk.isNotEmpty) {
          final querySnapshot =
              await _answersCollection
                  .where(FieldPath.documentId, whereIn: chunk)
                  .get();
          allAnswers.addAll(querySnapshot.docs.map((doc) => doc.data()));
        }
      }
      _logger.fine(
        'getAnswers: Found ${allAnswers.length} answers for ${answerIds.length} IDs (batched).',
      );
      return allAnswers;
    } catch (e, stack) {
      _logger.severe('Error in getAnswers: $e', e, stack);
      // Rethrow the exception.
      rethrow;
    }
  }

  @override
  Future<List<Result>> getResults(String userId) async {
    try {
      final querySnapshot =
          await _resultsCollection.where('userId', isEqualTo: userId).get();
      final results = querySnapshot.docs.map((doc) => doc.data()).toList();
      _logger.fine('getResults: Found ${results.length} results for $userId.');
      return results;
    } catch (e, stack) {
      _logger.severe('Error in getResults for $userId: $e', e, stack);
      // Rethrow the exception.
      rethrow;
    }
  }

  @override
  Future<void> saveResult(Result result) async {
    try {
      // Firestore will auto-generate an ID for the new document.
      await _resultsCollection.add(result);
      _logger.info(
        '💾 Result saved for user ${result.userId} on topic ${result.topicId}.',
      );
    } catch (e, stack) {
      _logger.severe('Error in saveResult: $e', e, stack);
      // Rethrow the exception.
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    try {
      await _categoriesCollection.doc(category.id).set(category);
      _logger.info('✅ Category ${category.id} updated.');
    } catch (e, stack) {
      _logger.severe(
        'Error in updateCategory for ${category.id}: $e',
        e,
        stack,
      );
      // Rethrow the exception.
      rethrow;
    }
  }
}
