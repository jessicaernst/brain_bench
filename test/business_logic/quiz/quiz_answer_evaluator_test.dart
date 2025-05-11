import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';

// --- Fake Data ---

// Helper function to create new Answer objects for testing
Answer createFakeAnswer({
  required String id,
  required String textEn,
  required String textDe,
  required bool isCorrect,
  bool isSelected = false,
}) {
  return Answer(
    id: id,
    textEn: textEn,
    textDe: textDe,
    isCorrect: isCorrect,
    isSelected: isSelected,
  );
}

// Updated Sample lists of fake answers using the new model
final List<Answer> fakeAnswers1 = [
  createFakeAnswer(
    id: 'a1',
    textEn: 'Answer 1 EN',
    textDe: 'Antwort 1 DE',
    isCorrect: true,
  ),
  createFakeAnswer(
    id: 'a2',
    textEn: 'Answer 2 EN',
    textDe: 'Antwort 2 DE',
    isCorrect: false,
  ),
  createFakeAnswer(
    id: 'a3',
    textEn: 'Answer 3 EN',
    textDe: 'Antwort 3 DE',
    isCorrect: false,
  ),
];

final List<Answer> fakeAnswers2 = [
  createFakeAnswer(
    id: 'b1',
    textEn: 'Another Answer 1 EN',
    textDe: 'Andere Antwort 1 DE',
    isCorrect: false,
  ),
  createFakeAnswer(
    id: 'b2',
    textEn: 'Another Answer 2 EN',
    textDe: 'Andere Antwort 2 DE',
    isCorrect: true,
  ),
];

void main() {
  group('AnswersNotifier', () {
    late ProviderContainer container;
    late AnswersNotifier notifier;

    // Set up a new container and notifier before each test
    setUp(() {
      container = ProviderContainer();
      // Read the notifier instance to interact with its methods
      notifier = container.read(answersNotifierProvider.notifier);
      // Ensure container is disposed after each test
      addTearDown(container.dispose);
    });

    test('initial state is an empty list', () {
      // Act: Read the initial state
      final initialState = container.read(answersNotifierProvider);

      // Assert: Verify the state is an empty list
      expect(initialState, isEmpty);
      expect(initialState, isA<List<Answer>>());
    });

    group('initializeAnswers', () {
      test('sets the state to the provided list of answers', () {
        // Act: Initialize the notifier with fakeAnswers1
        notifier.initializeAnswers(fakeAnswers1);

        // Assert: Verify the state is now fakeAnswers1
        final currentState = container.read(answersNotifierProvider);
        expect(currentState, isNotEmpty);
        expect(currentState.length, fakeAnswers1.length);
        // Use ListEquality to compare list contents
        const listEquality = ListEquality();
        expect(listEquality.equals(currentState, fakeAnswers1), isTrue);
      });

      test('does not re-initialize if the same answers (by ID) are provided', () {
        // Arrange: Initialize once with fakeAnswers1
        notifier.initializeAnswers(fakeAnswers1);
        container.read(answersNotifierProvider);
        // Modify the list content slightly but keep IDs the same to test equality check
        final sameIdsDifferentContent = [
          createFakeAnswer(
            id: 'a1',
            textEn: 'Answer 1 EN Modified',
            textDe: 'Antwort 1 DE Modifiziert',
            isCorrect: true,
          ), // Different text
          createFakeAnswer(
            id: 'a2',
            textEn: 'Answer 2 EN',
            textDe: 'Antwort 2 DE',
            isCorrect: false,
          ),
          createFakeAnswer(
            id: 'a3',
            textEn: 'Answer 3 EN',
            textDe: 'Antwort 3 DE',
            isCorrect: false,
          ),
        ];

        // Act: Attempt to initialize again with a list having the same IDs
        notifier.initializeAnswers(sameIdsDifferentContent);

        // Assert: Verify the state is still the *original* fakeAnswers1 list
        // because the IDs matched, and re-initialization was skipped.
        final currentState = container.read(answersNotifierProvider);
        const listEquality = ListEquality();
        expect(listEquality.equals(currentState, fakeAnswers1), isTrue);
        // Also verify it's NOT the modified list
        expect(
          listEquality.equals(currentState, sameIdsDifferentContent),
          isFalse,
        );
      });

      test('re-initializes if different answers (by ID) are provided', () {
        // Arrange: Initialize once with fakeAnswers1
        notifier.initializeAnswers(fakeAnswers1);
        final firstState = container.read(answersNotifierProvider);
        expect(firstState.length, fakeAnswers1.length);

        // Act: Initialize again with fakeAnswers2 (different IDs)
        notifier.initializeAnswers(fakeAnswers2);

        // Assert: Verify the state is now fakeAnswers2
        final currentState = container.read(answersNotifierProvider);
        expect(currentState, isNotEmpty);
        expect(currentState.length, fakeAnswers2.length);
        const listEquality = ListEquality();
        expect(listEquality.equals(currentState, fakeAnswers2), isTrue);
      });
    });

    group('toggleAnswerSelection', () {
      // Initialize with fakeAnswers1 for these tests
      setUp(() {
        container = ProviderContainer();
        notifier = container.read(answersNotifierProvider.notifier);
        addTearDown(container.dispose);
        // Initialize the state before each toggle test
        // Create a deep copy for initialization to avoid modifying the original list
        final initialAnswers =
            fakeAnswers1.map((a) => a.copyWith(isSelected: false)).toList();
        notifier.initializeAnswers(initialAnswers);
        // Verify initial state (all not selected)
        expect(
          container.read(answersNotifierProvider).every((a) => !a.isSelected),
          isTrue,
        );
      });

      test(
        'toggles selection for a single answer (isMultipleChoice: true)',
        () {
          // Arrange: State is initialized with fakeAnswers1 (all not selected)
          const answerIdToToggle = 'a2';

          // Act: Toggle answer 'a2' with multiple choice enabled
          notifier.toggleAnswerSelection(answerIdToToggle, true);

          // Assert: Only answer 'a2' should be selected
          final currentState = container.read(answersNotifierProvider);
          expect(
            currentState.firstWhere((a) => a.id == 'a1').isSelected,
            isFalse,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a2').isSelected,
            isTrue,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a3').isSelected,
            isFalse,
          );
        },
      );

      test('deselects other answers when isMultipleChoice is false', () {
        // Arrange: Select 'a1' first
        notifier.toggleAnswerSelection('a1', true);
        expect(
          container
              .read(answersNotifierProvider)
              .firstWhere((a) => a.id == 'a1')
              .isSelected,
          isTrue,
        );
        expect(
          container
              .read(answersNotifierProvider)
              .firstWhere((a) => a.id == 'a2')
              .isSelected,
          isFalse,
        );

        // Act: Toggle answer 'a2' with multiple choice disabled
        notifier.toggleAnswerSelection('a2', false);

        // Assert: 'a1' should be deselected, and 'a2' should be selected
        final currentState = container.read(answersNotifierProvider);
        expect(
          currentState.firstWhere((a) => a.id == 'a1').isSelected,
          isFalse,
        );
        expect(currentState.firstWhere((a) => a.id == 'a2').isSelected, isTrue);
        expect(
          currentState.firstWhere((a) => a.id == 'a3').isSelected,
          isFalse,
        );
      });

      test(
        'deselects the answer if it is already selected (isMultipleChoice: true)',
        () {
          // Arrange: Select 'a2' first
          notifier.toggleAnswerSelection('a2', true);
          expect(
            container
                .read(answersNotifierProvider)
                .firstWhere((a) => a.id == 'a2')
                .isSelected,
            isTrue,
          );

          // Act: Toggle answer 'a2' again with multiple choice enabled
          notifier.toggleAnswerSelection('a2', true);

          // Assert: Answer 'a2' should now be deselected
          final currentState = container.read(answersNotifierProvider);
          expect(
            currentState.firstWhere((a) => a.id == 'a1').isSelected,
            isFalse,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a2').isSelected,
            isFalse,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a3').isSelected,
            isFalse,
          );
        },
      );

      test(
        'selects the answer if it is already selected (isMultipleChoice: false)',
        () {
          // Arrange: Select 'a2' first (using false to ensure others are deselected)
          notifier.toggleAnswerSelection('a2', false);
          expect(
            container
                .read(answersNotifierProvider)
                .firstWhere((a) => a.id == 'a2')
                .isSelected,
            isTrue,
          );
          expect(
            container
                .read(answersNotifierProvider)
                .where((a) => a.isSelected)
                .length,
            1,
          );

          // Act: Toggle answer 'a2' again with multiple choice disabled
          // This should effectively keep 'a2' selected and others deselected
          notifier.toggleAnswerSelection('a2', false);

          // Assert: Answer 'a2' should remain selected, others deselected
          final currentState = container.read(answersNotifierProvider);
          expect(
            currentState.firstWhere((a) => a.id == 'a1').isSelected,
            isFalse,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a2').isSelected,
            isTrue,
          );
          expect(
            currentState.firstWhere((a) => a.id == 'a3').isSelected,
            isFalse,
          );
          expect(currentState.where((a) => a.isSelected).length, 1);
        },
      );

      test('does nothing if the answerId does not exist', () {
        // Arrange: State is initialized with fakeAnswers1 (all not selected)
        const nonExistentAnswerId = 'non-existent-id';
        // Make a copy of the initial state for comparison
        final initialState = List<Answer>.from(
          container.read(answersNotifierProvider),
        );

        // Act: Attempt to toggle a non-existent answer
        notifier.toggleAnswerSelection(nonExistentAnswerId, true);
        notifier.toggleAnswerSelection(nonExistentAnswerId, false);

        // Assert: The state should remain unchanged
        final currentState = container.read(answersNotifierProvider);
        const listEquality = ListEquality();
        // Compare the current state list with the initial state list
        expect(listEquality.equals(currentState, initialState), isTrue);
        expect(currentState.every((a) => !a.isSelected), isTrue);
      });
    });

    group('resetAnswers', () {
      test('sets isSelected to false for all answers', () {
        // Arrange: Initialize and select some answers
        notifier.initializeAnswers(fakeAnswers1);
        notifier.toggleAnswerSelection('a1', true);
        notifier.toggleAnswerSelection('a3', true);
        // Verify some are selected
        expect(
          container
              .read(answersNotifierProvider)
              .where((a) => a.isSelected)
              .length,
          2,
        );

        // Act: Reset all answers
        notifier.resetAnswers();

        // Assert: All answers should now be deselected
        final currentState = container.read(answersNotifierProvider);
        expect(currentState.every((a) => !a.isSelected), isTrue);
        expect(currentState.where((a) => a.isSelected).length, 0);
      });

      test('does nothing if the state is already empty', () {
        // Arrange: State is initially empty

        // Act: Call resetAnswers on an empty state
        notifier.resetAnswers();

        // Assert: State remains empty
        expect(container.read(answersNotifierProvider), isEmpty);
      });
    });

    group('selectedAnswers getter', () {
      test('returns an empty list when no answers are selected', () {
        // Arrange: Initialize state (all not selected by default)
        notifier.initializeAnswers(fakeAnswers1);

        // Act: Get selected answers
        final selected = notifier.selectedAnswers;

        // Assert: The list should be empty
        expect(selected, isEmpty);
      });

      test('returns a list of only the selected answers', () {
        // Arrange: Initialize and select some answers
        notifier.initializeAnswers(fakeAnswers1);
        notifier.toggleAnswerSelection('a1', true);
        notifier.toggleAnswerSelection('a3', true);

        // Act: Get selected answers
        final selected = notifier.selectedAnswers;

        // Assert: The list should contain only 'a1' and 'a3'
        expect(selected.length, 2);
        expect(selected.any((a) => a.id == 'a1'), isTrue);
        expect(selected.any((a) => a.id == 'a3'), isTrue);
        expect(
          selected.any((a) => a.id == 'a2'),
          isFalse,
        ); // Ensure non-selected is not included
      });

      test('returns an empty list if the state is empty', () {
        // Act: Get selected answers
        final selected = notifier.selectedAnswers;

        // Assert: The list should be empty
        expect(selected, isEmpty);
      });
    });

    group('toggleAnswer (deprecated)', () {
      // Initialize with fakeAnswers1 for these tests
      setUp(() {
        container = ProviderContainer();
        notifier = container.read(answersNotifierProvider.notifier);
        addTearDown(container.dispose);
        // Initialize the state before each toggle test
        // Create a deep copy for initialization
        final initialAnswers =
            fakeAnswers1.map((a) => a.copyWith(isSelected: false)).toList();
        notifier.initializeAnswers(initialAnswers);
        // Verify initial state (all not selected)
        expect(
          container.read(answersNotifierProvider).every((a) => !a.isSelected),
          isTrue,
        );
      });

      test('toggles selection for a single answer', () {
        // Arrange: State is initialized with fakeAnswers1 (all not selected)
        const answerIdToToggle = 'a2';

        // Act: Toggle answer 'a2'
        notifier.toggleAnswer(answerIdToToggle);

        // Assert: Only answer 'a2' should be selected
        final currentState = container.read(answersNotifierProvider);
        expect(
          currentState.firstWhere((a) => a.id == 'a1').isSelected,
          isFalse,
        );
        expect(currentState.firstWhere((a) => a.id == 'a2').isSelected, isTrue);
        expect(
          currentState.firstWhere((a) => a.id == 'a3').isSelected,
          isFalse,
        );
      });

      test('deselects the answer if it is already selected', () {
        // Arrange: Select 'a2' first
        notifier.toggleAnswer('a2');
        expect(
          container
              .read(answersNotifierProvider)
              .firstWhere((a) => a.id == 'a2')
              .isSelected,
          isTrue,
        );

        // Act: Toggle answer 'a2' again
        notifier.toggleAnswer('a2');

        // Assert: Answer 'a2' should now be deselected
        final currentState = container.read(answersNotifierProvider);
        expect(
          currentState.firstWhere((a) => a.id == 'a1').isSelected,
          isFalse,
        );
        expect(
          currentState.firstWhere((a) => a.id == 'a2').isSelected,
          isFalse,
        );
        expect(
          currentState.firstWhere((a) => a.id == 'a3').isSelected,
          isFalse,
        );
      });

      test('does nothing if the answerId does not exist', () {
        // Arrange: State is initialized with fakeAnswers1 (all not selected)
        const nonExistentAnswerId = 'non-existent-id';
        // Make a copy of the initial state for comparison
        final initialState = List<Answer>.from(
          container.read(answersNotifierProvider),
        );

        // Act: Attempt to toggle a non-existent answer
        notifier.toggleAnswer(nonExistentAnswerId);

        // Assert: The state should remain unchanged
        final currentState = container.read(answersNotifierProvider);
        const listEquality = ListEquality();
        expect(listEquality.equals(currentState, initialState), isTrue);
        expect(
          currentState.every((a) => !a.isSelected),
          isTrue,
        ); // Still all not selected
      });
    });
  });
}
