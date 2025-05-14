import 'dart:async';
import 'dart:io';

import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/utils/auth/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/storage/storage_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProfileNotifier extends ProfileNotifier {
  @override
  FutureOr<void> build() => null;

  @override
  Future<void> updateUserProfileImage({
    required XFile newImageFile,
    required String userId,
  }) async {
    // Stub
  }
}

class MockDatabaseRepository extends Mock
    implements QuizMockDatabaseRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late MockDatabaseRepository mockDb;
  late MockStorageRepository mockStorageRepository;
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
    registerFallbackValue(XFile('dummy_image.jpg'));
  });

  setUp(() {
    mockDb = MockDatabaseRepository();
    mockStorageRepository = MockStorageRepository();
    testUser = AppUser(
      uid: 'test-id',
      id: 'test-id',
      email: 'user@example.com',
      displayName: 'Initial Name',
      photoUrl: 'http://photo.url',
    );

    const MethodChannel channelPathProvider = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channelPathProvider, (methodCall) async {
          if (methodCall.method == 'getTemporaryDirectory') {
            final tempDir = await Directory.systemTemp.createTemp(
              'flutter_test_',
            );
            return tempDir.path;
          }
          return null;
        });

    const MethodChannel channelContacts = MethodChannel(
      'de.jessicaernst.brainbench/contacts',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channelContacts, (methodCall) async {
          if (methodCall.method == 'getUserContact') {
            return null;
          }
          return null;
        });

    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channelPathProvider, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channelContacts, null);
    });
  });

  group('ensureUserExistsIfNeeded', () {
    test('creates user if not found in DB', () async {
      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) async => mockDb,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockDb.getUser(testUser.uid)).thenAnswer((_) async => null);
      when(() => mockDb.saveUser(any())).thenAnswer((_) async {});

      await ensureUserExistsIfNeeded(container.read, testUser);

      verify(() => mockDb.saveUser(any())).called(1);
    });

    test('does nothing if user already exists and is up to date', () async {
      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) async => mockDb,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      when(
        () => mockDb.getUser(testUser.uid),
      ).thenAnswer((_) async => testUser);

      await ensureUserExistsIfNeeded(container.read, testUser);

      verifyNever(() => mockDb.saveUser(any()));
    });

    test('updates user if displayName changed', () async {
      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) async => mockDb,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      final dbUser = testUser.copyWith(displayName: 'Old Name');
      final authUser = testUser.copyWith(displayName: 'New Name From Auth');

      when(() => mockDb.getUser(authUser.uid)).thenAnswer((_) async => dbUser);
      when(() => mockDb.saveUser(any())).thenAnswer((_) async {});

      await ensureUserExistsIfNeeded(container.read, authUser);

      verify(
        () => mockDb.saveUser(
          any(
            that: isA<model.AppUser>().having(
              (u) => u.displayName,
              'displayName',
              'New Name From Auth',
            ),
          ),
        ),
      ).called(1);
    });

    test('skips if passed user is null', () async {
      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) async => mockDb,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      await ensureUserExistsIfNeeded(container.read, null);

      verifyNever(() => mockDb.getUser(any()));
    });
  });
}
