import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/core/widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/providers/quiz/question_providers.dart';
import 'package:brain_bench/presentation/questions/widgets/answer_row_view.dart';
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
  // Stores the ID of the selected answer (for single-choice questions)
  String? _selectedAnswerId;

  // Stores the IDs of selected answers (for multiple-choice questions)
  final Set<String> _selectedAnswerIds = {};

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    _logger.info(
        '📌 Loading questions for Topic ID: ${widget.topicId}, Language: $languageCode');

    // Initialize the QuizViewModel
    final quizViewModel = ref.read(quizViewModelProvider.notifier);

    // Fetch questions asynchronously from DataProvider
    final questionsAsync =
        ref.watch(questionsProvider(widget.topicId, languageCode));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
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

          final answerIds = question.answers.map((e) => e.id).toList();
          _logger.info('📌 Answer IDs: $answerIds');

          // Initialize and watch AnswersNotifier
          final answersNotifier = ref.read(answersNotifierProvider.notifier);
          final answers = ref.watch(answersNotifierProvider);

          // Delay the initialization of answers until after the widget is built and ensures that the notifier
          // is initialized only once.
          if (answers.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logger.info('🔄 Initializing answers in AnswersNotifier');
              answersNotifier.initializeAnswers(question.answers);
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const ProgressIndicatorBarView(),
                const SizedBox(height: 24),

                // Display the question text
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Spacer(),

                // Answer List
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.03,
                    horizontal: MediaQuery.of(context).size.width * 0.10,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: answers.map((answer) {
                      final isSelected = isMultipleChoice
                          ? _selectedAnswerIds.contains(answer.id)
                          : _selectedAnswerId == answer.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isMultipleChoice) {
                              if (_selectedAnswerIds.contains(answer.id)) {
                                _selectedAnswerIds.remove(answer.id);
                                _logger.info(
                                    '❌ Deselected answer: ${answer.text} (ID: ${answer.id})');
                              } else {
                                _selectedAnswerIds.add(answer.id);
                                _logger.info(
                                    '🟢 Selected answer: ${answer.text} (ID: ${answer.id})');
                              }
                            } else {
                              _selectedAnswerId = _selectedAnswerId == answer.id
                                  ? null
                                  : answer.id;
                              _logger.info(
                                  '🟢 Selected answer: ${answer.text} (ID: ${answer.id})');
                            }
                          });

                          // Toggle selection in the notifier
                          answersNotifier.toggleAnswer(answer.id);
                        },
                        child: AnswerRowView(
                          selected: isSelected,
                          answer: answer,
                          isDarkMode: isDarkMode,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Submit Answer Button
                Center(
                  child: LightDarkSwitchBtn(
                    title: localizations.submitAnswerBtnLbl,
                    isActive: isMultipleChoice
                        ? _selectedAnswerIds.isNotEmpty
                        : _selectedAnswerId != null,
                    isDarkMode: isDarkMode,
                    onPressed: () {
                      if (answers.isNotEmpty) {
                        _logger.info('🟢 Submit button pressed');
                        quizViewModel.checkAnswers(ref);
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

        // Show loading indicator while fetching questions
        loading: () {
          _logger.info('🔄 Questions are loading...');
          return const Center(child: CircularProgressIndicator());
        },

        // Handle errors while fetching questions
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
