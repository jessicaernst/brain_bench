import 'package:brain_bench/data/models/answer.dart';
import 'package:flutter/material.dart';

class FeedbackBottomSheetView extends StatelessWidget {
  const FeedbackBottomSheetView({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.missedCorrectAnswers,
  });

  final List<Answer> correctAnswers;
  final List<Answer> incorrectAnswers;
  final List<Answer> missedCorrectAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      // or use a custom widget like a ResultBottomSheet widget
      height: 400,
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
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
