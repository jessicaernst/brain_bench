import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/data/providers/answer_providers.dart';
import 'package:brain_bench/data/providers/question_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

// Private logger
final Logger _logger = Logger('SingleMultipleChoiceQuestionPage');

class SingleMultipleChoiceQuestionPage extends ConsumerWidget {
  const SingleMultipleChoiceQuestionPage({
    super.key,
    required this.topicId,
  });

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String languageCode = Localizations.localeOf(context).languageCode;

    _logger.info(
        '📌 Loading questions for Topic ID: $topicId, Language: $languageCode');

    final questionsAsync = ref.watch(questionsProvider(topicId, languageCode));

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.quizAppBarTitle),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            _logger.warning('⚠️ No questions found for Topic ID: $topicId');
            return const Center(child: Text('No questions available.'));
          }

          final question = questions.first;
          final answerIds = question.answers.map((e) => e.id).toList();

          _logger.info(
              '✅ First question loaded: ${question.question} (ID: ${question.id})');
          _logger.info('📌 Answer IDs: $answerIds');

          final answersFuture = ref.read(
            answersProvider(answerIds, languageCode).future,
          );

          return FutureBuilder<List<Answer>>(
            future: answersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                _logger.info('🔄 Answers are loading...');
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                _logger.severe('❌ Error loading answers: ${snapshot.error}');
                return Center(
                  child: Text(
                    'Error loading answers: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                final answers = snapshot.data!;
                _logger.info(
                    '✅ Loaded answers: ${answers.map((e) => e.text).toList()}');

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display question
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      // Display answers as a list
                      ...answers.map(
                        (answer) => ListTile(
                          title: Text(answer.text),
                          leading: Icon(Icons.radio_button_unchecked),
                          onTap: () {
                            _logger.fine(
                                '🟢 Answer selected: ${answer.text} (ID: ${answer.id})');
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
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
