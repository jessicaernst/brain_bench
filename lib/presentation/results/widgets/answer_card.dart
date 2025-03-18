import 'package:brain_bench/core/mixins/ensure_visible_mixin.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_expandable_content.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_main_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('TopicCard');

/// This widget displays a single topic card in the list of topics.
///
/// It handles the display of the topic's title and an expandable section for more details.
class TopicCard extends StatefulWidget {
  /// Creates a [TopicCard].
  ///
  /// [topic]: The topic data to be displayed.
  /// [onPressed]: Callback for when the user wants to start the quiz for this topic.
  /// [isExpanded]: Whether the expandable content is currently shown.
  /// [onToggle]: Callback for when the user taps on the card to expand/collapse.
  const TopicCard({
    super.key,
    required this.topic,
    required this.onPressed,
    required this.isExpanded,
    required this.onToggle,
  });

  /// The topic data to be displayed.
  final Topic topic;

  /// Callback for when the user wants to start the quiz for this topic.
  final VoidCallback onPressed;

  /// Whether the expandable content is currently shown.
  final bool isExpanded;

  /// Callback for when the user taps on the card to expand/collapse.
  final VoidCallback onToggle;

  @override
  State<TopicCard> createState() => _TopicCardState();
}

/// State for the [TopicCard] widget.
class _TopicCardState extends State<TopicCard> with EnsureVisibleMixin {
  // ✅ Add a GlobalKey to each AnswerCard - Allows us to identify this card in the widget tree.
  @override
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Check if the app is in dark mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    logger.fine('build called for topic: ${widget.topic.name}');
    return Column(
      key: cardKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main card section with title and tap functionality.
        TopicMainCard(
          title: widget.topic.name,
          isExpanded: widget.isExpanded,
          onTap: () {
            logger.fine('tapped topic: ${widget.topic.name}');
            widget
                .onToggle(); // Call the onToggle callback to notify the parent that the card was tapped.
            // If the card is not expanded (just tapped to expand), ensure it's visible.
            if (!widget.isExpanded) {
              ensureCardIsVisible(cardName: widget.topic.name);
            }
          },
          isDarkMode: isDarkMode,
        ),
        // Expandable content section.
        TopicCardExpandable(
          description: widget.topic.description,
          onPressed: widget.onPressed, // Pass the quiz start callback.
          isExpanded: widget.isExpanded,
          title: widget.topic.name,
        ),
      ],
    );
  }
}
