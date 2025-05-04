import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/component_widgets/back_nav_app_bar.dart';
import 'package:brain_bench/core/component_widgets/no_data_available_view.dart';
import 'package:brain_bench/core/component_widgets/progress_indicator_bar_view.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('TopicsPage');

/// The screen that displays the topics for a specific category.
class TopicsPage extends ConsumerStatefulWidget {
  TopicsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  ConsumerState<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends ConsumerState<TopicsPage> {
  // ✅ Map to hold the expanded state of each TopicCard, keyed by topicId + status
  final Map<String, bool> _expandedStates = {};
  bool _showDoneTopics = false;

  /// Helper method to get and initialize the expanded state for a topic,
  /// considering its current done status to ensure state reset on status change.
  bool _getExpandedState(Topic topic, bool isDone) {
    // Create a status-specific key
    final stateKey = '${topic.id}_$isDone';
    // Remove the old state key for the opposite status, if it exists
    final oldStateKey = '${topic.id}_${!isDone}';
    if (_expandedStates.containsKey(oldStateKey)) {
      _expandedStates.remove(oldStateKey);
    }
    // Ensure the state exists, defaulting to false if not.
    _expandedStates.putIfAbsent(stateKey, () => false);
    final isExpandedRaw = _expandedStates[stateKey];
    // Validate the state type, logging an error if it's not a bool.
    if (isExpandedRaw is! bool) {
      _logger.severe(
          '❌ Invalid expanded state for topic ${topic.id} (status: $isDone): $isExpandedRaw. Resetting to false.');
      return false;
    }
    return isExpandedRaw;
  }

  @override
  Widget build(BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final topicsAsync =
        ref.watch(topicsProvider(widget.categoryId, languageCode));

    final categoryAsync =
        ref.watch(categoryByIdProvider(widget.categoryId, languageCode));

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.topicsTitle,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(AppRouteNames.categories);
          }
        },
      ),
      body: Column(
        children: [
          categoryAsync.when(
            data: (category) {
              final user = ref.watch(currentUserModelProvider).valueOrNull;
              final progress = user?.categoryProgress[category.id] ?? 0.0;

              return ProgressIndicatorBarView(progress: progress);
            },
            loading: () => const ProgressIndicatorBarView(progress: 0),
            error: (error, stack) => const SizedBox.shrink(),
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
                final user = ref.watch(currentUserModelProvider).valueOrNull;
                final topicDoneMap = user?.isTopicDone[widget.categoryId] ?? {};

                final List<Topic> doneTopics =
                    topics.where((t) => topicDoneMap[t.id] == true).toList();
                final List<Topic> undoneTopics =
                    topics.where((t) => topicDoneMap[t.id] != true).toList();

                return ListView(
                  key: const PageStorageKey('topicList'),
                  children: [
                    // ✅ Undone Topics
                    if (undoneTopics.isNotEmpty)
                      ...undoneTopics.map((topic) {
                        const bool isDone =
                            false; // Topic is in the undone list
                        final stateKey = '${topic.id}_$isDone';
                        final isExpanded = _getExpandedState(topic, isDone);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: TopicCard(
                            isExpanded: isExpanded,
                            onToggle: () {
                              setState(() {
                                _expandedStates[stateKey] =
                                    !_expandedStates[stateKey]!;
                              });
                            },
                            onPressed: () {
                              context.goNamed(
                                AppRouteNames.quiz,
                                pathParameters: {
                                  'topicId': topic.id,
                                  'categoryId': widget.categoryId,
                                },
                              );
                            },
                            topic: topic,
                          ),
                        );
                      }),

                    if (doneTopics.isNotEmpty)
                      ExpansionTile(
                        key: PageStorageKey<String>(
                          'doneTopicsExpansionTile_${widget.categoryId}',
                        ),
                        title: Text(
                          localizations.topicsDone,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        initiallyExpanded: _showDoneTopics,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _showDoneTopics = expanded;
                          });
                        },
                        children: doneTopics.map((topic) {
                          const bool isDone = true;
                          final stateKey = '${topic.id}_$isDone';
                          final isExpanded = _getExpandedState(topic, isDone);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TopicCard(
                              isExpanded: isExpanded,
                              onToggle: () {
                                setState(() {
                                  _expandedStates[stateKey] =
                                      !_expandedStates[stateKey]!;
                                });
                              },
                              onPressed: () {
                                context.goNamed(
                                  AppRouteNames.quiz,
                                  pathParameters: {
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
