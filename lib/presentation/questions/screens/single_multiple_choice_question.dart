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
  void _showResultBottomSheet(
      BuildContext context, QuizViewModel quizViewModel) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // prevent accidental dismissal
      builder: (ctx) {
        // Use a Consumer so that if the quiz state updates,
        // the bottom sheet rebuilds automatically
        return Consumer(
          builder: (context, ref, child) {
            // Get the updated quiz state
            final quizState = ref.watch(quizViewModelProvider);

            final correctAnswers = quizState.correctAnswers;
            final incorrectAnswers = quizState.incorrectAnswers;
            final missedCorrectAnswers = quizState.missedCorrectAnswers;

            return FeedbackBottomSheetView(
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
              missedCorrectAnswers: missedCorrectAnswers,
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

          final question = questions.first;
          final isMultipleChoice = question.type == QuestionType.multipleChoice;

          _logger.info(
              '✅ First question loaded: ${question.question} (ID: ${question.id}), Type: ${question.type}');

          final answers = ref.watch(answersNotifierProvider);
          final answersNotifier = ref.watch(answersNotifierProvider.notifier);

          Future.microtask(() {
            final answers = ref.read(answersNotifierProvider);
            if (answers.isEmpty) {
              _logger.info('🔄 Initializing answers in AnswersNotifier');
              ref
                  .read(answersNotifierProvider.notifier)
                  .initializeAnswers(question.answers);
            }
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const ProgressIndicatorBarView(),
                const SizedBox(height: 24),
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                AnswerListView(
                  question: question,
                  isMultipleChoice: isMultipleChoice,
                  onAnswerSelected: (answerId) => answersNotifier
                      .toggleAnswerSelection(answerId, isMultipleChoice),
                ),
                const SizedBox(height: 24),
                Center(
                  child: LightDarkSwitchBtn(
                    title: localizations.submitAnswerBtnLbl,
                    isActive: isMultipleChoice
                        ? answers.any((answer) => answer
                            .isSelected) // Prüft, ob mindestens eine Antwort ausgewählt ist
                        : answers.any((answer) =>
                            answer.isSelected), // Gilt auch für Single Choice
                    onPressed: () {
                      if (answers.isNotEmpty &&
                          answers.any((answer) => answer.isSelected)) {
                        _logger.info('🟢 Submit button pressed');
                        quizViewModel.checkAnswers(ref);
                        _showResultBottomSheet(context, quizViewModel);
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
