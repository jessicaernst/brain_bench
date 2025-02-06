import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/result.dart';

abstract class QuizDatabaseRepository {
  Future<List<Category>> getCategories(String languageCode);
  Future<List<Topic>> getTopics(String categoryId, String languageCode);
  Future<List<Question>> getQuestions(String topicId, String languageCode);
  Future<List<Answer>> getAnswers(List<String> answerIds, String languageCode);
  Future<List<Result>> getResults(String userId);
  Future<void> saveResult(Result result);
}
