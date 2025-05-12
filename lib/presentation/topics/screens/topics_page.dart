import 'package:brain_bench/business_logic/categories/categories_provider.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/back_nav_app_bar.dart';
import 'package:brain_bench/core/shared_widgets/error_views/no_data_available_view.dart';
import 'package:brain_bench/core/shared_widgets/progress_bars/progress_indicator_bar_view.dart';
import 'package:brain_bench/data/infrastructure/quiz/topic_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/topic/topic.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('TopicsPage');

class TopicsPage extends ConsumerStatefulWidget {
  const TopicsPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends ConsumerState<TopicsPage> {
  final Map<String, bool> _expandedStates = {};
  bool _showDoneTopics = false;

  bool _getExpandedState(Topic topic, bool isDone) {
    final stateKey = '${topic.id}_$isDone';
    final oldStateKey = '${topic.id}_${!isDone}';
    if (_expandedStates.containsKey(oldStateKey)) {
      _expandedStates.remove(oldStateKey);
    }
    _expandedStates.putIfAbsent(stateKey, () => false);
    final isExpandedRaw = _expandedStates[stateKey];
    if (isExpandedRaw is! bool) {
      _logger.severe(
        '❌ Invalid expanded state for topic ${topic.id} (status: $isDone): $isExpandedRaw. Resetting to false.',
      );
      return false;
    }
    return isExpandedRaw;
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final localizations = AppLocalizations.of(context)!;

    final topicsAsync = ref.watch(topicsProvider(widget.categoryId));

    final categoryAsync = ref.watch(
      categoryByIdProvider(widget.categoryId, languageCode),
    );

    final userStateAsync = ref.watch(currentUserModelProvider);
    AppUser? user;
    if (userStateAsync is AsyncData && userStateAsync.value is UserModelData) {
      user = (userStateAsync.value as UserModelData).user;
    }

    return Scaffold(
      appBar: BackNavAppBar(
        title: localizations.topicsTitle,
        onBack: () {
          ref
              .read(selectedCategoryNotifierProvider.notifier)
              .selectCategory(null);
          context.goNamed(AppRouteNames.categories);
        },
      ),
      body: Column(
        children: [
          categoryAsync.when(
            data: (category) {
              final progress = user?.categoryProgress[category.id] ?? 0.0;
              return ProgressIndicatorBarView(progress: progress);
            },
            loading: () => const ProgressIndicatorBarView(progress: 0),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: topicsAsync.when(
              data: (topics) {
                if (topics.isEmpty) {
                  _logger.warning(
                    '⚠️ No topics found for Category ID: ${widget.categoryId}',
                  );
                  return const NoDataAvailableView(
                    text: '❌  No topics available.',
                  );
                }

                final topicDoneMap = user?.isTopicDone[widget.categoryId] ?? {};

                final doneTopics =
                    topics.where((t) => topicDoneMap[t.id] == true).toList();
                final undoneTopics =
                    topics.where((t) => topicDoneMap[t.id] != true).toList();

                return ListView(
                  key: const PageStorageKey('topicList'),
                  children: [
                    if (undoneTopics.isNotEmpty)
                      ...undoneTopics.map((topic) {
                        const isDone = false;
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
                        children:
                            doneTopics.map((topic) {
                              const isDone = true;
                              final stateKey = '${topic.id}_$isDone';
                              final isExpanded = _getExpandedState(
                                topic,
                                isDone,
                              );
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
              error:
                  (error, _) => Center(
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
