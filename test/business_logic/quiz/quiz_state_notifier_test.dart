/// This file contains the unit tests for the `QuizStateNotifier` class.
/// It tests the behavior of the `QuizStateNotifier` and its interactions with other classes.
/// The tests cover the initialization of the quiz, the state of the quiz, and the interactions with the repository and the answers notifier.
/// The tests are written using the `flutter_test` package and the `mocktail` package for mocking dependencies.
/// The `FakeAnswersNotifier` class is used as a fake implementation of the `AnswersNotifier` class for testing purposes.
/// The `MockQuizMockDatabaseRepository` class is used as a mock implementation of the `QuizMockDatabaseRepository` class for testing purposes.
/// The tests are organized into different groups to test different scenarios and edge cases.
/// The `setUpAll` function is used to set up the necessary dependencies and fallback values for the tests.
/// The `createContainer` function is a helper function to create a new provider container with test-specific overrides.
/// The `initViewModel` function is a helper function to initialize the view model for the tests.
/// The `group` function is used to group related tests together.
/// The `test` function is used to define individual test cases.
/// The tests cover the initial state of the quiz, the initialization of the quiz with questions, and the behavior when trying to initialize the quiz multiple times or with an empty questions list.
library;

import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state.dart';
import 'package:brain_bench/business_logic/quiz/quiz_state_notifier.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:brain_bench/data/repositories/database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' hide Answer;

// --- Mocks ---

// Mock for the Repository dependency
class MockDatabaseRepository extends Mock implements DatabaseRepository {}

// --- FAKE Implementation for AnswersNotifier ---
// Accepts optional initial state via constructor
class FakeAnswersNotifier extends Notifier<List<Answer>>
    implements AnswersNotifier {
  // Optional initial state
  final List<Answer> initialAnswers;
  FakeAnswersNotifier([
    this.initialAnswers = const [],
  ]); // Default to empty list

  // build returns the initial state provided via constructor
  @override
  List<Answer> build() {
    return initialAnswers;
  }

  // Counters for testing interactions (optional)
  int initializeAnswersCallCount = 0;
  List<Answer>? lastInitializedAnswers;
  int resetAnswersCallCount = 0;
  int toggleAnswerCallCount = 0;
  String? lastToggledAnswerId;
  int toggleAnswerSelectionCallCount = 0;
  String? lastToggledSelectionAnswerId;
  bool? lastToggledSelectionIsMultiple;

  // Methods now update the state managed by Riverpod
  @override
  void initializeAnswers(List<Answer> answers) {
    initializeAnswersCallCount++;
    lastInitializedAnswers = answers;
    state = answers; // Update Riverpod's state
  }

  @override
  void resetAnswers() {
    resetAnswersCallCount++;
    state = []; // Update Riverpod's state
  }

  @override
  void toggleAnswer(String answerId) {
    toggleAnswerCallCount++;
    lastToggledAnswerId = answerId;
    state =
        state.map((answer) {
          if (answer.id == answerId) {
            return answer.copyWith(isSelected: !answer.isSelected);
          }
          return answer;
        }).toList();
  }

  @override
  List<Answer> get selectedAnswers {
    // Access Riverpod's state
    return state.where((answer) => answer.isSelected).toList();
  }

  @override
  void toggleAnswerSelection(String answerId, bool isMultipleChoice) {
    toggleAnswerSelectionCallCount++;
    lastToggledSelectionAnswerId = answerId;
    lastToggledSelectionIsMultiple = isMultipleChoice;
    if (!isMultipleChoice) {
      state =
          state.map((answer) {
            return answer.copyWith(isSelected: answer.id == answerId);
          }).toList();
    } else {
      state =
          state.map((answer) {
            return answer.id == answerId
                ? answer.copyWith(isSelected: !answer.isSelected)
                : answer;
          }).toList();
    }
  }
}
// --- END OF FAKE ---

// --- Test Data ---
final mockQuestion1 = Question(
  id: 'q1',
  questionEn: 'Question 1 EN',
  questionDe: 'Frage 1 DE',
  answerIds: ['a1', 'a2'],
  explanationEn: 'Expl 1 EN',
  explanationDe: 'Erkl 1 DE',
  type: QuestionType.singleChoice,
  topicId: 't1',
);

final mockQuestion2 = Question(
  id: 'q2',
  questionEn: 'Question 2 EN',
  questionDe: 'Frage 2 DE',
  answerIds: ['a3', 'a4'],
  explanationEn: 'Expl 2 EN',
  explanationDe: 'Erkl 2 DE',
  type: QuestionType.multipleChoice,
  topicId: 't1',
);

final mockAnswer1 = Answer(
  id: 'a1',
  textEn: 'Answer 1 EN',
  textDe: 'Answer 1 DE',
  isCorrect: true,
  isSelected: false,
);
final mockAnswer2 = Answer(
  id: 'a2',
  textEn: 'Answer 2 EN',
  textDe: 'Answer 2 DE',
  isCorrect: false,
  isSelected: false,
);
final mockAnswer3 = Answer(
  id: 'a3',
  textEn: 'Answer 3 EN',
  textDe: 'Answer 3 DE',
  isCorrect: true,
  isSelected: false,
);
final mockAnswer4 = Answer(
  id: 'a4',
  textEn: 'Answer 4 EN',
  textDe: 'Answer 4 DE',
  isCorrect: true,
  isSelected: false,
);

final mockAnswersQ1 = [mockAnswer1, mockAnswer2];
final mockAnswersQ2 = [mockAnswer3, mockAnswer4];

void main() {
  // Declare mock repository needed across tests/setup
  late MockDatabaseRepository mockRepository;
  // No global fake instance needed anymore

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(<String>[]);
  });

  // Function to create a new container with overrides for each test
  ProviderContainer createContainer({
    // Allow providing test-specific overrides, e.g., for the FakeAnswersNotifier
    List<Override> overrides = const [],
  }) {
    // Create fresh mock repository for each test run
    mockRepository = MockDatabaseRepository();

    // Define the default overrides used in most tests
    final defaultOverrides = [
      // Override the repository provider
      quizFirebaseRepositoryProvider.overrideWith((ref) => mockRepository),
      // Default override for the answers notifier (creates fake with empty initial state)
      answersNotifierProvider.overrideWith(() => FakeAnswersNotifier()),
    ];

    // Create the container, combining default and test-specific overrides
    final container = ProviderContainer(
      overrides: [...defaultOverrides, ...overrides],
    );
    // Ensure container disposal after each test
    addTearDown(container.dispose);
    return container;
  }

  // Helper to initialize the view model for tests
  Future<void> initViewModel(
    ProviderContainer container,
    List<Question> questions,
  ) async {
    when(
      () => mockRepository.getAnswers(questions.first.answerIds),
    ).thenAnswer((_) async => mockAnswersQ1); // Use appropriate mock answers

    final viewModel = container.read(quizStateNotifierProvider.notifier);
    await viewModel.initializeQuizIfNeeded(questions);
    await container.pump(); // Allow futures to complete
  }

  group('QuizViewModel Tests', () {
    test('Initial state is correct', () {
      final container = createContainer(); // Use default overrides
      final initialState = container.read(quizStateNotifierProvider);

      // Assert initial state properties
      expect(initialState, QuizState.initial());
      expect(initialState.questions, isEmpty);
      expect(initialState.currentIndex, -1);
      expect(initialState.correctAnswers, isEmpty);
      expect(initialState.incorrectAnswers, isEmpty);
      expect(initialState.missedCorrectAnswers, isEmpty);
      expect(initialState.isLoadingAnswers, false);
    });

    group('initializeQuizIfNeeded', () {
      test('Initializes correctly with questions', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];

        // Arrange: Stub repository
        when(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).thenAnswer((_) async => mockAnswersQ1);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.initializeQuizIfNeeded(questions);
        await container.pump(); // Settle futures

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state.questions, questions);
        expect(state.currentIndex, 0);
        expect(
          state.isLoadingAnswers,
          false,
        ); // Should be false after completion

        // Assert Interactions
        verify(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).called(1);
        // Check the state of the overridden notifier
        final answersState = container.read(answersNotifierProvider);
        expect(answersState, mockAnswersQ1);
      });

      test('Does not initialize if already initialized', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1];

        // Arrange: Initialize first using the helper
        await initViewModel(container, questions);

        // Arrange: Stub repository for potential unexpected second call
        when(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).thenAnswer((_) async => mockAnswersQ1);

        // Act: Try to initialize again
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.initializeQuizIfNeeded(questions);
        await container.pump();

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state.currentIndex, 0); // Should remain the same

        // Assert Interactions (should not call repo again)
        // Verify checks total calls since mock creation
        verify(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).called(1);
      });

      test('Does not initialize if questions list is empty', () async {
        final container = createContainer(); // Use default overrides
        final List<Question> questions = [];

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.initializeQuizIfNeeded(questions);
        await container.pump();

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state, QuizState.initial()); // Should remain initial

        // Assert Interactions
        verifyNever(() => mockRepository.getAnswers(any()));
      });

      test('Handles error during answer fetching', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1];
        final testError = Exception('Failed to fetch');

        // Arrange: Stub repository to throw
        when(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).thenThrow(testError);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.initializeQuizIfNeeded(questions);
        await container.pump();

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state.questions, questions); // Questions should be set
        expect(state.currentIndex, 0); // Index should be set
        expect(state.isLoadingAnswers, false); // Should be false after error

        // Assert Interactions
        verify(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).called(1);
        // Check the state of the overridden notifier (should be reset)
        final answersState = container.read(answersNotifierProvider);
        expect(answersState, isEmpty);
      });
    });

    group('Progress and Navigation', () {
      test('getProgress returns correct percentage', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];
        await initViewModel(
          container,
          questions,
        ); // Initialize with 2 questions, index 0

        final viewModel = container.read(quizStateNotifierProvider.notifier);
        expect(viewModel.getProgress(), 0.5); // 1 / 2

        // Arrange for next question
        when(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).thenAnswer((_) async => mockAnswersQ2);

        // Act: Move to next question
        await viewModel.loadNextQuestion();
        await container.pump();

        // Assert
        expect(viewModel.getProgress(), 1.0); // 2 / 2
        // Optional: Check counters if needed
        // final fakeNotifier = container.read(answersNotifierProvider.notifier) as FakeAnswersNotifier;
        // expect(fakeNotifier.initializeAnswersCallCount, 1); // Called once for loadNextQuestion after initViewModel reset
      });

      test('getProgress returns 0 for empty quiz or initial state', () {
        final container = createContainer(); // Use default overrides
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        expect(viewModel.getProgress(), 0.0); // Initial state
      });

      test('hasNextQuestion returns true when not on last question', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];
        await initViewModel(container, questions); // Initialize, index 0

        final viewModel = container.read(quizStateNotifierProvider.notifier);
        expect(viewModel.hasNextQuestion(), isTrue);
      });

      test('hasNextQuestion returns false when on last question', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];
        await initViewModel(container, questions); // Initialize, index 0

        // Arrange for next question
        when(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).thenAnswer((_) async => mockAnswersQ2);

        // Act: Move to next (last) question
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.loadNextQuestion();
        await container.pump(); // Settle loadNextQuestion

        // Assert
        expect(viewModel.hasNextQuestion(), isFalse); // Now on index 1 of 2
      });

      test(
        'hasNextQuestion returns false for empty or single question quiz',
        () async {
          final container = createContainer(); // Use default overrides
          final viewModel = container.read(quizStateNotifierProvider.notifier);
          expect(viewModel.hasNextQuestion(), isFalse); // Initial empty

          // Test with single question
          final questionsSingle = [mockQuestion1];
          await initViewModel(
            container,
            questionsSingle,
          ); // Initialize with 1 question
          expect(viewModel.hasNextQuestion(), isFalse);
        },
      );

      test('loadNextQuestion updates index and fetches answers', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];
        await initViewModel(container, questions); // Initialize, index 0

        // Arrange: Stub calls for the *second* question
        when(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).thenAnswer((_) async => mockAnswersQ2);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.loadNextQuestion();
        await container.pump();

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state.currentIndex, 1); // Index should be updated
        expect(
          state.isLoadingAnswers,
          false,
        ); // Should be false after completion

        // Assert Interactions
        verify(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).called(1);
        // Check the state of the overridden notifier
        final answersState = container.read(answersNotifierProvider);
        expect(answersState, mockAnswersQ2);
      });

      test('loadNextQuestion does nothing if no next question', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1]; // Only one question
        await initViewModel(container, questions); // Initialize, index 0

        final initialState = container.read(quizStateNotifierProvider);

        // Arrange: Stub for potential unexpected call
        when(
          () => mockRepository.getAnswers(any()),
        ).thenAnswer((_) async => []);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.loadNextQuestion();
        await container.pump();
        // Assert State (should not change)
        final finalState = container.read(quizStateNotifierProvider);
        expect(finalState.currentIndex, initialState.currentIndex);
        expect(finalState.isLoadingAnswers, false); // Should remain false

        // Assert Interactions (should not fetch again)
        verify(
          () => mockRepository.getAnswers(mockQuestion1.answerIds),
        ).called(1); // Only the one from initViewModel
        verifyNever(() => mockRepository.getAnswers(mockQuestion2.answerIds));
      });

      test('loadNextQuestion handles error fetching next answers', () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1, mockQuestion2];
        await initViewModel(container, questions); // Initialize, index 0
        final testError = Exception('Failed to fetch next');

        // Arrange: Stub repo to throw for *second* question
        when(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).thenThrow(testError);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        await viewModel.loadNextQuestion();
        await container.pump();

        // Assert State
        final state = container.read(quizStateNotifierProvider);
        expect(state.currentIndex, 1); // Index should update
        expect(state.isLoadingAnswers, false); // Should be false after error
        // Assert Interactions
        verify(
          () => mockRepository.getAnswers(mockQuestion2.answerIds),
        ).called(1);
        // Check the state of the overridden notifier (should be reset)
        final answersState = container.read(answersNotifierProvider);
        expect(answersState, isEmpty);
      });
    });

    group('checkAnswers', () {
      test(
        'Correctly identifies correct, incorrect, and missed answers',
        () async {
          final testAnswers = [
            Answer(
              id: 'a1',
              textDe: 'Richtig',
              textEn: 'Correct',
              isCorrect: true,
              isSelected: true,
            ),
            Answer(
              id: 'a2',
              textDe: 'Falsch',
              textEn: 'Incorrect',
              isCorrect: false,
              isSelected: true,
            ),
            Answer(
              id: 'a3',
              textDe: 'Vermissen',
              textEn: 'Missed',
              isCorrect: true,
              isSelected: false,
            ),
            Answer(
              id: 'a4',
              textDe: 'Nicht Richtig',
              textEn: 'Not Correct',
              isCorrect: false,
              isSelected: false,
            ),
          ];

          final container = createContainer(
            overrides: [
              answersNotifierProvider.overrideWith(
                () => FakeAnswersNotifier(testAnswers),
              ),
            ],
          );

          // Arrange: Initialer Zustand des ViewModels
          final viewModel = container.read(quizStateNotifierProvider.notifier);
          final initialState = QuizState.initial().copyWith(
            questions: [mockQuestion1],
            currentIndex: 0,
          );
          viewModel.state = initialState;

          final expectedState = initialState.copyWith(
            correctAnswers: ['a1'],
            incorrectAnswers: ['a2'],
            missedCorrectAnswers: ['a3'],
          );

          // Act
          viewModel.checkAnswers();
          await container.pump(); // Allow state update propagation

          // Assert
          expect(
            viewModel.state,
            expectedState,
            reason:
                'The viewModel state should match the expected state after checkAnswers',
          );
        },
      );

      test('Handles empty answers list', () async {
        final container = createContainer();
        final viewModel = container.read(quizStateNotifierProvider.notifier);

        // Arrange: Set initial VM state
        final initialState = QuizState.initial().copyWith(
          questions: [mockQuestion1],
          currentIndex: 0,
        );
        viewModel.state = initialState;

        // Define expected state (should have empty lists)
        final expectedState = initialState.copyWith(
          correctAnswers: [],
          incorrectAnswers: [],
          missedCorrectAnswers: [],
        );

        // Act
        viewModel.checkAnswers();
        await container.pump();

        // Assert direkt
        expect(viewModel.state, expectedState);
      });
    }); // End group 'checkAnswers'

    test(
      'resetQuiz resets state and calls answersNotifier.resetAnswers',
      () async {
        final container = createContainer(); // Use default overrides
        final questions = [mockQuestion1];

        // Arrange: Initialize
        await initViewModel(container, questions);

        // Act
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        viewModel.resetQuiz();
        // No pump needed for synchronous reset

        // Assert State
        expect(container.read(quizStateNotifierProvider), QuizState.initial());

        // Assert Interactions (check state of the overridden notifier)
        final answersState = container.read(answersNotifierProvider);
        expect(answersState, isEmpty); // State should be reset
      },
    );

    group('getAllCorrectAnswersForCurrentQuestion', () {
      test('Returns correct answer texts for the specified language', () async {
        final testAnswers = [
          Answer(
            id: 'a1',
            textEn: 'Correct 1 EN',
            textDe: 'Richtig 1 DE',
            isCorrect: true,
            isSelected: false,
          ),
          Answer(
            id: 'a2',
            textEn: 'Incorrect EN',
            textDe: 'Falsch DE',
            isCorrect: false,
            isSelected: true,
          ),
          Answer(
            id: 'a3',
            textEn: 'Correct 2 EN',
            textDe: 'Richtig 2 DE',
            isCorrect: true,
            isSelected: false,
          ),
        ];
        final container = createContainer(
          overrides: [
            answersNotifierProvider.overrideWith(
              () => FakeAnswersNotifier(testAnswers),
            ),
          ],
        );

        // Arrange: Set VM state (optional, if needed by the method)
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        viewModel.state = QuizState.initial().copyWith(
          questions: [mockQuestion1],
          currentIndex: 0,
        );

        const langDe = 'de';
        const langEn = 'en';

        // Act & Assert DE
        final correctDe = viewModel.getAllCorrectAnswersForCurrentQuestion(
          langDe,
        );
        expect(correctDe, ['Richtig 1 DE', 'Richtig 2 DE']);

        // Act & Assert EN
        final correctEn = viewModel.getAllCorrectAnswersForCurrentQuestion(
          langEn,
        );
        expect(correctEn, ['Correct 1 EN', 'Correct 2 EN']);
      });

      test('Returns empty list when answers notifier is empty', () async {
        final container = createContainer();
        final viewModel = container.read(quizStateNotifierProvider.notifier);
        viewModel.state = QuizState.initial().copyWith(
          questions: [mockQuestion1],
          currentIndex: 0,
        ); // Set VM state
        const lang = 'en';

        // Act
        final correctAnswers = viewModel.getAllCorrectAnswersForCurrentQuestion(
          lang,
        );

        // Assert
        expect(correctAnswers, isEmpty);
      });
    });
  }); // End group 'QuizViewModel Tests'
} // End main
