import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/material.dart';

/// A widget that displays the header for the actual category section in the home screen.
class ActualCategoryHeader extends StatelessWidget {
  const ActualCategoryHeader({
    super.key,
    required this.localizations,
    required this.verticalSpacing,
    required this.isDarkMode,
  });

  final AppLocalizations localizations;
  final double verticalSpacing;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, top: verticalSpacing),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          localizations.homeActualCategorySectionTitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode
                    ? BrainBenchColors.cloudCanvas.withAlpha(
                      (0.6 * 255).toInt(),
                    )
                    : BrainBenchColors.deepDive.withAlpha((0.6 * 255).toInt()),
          ),
        ),
      ),
    );
  }
}
