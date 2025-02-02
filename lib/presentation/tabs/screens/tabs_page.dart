import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/results/Screens/result_page.dart';
import 'package:brain_bench/presentation/tabs/widgets/brain_bench_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const CategoriesPage(),
    const ResultPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BrainBenchBottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
