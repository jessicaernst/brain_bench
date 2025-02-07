import 'package:brain_bench/presentation/topics/widgets/topic_expandable_content.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/topics/topic_provider.dart';

class TopicCard extends ConsumerWidget {
  const TopicCard({
    super.key,
    required this.cardId,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final String cardId;
  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(topicCardStateProvider(cardId: cardId));
    final stateNotifier =
        ref.read(topicCardStateProvider(cardId: cardId).notifier);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopicMainCard(
              title: title,
              isExpanded: isExpanded,
              onTap: stateNotifier.toggle,
              isDarkMode: isDarkMode,
            ),
            TopicExpandableContent(
              cardWidth: cardWidth,
              description: description,
              onPressed: onPressed,
              isExpanded: isExpanded,
            ),
          ],
        );
      },
    );
  }
}
