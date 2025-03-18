import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/component_widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/providers/quiz/topic_providers.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

Logger _logger = Logger('TopicsPage');

class TopicsPage extends ConsumerWidget {
  const TopicsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final title = languageCode == 'de' ? 'Themen' : 'Topics';

    final topicsAsync = ref.watch(topicsProvider(categoryId, languageCode));

    return Scaffold(
      appBar: BackNavAppBar(
        title: title,
        onBack: () {
          context.go('/categories');
        },
      ),
      body: Column(
        children: [
          const ProgressIndicatorBarView(
            progress: 0.5,
          ),
          Expanded(
            child: topicsAsync.when(
              data: (topics) {
                if (topics.isEmpty) {
                  _logger.warning(
                      '⚠️ No topics found for Category ID: $categoryId');
                  return const NoDataAvailableView(
                    text: '❌  No topics available.',
                  );
                }
                return ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TopicCard(
                        onPressed: () {
                          context.go(
                            '/categories/details/topics/quiz',
                            extra: {
                              'topicId': topic.id,
                              'categoryId': categoryId,
                            },
                          );
                        },
                        topic: topic,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading topics: $error',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
