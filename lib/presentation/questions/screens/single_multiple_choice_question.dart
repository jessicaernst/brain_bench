import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/widgets/no_data_available_view.dart';
import 'package:brain_bench/core/widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/providers/quiz/answer_providers.dart';
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
  String? _selectedAnswerId;

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    _logger.info(
        '📌 Loading questions for Topic ID: ${widget.topicId}, Language: $languageCode');

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
          _logger.info(
              '✅ First question loaded: ${question.question} (ID: ${question.id})');

          final answerIds = question.answers.map((e) => e.id).toList();
          _logger.info('📌 Answer IDs: $answerIds');

          final answersFuture = ref.read(
            answersProvider(answerIds, languageCode).future,
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const ProgressIndicatorBarView(),
                const SizedBox(height: 24),
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                FutureBuilder<List<Answer>>(
                  future: answersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      _logger.info('🔄 Answers are loading...');
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      _logger
                          .severe('❌ Error loading answers: ${snapshot.error}');
                      return Center(
                        child: Text(
                          'Error loading answers: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    } else {
                      final answers = snapshot.data!;
                      _logger.info(
                          '✅ Loaded answers: ${answers.map((e) => e.text).toList()}');

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                          horizontal: MediaQuery.of(context).size.width * 0.15,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: answers.map((answer) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedAnswerId == answer.id) {
                                    _selectedAnswerId = null;
                                    _logger.info(
                                        '❌ Deselected answer: ${answer.text} (ID: ${answer.id})');
                                  } else {
                                    _selectedAnswerId = answer.id;
                                    _logger.info(
                                        '🟢 Selected answer: ${answer.text} (ID: ${answer.id})');
                                  }
                                });
                              },
                              child: AnswerRowView(
                                selectedAnswerId: _selectedAnswerId,
                                answer: answer,
                                isDarkMode: isDarkMode,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: LightDarkSwitchBtn(
                    title: localizations.submitAnswerBtnLbl,
                    isActive: _selectedAnswerId != null,
                    isDarkMode: isDarkMode,
                    onPressed: () {
                      if (_selectedAnswerId != null) {
                        _logger
                            .info('✅ Submitted answer ID: $_selectedAnswerId');
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
