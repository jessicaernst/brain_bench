import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_view_model.g.dart';

final Logger _logger = Logger('QuizViewModel');

@Riverpod(keepAlive: true)
class QuizViewModel extends _$QuizViewModel {
  @override
  QuizState build() {
    _logger.info('QuizViewModel initialized with initial state.');
    return QuizState.initial();
  }

  /// Initializes the quiz if not already initialized
  void initializeQuizIfNeeded(List<Question> questions, WidgetRef ref) {
    if (state.questions.isEmpty && questions.isNotEmpty) {
      state = state.copyWith(questions: questions, currentIndex: 0);
      ref
          .read(answersNotifierProvider.notifier)
          .initializeAnswers(questions.first.answers);
      _logger.info('✅ Quiz initialized with ${questions.length} questions.');
    }
  }

  /// Returns the quiz progress as a percentage (0.0 to 1.0)
  double getProgress() {
    if (state.questions.isEmpty) return 0.0;
    return (state.currentIndex + 1) / state.questions.length;
  }

  /// Determines if there are more questions left
  bool hasNextQuestion() => state.currentIndex + 1 < state.questions.length;

  /// Moves to the next question (if available)
  void loadNextQuestion(WidgetRef ref) {
    if (hasNextQuestion()) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      _logger.info('🔄 Loading next question: Index ${state.currentIndex}');
      ref
          .read(answersNotifierProvider.notifier)
          .initializeAnswers(state.questions[state.currentIndex].answers);
    }
  }

  /// Checks the user's selected answers and updates state accordingly
  void checkAnswers(WidgetRef ref) {
    final answers = ref.read(answersNotifierProvider);
    final correctAnswers =
        answers.where((a) => a.isSelected && a.isCorrect).toList();
    final incorrectAnswers =
        answers.where((a) => a.isSelected && !a.isCorrect).toList();
    final missedCorrectAnswers =
        answers.where((a) => !a.isSelected && a.isCorrect).toList();

    state = state.copyWith(
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers,
    );
  }

  /// Resets the quiz
  void resetQuiz(WidgetRef ref) {
    state = QuizState.initial();
    ref.read(answersNotifierProvider.notifier).resetAnswers();
  }
}

class QuizState {
  QuizState({
    required this.questions,
    required this.currentIndex,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
  });

  final List<Question> questions;
  final int currentIndex;
  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;

  factory QuizState.initial() => QuizState(
        questions: [],
        currentIndex: 0,
        correctAnswers: [],
        incorrectAnswers: [],
        missedCorrectAnswers: [],
      );

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<Answer>? correctAnswers,
    List<Answer>? incorrectAnswers,
    List<Answer>? missedCorrectAnswers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers ?? this.missedCorrectAnswers,
    );
  }
}
