import 'dart:io';

import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizRepo extends Mock implements QuizMockDatabaseRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // Declare variables at the top level of main so they are accessible
  // in setUpAll, tearDownAll, and individual tests.
  late MockQuizRepo mockRepo;
  late MockUserRepository mockUserRepo;
  late MethodChannel channelPathProvider;

  // Define testUser and testResult here so they are available for registerFallbackValue
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

  // Initialize Flutter binding and mock path_provider once for all tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize and mock the path_provider MethodChannel
    channelPathProvider = const MethodChannel(
      // Assign to the declared variable
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channelPathProvider, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            // Return a mock path for the documents directory
            return Directory.systemTemp
                .createTempSync('flutter_test_docs_')
                .path;
          }
          if (methodCall.method == 'getTemporaryDirectory') {
            return Directory.systemTemp
                .createTempSync('flutter_test_temp_')
                .path;
          }
          return null;
        });
    registerFallbackValue(testResult);
    registerFallbackValue(
      const AppUser(
        uid: 'fallback',
        id: 'fallback',
        email: 'fallback@example.com',
      ),
    ); // Fallback for AppUser
    registerFallbackValue(const AsyncValue<UserModelState>.loading());
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channelPathProvider, null);
  });

  setUp(() {
    mockRepo = MockQuizRepo();
    mockUserRepo = MockUserRepository();
  });

  group('resultsProvider', () {
    test('returns results for current user', () async {
      when(
        () => mockRepo.getResults(testUser.uid),
      ).thenAnswer((_) async => [testResult]);

      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) => Future.value(mockRepo),
          ),
          currentUserModelProvider.overrideWith(
            (ref) => Stream.value(UserModelState.data(testUser)),
          ),
        ],
      );

      final result = await container.read(resultsProvider.future);

      expect(result, [testResult]);
      verify(() => mockRepo.getResults(testUser.uid)).called(1);
    });

    test('throws exception if no user is logged in', () async {
      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) => Future.value(mockRepo),
          ),
          currentUserModelProvider.overrideWith(
            (ref) => Stream.value(const UserModelState.unauthenticated()),
          ),
        ],
      );

      expect(() => container.read(resultsProvider.future), throwsException);
    });
  });

  group('SaveResultNotifier', () {
    test('saveResult saves result via repository', () async {
      when(() => mockRepo.saveResult(any())).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          quizMockDatabaseRepositoryProvider.overrideWith(
            (ref) => Future.value(mockRepo),
          ),
          currentUserModelProvider.overrideWith(
            (ref) => Stream.value(UserModelState.data(testUser)),
          ),
        ],
      );

      final notifier = container.read(saveResultNotifierProvider.notifier);

      await notifier.saveResult(testResult);

      verify(() => mockRepo.saveResult(testResult)).called(1);
    });
  });
}
