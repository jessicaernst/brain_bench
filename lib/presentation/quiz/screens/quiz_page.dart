import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/providers/quiz/question_providers.dart';
import 'package:brain_bench/presentation/quiz/widgets/feedback_bottom_sheet_view.dart';
import 'package:brain_bench/presentation/quiz/widgets/single_multtiple_question_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizPage');

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({
    super.key,
    required this.topicId,
    required this.categoryId,
  });

  final String topicId;
  final String categoryId;

  @override
  ConsumerState<QuizPage> createState() =>
      _SingleMultipleChoiceQuestionPageState();
}

class _SingleMultipleChoiceQuestionPageState extends ConsumerState<QuizPage> {
  /// Displays the result bottom sheet after a question is answered
  void _showResultBottomSheet(BuildContext context, WidgetRef ref) {
    final quizState = ref.read(quizViewModelProvider);
    final quizAnswerNotifier = ref.read(quizAnswersNotifierProvider.notifier);

    final currentQuestion = quizState.questions[quizState.currentIndex];

    // User Selected Answers
    final selectedAnswers = ref
        .read(answersNotifierProvider)
        .where((answer) => answer.isSelected)
        .map((answer) => answer.text)
        .toList();

    // Get the correct answers
    final correctAnswers = currentQuestion.answers
        .where((answer) => answer.isCorrect)
        .map((answer) => answer.text)
        .toList();

    // Save the answer to the QuizAnswersNotifier
    quizAnswerNotifier.addAnswer(
      currentQuestion.id,
      currentQuestion.topicId,
      widget.categoryId,
      currentQuestion.question,
      selectedAnswers,
      correctAnswers,
    );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final quizState = ref.watch(quizViewModelProvider);

            return FeedbackBottomSheetView(
              correctAnswers: quizState.correctAnswers,
              incorrectAnswers: quizState.incorrectAnswers,
              missedCorrectAnswers: quizState.missedCorrectAnswers,
              btnLbl: quizState.currentIndex + 1 < quizState.questions.length
                  ? AppLocalizations.of(context)!.nextQuestionBtnLbl
                  : AppLocalizations.of(context)!.finishQuizBtnLbl,
              onBtnPressed: () {
                Navigator.pop(context);
                _handleNextQuestionOrFinish(context, ref);
              },
            );
          },
        );
      },
    );
  }

  /// Handles logic to either load the next question or finish the quiz
  void _handleNextQuestionOrFinish(BuildContext context, WidgetRef ref) {
    final quizViewModel = ref.read(quizViewModelProvider.notifier);

    if (quizViewModel.hasNextQuestion()) {
      quizViewModel.loadNextQuestion(ref);
    } else {
      _logger.info('🎉 Quiz completed.');

      context.go('/categories/details/topics/quiz/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    _logger.info(
        '📌 Loading questions for Topic ID: ${widget.topicId}, Language: $languageCode');

    final QuizViewModel quizViewModel =
        ref.read(quizViewModelProvider.notifier);
    final AsyncValue questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.quizAppBarTitle),
      ),
      body: questionsAsync.when(
        data: (questions) {
          // Check if the list of questions is empty
          if (questions.isEmpty) {
            _logger.warning(
                '⚠️ No questions found for Topic ID: ${widget.topicId}');
            return const NoDataAvailableView(text: '❌ No questions available.');
          }

          // Initialize the quiz if it's not already set up
          Future.microtask(() {
            quizViewModel.initializeQuizIfNeeded(questions, ref);
          });

          final quizState = ref.watch(quizViewModelProvider);

          // If the questions in the QuizViewModel remain uninitialized, display an error
          if (quizState.questions.isEmpty) {
            _logger
                .warning('⚠️ Questions list is empty. Check initialization.');
            return const Center(
              child: Text(
                'No questions available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Get the current question and its type
          final Question currentQuestion =
              quizState.questions[quizState.currentIndex];
          // Determine if the current question is multiple choice
          final bool isMultipleChoice =
              currentQuestion.type == QuestionType.multipleChoice;

          // Get the current progress of the quiz
          final double progress = quizViewModel.getProgress();

          _logger.info(
              '✅ Current question: ${currentQuestion.question} (ID: ${currentQuestion.id}), Type: ${currentQuestion.type}, Progress: ${(progress * 100).toStringAsFixed(1)}%');

          // Get the list of answers and the answers notifier
          final List<Answer> answers = ref.watch(answersNotifierProvider);
          // Get the answers notifier to initialize the answers
          final AnswersNotifier answersNotifier =
              ref.watch(answersNotifierProvider.notifier);

          // Ensure the answers are correctly initialized for the current question
          Future.microtask(() {
            _logger.info(
                '🔄 Initializing answers for question at index ${quizState.currentIndex}');
            answersNotifier.initializeAnswers(currentQuestion.answers);
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleMulttipleQuestionView(
              progress: progress,
              currentQuestion: currentQuestion,
              isMultipleChoice: isMultipleChoice,
              answersNotifier: answersNotifier,
              localizations: localizations,
              answers: answers,
              onAnswerSelected: () {
                if (answers.any((answer) => answer.isSelected)) {
                  _logger.info('🟢 Submit button pressed');
                  quizViewModel.checkAnswers(ref);
                  _showResultBottomSheet(context, ref);
                } else {
                  _logger.warning('⚠️ No answers selected.');
                }
              },
            ),
          );
        },
        loading: () {
          _logger.info('🔄 Questions are loading...');
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          _logger.severe('❌ Error loading questions: $error');
          return Center(
            child: Text(
              'Error loading questions: $error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
