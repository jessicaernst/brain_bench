import 'dart:ffi';

import 'package:brain_bench/core/widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/data/models/answer.dart';
import 'package:flutter/material.dart';

class FeedbackBottomSheetView extends StatelessWidget {
  const FeedbackBottomSheetView({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
    required this.btnLbl,
    required this.onBtnPressed,
  });

  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;
  final String btnLbl;
  final VoidCallback onBtnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Results',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (correctAnswers.isNotEmpty) ...[
            const Text('✅ Correct Answers:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...correctAnswers.map((a) => Text('- ${a.text}',
                style: const TextStyle(color: Colors.green))),
            const SizedBox(height: 8),
          ],

          if (incorrectAnswers.isNotEmpty) ...[
            const Text('❌ Incorrect Answers:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...incorrectAnswers.map((a) =>
                Text('- ${a.text}', style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 8),
          ],

          if (missedCorrectAnswers.isNotEmpty) ...[
            const Text('⚠️ Missed Correct Answers:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...missedCorrectAnswers.map((a) => Text('- ${a.text}',
                style: const TextStyle(color: Colors.orange))),
            const SizedBox(height: 8),
          ],

          const Spacer(),

          // You can add a button to close the BottomSheet or go to the next question
          Center(
            child: LightDarkSwitchBtn(
              title: btnLbl,
              isActive: true,
              onPressed: onBtnPressed,
            ),
          ),
        ],
      ),
    );
  }
}
