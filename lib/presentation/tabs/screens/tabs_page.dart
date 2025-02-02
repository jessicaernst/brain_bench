import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  Widget _buildSvgIcon({
    required Widget Function({
      double? width,
      double? height,
      ColorFilter? colorFilter,
    }) icon,
    Color? color,
  }) {
    return icon(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        color ?? Colors.white,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = BottomNavigationBarTheme.of(context);
    final selectedColor = theme.selectedItemColor;
    final unselectedColor = theme.unselectedItemColor;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            label: 'Home',
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
            label: 'Quiz',
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
            label: 'Result',
          ),
        ],
      ),
    );
  }
}
