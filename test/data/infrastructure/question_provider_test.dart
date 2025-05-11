import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

void main() {
  late MockQuizRepo mockRepo;
  late ProviderContainer container;

  const topicId = 't1';
  const languageCode = 'en';

  final question = Question(
    id: 'q1',
    topicId: topicId,
    question: 'What is Flutter?',
    type: QuestionType.singleChoice,
    answerIds: ['a1', 'a2', 'a3'],
    explanation: 'Flutter is a UI SDK.',
  );

  final fakeQuestions = [question];

  setUpAll(() {
    registerFallbackValue(QuestionType.singleChoice);
  });

  group('questionsProvider', () {
    setUp(() {
      mockRepo = MockQuizRepo();
      container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) => Future.value(mockRepo),
          ),
        ],
      );
    });

    test('returns expected questions', () async {
      when(
        () => mockRepo.getQuestions(topicId, languageCode),
      ).thenAnswer((_) async => fakeQuestions);

      final result = await container.read(
        questionsProvider(topicId, languageCode).future,
      );

      expect(result, fakeQuestions);
      verify(() => mockRepo.getQuestions(topicId, languageCode)).called(1);
    });

    test('handles empty list', () async {
      when(
        () => mockRepo.getQuestions(topicId, languageCode),
      ).thenAnswer((_) async => []);

      final result = await container.read(
        questionsProvider(topicId, languageCode).future,
      );

      expect(result, isEmpty);
    });

    test('throws exception when repository fails', () async {
      when(
        () => mockRepo.getQuestions(topicId, languageCode),
      ).thenThrow(Exception('DB Error'));

      expect(
        () => container.read(questionsProvider(topicId, languageCode).future),
        throwsException,
      );
    });
  });
}
