import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseRepo extends Mock implements DatabaseRepository {}

void main() {
  late ProviderContainer container;
  late MockDatabaseRepo mockRepo;

  setUp(() {
    mockRepo = MockDatabaseRepo();
  });

  test(
    'quizFirebaseRepositoryProvider returns overridden repository',
    () async {
      // Arrange: override the provider with a mock implementation
      container = ProviderContainer(
        overrides: [quizFirebaseRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Act: read the provider
      // Da der Provider synchron ist, kein .future und kein await nötig
      final result = container.read(quizFirebaseRepositoryProvider);

      // Assert: it should return the mocked instance
      expect(result, mockRepo);
    },
  );
}
