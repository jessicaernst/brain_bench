import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/component_widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/providers/quiz/topic_providers.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('TopicsPage');

class TopicsPage extends ConsumerStatefulWidget {
  const TopicsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  ConsumerState<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends ConsumerState<TopicsPage> {
  // ✅ Map to hold the expanded state of each TopicCard, keyed by topicId
  final Map<String, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final title = languageCode == 'de' ? 'Themen' : 'Topics';

    final topicsAsync =
        ref.watch(topicsProvider(widget.categoryId, languageCode));

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
                      '⚠️ No topics found for Category ID: ${widget.categoryId}');
                  return const NoDataAvailableView(
                    text: '❌  No topics available.',
                  );
                }
                return ListView.builder(
                  key: const PageStorageKey(
                      'topicList'), //✅ Add Key for listview
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    // ✅ Initialize the expanded state in the map if it doesn't exist.
                    _expandedStates.putIfAbsent(topic.id, () => false);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TopicCard(
                        isExpanded:
                            _expandedStates[topic.id]!, //✅ pass the value.
                        onToggle: () {
                          //✅ Create a toggle callback
                          setState(() {
                            _expandedStates[topic.id] =
                                !_expandedStates[topic.id]!;
                          });
                        },
                        onPressed: () {
                          context.go(
                            '/categories/details/topics/quiz',
                            extra: {
                              'topicId': topic.id,
                              'categoryId': widget.categoryId,
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
