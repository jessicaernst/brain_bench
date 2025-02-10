import 'package:brain_bench/data/models/answer.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'answers_notifier.g.dart';

final Logger _logger = Logger('AnswersNotifier');

@riverpod
class AnswersNotifier extends _$AnswersNotifier {
  @override
  List<Answer> build() {
    _logger.info('AnswersNotifier initialized with an empty state.');
    return [];
  }

  /// Initialize the list of answers at the start of a quiz
  void initializeAnswers(List<Answer> initialAnswers) {
    final currentAnswerIds = state.map((answer) => answer.id).toList();
    final newAnswerIds = initialAnswers.map((answer) => answer.id).toList();

    if (currentAnswerIds.isNotEmpty && currentAnswerIds.equals(newAnswerIds)) {
      _logger.info(
          '🔹 Answers are already initialized for this question, skipping re-initialization.');
      return; // Prevent resetting if the same question's answers are already loaded
    }

    _logger
        .info('🔄 Initializing answers with ${initialAnswers.length} items.');
    state = initialAnswers;
  }

  /// Toggle the `isSelected` state of a specific answer by its ID
  void toggleAnswer(String answerId) {
    _logger.info('Toggling answer selection for ID: $answerId');
    state = state.map((answer) {
      if (answer.id == answerId) {
        _logger.fine(
            '𝌡 Answer ${answer.id} selection changed to: ${!answer.isSelected}');
        return answer.copyWith(isSelected: !answer.isSelected);
      }
      return answer;
    }).toList();
  }

  /// Reset all answers' `isSelected` states to `false`
  void resetAnswers() {
    _logger.info('Resetting all answers.');
    state = state.map((answer) {
      _logger.fine('Resetting answer ${answer.id} selection to false.');
      return answer.copyWith(isSelected: false);
    }).toList();
  }

  /// Get a list of all selected answers
  List<Answer> get selectedAnswers {
    final selected = state.where((answer) => answer.isSelected).toList();
    _logger.info('Retrieved ${selected.length} selected answers.');
    return selected;
  }

  // Toggle the `isSelected` state of a specific answer by its ID
  void toggleAnswerSelection(String answerId, bool isMultipleChoice) {
    state = state.map((answer) {
      if (isMultipleChoice) {
        return answer.id == answerId
            ? answer.copyWith(isSelected: !answer.isSelected)
            : answer;
      } else {
        return answer.copyWith(isSelected: answer.id == answerId);
      }
    }).toList();

    _logger.info('🔄 Answer selection updated for ID: $answerId');
  }
}

extension ListEquality<T> on List<T> {
  // Define an extension on the List type to provide an equality-checking method.

  bool equals(List<T> other) {
    // Define a method `equals` that checks if the current list and the `other` list are equal.

    if (length != other.length) return false;
    // Step 1: Check if the lengths of the two lists are different.
    // If they are not the same, the lists cannot be equal, so return false.

    for (int i = 0; i < length; i++) {
      // Step 2: Iterate over each index of the lists.
      // Compare the corresponding elements in both lists.

      if (this[i] != other[i]) return false;
      // Step 3: If any element in the current list (`this[i]`) is not equal to the corresponding
      // element in the `other` list (`other[i]`), return false.
    }

    return true;
    // Step 4: If the loop completes without finding any mismatched elements,
    // it means the two lists are equal. Return true.
  }
}
