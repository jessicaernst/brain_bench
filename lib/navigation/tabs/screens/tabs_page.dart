import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/questions/single_multiple_choice_question.dart';
import 'package:brain_bench/presentation/results/Screens/result_page.dart';
import 'package:brain_bench/navigation/tabs/widgets/brain_bench_bottom_nav_bar.dart';
import 'package:brain_bench/presentation/topics/screens/topics_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Logger logger = Logger('TabsPage');

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<String> _initialRoutes = [
    '/home',
    '/categories',
    '/results',
  ];

  void _onTabSelected(int index) {
    if (_selectedIndex == index) {
      logger.info('Re-selecting tab $index, popping to root.');
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      logger.info('Switching to tab $index.');
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildTabNavigator(int index) {
    if (index < 0 || index >= _navigatorKeys.length) {
      logger.severe('Invalid tab index: $index');
      return const NotFoundPage();
    }

    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: _initialRoutes[index],
      onGenerateRoute: (settings) {
        logger.info(
            'Generating route for tab $index: ${settings.name}, arguments: ${settings.arguments}');
        switch (index) {
          case 0:
            return _homeRoutes(settings);
          case 1:
            return _categoriesRoutes(settings);
          case 2:
            return _resultsRoutes(settings);
          default:
            return MaterialPageRoute(builder: (_) => const NotFoundPage());
        }
      },
    );
  }

  Route<dynamic> _homeRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }

  Route<dynamic> _categoriesRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesPage());
      case '/categories/details':
        final category = settings.arguments as Category?;
        if (category == null) {
          logger.warning('Category is null!');
          return MaterialPageRoute(
            builder: (_) => const NotFoundPage(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => CategoryDetailsPage(category: category),
        );
      case '/categories/details/topics':
        final categoryId = settings.arguments as String?;
        if (categoryId == null) {
          logger.warning('CategoryId is null!');
          return MaterialPageRoute(
            builder: (_) => const NotFoundPage(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TopicsPage(categoryId: categoryId),
        );
      case '/categories/details/topics/quiz':
        final topicId = settings.arguments as String?;
        if (topicId == null) {
          logger.warning('TopicId is null!');
          return MaterialPageRoute(
            builder: (_) => const NotFoundPage(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => SingleMultipleChoiceQuestionPage(topicId: topicId),
        );
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }

  Route<dynamic> _resultsRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/results':
        return MaterialPageRoute(builder: (_) => const ResultPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(
          _navigatorKeys.length,
          (index) => Offstage(
            offstage: _selectedIndex != index,
            child: _buildTabNavigator(index),
          ),
        ),
      ),
      bottomNavigationBar: BrainBenchBottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
