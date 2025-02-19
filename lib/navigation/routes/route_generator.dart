import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_result_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const TabsPage());
      case '/quiz':
        final topicId = settings.arguments as String?;
        if (topicId == null) {
          return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
        return MaterialPageRoute(
          builder: (_) => QuizPage(topicId: topicId),
        );
      case '/quizResult':
        return MaterialPageRoute(
          builder: (_) => const QuizResultPage(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
