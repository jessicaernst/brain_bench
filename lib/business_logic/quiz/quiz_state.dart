import 'package:brain_bench/data/models/quiz/question.dart';
import 'package:equatable/equatable.dart'; // Import equatable for value comparison
// Answer model import is not directly needed if only storing IDs

/// Represents the state of the quiz view.
///
/// Holds the list of questions, the current question index,
/// loading status, and lists tracking the user's performance
/// after checking answers.
/// Extends [Equatable] to enable value-based comparison, essential for testing
/// and state management updates.
class QuizState extends Equatable {
  /// Creates an instance of [QuizState].
  ///
  /// Requires all fields except [isLoadingAnswers], which defaults to false.
  const QuizState({
    // Mark constructor as const
    required this.questions,
    required this.currentIndex,
    required this.correctAnswers, // Changed to List<String> based on tests
    required this.incorrectAnswers, // Changed to List<String> based on tests
    required this.missedCorrectAnswers, // Changed to List<String> based on tests
    this.isLoadingAnswers = false,
  });

  /// The list of [Question] objects for the current quiz.
  final List<Question> questions;

  /// The index of the currently displayed question in the [questions] list.
  /// -1 typically indicates the quiz hasn't started or is finished/reset.
  final int currentIndex;

  /// A list of IDs for answers the user correctly selected.
  final List<String> correctAnswers; // Stores Answer IDs

  /// A list of IDs for answers the user incorrectly selected.
  final List<String> incorrectAnswers; // Stores Answer IDs

  /// A list of IDs for correct answers the user did *not* select.
  final List<String> missedCorrectAnswers; // Stores Answer IDs

  /// Flag indicating if the answers for the current question are being loaded.
  final bool isLoadingAnswers;

  /// Factory constructor for the initial state of the quiz.
  ///
  /// Returns a [QuizState] with empty lists, a [currentIndex] of -1 (or 0 depending on logic),
  /// and [isLoadingAnswers] set to false.
  factory QuizState.initial() => const QuizState(
    // Mark as const
    questions: [],
    // Set to -1 to align with 'Initial state is correct' test expectation.
    // Adjust if 0 is the intended starting index after initialization.
    currentIndex: -1,
    correctAnswers: [],
    incorrectAnswers: [],
    missedCorrectAnswers: [],
    isLoadingAnswers: false,
  );

  /// Creates a copy of the current [QuizState] with potentially updated fields.
  ///
  /// Useful for state management to create a new state object instead of mutating
  /// the existing one.
  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<String>? correctAnswers, // Adjusted type
    List<String>? incorrectAnswers, // Adjusted type
    List<String>? missedCorrectAnswers, // Adjusted type
    bool? isLoadingAnswers,
  }) {
    // Return a new instance with updated values, falling back to current values if null
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers ?? this.missedCorrectAnswers,
      isLoadingAnswers: isLoadingAnswers ?? this.isLoadingAnswers,
    );
  }

  // --- Equatable Implementation ---

  /// The list of properties that will be used to determine whether two instances
  /// are equal. If all properties in this list are equal for two instances,
  /// the instances are considered equal.
  @override
  List<Object?> get props => [
    questions,
    currentIndex,
    correctAnswers,
    incorrectAnswers,
    missedCorrectAnswers,
    isLoadingAnswers,
  ];

  /// Optional: Enhances the default `toString()` output for easier debugging.
  /// When true, `toString()` will include the class name and the `props`.
  @override
  bool get stringify => true;

  // --- End Equatable Implementation ---
}
