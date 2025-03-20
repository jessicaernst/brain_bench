import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/component_widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
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
  bool _showDoneTopics = false; // ✅ State for the "Done" section

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final topicsAsync =
        ref.watch(topicsProvider(widget.categoryId, languageCode));

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.topicsTitle,
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

                // ✅ Split topics into done and undone
                final List<Topic> doneTopics =
                    topics.where((t) => t.isDone).toList();
                final List<Topic> undoneTopics =
                    topics.where((t) => !t.isDone).toList();

                return ListView(
                  key: const PageStorageKey('topicList'),
                  children: [
                    // ✅ Undone Topics
                    if (undoneTopics.isNotEmpty)
                      ...undoneTopics.map((topic) {
                        _expandedStates.putIfAbsent(topic.id, () => false);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: TopicCard(
                            isExpanded: _expandedStates[topic.id]!,
                            onToggle: () {
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
                      }),

                    // ✅ Done Topics Section
                    if (doneTopics.isNotEmpty)
                      ExpansionTile(
                        title: Text(
                          localizations.topicsDone,
                          style: TextTheme.of(context).headlineMedium,
                        ),
                        initiallyExpanded: _showDoneTopics,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _showDoneTopics = expanded;
                          });
                        },
                        children: doneTopics.map((topic) {
                          _expandedStates.putIfAbsent(topic.id, () => false);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TopicCard(
                              isExpanded: _expandedStates[topic.id]!,
                              onToggle: () {
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
                        }).toList(),
                      ),
                  ],
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
