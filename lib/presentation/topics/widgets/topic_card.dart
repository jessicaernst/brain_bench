import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_expandable_content.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/business_logic/topics/topic_provider.dart';

class TopicCard extends ConsumerStatefulWidget {
  const TopicCard({
    super.key,
    required this.topic,
    required this.onPressed,
  });

  final Topic topic;
  final VoidCallback onPressed;

  @override
  ConsumerState<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends ConsumerState<TopicCard> {
  // ✅ Add a GlobalKey to each AnswerCard
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isExpanded =
        ref.watch(topicCardStateProvider(cardId: widget.topic.id));
    final stateNotifier =
        ref.read(topicCardStateProvider(cardId: widget.topic.id).notifier);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    logger.fine('build called for topic: ${widget.topic.name}');
    return Column(
      key: _cardKey, // Add key to the main Widget.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopicMainCard(
          title: widget.topic.name,
          isExpanded: isExpanded,
          onTap: () {
            logger.fine('tapped topic: ${widget.topic.name}');
            stateNotifier.toggle();
            if (!isExpanded) {
              _ensureCardIsVisible();
            }
          },
          isDarkMode: isDarkMode,
        ),
        TopicCardExpandable(
          description: widget.topic.description,
          onPressed: widget.onPressed,
          isExpanded: isExpanded,
          title: widget.topic.name,
        ),
      ],
    );
  }

  // ✅ Helper method to ensure the card is visible
  void _ensureCardIsVisible() {
    logger.fine('_ensureCardIsVisible called for topic: ${widget.topic.name}');
    Future.delayed(const Duration(milliseconds: 300), () {
      final RenderObject? renderObject =
          _cardKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject.attached) {
        logger.info('Scrolling to make topic visible: ${widget.topic.name}');
        Scrollable.ensureVisible(
          _cardKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        logger.warning('RenderObject not found or not attached');
      }
    });
  }
}
