import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/core/widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/providers/quiz/question_providers.dart';
import 'package:brain_bench/presentation/questions/widgets/answer_list_view.dart';
import 'package:brain_bench/presentation/questions/widgets/feedback_bottom_sheet_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SingleMultipleChoiceQuestionPage');

class SingleMultipleChoiceQuestionPage extends ConsumerStatefulWidget {
  const SingleMultipleChoiceQuestionPage({
    super.key,
    required this.topicId,
  });

  final String topicId;

  @override
  ConsumerState<SingleMultipleChoiceQuestionPage> createState() =>
      _SingleMultipleChoiceQuestionPageState();
}

class _SingleMultipleChoiceQuestionPageState
    extends ConsumerState<SingleMultipleChoiceQuestionPage> {
  void _showResultBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            // Watch the existing QuizViewModel state
            final quizState = ref.watch(quizViewModelProvider);

            _logger.info(
                'Bottom Sheet Data: Correct: ${quizState.correctAnswers.length}, '
                'Incorrect: ${quizState.incorrectAnswers.length}, '
                'Missed: ${quizState.missedCorrectAnswers.length}');

            return FeedbackBottomSheetView(
              correctAnswers: quizState.correctAnswers,
              incorrectAnswers: quizState.incorrectAnswers,
              missedCorrectAnswers: quizState.missedCorrectAnswers,
              btnLbl: quizState.currentIndex + 1 < quizState.questions.length
                  ? 'Next Question'
                  : 'Finish',
              onBtnPressed: () {
                Navigator.pop(context);

                if (quizState.currentIndex + 1 < quizState.questions.length) {
                  ref
                      .read(quizViewModelProvider.notifier)
                      .loadNextQuestion(ref);
                } else {
                  _logger.info('Quiz completed.');
                  ref.read(quizViewModelProvider.notifier).resetQuiz(ref);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quiz completed!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    _logger.info(
        '📌 Loading questions for Topic ID: ${widget.topicId}, Language: $languageCode');

    final quizViewModel = ref.read(quizViewModelProvider.notifier);
    final questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            _logger.warning(
                '⚠️ No questions found for Topic ID: ${widget.topicId}');
            return const NoDataAvailableView(text: '❌ No questions available.');
          }

          Future.microtask(() {
            if (ref.read(quizViewModelProvider).questions.isEmpty) {
              ref
                  .read(quizViewModelProvider.notifier)
                  .setQuestions(questions, ref);
              _logger.info('Questions initialized in QuizViewModel.');
            }
          });

          final quizState = ref.watch(quizViewModelProvider);

          if (quizState.questions.isEmpty) {
            _logger.warning(
                'Questions list is empty. Make sure they are initialized properly.');
            return const Center(
              child: Text(
                'No questions available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final currentQuestion = quizState.questions[quizState.currentIndex];
          final isMultipleChoice =
              currentQuestion.type == QuestionType.multipleChoice;

          final progress =
              (quizState.currentIndex + 1) / quizState.questions.length;

          _logger.info(
              '✅ Current question: ${currentQuestion.question} (ID: ${currentQuestion.id}), Type: ${currentQuestion.type}, Progress: ${progress * 100}%');

          final answers = ref.watch(answersNotifierProvider);
          final answersNotifier = ref.watch(answersNotifierProvider.notifier);

          Future.microtask(() {
            _logger.info(
                '🔄 Initializing answers for question at index ${quizState.currentIndex}');
            answersNotifier.initializeAnswers(currentQuestion.answers);
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                ProgressIndicatorBarView(
                  progress: progress,
                ),
                const SizedBox(height: 24),
                Text(
                  currentQuestion.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                AnswerListView(
                  question: currentQuestion,
                  isMultipleChoice: isMultipleChoice,
                  onAnswerSelected: (answerId) => answersNotifier
                      .toggleAnswerSelection(answerId, isMultipleChoice),
                ),
                const SizedBox(height: 24),
                Center(
                  child: LightDarkSwitchBtn(
                    title: localizations.submitAnswerBtnLbl,
                    isActive: isMultipleChoice
                        ? answers.any((answer) => answer.isSelected)
                        : answers.any((answer) => answer.isSelected),
                    onPressed: () {
                      if (answers.isNotEmpty &&
                          answers.any((answer) => answer.isSelected)) {
                        _logger.info('🟢 Submit button pressed');
                        quizViewModel.checkAnswers(ref);
                        _showResultBottomSheet(context);
                      } else {
                        _logger.warning('⚠️ No answers available to check.');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
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
              style: TextTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
