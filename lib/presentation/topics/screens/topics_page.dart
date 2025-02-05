import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/providers/topic_providers.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('TopicsPage');

class TopicsPage extends ConsumerWidget {
  const TopicsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final title = languageCode == 'de' ? 'Themen' : 'Topics';

    final topicsAsync = ref.watch(topicsProvider(categoryId, languageCode));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isDarkMode
            ? BrainBenchColors.deepDive
            : BrainBenchColors.cloudCanvas,
      ),
      body: topicsAsync.when(
        data: (topics) => ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TopicCard(
                cardId: topic.id,
                title: topic.name,
                description: topic.description,
                isDarkMode: isDarkMode,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/categories/details/topics/quiz',
                    arguments: topic.id,
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading topics: $error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
