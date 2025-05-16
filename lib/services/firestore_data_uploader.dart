import 'package:brain_bench/data/infrastructure/database_repository_providers.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_mock_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_data_uploader.g.dart';

// Der Mock-User-ID aus dem QuizMockDatabaseRepository, falls wir ihn hier brauchen
// oder um konsistent zu sein, falls Results spezifisch für diesen User geladen werden.
const String _mockUserIdForResultsUpload = 'mock-user-1234';

@riverpod
FirestoreDataUploader firestoreDataUploader(Ref ref) {
  // Dieser Provider ist abhängig vom 'firestoreProvider',
  // der die FirebaseFirestore-Instanz bereitstellt.
  // Stelle sicher, dass 'firestoreProvider' korrekt importiert und verfügbar ist.
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
  ) async {
    _logger.info('Starte Daten-Upload zu Firestore...');

    try {
      // Stelle sicher, dass die JSON-Dateien im Dokumentenverzeichnis vorhanden sind
      _logger.info('Kopiere Asset-Dateien in das Dokumentenverzeichnis...');
      await mockDbRepo.copyAssetsToDocuments();
      _logger.info('Asset-Dateien erfolgreich kopiert.');

      // 0. Benutzer hochladen
      _logger.info('Lade Benutzer...');
      final List<AppUser> users = await userRepo.getAllUsers();
      if (users.isNotEmpty) {
        final WriteBatch userBatch = _firestore.batch();
        for (final user in users) {
          final userDocRef = _firestore.collection('users').doc(user.uid);
          userBatch.set(userDocRef, user.toJson());
        }
        await userBatch.commit();
        _logger.info('${users.length} Benutzer erfolgreich hochgeladen.');
      } else {
        _logger.info('Keine Benutzer zum Hochladen gefunden.');
      }

      // 1. Kategorien hochladen
      _logger.info('Lade Kategorien...');
      final List<Category> categories = await mockDbRepo.getCategories();
      final WriteBatch categoryBatch = _firestore.batch();
      for (final category in categories) {
        final catDocRef = _firestore.collection('categories').doc(category.id);
        categoryBatch.set(catDocRef, category.toJson());
      }
      await categoryBatch.commit();
      _logger.info('${categories.length} Kategorien erfolgreich hochgeladen.');

      // 2. Themen hochladen
      _logger.info('Lade Themen...');
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
      _logger.info('${allTopics.length} Themen erfolgreich hochgeladen.');

      // 3. Fragen und Antworten hochladen
      _logger.info('Lade Fragen und Antworten...');
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
      _logger.info('${allQuestions.length} Fragen erfolgreich hochgeladen.');

      if (allAnswerIds.isNotEmpty) {
        _logger.info('Lade ${allAnswerIds.length} eindeutige Antworten...');
        final List<Answer> allAnswers = await mockDbRepo.getAnswers(
          allAnswerIds.toList(),
        );
        final WriteBatch answerBatch = _firestore.batch();
        for (final answer in allAnswers) {
          final ansDocRef = _firestore.collection('answers').doc(answer.id);
          answerBatch.set(ansDocRef, answer.toJson());
        }
        await answerBatch.commit();
        _logger.info('${allAnswers.length} Antworten erfolgreich hochgeladen.');
      } else {
        _logger.info('Keine Antworten zum Hochladen gefunden.');
      }

      // 4. Ergebnisse (Results) hochladen
      _logger.info('Lade Ergebnisse (Results)...');
      final List<Result> results = await mockDbRepo.getResults(
        _mockUserIdForResultsUpload,
      );
      if (results.isNotEmpty) {
        final WriteBatch resultBatch = _firestore.batch();
        for (final result in results) {
          // Firestore generiert eine ID für jedes Ergebnis, da Results typischerweise keine vordefinierte ID haben
          final resultDocRef = _firestore.collection('results').doc();
          resultBatch.set(resultDocRef, result.toJson());
        }
        await resultBatch.commit();
        _logger.info('${results.length} Ergebnisse erfolgreich hochgeladen.');
      } else {
        _logger.info('Keine Ergebnisse zum Hochladen gefunden.');
      }

      _logger.info('Firestore Daten-Upload erfolgreich abgeschlossen!');
    } catch (e, s) {
      _logger.severe('Fehler beim Hochladen der Daten zu Firestore.', e, s);
      rethrow; // Wirf den Fehler weiter, damit die UI ihn behandeln kann
    }
  }
}
