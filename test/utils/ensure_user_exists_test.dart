import 'dart:async';
import 'dart:io';

import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/utils/auth/ensure_user_exists.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/storage/storage_providers.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/storage_repository.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
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

// Mock the interface, not the implementation
class MockUserRepository extends Mock implements UserRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late MockStorageRepository mockStorageRepository;
  late AppUser testUser;
  late MockUserRepository mockUserRepository;

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
    mockUserRepository = MockUserRepository();
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
            // Mock getTemporaryDirectory
            return Directory.systemTemp
                .createTempSync('flutter_test_temp_')
                .path; // Return a mock path
          } else if (methodCall.method == 'getApplicationDocumentsDirectory') {
            // <-- Mock getApplicationDocumentsDirectory
            return Directory.systemTemp
                .createTempSync('flutter_test_docs_')
                .path; // Return a mock path
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
          userRepositoryProvider.overrideWith(
            (ref) async => mockUserRepository,
          ), // Override with the interface mock
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      when(
        () => mockUserRepository.getUser(testUser.uid),
      ).thenAnswer((_) async => null);
      when(() => mockUserRepository.saveUser(any())).thenAnswer((_) async {});

      await ensureUserExistsIfNeeded(container.read, testUser);

      verify(() => mockUserRepository.saveUser(any())).called(1);
    });

    test('does nothing if user already exists and is up to date', () async {
      final container = ProviderContainer(
        overrides: [
          // Assuming QuizMockDatabaseRepository is not directly used by ensureUserExistsIfNeeded for user ops
          userRepositoryProvider.overrideWith(
            (ref) async => mockUserRepository,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      when(
        () => mockUserRepository.getUser(testUser.uid),
      ).thenAnswer((_) async => testUser);

      await ensureUserExistsIfNeeded(container.read, testUser);

      verify(() => mockUserRepository.getUser(testUser.uid)).called(1);
      verifyNever(() => mockUserRepository.saveUser(any()));
      verifyNever(() => mockUserRepository.updateUserFields(any(), any()));
    });

    test('updates user if displayName changed', () async {
      final container = ProviderContainer(
        overrides: [
          // Override userRepositoryProvider with an async function returning the mock
          userRepositoryProvider.overrideWith(
            (ref) async => mockUserRepository,
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

      when(
        () => mockUserRepository.getUser(authUser.uid),
      ).thenAnswer((_) async => dbUser);
      // Mock updateUserFields as this is the method called when a user is updated
      when(
        () => mockUserRepository.updateUserFields(
          authUser.uid,
          any<Map<String, dynamic>>(),
        ), // Use any<Map<String, dynamic>>() for positional argument
      ).thenAnswer(
        (_) async {},
      ); // Expect updateUserFields with the correct UID and data map

      await ensureUserExistsIfNeeded(container.read, authUser);

      verify(
        // Verify updateUserFields was called with the correct UID and data
        () => mockUserRepository.updateUserFields(
          authUser.uid,
          any<Map<String, dynamic>>(
            // Use any<Map<String, dynamic>>() for positional argument
            that: isA<Map<String, dynamic>>().having(
              (map) => map['displayName'],
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
          userRepositoryProvider.overrideWith(
            (ref) async => mockUserRepository,
          ),
          storageRepositoryProvider.overrideWith(
            (ref) => mockStorageRepository,
          ),
          profileNotifierProvider.overrideWith(() => FakeProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      await ensureUserExistsIfNeeded(container.read, null);

      verifyNever(() => mockUserRepository.getUser(any()));
    });
  });
}
