import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/question.dart';

class QuizState {
  QuizState({
    required this.questions,
    required this.currentIndex,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
    this.isLoadingAnswers = false,
  });

  final List<Question> questions;
  final int currentIndex;
  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;
  final bool isLoadingAnswers;

  factory QuizState.initial() => QuizState(
        questions: [],
        currentIndex: 0,
        correctAnswers: [],
        incorrectAnswers: [],
        missedCorrectAnswers: [],
        isLoadingAnswers: false,
      );

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    List<Answer>? correctAnswers,
    List<Answer>? incorrectAnswers,
    List<Answer>? missedCorrectAnswers,
    bool? isLoadingAnswers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      missedCorrectAnswers: missedCorrectAnswers ?? this.missedCorrectAnswers,
      isLoadingAnswers: isLoadingAnswers ?? this.isLoadingAnswers,
    );
  }
}
