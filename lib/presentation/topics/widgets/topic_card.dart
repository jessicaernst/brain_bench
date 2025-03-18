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

class _TopicCardState extends State<TopicCard> {
  // ✅ Add a GlobalKey to each AnswerCard
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    logger.fine('build called for topic: ${widget.topic.name}');
    return Column(
      key: _cardKey, // Add key to the main Widget.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopicMainCard(
          title: widget.topic.name,
          isExpanded: widget.isExpanded,
          onTap: () {
            logger.fine('tapped topic: ${widget.topic.name}');
            widget.onToggle();
            if (!widget.isExpanded) {
              _ensureCardIsVisible();
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
