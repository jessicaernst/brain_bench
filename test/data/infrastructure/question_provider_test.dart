import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/question_providers.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseRepo extends Mock implements DatabaseRepository {}

void main() {
  late MockDatabaseRepo mockRepo;
  late ProviderContainer container;

  const topicId = 't1';

  final question = Question(
    id: 'q1',
    topicId: topicId,
    questionEn: 'What is Flutter?',
    questionDe: 'Was ist Flutter?',
    type: QuestionType.singleChoice,
    answerIds: ['a1', 'a2', 'a3'],
    explanationEn: 'Flutter is a UI SDK.',
  );

  final fakeQuestions = [question];

  setUpAll(() {
    registerFallbackValue(QuestionType.singleChoice);
  });

  group('questionsProvider', () {
    setUp(() {
      mockRepo = MockDatabaseRepo();
      container = ProviderContainer(
        overrides: [quizFirebaseRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    test('returns expected questions', () async {
      when(
        () => mockRepo.getQuestions(topicId),
      ).thenAnswer((_) async => fakeQuestions);

      final result = await container.read(questionsProvider(topicId).future);

      expect(result, fakeQuestions);
      verify(() => mockRepo.getQuestions(topicId)).called(1);
    });

    test('handles empty list', () async {
      when(() => mockRepo.getQuestions(topicId)).thenAnswer((_) async => []);

      final result = await container.read(questionsProvider(topicId).future);

      expect(result, isEmpty);
    });

    test('throws exception when repository fails', () async {
      when(
        () => mockRepo.getQuestions(topicId),
      ).thenThrow(Exception('DB Error'));

      expect(
        () => container.read(questionsProvider(topicId).future),
        throwsException,
      );
    });
  });
}
