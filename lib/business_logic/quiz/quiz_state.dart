import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/question.dart';

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
