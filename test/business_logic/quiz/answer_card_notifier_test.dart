import 'package:brain_bench/business_logic/quiz/answer_card_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnswerCardExpanded Notifier', () {
    // Define some test question IDs
    const questionId1 = 'q1';
    const questionId2 = 'q2';

    late ProviderContainer container;

    // Create a new container before each test for isolation
    setUp(() {
      container = ProviderContainer();
      // Ensure the container is disposed after each test
      addTearDown(container.dispose);
    });

    test('initial state is false for a given questionId', () {
      // Act: Read the initial state for questionId1
      final initialState = container.read(
        answerCardExpandedProvider(questionId1),
      );

      // Assert: Verify the initial state is false
      expect(initialState, isFalse);
    });

    test('toggle changes state from false to true', () {
      // Arrange: Get the notifier for questionId1
      final notifier = container.read(
        answerCardExpandedProvider(questionId1).notifier,
      );
      // Verify initial state (optional but good practice)
      expect(container.read(answerCardExpandedProvider(questionId1)), isFalse);

      // Act: Call the toggle method
      notifier.toggle();

      // Assert: Verify the state is now true
      expect(container.read(answerCardExpandedProvider(questionId1)), isTrue);
    });

    test('toggle changes state from true to false', () {
      // Arrange: Get the notifier and toggle once to set state to true
      final notifier = container.read(
        answerCardExpandedProvider(questionId1).notifier,
      );
      notifier.toggle();
      // Verify intermediate state
      expect(container.read(answerCardExpandedProvider(questionId1)), isTrue);

      // Act: Call the toggle method again
      notifier.toggle();

      // Assert: Verify the state is now false
      expect(container.read(answerCardExpandedProvider(questionId1)), isFalse);
    });

    test('state for different questionIds is independent', () {
      // Arrange: Get notifiers for two different question IDs
      final notifier1 = container.read(
        answerCardExpandedProvider(questionId1).notifier,
      );
      final notifier2 = container.read(
        answerCardExpandedProvider(questionId2).notifier,
      );

      // Verify initial states for both are false
      expect(container.read(answerCardExpandedProvider(questionId1)), isFalse);
      expect(container.read(answerCardExpandedProvider(questionId2)), isFalse);

      // Act: Toggle the state only for the first question ID
      notifier1.toggle();

      // Assert:
      // State for questionId1 should be true
      expect(container.read(answerCardExpandedProvider(questionId1)), isTrue);
      // State for questionId2 should remain false
      expect(container.read(answerCardExpandedProvider(questionId2)), isFalse);

      // Act again: Toggle the second one
      notifier2.toggle();

      // Assert:
      // State for questionId1 should still be true
      expect(container.read(answerCardExpandedProvider(questionId1)), isTrue);
      // State for questionId2 should now be true
      expect(container.read(answerCardExpandedProvider(questionId2)), isTrue);
    });
  });
}
