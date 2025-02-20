import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/navigation/tabs/widgets/brain_bench_bottom_nav_bar.dart';

class TabsPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const TabsPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final bool isFullScreen =
        GoRouterState.of(context).uri.toString().contains('/quiz');

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: isFullScreen
          ? null
          : BrainBenchBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTabSelected: (index) => navigationShell.goBranch(index),
            ),
    );
  }
}
