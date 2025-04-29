import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

void main() {
  late ProviderContainer container;
  late MockQuizRepo mockRepo;

  setUp(() {
    mockRepo = MockQuizRepo();
  });

  test('quizMockDatabaseRepositoryProvider returns overridden repository',
      () async {
    // Arrange: override the provider with a mock implementation
    container = ProviderContainer(overrides: [
      quizMockDatabaseRepositoryProvider.overrideWith((ref) async => mockRepo),
    ]);

    // Act: read the provider
    final result =
        await container.read(quizMockDatabaseRepositoryProvider.future);

    // Assert: it should return the mocked instance
    expect(result, mockRepo);
  });
}
