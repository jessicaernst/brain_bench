import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          activeIcon: Assets.icons.quizFilled.svg(
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              BrainBenchColors.blueprintBlue,
              BlendMode.srcIn,
            ),
          ),
          icon: Assets.icons.quizOutlined.svg(width: 24, height: 24),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          activeIcon: Assets.icons.resultFilled.svg(width: 24, height: 24),
          icon: Assets.icons.resultOulined.svg(
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              BrainBenchColors.blueprintBlue,
              BlendMode.srcIn,
            ),
          ),
          label: 'Result',
        ),
      ]),
    );
  }
}
