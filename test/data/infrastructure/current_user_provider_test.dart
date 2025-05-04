import 'dart:async'; // Import StreamController

import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/firebase_core'),
          (call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {'name': '[DEFAULT]', 'options': {}, 'pluginConstants': {}}
      ];
    }
    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': {},
        'pluginConstants': {}
      };
    }
    customHandlers?.call(call);
    return null;
  });
}

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
    setupFirebaseAuthMocks();
    Firebase.initializeApp();

    registerFallbackValue(testUser);
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
    test('currentUserModelProvider returns user model from DB', () async {
      when(() => mockRepo.getUser(testUser.uid))
          .thenAnswer((_) async => testUser);
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      authStateController.add(testUser);
      await container.pump();

      final result = await container.read(currentUserModelProvider.future);

      // Assert
      expect(result, testUser);
      verify(() => mockRepo.getUser(testUser.uid)).called(1);
    });

    test('currentUserModelProvider returns null if no user', () async {
      // Arrange
      when(() => mockRepo.getUser(testUser.uid))
          .thenAnswer((_) async => testUser);
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        quizMockDatabaseRepositoryProvider
            .overrideWith((ref) async => mockRepo),
      ]);

      authStateController.add(null);
      await container.pump(); // Use pump

      final result = await container.read(currentUserModelProvider.future);

      // Assert
      expect(result, isNull);
      verifyNever(() => mockRepo.getUser(any()));
    });
  });
}
