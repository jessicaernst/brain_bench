import 'package:brain_bench/data/models/answer.dart';
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
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
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
