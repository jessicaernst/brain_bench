import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_result_page.dart';
import 'package:brain_bench/presentation/results/screens/result_page.dart';
import 'package:brain_bench/presentation/topics/screens/topics_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    /// 🟢 **TABS-ROUTE mit Bottom Navbar**
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return TabsPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/categories',
                builder: (_, __) => const CategoriesPage()),
            GoRoute(
              path: '/categories/details',
              builder: (_, state) {
                final category = state.extra as Category?;
                return category != null
                    ? CategoryDetailsPage(category: category)
                    : const NotFoundPage();
              },
            ),
            GoRoute(
                path: '/categories/details/topics',
                builder: (_, state) {
                  final categoryId = state.extra as String?;
                  return categoryId != null
                      ? TopicsPage(categoryId: categoryId)
                      : const NotFoundPage();
                }),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/results', builder: (_, __) => const ResultPage()),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/categories/details/topics/quiz',
      builder: (_, state) {
        final topicId = state.extra as String?;
        return topicId != null
            ? QuizPage(topicId: topicId)
            : const NotFoundPage();
      },
    ),
    GoRoute(
      path: '/categories/details/topics/quiz/result',
      builder: (_, __) => const QuizResultPage(),
    ),
  ],
);
