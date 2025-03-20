import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/result.dart';

/// An abstract class defining the contract for a quiz database repository.
///
/// This interface specifies the methods that any concrete implementation of a
/// quiz database repository must provide. It includes methods for retrieving
/// categories, topics, questions, answers, and results, as well as for saving
/// results and marking topics as done.
abstract class QuizDatabaseRepository {
  /// Retrieves a list of [Category] objects.
  ///
  /// Parameters:
  ///   - [languageCode]: The language code to determine which language to use for the category names and descriptions.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Category] objects.
  Future<List<Category>> getCategories(String languageCode);

  /// Retrieves a list of [Topic] objects for a given category.
  ///
  /// Parameters:
  ///   - [categoryId]: The ID of the category to retrieve topics for.
  ///   - [languageCode]: The language code to determine which language to use for the topic names and descriptions.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Topic] objects.
  Future<List<Topic>> getTopics(String categoryId, String languageCode);

  /// Retrieves a list of [Question] objects for a given topic.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to retrieve questions for.
  ///   - [languageCode]: The language code to determine which language to use for the question text and explanations.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Question] objects.
  Future<List<Question>> getQuestions(String topicId, String languageCode);

  /// Retrieves a list of [Answer] objects for given answer IDs.
  ///
  /// Parameters:
  ///   - [answerIds]: A list of answer IDs to retrieve.
  ///   - [languageCode]: The language code to determine which language to use for the answer text.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Answer] objects.
  Future<List<Answer>> getAnswers(List<String> answerIds, String languageCode);

  /// Retrieves a list of [Result] objects for a given user.
  ///
  /// Parameters:
  ///   - [userId]: The ID of the user to retrieve results for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Result] objects.
  Future<List<Result>> getResults(String userId);

  /// Saves a [Result] object.
  ///
  /// Parameters:
  ///   - [result]: The [Result] object to save.
  ///
  /// Returns:
  ///   A [Future] that completes when the result has been saved.
  Future<void> saveResult(Result result);

  /// Marks a topic as done.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to mark as done.
  ///
  /// Returns:
  ///   A [Future] that completes when the topic has been marked as done.
  Future<void> markTopicAsDone(
      String topicId); // Neu: markTopicAsDone hinzugefügt
}
