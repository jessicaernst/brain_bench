import 'package:brain_bench/business_logic/quiz/answers_notifier.dart';
import 'package:brain_bench/business_logic/quiz/quiz_view_model.dart';
import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/core/widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/question.dart';
import 'package:brain_bench/data/providers/quiz/question_providers.dart';
import 'package:brain_bench/presentation/questions/widgets/answer_list_view.dart';
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
  String? _selectedAnswerId;
  final Set<String> _selectedAnswerIds = {};

  void _handleAnswerSelection(
      String answerId, bool isMultipleChoice, AnswersNotifier answersNotifier) {
    setState(() {
      if (isMultipleChoice) {
        if (_selectedAnswerIds.contains(answerId)) {
          _selectedAnswerIds.remove(answerId);
          _logger.info('❌ Deselected answer: $answerId');
        } else {
          _selectedAnswerIds.add(answerId);
          _logger.info('🟢 Selected answer: $answerId');
        }
      } else {
        _selectedAnswerId = _selectedAnswerId == answerId ? null : answerId;
        _logger.info('🟢 Selected answer: $answerId');
      }
    });

    // Toggle selection in the notifier
    answersNotifier.toggleAnswer(answerId);
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

          final answersNotifier = ref.read(answersNotifierProvider.notifier);

          if (ref.watch(answersNotifierProvider).isEmpty) {
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
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                AnswerListView(
                  question: question,
                  isMultipleChoice: isMultipleChoice,
                  selectedAnswerId: _selectedAnswerId,
                  selectedAnswerIds: _selectedAnswerIds,
                  onAnswerSelected: (answerId) => _handleAnswerSelection(
                      answerId, isMultipleChoice, answersNotifier),
                ),
                const SizedBox(height: 24),
                Center(
                  child: LightDarkSwitchBtn(
                    title: localizations.submitAnswerBtnLbl,
                    isActive: isMultipleChoice
                        ? _selectedAnswerIds.isNotEmpty
                        : _selectedAnswerId != null,
                    onPressed: () {
                      if (ref.watch(answersNotifierProvider).isNotEmpty) {
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
