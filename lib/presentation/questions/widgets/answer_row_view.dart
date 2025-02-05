import 'package:brain_bench/data/models/answer.dart';
import 'package:brain_bench/presentation/questions/widgets/round_check_mark_view.dart';
import 'package:flutter/material.dart';

class AnswerRowView extends StatelessWidget {
  const AnswerRowView({
    super.key,
    required String? selectedAnswerId,
    required this.answer,
    required this.isDarkMode,
  }) : _selectedAnswerId = selectedAnswerId;

  final String? _selectedAnswerId;
  final Answer answer;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final isSelected = _selectedAnswerId == answer.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundCheckMarkView(isSelected: isSelected),
          const SizedBox(width: 12),
          // Antwort-Text
          Expanded(
            child: Text(
              answer.text,
              style: isSelected
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
