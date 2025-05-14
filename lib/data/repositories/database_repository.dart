import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';

/// An abstract class defining the contract for a quiz database repository.
///
/// This interface specifies the methods that any concrete implementation of a
/// quiz database repository must provide. It includes methods for retrieving
/// categories, topics, questions, answers, and results, as well as for saving
/// results and marking topics as done.
abstract class DatabaseRepository {
  /// Retrieves a list of [Category] objects.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Category] objects.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Category] objects.
  Future<List<Category>> getCategories();

  /// Retrieves a list of [Topic] objects for a given category.
  ///
  /// Parameters:
  ///   - [categoryId]: The ID of the category to retrieve topics for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Topic] objects.
  Future<List<Topic>> getTopics(String categoryId);

  /// Retrieves a list of [Question] objects for a given topic.
  ///
  /// Parameters:
  ///   - [topicId]: The ID of the topic to retrieve questions for.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Question] objects.
  Future<List<Question>> getQuestions(String topicId);

  /// Retrieves a list of [Answer] objects for given answer IDs.
  ///
  /// Parameters:
  ///   - [answerIds]: A list of answer IDs to retrieve.
  ///
  /// Returns:
  ///   A [Future] that completes with a list of [Answer] objects.
  Future<List<Answer>> getAnswers(List<String> answerIds);

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
    String topicId,
    String categoryId,
    String userId,
  ); // Changed AppUser to String userId

  /// Updates a [Category] object.
  ///
  /// Parameters:
  ///   - [category]: The [Category] object to update.
  ///
  /// Returns:
  ///   A [Future] that completes when the category has been updated.
  Future<void> updateCategory(Category category);
}
