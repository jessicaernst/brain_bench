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

final Logger _logger = Logger('QuizFlowDatabaseRepository');

// Define a mock user ID (since the User model does not exist)
const String _mockUserId = 'mock-user-1234';

class QuizFlowDatabaseRepository implements DatabaseRepository {
  final String resultsPath = 'lib/data/data_source/results.json';
  final String categoriesPath = 'lib/data/data_source/category.json';
  final String topicsPath = 'lib/data/data_source/topics.json';
  final String questionsPath = 'lib/data/data_source/questions.json';
  final String answersPath = 'lib/data/data_source/answers.json';

  // read Categories
  @override
  Future<List<Category>> getCategories(String languageCode) async {
    final String jsonString = await rootBundle.loadString(categoriesPath);
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((e) => Category(
              id: e['id'],
              nameEn: e['nameEn'],
              nameDe: e['nameDe'],
              subtitleEn: e['subtitleEn'],
              subtitleDe: e['subtitleDe'],
              descriptionEn: e['descriptionEn'],
              descriptionDe: e['descriptionDe'],
              progress: (e['progress'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();
  }

  // read Topics
  @override
  Future<List<Topic>> getTopics(String categoryId, String languageCode) async {
    final String jsonString = await rootBundle.loadString(topicsPath);
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
        await rootBundle.loadString(questionsPath);
    final List<dynamic> questionJsonData = json.decode(questionJsonString);

    final String answerJsonString = await rootBundle.loadString(answersPath);
    final List<dynamic> answerJsonData = json.decode(answerJsonString);

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
  }

  @override
  Future<List<Answer>> getAnswers(
      List<String> answerIds, String languageCode) async {
    _logger.info('getAnswers() aufgerufen für: $answerIds');

    final String jsonString = await rootBundle.loadString(answersPath);
    final List<dynamic> jsonData = json.decode(jsonString);

    _logger
        .info('Geladene Antwortdaten: ${jsonData.length} Antworten gefunden.');

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
