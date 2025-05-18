import 'dart:convert';
import 'dart:io';

import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'database_repository.dart';

final Logger _logger = Logger('QuizMockDatabaseRepository');

/// A mock user ID used for all results in this mock database.
/// This constant is used to simulate a user ID for results in this mock
/// quiz database, as user data is handled by a separate repository.
const String _mockUserId = 'mock-user-1234';

/// A mock implementation of the [DatabaseRepository] interface.
///
/// This class simulates a database by reading and writing data to JSON files.
/// It provides methods to retrieve quiz-related data such as categories, topics,
/// questions, answers, and results. It also allows saving results and marking
/// topics as done. This implementation is intended for development and testing
/// purposes and should not be used in a production environment.
class QuizMockDatabaseRepository implements DatabaseRepository {
  QuizMockDatabaseRepository({
    required this.resultsPath,
    required this.categoriesPath,
    required this.topicsPath,
    required this.questionsPath,
    required this.answersPath,
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

  /// Copies the JSON asset files from the app bundle to the documents directory.
  Future<void> copyAssetsToDocuments() async {
    await _copyAssetToDocument(
      'lib/data/data_source/results.json',
      resultsPath,
    );
    await _copyAssetToDocument(
      'lib/data/data_source/category.json',
      categoriesPath,
    );
    await _copyAssetToDocument('lib/data/data_source/topics.json', topicsPath);
    await _copyAssetToDocument(
      'lib/data/data_source/questions.json',
      questionsPath,
    );
    await _copyAssetToDocument(
      'lib/data/data_source/answers.json',
      answersPath,
    );
  }

  /// Copies a single asset file to the documents directory.
  Future<void> _copyAssetToDocument(
    String assetPath,
    String documentPath,
  ) async {
    final file = File(documentPath);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
    }
  }

  /// Retrieves a list of [Category] objects.
  ///
  /// This method reads the categories data from the `categories.json` file,
  /// decodes it, and returns a list of [Category] objects. It also simulates
  /// a network delay of 1 second.
  ///   A [Future] that completes with a list of [Category] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Category>> getCategories() async {
    try {
      final file = File(categoriesPath); // ✅ Use File here
      final String jsonString =
          await file.readAsString(); // ✅ Use readAsString()
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['categories'];

      return jsonData
          .map(
            (e) => Category(
              id: e['id'],
              nameEn: e['nameEn'],
              nameDe: e['nameDe'] as String?,
              subtitleEn: e['subtitleEn'],
              subtitleDe: e['subtitleDe'] as String?,
              descriptionEn: e['descriptionEn'],
              descriptionDe: e['descriptionDe'] as String?,
            ),
          )
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

  /// Retrieves a list of [Topic] objects for a given category.
  ///
  /// This method reads the topics data from the `topics.json` file, decodes it,
  /// filters the topics by the given [categoryId], and returns a list of
  /// [Topic] objects. It also simulates a network delay of 1 second.
  ///   - [categoryId]: The ID of the category to retrieve topics for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Topic] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Topic>> getTopics(String categoryId) async {
    try {
      final file = File(topicsPath);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['topics'];

      return jsonData.where((e) => e['categoryId'] == categoryId).map((e) {
        return Topic(
          id: e['id'],
          nameEn: e['nameEn'],
          nameDe: e['nameDe'] as String?,
          descriptionEn: e['descriptionEn'],
          descriptionDe: e['descriptionDe'] as String?,
          categoryId: e['categoryId'],
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

  /// Retrieves a list of [Question] objects for a given topic.
  ///
  /// This method reads the questions data from the `questions.json` file and
  /// the answers data from the `answers.json` file, decodes them, filters the
  /// questions by the given [topicId], and returns a list of [Question]
  /// objects. It also simulates a network delay of 1 second.
  ///   - [topicId]: The ID of the topic to retrieve questions for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Question] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Question>> getQuestions(String topicId) async {
    try {
      final fileQuestion = File(questionsPath);
      final String questionJsonString = await fileQuestion.readAsString();
      final Map<String, dynamic> questionJsonMap = json.decode(
        questionJsonString,
      );
      final List<dynamic> questionJsonData = questionJsonMap['questions'];

      final fileAnswer = File(answersPath);
      final String answerJsonString = await fileAnswer.readAsString();
      json.decode(answerJsonString);

      return questionJsonData.where((e) => e['topicId'] == topicId).map((e) {
        return Question(
          id: e['id'],
          topicId: e['topicId'],
          questionEn: e['questionEn'],
          questionDe: e['questionDe'] as String?,
          type: QuestionType.values.firstWhere(
            (type) => type.toString().split('.').last == e['type'],
          ),
          answerIds:
              (e['answerIds'] as List<dynamic>)
                  .map((id) => id.toString())
                  .toList(),
          explanationEn: e['explanationEn'] as String?,
          explanationDe: e['explanationDe'] as String?,
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

  /// Retrieves a list of [Answer] objects for given answer IDs.
  ///
  /// This method reads the answers data from the `answers.json` file, decodes
  /// it, filters the answers by the given [answerIds], and returns a list of
  /// [Answer] objects. It also simulates a network delay of 1 second.
  ///   - [answerIds]: A list of answer IDs to retrieve.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Answer] objects.
  ///   Returns an empty list if an error occurs.
  @override
  Future<List<Answer>> getAnswers(List<String> answerIds) async {
    try {
      final file = File(answersPath);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['answers'];

      _logger.fine('Loaded answer data: ${jsonData.length} answers found.');

      final List<Answer> answers =
          jsonData
              .where((e) => answerIds.contains(e['id']))
              .map(
                (e) => Answer(
                  id: e['id'],
                  textEn: e['textEn'],
                  textDe: e['textDe'],
                  isCorrect: e['isCorrect'],
                ),
              )
              .toList();

      _logger.fine(
        'Filtered answers: ${answers.length} of ${answerIds.length} IDs found.',
      );

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

  /// Retrieves a list of [Result] objects for a given user.
  ///
  /// This method reads the results data from the `results.json` file, decodes
  /// it, filters the results by the given [userId], and returns a list of
  /// [Result] objects.
  ///   - [userId]: The ID of the user to retrieve results for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Result] objects.
  ///   Returns an empty list if an error occurs or the file does not exist.
  @override
  Future<List<Result>> getResults(String userId) async {
    try {
      // Load the JSON file
      final file = File(resultsPath);

      // Check if the file exists, return an empty list if not
      if (!file.existsSync()) {
        _logger.warning('Results file does not exist.');
        return [];
      }

      // Read the file content as a string
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonData = jsonMap['results'];

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

  /// Saves a [Result] object.
  ///
  /// This method writes the given [result] to the `results.json` file.
  /// It always assigns the [_mockUserId] to the result, overwriting any
  /// existing user ID.
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

  /// Updates a [Category] object.
  ///
  /// This method updates the `progress` property of a category in the `categories.json` file.
  ///   - [category]: The [Category] object to update.
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
      final categoryIndex = jsonData.indexWhere(
        (cat) => cat['id'] == category.id,
      );

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
        'Category ${category.id} updated in categories.json successfully!',
      );
    } on FileSystemException catch (e) {
      _logger.severe('FileSystemException in updateCategory: $e');
    } on FormatException catch (e) {
      _logger.severe('FormatException in updateCategory: $e');
    } catch (e) {
      _logger.severe('Error updating category ${category.id}: $e');
    }
  }
}
