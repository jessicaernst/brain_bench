import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class BrainBenchBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BrainBenchBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  Widget _buildSvgIcon({
    required Widget Function({
      double? width,
      double? height,
      ColorFilter? colorFilter,
    })
    icon,
    Color? color,
  }) {
    return icon(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color ?? Colors.grey, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = BottomNavigationBarTheme.of(context);
    final selectedColor = theme.selectedItemColor;
    final unselectedColor = theme.unselectedItemColor;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: [
        BottomNavigationBarItem(
          activeIcon: _buildSvgIcon(
            icon: Assets.icons.homeFilled.svg,
            color: selectedColor,
          ),
          icon: _buildSvgIcon(
            icon: Assets.icons.homeOutlined.svg,
            color: unselectedColor,
          ),
          label: localizations.bottomNavigationHome,
        ),
        BottomNavigationBarItem(
          activeIcon: _buildSvgIcon(
            icon: Assets.icons.quizFilled.svg,
            color: selectedColor,
          ),
          icon: _buildSvgIcon(
            icon: Assets.icons.quizOutlined.svg,
            color: unselectedColor,
          ),
          label: localizations.bottomNavigationQuiz,
        ),
        BottomNavigationBarItem(
          activeIcon: _buildSvgIcon(
            icon: Assets.icons.resultFilled.svg,
            color: selectedColor,
          ),
          icon: _buildSvgIcon(
            icon: Assets.icons.resultOulined.svg,
            color: unselectedColor,
          ),
          label: localizations.bottomNavigationResults,
        ),
      ],
    );
  }
}
