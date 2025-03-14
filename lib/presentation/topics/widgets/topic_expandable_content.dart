import 'package:brain_bench/core/component_widgets/card_expandable_content.dart';
import 'package:brain_bench/core/styles/gradient_colors.dart';
import 'package:brain_bench/presentation/topics/widgets/topic_card_expandable_content.dart';
import 'package:flutter/material.dart';

/// A widget that represents an expandable topic card.
///
/// This widget is used to display an expandable topic card with a title, description, and an action button.
/// It is typically used within a [CardExpandableContent] widget to provide expandable content for a card.
class TopicCardExpandable extends StatelessWidget {
  const TopicCardExpandable({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.isExpanded,
  });

  final String title;
  final String description;
  final VoidCallback onPressed;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return CardExpandableContent(
      isExpanded: isExpanded,
      padding: 16,
      lightGradient: BrainBenchGradients.topicCardLightGradient,
      darkGradient: BrainBenchGradients.topicCardDarkGradient,
      child: TopicCardExpandableContent(
        title: title,
        description: description,
        onPressed: onPressed,
      ),
    );
  }
}
