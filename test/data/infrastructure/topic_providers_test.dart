import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

void main() {
  late MockQuizRepo mockRepo;
  late ProviderContainer container;

  const categoryId = 'cat1';

  final topic = Topic(
    id: 't1',
    nameEn: 'Topic EN',
    nameDe: 'Thema DE',
    descriptionEn: 'Description EN',
    descriptionDe: 'Beschreibung DE',
    categoryId: categoryId,
  );

  final fakeTopics = [topic];

  group('topicsProvider', () {
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

    test('returns expected topics', () async {
      when(
        () => mockRepo.getTopics(categoryId),
      ).thenAnswer((_) async => fakeTopics);

      final result = await container.read(topicsProvider(categoryId).future);

      expect(result, fakeTopics);
      verify(() => mockRepo.getTopics(categoryId)).called(1);
    });

    test('handles empty list', () async {
      when(() => mockRepo.getTopics(categoryId)).thenAnswer((_) async => []);

      final result = await container.read(topicsProvider(categoryId).future);

      expect(result, isEmpty);
    });

    test('throws exception when repository fails', () async {
      when(
        () => mockRepo.getTopics(categoryId),
      ).thenThrow(Exception('DB Error'));

      expect(
        () => container.read(topicsProvider(categoryId).future),
        throwsException,
      );
    });
  });
}
