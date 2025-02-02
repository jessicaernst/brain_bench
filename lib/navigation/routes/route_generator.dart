import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/results/Screens/result_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TabsPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesPage());
      case '/results':
        return MaterialPageRoute(builder: (_) => const ResultPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
