import 'dart:async';

import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_result_state.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/infrastructure/results/result_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/quiz/quiz_answer.dart';
import 'package:brain_bench/data/models/result/result.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/data/repositories/quiz_mock_database_repository_impl.dart';
import 'package:brain_bench/data/repositories/user_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks & Fakes ---

// Mock for QuizAnswersNotifier
class MockQuizAnswersNotifier extends Notifier<List<QuizAnswer>>
    with Mock
    implements QuizAnswersNotifier {
  final List<QuizAnswer> _initialState;
  MockQuizAnswersNotifier(this._initialState);
  @override
  List<QuizAnswer> build() => _initialState;
}

// --- FAKE Implementation for SaveResultNotifier ---
class FakeSaveResultNotifier extends AutoDisposeAsyncNotifier<void>
    implements SaveResultNotifier {
  int saveResultCallCount = 0;
  Result? lastSavedResult;
  Exception? errorToThrowOnSave;
  int markTopicAsDoneCallCount = 0;
  String? lastMarkedTopicId;
  String? lastMarkedCategoryId;
  Exception? errorToThrowOnMarkDone;

  @override
  FutureOr<void> build() => null;

  @override
  Future<void> saveResult(Result result) async {
    saveResultCallCount++;
    lastSavedResult = result;
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 5));
    if (errorToThrowOnSave != null) {
      state = AsyncError(errorToThrowOnSave!, StackTrace.current);
      throw errorToThrowOnSave!;
    } else {
      state = const AsyncData(null);
    }
  }

  @override
  Future<void> markTopicAsDone({
    required String categoryId,
    required String topicId,
  }) async {
    markTopicAsDoneCallCount++;
    lastMarkedTopicId = topicId;
    lastMarkedCategoryId = categoryId;
    await Future.delayed(const Duration(milliseconds: 1));
    if (errorToThrowOnMarkDone != null) {
      throw errorToThrowOnMarkDone!;
    }
  }

  void setErrorToThrowOnSave(Exception? error) => errorToThrowOnSave = error;
  void setErrorToThrowOnMarkDone(Exception? error) =>
      errorToThrowOnMarkDone = error;

  void reset() {
    saveResultCallCount = 0;
    lastSavedResult = null;
    errorToThrowOnSave = null;
    markTopicAsDoneCallCount = 0;
    lastMarkedTopicId = null;
    lastMarkedCategoryId = null;
    errorToThrowOnMarkDone = null;
    state = const AsyncData(null);
  }
}

// Mock for the database (remains Mock)
class MockQuizMockDatabaseRepository extends Mock
    implements QuizMockDatabaseRepository {}

class MockUserDatabaseRepository extends Mock implements UserRepository {}

// --- MockAppUser using Mocktail ---
class MockAppUser extends Mock implements AppUser {}

// --- Helper for copyWith mocking ---
// Define the helper object for the freezed pattern (used in generated code)
const freezed = Object();

// --- Mock for the copyWith function object ---
// Use the *actual* generated type from app_user.freezed.dart
class MockAppUserCopyWith extends Mock implements $AppUserCopyWith<AppUser> {}

// Mock for Topic (remains Mock)
class MockTopic extends Mock implements Topic {
  // @override // No override needed if Topic is an interface/abstract
  @override
  final String id; // Add final if needed by mocktail/interface
  MockTopic({this.id = 'mockTopicId'});
}

// Fake for Result (remains Fake)
class FakeResult extends Fake implements Result {}

// --- Test Data --- (remains the same)
QuizAnswer createQuizAnswer({
  required String questionId,
  String topicId = 't1',
  String categoryId = 'c1',
  String questionText = 'Question?',
  List<String> givenAnswers = const [],
  List<String> correctAnswers = const [],
  List<String> allAnswers = const [],
  String? explanation,
  required int pointsEarned,
  required int possiblePoints,
}) {
  return QuizAnswer.create(
    questionId: questionId,
    topicId: topicId,
    categoryId: categoryId,
    questionText: questionText,
    givenAnswers: givenAnswers,
    correctAnswers: correctAnswers,
    allAnswers: allAnswers,
    explanation: explanation,
    pointsEarned: pointsEarned,
    possiblePoints: possiblePoints,
  );
}

final quizAnswerCorrect1 = createQuizAnswer(
  questionId: 'q1',
  givenAnswers: ['a1'],
  correctAnswers: ['a1'],
  allAnswers: ['a1', 'a2'],
  pointsEarned: 1,
  possiblePoints: 1,
);
final quizAnswerIncorrect1 = createQuizAnswer(
  questionId: 'q2',
  givenAnswers: ['a2'],
  correctAnswers: ['a3'],
  allAnswers: ['a2', 'a3'],
  pointsEarned: 0,
  possiblePoints: 1,
);
final quizAnswerPartial1 = createQuizAnswer(
  questionId: 'q3',
  givenAnswers: ['a4'],
  correctAnswers: ['a4', 'a5'],
  allAnswers: ['a4', 'a5', 'a6'],
  pointsEarned: 1,
  possiblePoints: 2,
);
final List<QuizAnswer> sampleAnswersAllCorrect = [quizAnswerCorrect1];
final List<QuizAnswer> sampleAnswersAllIncorrect = [quizAnswerIncorrect1];
final List<QuizAnswer> sampleAnswersMixed = [
  quizAnswerCorrect1,
  quizAnswerIncorrect1,
  quizAnswerPartial1,
];
final List<QuizAnswer> sampleAnswersEmpty = [];

// --- Main Test Suite ---

// MOVED _createDefaultMockUser BEFORE main()
// Helper to create a default stubbed MockAppUser
MockAppUser _createDefaultMockUser() {
  final user = MockAppUser();
  final mockCopyWith = MockAppUserCopyWith();
  when(() => user.id).thenReturn('mockUserId');
  when(() => user.uid).thenReturn('mockUserUid');
  when(() => user.email).thenReturn('mock@example.com');
  when(() => user.language).thenReturn('en');
  when(() => user.themeMode).thenReturn('system');
  when(() => user.isTopicDone).thenReturn(const {});
  when(() => user.categoryProgress).thenReturn(const {});
  when(() => user.displayName).thenReturn(null);
  when(() => user.photoUrl).thenReturn(null);
  when(() => user.profileImageUrl).thenReturn(null);
  when(() => user.copyWith).thenReturn(mockCopyWith); // Stub copyWith getter

  // Basic stub for copyWith.call - returns the same user by default
  // Tests needing specific copyWith results will need more detailed stubbing
  // REMOVED orElse from any() calls
  when(
    () => mockCopyWith.call(
      id: any(named: 'id'),
      uid: any(named: 'uid'),
      email: any(named: 'email'),
      language: any(named: 'language'),
      themeMode: any(named: 'themeMode'),
      isTopicDone: any(named: 'isTopicDone'),
      categoryProgress: any(named: 'categoryProgress'),
      displayName: any(named: 'displayName'),
      photoUrl: any(named: 'photoUrl'),
      profileImageUrl: any(named: 'profileImageUrl'),
    ),
  ).thenReturn(user); // Default: return same mock

  return user;
}

void main() {
  // Register fallbacks for mocks
  setUpAll(() {
    registerFallbackValue(MockAppUser()); // Register the mock user
    // Use the *actual* generated type here for registration
    registerFallbackValue(MockAppUserCopyWith());
    registerFallbackValue(FakeResult());
    // registerFallbackValue(MockTopic()); // Keep if MockTopic extends Mock
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to create container - Now just takes AppUser?
  ProviderContainer createContainer({
    required List<QuizAnswer> initialQuizAnswers,
    AppUser? user, // Use AppUser interface type
    List<Topic>? topics,
    FakeSaveResultNotifier? saveResultNotifier,
    MockQuizMockDatabaseRepository? databaseRepo,
    List<Override> additionalOverrides = const [],
  }) {
    final currentSaveNotifier = saveResultNotifier ?? FakeSaveResultNotifier();
    final currentDbRepo = databaseRepo ?? MockQuizMockDatabaseRepository();
    // If no user provided, create a default *stubbed* MockAppUser
    // _createDefaultMockUser is now defined above main()
    final currentUser = user ?? _createDefaultMockUser();

    final overrides = [
      quizAnswersNotifierProvider.overrideWith(
        () => MockQuizAnswersNotifier(initialQuizAnswers),
      ),
      saveResultNotifierProvider.overrideWith(() => currentSaveNotifier),
      currentUserModelProvider.overrideWith(
        (ref) => Stream.value(UserModelState.data(currentUser)),
      ),
      quizMockDatabaseRepositoryProvider.overrideWith(
        (ref) => Future.value(currentDbRepo),
      ),
      if (topics != null)
        topicsProvider('c1').overrideWith((ref) => Future.value(topics)),
      ...additionalOverrides,
    ];
    return ProviderContainer(overrides: overrides);
  }

  group('QuizResultNotifier', () {
    // --- Initial State & Build group ---
    group('Initial State & Build', () {
      test('builds with initial state', () {
        final container = createContainer(
          initialQuizAnswers: sampleAnswersMixed,
        );
        addTearDown(container.dispose);

        container.read(quizResultNotifierProvider.notifier); // Trigger build
        final state = container.read(quizResultNotifierProvider);

        expect(state, isA<QuizResultState>());
        expect(state.selectedView, SelectedView.none);
        expect(state.expandedAnswers, isEmpty);
        expect(state.quizAnswers, equals(sampleAnswersMixed));
      });
    });

    // --- UI Interactions group ---
    group('UI Interactions', () {
      late ProviderContainer container;
      setUp(() {
        container = createContainer(initialQuizAnswers: sampleAnswersMixed);
        addTearDown(container.dispose);
      });

      // Tests for toggleView, toggleExplanation
      test('toggleView: none -> correct', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        notifier.toggleView(SelectedView.correct);
        final state = container.read(quizResultNotifierProvider);
        expect(state.selectedView, SelectedView.correct);
      });

      test('toggleView: correct -> none', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        notifier.toggleView(SelectedView.correct);
        notifier.toggleView(SelectedView.correct); // Toggle off
        final state = container.read(quizResultNotifierProvider);
        expect(state.selectedView, SelectedView.none);
      });

      test('toggleView: correct -> incorrect (with delay)', () async {
        // Arrange
        final container = createContainer(
          initialQuizAnswers: sampleAnswersMixed,
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          quizResultNotifierProvider,
          (_, __) {},
        );
        addTearDown(subscription.close);

        final notifier = container.read(quizResultNotifierProvider.notifier);

        // Act
        notifier.toggleView(SelectedView.correct);
        await container.pump();

        notifier.toggleView(SelectedView.incorrect); // Start switch

        // Optional: Prüfe den Zwischenzustand direkt nach dem zweiten Toggle
        final intermediateState = container.read(quizResultNotifierProvider);
        expect(
          intermediateState.selectedView,
          SelectedView.correct,
          reason: 'Should be correct immediately after starting switch',
        );
        expect(
          intermediateState.expandedAnswers,
          isEmpty,
          reason: 'Should be empty immediately after starting switch',
        );

        // Warte auf den Delay im Notifier
        await Future.delayed(
          const Duration(milliseconds: 300),
        ); // Länger als 200ms

        // Gib Riverpod eine Chance, den State-Update aus dem Future zu verarbeiten
        await container.pump(); // Oder await Future.delayed(Duration.zero);

        // Assert: Prüfe den finalen Zustand
        final finalState = container.read(quizResultNotifierProvider);
        expect(
          finalState.selectedView,
          SelectedView.incorrect, // <-- Sollte jetzt korrekt sein
          reason: "Should be 'incorrect' after delay",
        );
        expect(finalState.expandedAnswers, isEmpty); // Sollte leer bleiben
      });

      test(
        'toggleView: correct -> incorrect -> cancelled to none (during delay)',
        () async {
          // This test might need review depending on how cancellation should work.
          // The current implementation in the notifier (this.state=...) should handle it.
          final notifier = container.read(quizResultNotifierProvider.notifier);
          notifier.toggleView(SelectedView.correct);
          await Future.delayed(const Duration(milliseconds: 10));
          notifier.toggleView(SelectedView.incorrect); // Start switch
          await Future.delayed(
            const Duration(milliseconds: 50),
          ); // During the delay
          notifier.toggleView(
            SelectedView.correct,
          ); // Toggle original OFF -> should cancel switch and go to none
          await Future.delayed(
            const Duration(milliseconds: 300),
          ); // Wait longer than remaining delay

          final state = container.read(quizResultNotifierProvider);
          expect(
            state.selectedView,
            SelectedView.none,
            reason: "Should be 'none' after cancellation",
          );
        },
      );

      // --- toggleExplanation tests ---
      test('toggleExplanation: adds questionId', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        notifier.toggleExplanation('q1');
        expect(container.read(quizResultNotifierProvider).expandedAnswers, {
          'q1',
        });
      });

      test('toggleExplanation: removes questionId', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        notifier.toggleExplanation('q1'); // Add
        notifier.toggleExplanation('q1'); // Remove
        expect(
          container.read(quizResultNotifierProvider).expandedAnswers,
          isEmpty,
        );
      });
    });

    // --- Data Access/Filtering group ---
    group('Data Access/Filtering', () {
      late ProviderContainer container;
      setUp(() {
        container = createContainer(initialQuizAnswers: sampleAnswersMixed);
        addTearDown(container.dispose);
      });
      // Tests remain logically the same
      test('getFilteredAnswers: returns empty list for SelectedView.none', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.getFilteredAnswers(), isEmpty);
      });
      test(
        'getFilteredAnswers: returns correct answers for SelectedView.correct',
        () {
          final notifier = container.read(quizResultNotifierProvider.notifier);
          notifier.toggleView(SelectedView.correct);
          final filtered = notifier.getFilteredAnswers();
          expect(filtered.length, 1);
          expect(filtered.first.questionId, 'q1');
        },
      );
      test(
        'getFilteredAnswers: returns incorrect answers for SelectedView.incorrect',
        () {
          final notifier = container.read(quizResultNotifierProvider.notifier);
          notifier.toggleView(SelectedView.incorrect);
          final filtered = notifier.getFilteredAnswers();
          expect(filtered.length, 2);
          expect(filtered.map((a) => a.questionId), containsAll(['q2', 'q3']));
        },
      );
      test('hasCorrectAnswers: returns true when correct answers exist', () {
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.hasCorrectAnswers(), isTrue);
      });
      test(
        'hasCorrectAnswers: returns false when no correct answers exist',
        () {
          final specificContainer = createContainer(
            initialQuizAnswers: sampleAnswersAllIncorrect,
          );
          addTearDown(specificContainer.dispose);
          final notifier = specificContainer.read(
            quizResultNotifierProvider.notifier,
          );
          expect(notifier.hasCorrectAnswers(), isFalse);
        },
      );
      test(
        'hasIncorrectAnswers: returns true when incorrect answers exist',
        () {
          final notifier = container.read(quizResultNotifierProvider.notifier);
          expect(notifier.hasIncorrectAnswers(), isTrue);
        },
      );
      test(
        'hasIncorrectAnswers: returns false when no incorrect answers exist',
        () {
          final specificContainer = createContainer(
            initialQuizAnswers: sampleAnswersAllCorrect,
          );
          addTearDown(specificContainer.dispose);
          final notifier = specificContainer.read(
            quizResultNotifierProvider.notifier,
          );
          expect(notifier.hasIncorrectAnswers(), isFalse);
        },
      );
    });

    // --- Calculations group ---
    group('Calculations', () {
      // Tests remain logically the same, add addTearDown
      test('calculates points and percentage correctly for mixed results', () {
        final container = createContainer(
          initialQuizAnswers: sampleAnswersMixed,
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.calculateUserPoints(), 2);
        expect(notifier.calculateTotalPossiblePoints(), 4);
        expect(notifier.calculatePercentage(), 50.0);
        expect(notifier.isQuizPassed(), isFalse);
      });
      test('calculates points and percentage correctly for all correct', () {
        final container = createContainer(
          initialQuizAnswers: [
            quizAnswerCorrect1,
            createQuizAnswer(
              questionId: 'q4',
              correctAnswers: ['a', 'b'],
              givenAnswers: ['a', 'b'],
              pointsEarned: 2,
              possiblePoints: 2,
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.calculateUserPoints(), 3);
        expect(notifier.calculateTotalPossiblePoints(), 3);
        expect(notifier.calculatePercentage(), 100.0);
        expect(notifier.isQuizPassed(), isTrue);
      });
      test('calculates points and percentage correctly for all incorrect', () {
        final container = createContainer(
          initialQuizAnswers: sampleAnswersAllIncorrect,
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.calculateUserPoints(), 0);
        expect(notifier.calculateTotalPossiblePoints(), 1);
        expect(notifier.calculatePercentage(), 0.0);
        expect(notifier.isQuizPassed(), isFalse);
      });
      test('handles division by zero when calculating percentage', () {
        final container = createContainer(
          initialQuizAnswers: sampleAnswersEmpty,
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);
        expect(notifier.calculateUserPoints(), 0);
        expect(notifier.calculateTotalPossiblePoints(), 0);
        expect(notifier.calculatePercentage(), 0.0);
        expect(notifier.isQuizPassed(), isFalse);
      });
    });

    // --- Database Interactions group ---
    group('Database Interactions', () {
      const testCategoryId = 'c1';
      const testTopicId = 't1';
      const testUserId = 'mockUserId';

      test(
        'saveQuizResult calls saveResultNotifier with correct Result data',
        () async {
          // Arrange
          final fakeNotifier = FakeSaveResultNotifier();
          // Use default stubbed mock user
          final container = createContainer(
            initialQuizAnswers: sampleAnswersMixed,
            saveResultNotifier: fakeNotifier,
          );
          addTearDown(container.dispose);
          final notifier = container.read(quizResultNotifierProvider.notifier);

          // Act
          await notifier.saveQuizResult(
            testCategoryId,
            testTopicId,
            testUserId,
          );

          // Assert
          expect(fakeNotifier.saveResultCallCount, 1);
          final capturedResult = fakeNotifier.lastSavedResult;
          expect(capturedResult, isNotNull);
          expect(capturedResult!.categoryId, testCategoryId);
          expect(capturedResult.topicId, testTopicId);
          expect(capturedResult.userId, testUserId);
          expect(capturedResult.correct, 2);
          expect(capturedResult.total, 4);
          expect(capturedResult.score, 50.0);
          expect(capturedResult.isPassed, isFalse);
          const listEquality = DeepCollectionEquality();
          expect(
            listEquality.equals(capturedResult.quizAnswers, sampleAnswersMixed),
            isTrue,
          );
          expect(capturedResult.timestamp, isNotNull);
        },
      );

      test('saveQuizResult handles errors from saveResultNotifier', () async {
        // Arrange
        final fakeNotifier = FakeSaveResultNotifier();
        final testError = Exception('Database save failed');
        fakeNotifier.setErrorToThrowOnSave(testError);

        final container = createContainer(
          initialQuizAnswers: sampleAnswersMixed,
          saveResultNotifier: fakeNotifier,
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);

        // Act & Assert
        await expectLater(
          notifier.saveQuizResult(testCategoryId, testTopicId, testUserId),
          completes,
        );
        expect(fakeNotifier.saveResultCallCount, 1);
      });

      test('markTopicAsDone throws if repo fetch fails', () async {
        final testError = Exception('Repo fetch failed');
        // Use default stubbed user is fine here as copyWith isn't reached
        final container = createContainer(
          initialQuizAnswers: sampleAnswersMixed,
          user:
              _createDefaultMockUser(), // Or setupMockUserForCopyWith if needed
          additionalOverrides: [
            quizMockDatabaseRepositoryProvider.overrideWith(
              (ref) => Future.error(testError),
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(quizResultNotifierProvider.notifier);

        // Pass a mock user
        await expectLater(
          notifier.markTopicAsDone(
            _createDefaultMockUser(),
            testTopicId,
            testCategoryId,
          ),
          throwsA(testError),
        );
      });
    });
  });
}
