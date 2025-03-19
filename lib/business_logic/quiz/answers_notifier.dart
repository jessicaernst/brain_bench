import 'package:brain_bench/data/models/answer.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

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

    const listEquality = ListEquality();
    if (listEquality.equals(currentAnswerIds, newAnswerIds)) {
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
    if (!isMultipleChoice) {
      // If it's not a multiple-choice question, deselect all other answers
      state = state.map((answer) {
        return answer.copyWith(isSelected: answer.id == answerId);
      }).toList();
    } else {
      // If it's a multiple-choice question, toggle the selected state of the answer
      state = state.map((answer) {
        return answer.id == answerId
            ? answer.copyWith(isSelected: !answer.isSelected)
            : answer;
      }).toList();
    }

    _logger.info('🔄 Answer selection updated for ID: $answerId');
  }
}
