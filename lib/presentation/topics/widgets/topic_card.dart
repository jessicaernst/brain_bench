import 'package:brain_bench/core/mixins/ensure_visible_mixin.dart';
import 'package:brain_bench/data/models/topic.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_expandable_content.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_main_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('TopicCard');

/// This widget represents a single topic card in a list of topics.
///
/// It displays the topic's title and provides an expandable area to show more
/// information about the topic, such as a detailed explanation. It also includes
/// a button to start a quiz related to this topic.
class TopicCard extends StatefulWidget {
  /// Creates a [TopicCard].
  ///
  /// [topic]: The [Topic] object containing the data to display.
  /// [onPressed]: Callback that is called when the user wants to start a quiz.
  /// [isExpanded]: Indicates whether the expandable content is currently visible.
  /// [onToggle]: Callback that is called when the user taps the card to expand or collapse it.
  const TopicCard({
    super.key,
    required this.topic,
    required this.onPressed,
    required this.isExpanded,
    required this.onToggle,
  });

  /// The [Topic] object containing the data to display.
  final Topic topic;

  /// Callback that is called when the user wants to start a quiz.
  final VoidCallback onPressed;

  /// Indicates whether the expandable content is currently visible.
  final bool isExpanded;

  /// Callback that is called when the user taps the card to expand or collapse it.
  final VoidCallback onToggle;

  @override
  State<TopicCard> createState() => _TopicCardState();
}

/// The state for the [TopicCard] widget.
///
/// This state manages the interaction with the card, such as handling taps
/// and ensuring the card is visible when expanded.
class _TopicCardState extends State<TopicCard> with EnsureVisibleMixin {
  // We use the mixin to ensure the card is visible when expanded.

  // ✅ Add a GlobalKey to each TopicCard - Allows us to identify this card uniquely in the widget tree.
  @override
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Check if the app is in dark mode to style the card accordingly.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    logger.fine('build called for topic: ${widget.topic.name}');
    return Column(
      key: cardKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main card area that displays the topic title and handles expansion.
        TopicMainCard(
          title: widget.topic.name,
          isExpanded: widget.isExpanded,
          onTap: () {
            logger.fine('tapped topic: ${widget.topic.name}');
            widget
                .onToggle(); // Notify the parent widget that the card was tapped to expand/collapse.
            // If the card is not expanded (meaning it was just tapped to expand), ensure it's visible.
            if (!widget.isExpanded) {
              ensureCardIsVisible(cardName: widget.topic.name);
            }
          },
          isDarkMode: isDarkMode,
        ),
        // The expandable area that contains detailed information about the topic.
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TopicCardExpandable(
            description: widget.topic.description,
            onPressed: widget.onPressed, // Pass the callback to start the quiz.
            isExpanded: widget.isExpanded,
            title: widget.topic.name,
          ),
        ),
      ],
    );
  }
}
