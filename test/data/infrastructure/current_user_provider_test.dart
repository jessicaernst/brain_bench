import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

void main() {
  late ProviderContainer container;
  late MockQuizRepo mockRepo;
  const testUser = AppUser(
    uid: '123',
    id: '123',
    email: 'test@example.com',
  );

  setUpAll(() {
    registerFallbackValue(testUser);
  });

  setUp(() {
    mockRepo = MockQuizRepo();
  });

  group('currentUserModelProvider', () {
    test('currentUserModelProvider returns user model from DB', () async {
      when(() => mockRepo.getUser(testUser.uid))
          .thenAnswer((_) async => testUser);

      container = ProviderContainer(overrides: [
        currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      final result = await container.read(currentUserModelProvider.future);

      expect(result, testUser);
      verify(() => mockRepo.getUser(testUser.uid)).called(1);
    });

    test('currentUserModelProvider returns null if no user', () async {
      container = ProviderContainer(overrides: [
        currentUserProvider.overrideWith((ref) => Stream.value(null)),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      final result = await container.read(currentUserModelProvider.future);

      expect(result, isNull);
      verifyNever(() => mockRepo.getUser(any()));
    });
  });
}
