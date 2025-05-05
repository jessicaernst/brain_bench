import 'dart:async';

import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockQuizRepo mockRepo;
  late MockAuthRepository mockAuthRepo;
  late StreamController<AppUser?> authStateController;

  const testUser = AppUser(
    uid: '123',
    id: '123',
    email: 'test@example.com',
  );

  setUpAll(() {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/firebase_core');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'Firebase#initializeCore') {
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'fakeApiKey',
                'appId': '1:1234567890:android:abcdef',
                'messagingSenderId': '1234567890',
                'projectId': 'fake-project-id',
              },
              'pluginConstants': {},
            },
          ];
        }
        return null;
      },
    );
  });

  setUp(() {
    mockRepo = MockQuizRepo();
    mockAuthRepo = MockAuthRepository();
    authStateController = StreamController<AppUser?>();

    when(() => mockAuthRepo.authStateChanges())
        .thenAnswer((_) => authStateController.stream);
  });

  tearDown(() {
    authStateController.close();
    container.dispose();
  });

  group('currentUserModelProvider', () {
    test('returns user model from DB', () async {
      when(() => mockRepo.getUser(testUser.uid))
          .thenAnswer((_) async => testUser);

      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      // Trigger the auth change FIRST
      authStateController.add(testUser);

      // Directly expect the Stream of the provider
      await expectLater(
        container.read(currentUserModelProvider.future),
        emitsInOrder([
          const UserModelState.loading(),
          UserModelState.data(testUser),
        ]),
      );

      verify(() => mockRepo.getUser(testUser.uid)).called(1);
    });

    test('returns null if no user is signed in', () async {
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      // List to collect emitted AsyncValue states
      final emittedStates = <AsyncValue<UserModelState>>[];
      container.listen<AsyncValue<UserModelState>>(
        currentUserModelProvider,
        (_, next) => emittedStates.add(next),
        fireImmediately: true, // Capture initial loading state
      );

      // Trigger the event
      authStateController.add(null);

      // Wait for the provider to process the event
      await container.read(currentUserModelProvider.future);

      // Assert the final state
      expect(emittedStates.last,
          const AsyncData(UserModelState.unauthenticated()));
      verifyNever(() => mockRepo.getUser(any()));
    });
  });
}
