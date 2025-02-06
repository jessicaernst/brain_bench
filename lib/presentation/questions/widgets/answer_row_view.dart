import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/presentation/questions/widgets/round_check_mark_view.dart';
import 'package:flutter/material.dart';

class AnswerRowView extends StatelessWidget {
  const AnswerRowView({
    super.key,
    required this.selected,
    required this.answer,
    required this.isDarkMode,
  });

  final bool selected;
  final Answer answer;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        spacing: 12,
        children: [
          RoundCheckMarkView(isSelected: selected),
          Expanded(
            child: Text(
              answer.text,
              style: selected
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
