import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

void main() {
  late MockQuizRepo mockRepo;

  final testUser = const AppUser(
    uid: '123',
    id: '123',
    email: 'test@example.com',
  );

  final testResult = Result(
    id: 'r1',
    userId: '123',
    topicId: 't1',
    categoryId: 'cat1',
    correct: 8,
    total: 10,
    score: 0.8,
    isPassed: true,
    timestamp: DateTime(2024, 1, 1),
    quizAnswers: const [],
  );

  setUpAll(() {
    registerFallbackValue(testResult); // 👈 notwendig für mocktail
  });

  setUp(() {
    mockRepo = MockQuizRepo();
  });

  group('resultsProvider', () {
    test('returns results for current user', () async {
      when(() => mockRepo.getResults(testUser.uid))
          .thenAnswer((_) async => [testResult]);

      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => Future.value(mockRepo),
        ),
        currentUserModelProvider.overrideWith(
          (ref) => Stream.value(testUser),
        ),
      ]);

      final result = await container.read(resultsProvider.future);

      expect(result, [testResult]);
      verify(() => mockRepo.getResults(testUser.uid)).called(1);
    });

    test('throws exception if no user is logged in', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => Future.value(mockRepo),
        ),
        currentUserModelProvider.overrideWith(
          (ref) => Stream.value(null), // ❌ kein User vorhanden
        ),
      ]);

      expect(
        () => container.read(resultsProvider.future),
        throwsException,
      );
    });
  });

  group('SaveResultNotifier', () {
    test('saveResult saves result via repository', () async {
      when(() => mockRepo.saveResult(any())).thenAnswer((_) async {});

      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => Future.value(mockRepo),
        ),
        currentUserModelProvider.overrideWith(
          (ref) => Stream.value(testUser),
        ),
      ]);

      final notifier = container.read(saveResultNotifierProvider.notifier);

      await notifier.saveResult(testResult);

      verify(() => mockRepo.saveResult(testResult)).called(1);
    });

    test('markTopicAsDone marks topic and invalidates user', () async {
      when(() => mockRepo.markTopicAsDone('t1', 'cat1', testUser))
          .thenAnswer((_) async {});

      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => Future.value(mockRepo),
        ),
        currentUserModelProvider.overrideWith(
          (ref) => Stream.value(testUser),
        ),
      ]);

      final notifier = container.read(saveResultNotifierProvider.notifier);

      await notifier.markTopicAsDone(topicId: 't1', categoryId: 'cat1');

      verify(() => mockRepo.markTopicAsDone('t1', 'cat1', testUser)).called(1);
    });

    test('markTopicAsDone throws if user is null', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith(
          (ref) => Future.value(mockRepo),
        ),
        currentUserModelProvider.overrideWith(
          (ref) => Stream.value(null), // ❌ kein User vorhanden
        ),
      ]);

      final notifier = container.read(saveResultNotifierProvider.notifier);

      expect(
        () => notifier.markTopicAsDone(topicId: 't1', categoryId: 'cat1'),
        throwsException,
      );
    });
  });
}
