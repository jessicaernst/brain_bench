import 'package:brain_bench/data/models/category.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_page.dart';
import 'package:brain_bench/presentation/results/Screens/quiz_result_page.dart';
import 'package:brain_bench/presentation/results/screens/result_page.dart';
import 'package:brain_bench/presentation/topics/screens/topics_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
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
        // ✅ Extract topicId and categoryId correctly
        final extra = state.extra as Map<String, String>?;
        final topicId = extra?['topicId'];
        final categoryId = extra?['categoryId'];

        return topicId != null && categoryId != null
            ? QuizPage(topicId: topicId, categoryId: categoryId)
            : const NotFoundPage();
      },
    ),
    GoRoute(
      path: '/categories/details/topics/quiz/result',
      builder: (_, state) {
        // ✅ Extract categoryId correctly
        final categoryId = state.extra as String?;
        return categoryId != null
            ? QuizResultPage(categoryId: categoryId)
            : const NotFoundPage();
      },
    ),
  ],
);
