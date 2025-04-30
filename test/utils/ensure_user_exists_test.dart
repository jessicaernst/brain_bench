import 'package:brain_bench/core/utils/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseRepository extends Mock
    implements QuizMockDatabaseRepository {}

void main() {
  late MockDatabaseRepository mockDb;
  late AppUser testUser;

  setUpAll(() {
    registerFallbackValue(
      AppUser(
        uid: 'fallback-id',
        id: 'fallback-id',
        email: 'fallback@example.com',
        displayName: 'Fallback User',
        photoUrl: 'http://fallback.photo',
      ),
    );
  });

  setUp(() {
    mockDb = MockDatabaseRepository();
    testUser = AppUser(
      uid: 'test-id',
      id: 'test-id',
      email: 'user@example.com',
      displayName: 'Initial Name',
      photoUrl: 'http://photo.url',
    );
  });

  group('ensureUserExistsIfNeeded', () {
    test('creates user if not found in DB', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith((_) async => mockDb),
      ]);

      when(() => mockDb.getUser(testUser.uid)).thenAnswer((_) async => null);
      when(() => mockDb.saveUser(any())).thenAnswer((_) async {});

      await ensureUserExistsIfNeeded(container.read, testUser);

      verify(() => mockDb.saveUser(any())).called(1);
    });

    test('does nothing if user already exists and is up to date', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith((_) async => mockDb),
      ]);

      when(() => mockDb.getUser(testUser.uid))
          .thenAnswer((_) async => testUser);

      await ensureUserExistsIfNeeded(container.read, testUser);

      verifyNever(() => mockDb.saveUser(any()));
    });

    test('updates user if displayName changed', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith((_) async => mockDb),
      ]);

      final dbUser = testUser.copyWith(displayName: 'Old Name');

      when(() => mockDb.getUser(testUser.uid)).thenAnswer((_) async => dbUser);
      when(() => mockDb.saveUser(any())).thenAnswer((_) async {});

      await ensureUserExistsIfNeeded(container.read, testUser);

      verify(() => mockDb.saveUser(any())).called(1);
    });

    test('skips if passed user is null', () async {
      final container = ProviderContainer(overrides: [
        quizMockDatabaseRepositoryProvider.overrideWith((_) async => mockDb),
      ]);

      await ensureUserExistsIfNeeded(container.read, null);

      verifyNever(() => mockDb.getUser(any()));
    });
  });
}
