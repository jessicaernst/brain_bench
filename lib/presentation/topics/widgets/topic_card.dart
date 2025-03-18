import 'package:brain_bench/core/mixins/ensure_visible_mixin.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_expandable_content.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_main_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('TopicCard');

class TopicCard extends StatefulWidget {
  const TopicCard({
    super.key,
    required this.topic,
    required this.onPressed,
    required this.isExpanded,
    required this.onToggle,
  });

  final Topic topic;
  final VoidCallback onPressed;
  final bool isExpanded; //✅ Add isExpanded
  final VoidCallback onToggle; //✅ Add onToggle

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> with EnsureVisibleMixin {
  // ✅ Add a GlobalKey to each AnswerCard
  @override
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    logger.fine('build called for topic: ${widget.topic.name}');
    return Column(
      key: cardKey, // Add key to the main Widget.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopicMainCard(
          title: widget.topic.name,
          isExpanded: widget.isExpanded,
          onTap: () {
            logger.fine('tapped topic: ${widget.topic.name}');
            widget.onToggle();
            if (!widget.isExpanded) {
              ensureCardIsVisible(cardName: widget.topic.name);
            }
          },
          isDarkMode: isDarkMode,
        ),
        TopicCardExpandable(
          description: widget.topic.description,
          onPressed: widget.onPressed,
          isExpanded: widget.isExpanded,
          title: widget.topic.name,
        ),
      ],
    );
  }
}
