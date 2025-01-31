import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/result.dart';
import 'package:logging/logging.dart';
import 'database_repository.dart';

final Logger _logger = Logger('MockDatabaseRepository');

// Define a mock user ID (since the User model does not exist)
const String _mockUserId = 'mock-user-1234';

class MockDatabaseRepository implements DatabaseRepository {
  final String resultsPath = 'lib/data/data_source/results.json';

  static final MockDatabaseRepository _instance =
      MockDatabaseRepository._internal();

  factory MockDatabaseRepository() {
    return _instance;
  }

  MockDatabaseRepository._internal();

  // read Categories
  @override
  Future<List<Category>> getCategories(String languageCode) async {
    final String jsonString =
        await rootBundle.loadString('data/mock_database/category.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((e) {
      return Category(
        id: e['id'],
        name: languageCode == 'de' ? e['nameDe'] : e['nameEn'],
        subtitle: languageCode == 'de' ? e['subtitleDe'] : e['subtitleEn'],
        description:
            languageCode == 'de' ? e['descriptionDe'] : e['descriptionEn'],
      );
    }).toList();
  }

  // read Topics
  @override
  Future<List<Topic>> getTopics(String categoryId, String languageCode) async {
    final String jsonString =
        await rootBundle.loadString('data/mock_database/topics.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.where((e) => e['categoryId'] == categoryId).map((e) {
      return Topic(
        id: e['id'],
        name: languageCode == 'de' ? e['nameDe'] : e['nameEn'],
        description:
            languageCode == 'de' ? e['descriptionDe'] : e['descriptionEn'],
        categoryId: e['categoryId'],
        progress: e['progress'],
      );
    }).toList();
  }

  // read Questions
  @override
  Future<List<Question>> getQuestions(
      String topicId, String languageCode) async {
    final String questionJsonString =
        await rootBundle.loadString('data/mock_database/questions.json');
    final List<dynamic> questionJsonData = json.decode(questionJsonString);

    final String answerJsonString =
        await rootBundle.loadString('data/mock_database/answers.json');
    final List<dynamic> answerJsonData = json.decode(answerJsonString);

    final Map<String, Answer> answersMap = {
      for (var answer in answerJsonData)
        answer['id']: Answer(
          id: answer['id'],
          textEn: answer['textEn'],
          textDe: answer['textDe'],
          isCorrect: answer['isCorrect'],
        ),
    };

    return questionJsonData.where((e) => e['topicId'] == topicId).map((e) {
      final List<Answer> questionAnswers = (e['answerIds'] as List<dynamic>)
          .map((answerId) => answersMap[answerId]!)
          .toList();

      return Question(
        id: e['id'],
        topicId: e['topicId'],
        questionEn: e['questionEn'],
        questionDe: e['questionDe'],
        type: QuestionType.values.firstWhere(
          (type) => type.toString().split('.').last == e['type'],
        ),
        answers: questionAnswers,
        explanationEn: e['explanationEn'],
        explanationDe: e['explanationDe'],
      );
    }).toList();
  }

  // read Answers
  @override
  Future<List<Answer>> getAnswers(
      List<String> answerIds, String languageCode) async {
    final String jsonString =
        await rootBundle.loadString('data/mock_database/answers.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .where((e) => answerIds.contains(e['id']))
        .map((e) => Answer(
              id: e['id'],
              textEn: e['textEn'],
              textDe: e['textDe'],
              isCorrect: e['isCorrect'],
            ))
        .toList();
  }

// Read Results
  @override
  Future<List<Result>> getResults(String userId) async {
    try {
      // Load the JSON file
      final file = File(resultsPath);

      // Check if the file exists, return an empty list if not
      if (!file.existsSync()) {
        return [];
      }

      // Read the file content as a string
      final String jsonString = await file.readAsString();

      // Decode the string into a JSON list
      final List<dynamic> jsonData = json.decode(jsonString);

      // Use the mock user ID to filter results
      return jsonData
          .where((e) => e['userId'] == _mockUserId)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.severe('Error reading results: $e');
      return [];
    }
  }

  // Save Result - Always Assign the Mock User ID
  @override
  Future<void> saveResult(Result result) async {
    try {
      // Load existing JSON file or create an empty list
      final file = File(resultsPath);
      List<dynamic> jsonData = [];

      if (file.existsSync()) {
        // Read the file content
        final String jsonString = await file.readAsString();
        jsonData = json.decode(jsonString);
      }

      // Convert the new Result object to JSON
      final newResult = result.copyWith(userId: _mockUserId).toJson();
      jsonData.add(newResult);

      // Write updated JSON data back to the file
      await file.writeAsString(jsonEncode(jsonData), flush: true);

      _logger.info('Result successfully saved!');
    } catch (e) {
      _logger.severe('Error saving result: $e');
    }
  }
}
