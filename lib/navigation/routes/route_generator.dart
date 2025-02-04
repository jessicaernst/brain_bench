import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TabsPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
