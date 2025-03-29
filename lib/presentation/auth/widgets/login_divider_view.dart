import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

class LoginDividerView extends StatelessWidget {
  const LoginDividerView({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDarkMode
                ? BrainBenchColors.cloudCanvas.withAlpha((0.29 * 255).toInt())
                : BrainBenchColors.deepDive.withAlpha((0.29 * 255).toInt()),
            thickness: 0.7,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextTheme.of(context).bodySmall,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: isDarkMode
                ? BrainBenchColors.cloudCanvas.withAlpha((0.29 * 255).toInt())
                : BrainBenchColors.deepDive.withAlpha((0.29 * 255).toInt()),
            thickness: 0.7,
          ),
        ),
      ],
    );
  }
}
