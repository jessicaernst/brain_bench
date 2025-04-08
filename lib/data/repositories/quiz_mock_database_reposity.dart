import 'dart:convert';
import 'dart:io';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter/services.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:logging/logging.dart';
import 'database_repository.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;

final Logger _logger = Logger('QuizMockDatabaseRepository');

/// A mock user ID used for all results in this mock database.
///
/// Since the User model does not exist in this application, this constant is
/// used to simulate a user ID for all results.
const String _mockUserId = 'mock-user-1234';

/// A mock implementation of the [DatabaseRepository] interface.
///
/// This class simulates a database by reading and writing data to JSON files.
/// It provides methods to retrieve categories, topics, questions, answers, and
/// results, as well as to save results and mark topics as done. It is intended
/// for development and testing purposes and should not be used in a production
/// environment.
class QuizMockDatabaseRepository implements DatabaseRepository {
  QuizMockDatabaseRepository({
    required this.resultsPath,
    required this.categoriesPath,
    required this.topicsPath,
    required this.questionsPath,
    required this.answersPath,
    required this.userPath,
  });

  /// The file path for the results data.
  final String resultsPath;

  /// The file path for the categories data.
  final String categoriesPath;

  /// The file path for the topics data.
  final String topicsPath;

  /// The file path for the questions data.
  final String questionsPath;

  /// The file path for the answers data.
  final String answersPath;

  final String userPath;

  /// Copies the JSON asset files from the app bundle to the documents directory.
  Future<void> copyAssetsToDocuments() async {
    await _copyAssetToDocument(
        'lib/data/data_source/results.json', resultsPath);
    await _copyAssetToDocument(
        'lib/data/data_source/category.json', categoriesPath);
    await _copyAssetToDocument('lib/data/data_source/topics.json', topicsPath);
    await _copyAssetToDocument(
        'lib/data/data_source/questions.json', questionsPath);
    await _copyAssetToDocument(
        'lib/data/data_source/answers.json', answersPath);
    await _copyAssetToDocument('lib/data/data_source/user.json', userPath);
  }

  /// Copies a single asset file to the documents directory.
  Future<void> _copyAssetToDocument(
      String assetPath, String documentPath) async {
    final file = File(documentPath);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
    }
  }

  /// Retrieves a list of [Category] objects from the mock database.
  ///
  /// This method reads the categories data from the `categories.json` file,
  /// decodes it, and returns a list of [Category] objects. It also simulates
  /// a network delay of 1 second.
  ///
  /// Parameters:
  ///   - [languageCode]: The language code to determine which language to use for the category names and descriptions.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Category] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Category>> getCategories(String languageCode) async {
    try {
      final file = File(categoriesPath); // ✅ Use File here
      final String jsonString =
          await file.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['categories'];

      await Future.delayed(const Duration(seconds: 1));

      return jsonData
          .map((e) => Category(
                id: e['id'],
                nameEn: e['nameEn'],
                nameDe: e['nameDe'],
                subtitleEn: e['subtitleEn'],
                subtitleDe: e['subtitleDe'],
                descriptionEn: e['descriptionEn'],
                descriptionDe: e['descriptionDe'],
              ))
          .toList();
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in getCategories: $e');
      return [];
    } on FormatException catch (e) {
      _logger.severe('FormatException in getCategories: $e');
      return [];
    } catch (e) {
      _logger.severe('Unexpected error in getCategories: $e');
      return [];
    }
  }

  /// Retrieves a list of [Topic] objects for a given category from the mock database.
  ///
  /// This method reads the topics data from the `topics.json` file, decodes it,
  /// filters the topics by the given [categoryId], and returns a list of
  /// [Topic] objects. It also simulates a network delay of 1 second.
  ///
  /// Parameters:
  ///   - [categoryId]: The ID of the category to retrieve topics for.
  ///   - [languageCode]: The language code to determine which language to use for the topic names and descriptions.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Topic] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Topic>> getTopics(String categoryId, String languageCode) async {
    try {
      final file = File(topicsPath); // ✅ Use File here
      final String jsonString =
          await file.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['topics'];

      await Future.delayed(const Duration(seconds: 1));

      return jsonData.where((e) => e['categoryId'] == categoryId).map((e) {
        return Topic(
          id: e['id'],
          nameEn: e['nameEn'], // ✅ Use nameEn
          nameDe: e['nameDe'], // ✅ Use nameDe
          descriptionEn: e['descriptionEn'], // ✅ Use descriptionEn
          descriptionDe: e['descriptionDe'], // ✅ Use descriptionDe
          categoryId: e['categoryId'],
          progress: (e['progress'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in getTopics: $e');
      return [];
    } on FormatException catch (e) {
      _logger.severe('FormatException in getTopics: $e');
      return [];
    } catch (e) {
      _logger.severe('Unexpected error in getTopics: $e');
      return [];
    }
  }

  /// Retrieves a list of [Question] objects for a given topic from the mock database.
  ///
  /// This method reads the questions data from the `questions.json` file and
  /// the answers data from the `answers.json` file, decodes them, filters the
  /// questions by the given [topicId], and returns a list of [Question]
  /// objects. It also simulates a network delay of 1 second.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to retrieve questions for.
  ///   - [languageCode]: The language code to determine which language to use for the question text and explanations.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Question] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Question>> getQuestions(
      String topicId, String languageCode) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final fileQuestion = File(questionsPath); // ✅ Use File here
      final String questionJsonString =
          await fileQuestion.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> questionJsonMap =
          json.decode(questionJsonString);
      final List<dynamic> questionJsonData = questionJsonMap['questions'];

      final fileAnswer = File(answersPath); // ✅ Use File here
      final String answerJsonString =
          await fileAnswer.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> answerJsonMap = json.decode(answerJsonString);
      final List<dynamic> answerJsonData = answerJsonMap['answers'];

      final Map<String, Answer> answersMap = {
        for (var e in answerJsonData)
          e['id']: Answer(
            id: e['id'],
            text: languageCode == 'de' ? e['textDe'] : e['textEn'],
            isCorrect: e['isCorrect'],
          ),
      };

      return questionJsonData.where((e) => e['topicId'] == topicId).map((e) {
        return Question(
          id: e['id'],
          topicId: e['topicId'],
          question: languageCode == 'de' ? e['questionDe'] : e['questionEn'],
          type: QuestionType.values.firstWhere(
            (type) => type.toString().split('.').last == e['type'],
          ),
          answers: (e['answerIds'] as List<dynamic>)
              .map((answerId) => answersMap[answerId]!)
              .toList(),
          explanation:
              languageCode == 'de' ? e['explanationDe'] : e['explanationEn'],
        );
      }).toList();
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in getQuestions: $e');
      return [];
    } on FormatException catch (e) {
      _logger.severe('FormatException in getQuestions: $e');
      return [];
    } catch (e) {
      _logger.severe('Unexpected error in getQuestions: $e');
      return [];
    }
  }

  /// Retrieves a list of [Answer] objects for given answer IDs from the mock database.
  ///
  /// This method reads the answers data from the `answers.json` file, decodes
  /// it, filters the answers by the given [answerIds], and returns a list of
  /// [Answer] objects. It also simulates a network delay of 1 second.
  ///
  /// Parameters:
  ///   - [answerIds]: A list of answer IDs to retrieve.
  ///   - [languageCode]: The language code to determine which language to use for the answer text.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Answer] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Answer>> getAnswers(
      List<String> answerIds, String languageCode) async {
    try {
      _logger.info('getAnswers() aufgerufen für: $answerIds');

      final file = File(answersPath); // ✅ Use File here
      final String jsonString =
          await file.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['answers'];

      await Future.delayed(const Duration(seconds: 1));

      _logger.info(
          'Geladene Antwortdaten: ${jsonData.length} Antworten gefunden.');

      final List<Answer> answers = jsonData
          .where((e) => answerIds.contains(e['id']))
          .map((e) => Answer(
                id: e['id'],
                text: languageCode == 'de' ? e['textDe'] : e['textEn'],
                isCorrect: e['isCorrect'],
              ))
          .toList();

      _logger.info(
          'Gefilterte Antworten: ${answers.length} von ${answerIds.length} IDs gefunden.');

      return answers;
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in getAnswers: $e');
      return [];
    } on FormatException catch (e) {
      _logger.severe('FormatException in getAnswers: $e');
      return [];
    } catch (e) {
      _logger.severe('Unexpected error in getAnswers: $e');
      return [];
    }
  }

  /// Retrieves a list of [Result] objects for a given user from the mock database.
  ///
  /// This method reads the results data from the `results.json` file, decodes
  /// it, filters the results by the given [userId], and returns a list of
  /// [Result] objects.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to retrieve results for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Result] objects.
  ///   Returns an empty list if an error occurs or the file does not exist.
  @override
  Future<List<Result>> getResults(String userId) async {
    try {
      // Load the JSON file
      final file = File(resultsPath); // ✅ Use File here

      // Check if the file exists, return an empty list if not
      if (!file.existsSync()) {
        _logger.warning('Results file does not exist.');
        return [];
      }

      // Read the file content as a string
      final String jsonString =
          await file.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['results']; // Extraktion der Liste

      // Use the mock user ID to filter results
      return jsonData
          .where((e) => e['userId'] == _mockUserId)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in getResults: $e');
      return [];
    } on FormatException catch (e) {
      _logger.severe('FormatException in getResults: $e');
      return [];
    } catch (e) {
      _logger.severe('Unexpected error in getResults: $e');
      return [];
    }
  }

  /// Saves a [Result] object to the mock database.
  ///
  /// This method writes the given [result] to the `results.json` file.
  /// It always assigns the [_mockUserId] to the result, overwriting any
  /// existing user ID.
  ///
  /// Parameters:
  ///   - [result]: The [Result] object to save.
  ///
  /// Returns:
  ///   A [Future] that completes when the result has been saved.
  ///   Logs an error if an exception occurs.
  @override
  Future<void> saveResult(Result result) async {
    try {
      // Load existing JSON file or create an empty list
      final file = File(resultsPath);
      Map<String, dynamic> jsonMap = {'results': []};

      if (file.existsSync()) {
        // Read the file content
        final String jsonString = await file.readAsString();
        jsonMap = json.decode(jsonString);
      }

      // Add new result
      final newResult = result.copyWith(userId: _mockUserId).toJson();
      jsonMap['results'].add(newResult);

      // Write updated JSON data back to the file
      await file.writeAsString(jsonEncode(jsonMap), flush: true);

      _logger.info('Result successfully saved!');
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in saveResult: $e');
    } on FormatException catch (e) {
      _logger.severe('FormatException in saveResult: $e');
    } catch (e) {
      _logger.severe('Error saving result: $e');
    }
  }

  /// Marks a topic as done in the mock database.
  ///
  /// This method updates the `isDone` property of a topic in the `topics.json` file.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to mark as done.
  ///
  /// Returns:
  ///   A [Future] that completes when the topic has been marked as done.
  ///   Logs an error if an exception occurs.
  @override
  Future<void> markTopicAsDone(
      String topicId, String categoryId, AppUser user) async {
    try {
      // ✅ Step 1: Update local topics.json (wie gehabt)
      final file = File(topicsPath);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['topics'];

      final topicIndex = jsonData.indexWhere((topic) => topic['id'] == topicId);
      if (topicIndex != -1) {
        jsonData[topicIndex]['isDone'] = true;
        await file.writeAsString(jsonEncode(jsonMap), flush: true);
        _logger.info('✅ Topic $topicId marked as done in topics.json');
      }

      // ✅ Step 2: Update user.isTopicDone
      final updatedMap = {
        ...user.isTopicDone,
        categoryId: {
          ...(user.isTopicDone[categoryId] ?? {}),
          topicId: true,
        }
      };

      // ✅ Step 3: Berechne neuen Fortschritt
      final fileTopics =
          jsonData.where((topic) => topic['categoryId'] == categoryId).toList();

      final passedCount = fileTopics
          .where((topic) => updatedMap[categoryId]?[topic['id']] == true)
          .length;

      final progress =
          fileTopics.isEmpty ? 0.0 : passedCount / fileTopics.length;

      // ✅ Step 4: Update user model
      final updatedUser = user.copyWith(
        isTopicDone: updatedMap,
        categoryProgress: {
          ...user.categoryProgress,
          categoryId: progress,
        },
      );

      _logger.info(
          '🔁 Fortschritt berechnet: ${(progress * 100).toStringAsFixed(1)}%');

      // ✅ Step 5: Speichern
      await updateUser(updatedUser);
    } catch (e) {
      _logger.severe('Error in markTopicAsDone: $e');
    }
  }

  /// Updates a [Category] object in the mock database.
  ///
  /// This method updates the `progress` property of a category in the `categories.json` file.
  ///
  /// Parameters:
  ///   - [category]: The [Category] object to update.
  ///
  /// Returns:
  ///   A [Future] that completes when the category has been updated.
  ///   Logs an error if an exception occurs.
  @override
  Future<void> updateCategory(Category category) async {
    try {
      // Load the categories JSON file from the documents directory
      final file = File(categoriesPath);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['categories'];

      // Find the category to update
      final categoryIndex =
          jsonData.indexWhere((cat) => cat['id'] == category.id);

      if (categoryIndex == -1) {
        _logger.warning('Category with ID ${category.id} not found.');
        return;
      }

      // Update the category data
      jsonData[categoryIndex] = {
        'id': category.id,
        'nameEn': category.nameEn,
        'nameDe': category.nameDe,
        'subtitleEn': category.subtitleEn,
        'subtitleDe': category.subtitleDe,
        'descriptionEn': category.descriptionEn,
        'descriptionDe': category.descriptionDe,
      };

      // Write the updated JSON data back to the file
      await file.writeAsString(jsonEncode(jsonMap), flush: true);

      _logger.info(
          'Category ${category.id} updated in categories.json successfully!');
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in updateCategory: $e');
    } on FormatException catch (e) {
      _logger.severe('FormatException in updateCategory: $e');
    } catch (e) {
      _logger.severe('Error updating category ${category.id}: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final file = File(userPath);
      if (!file.existsSync()) return;

      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString);
      final users = (jsonMap['users'] as List<dynamic>)
          .where((e) => e['uid'] != userId)
          .toList();

      jsonMap['users'] = users;
      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('🗑️ User gelöscht: $userId');
    } catch (e) {
      _logger.severe('Fehler in deleteUser: $e');
    }
  }

  @override
  Future<model.AppUser?> getUser(String userId) async {
    try {
      final file = File(userPath);
      if (!await file.exists()) return null;

      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString);
      final List users = jsonMap['users'] ?? [];

      final userList = users
          .map((e) => model.AppUser.fromJson(e))
          .where((u) => u.uid == userId)
          .toList();

      return userList.isNotEmpty ? userList.first : null;
    } catch (e) {
      _logger.severe('Fehler in getUser (async): $e');
      return null;
    }
  }

  @override
  Future<void> updateUser(model.AppUser user) async {
    try {
      final file = File(userPath);
      if (!file.existsSync()) return;

      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString);
      final List<dynamic> users = jsonMap['users'];

      final index = users.indexWhere((e) => e['uid'] == user.uid);
      if (index == -1) {
        _logger.warning('User nicht gefunden: ${user.uid}');
        return;
      }

      users[index] = user.toJson();
      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('✅ User aktualisiert: ${user.uid}');
    } catch (e) {
      _logger.severe('Fehler in updateUser: $e');
    }
  }

  @override
  Future<void> saveUser(model.AppUser user) async {
    try {
      final file = File(userPath);
      Map<String, dynamic> jsonMap = {'users': []};

      if (file.existsSync()) {
        final content = await file.readAsString();
        jsonMap = json.decode(content);

        jsonMap['users'] ??= [];
      }

      (jsonMap['users'] as List).add(user.toJson());

      await file.writeAsString(jsonEncode(jsonMap), flush: true);
      _logger.info('🆕 User gespeichert: ${user.uid}');
    } catch (e) {
      _logger.severe('Fehler in saveUser: $e');
    }
  }
}
