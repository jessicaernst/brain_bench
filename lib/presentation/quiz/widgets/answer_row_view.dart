import 'package:brain_bench/data/models/quiz/answer.dart';
import 'package:brain_bench/data/models/quiz/answer_extensions.dart';
import 'package:brain_bench/presentation/quiz/widgets/round_check_mark_view.dart';
import 'package:flutter/material.dart';

class AnswerRowView extends StatelessWidget {
  const AnswerRowView({
    super.key,
    required this.selected,
    required this.answer,
    required this.isDarkMode,
    required this.languageCode,
  });

  final bool selected;
  final Answer answer;
  final bool isDarkMode;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final String displayText = answer.localizedText(languageCode);

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
              displayText,
              style:
                  selected
                      ? TextTheme.of(context).bodyLarge
                      : TextTheme.of(context).bodyMedium,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
