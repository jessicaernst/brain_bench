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

/// The main router for the BrainBench application, defining all navigation routes.
final GoRouter router = GoRouter(
  // The initial location to navigate to when the app starts.
  initialLocation: '/home',
  routes: [
    // StatefulShellRoute.indexedStack is used to create a bottom navigation bar with persistent state.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // The TabsPage widget is used as the root for the bottom navigation bar.
        return TabsPage(navigationShell: navigationShell);
      },
      branches: [
        // The first branch represents the 'Home' tab.
        StatefulShellBranch(
          routes: [
            // The route for the home page.
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          ],
        ),
        // The second branch represents the 'Categories' tab.
        StatefulShellBranch(
          routes: [
            // The route for the categories page.
            GoRoute(
                path: '/categories',
                builder: (_, __) => const CategoriesPage()),
            // The route for the category details page.
            GoRoute(
              path: '/categories/details',
              builder: (_, state) {
                // Extract the Category object passed as extra data.
                final category = state.extra as Category?;
                // If a category is provided, show the CategoryDetailsPage; otherwise, show the NotFoundPage.
                return category != null
                    ? CategoryDetailsPage(category: category)
                    : const NotFoundPage();
              },
            ),
            // The route for the topics page within a category.
            GoRoute(
                path: '/categories/details/topics',
                builder: (_, state) {
                  // Extract the categoryId passed as extra data.
                  final categoryId = state.extra as String?;
                  // If a categoryId is provided, show the TopicsPage; otherwise, show the NotFoundPage.
                  return categoryId != null
                      ? TopicsPage(categoryId: categoryId)
                      : const NotFoundPage();
                }),
          ],
        ),
        // The third branch represents the 'Results' tab.
        StatefulShellBranch(
          routes: [
            // The route for the results page.
            GoRoute(path: '/results', builder: (_, __) => const ResultPage()),
          ],
        ),
      ],
    ),
    // The route for the quiz page.
    // no BottomNavBar shown here
    GoRoute(
      path: '/categories/details/topics/quiz',
      builder: (_, state) {
        // Extract topicId and categoryId from the extra data (a Map).
        final extra = state.extra as Map<String, String>?;
        final topicId = extra?['topicId'];
        final categoryId = extra?['categoryId'];

        // If both topicId and categoryId are provided, show the QuizPage; otherwise, show the NotFoundPage.
        return topicId != null && categoryId != null
            ? QuizPage(topicId: topicId, categoryId: categoryId)
            : const NotFoundPage();
      },
    ),
    // The route for the quiz result page.
    GoRoute(
      path: '/categories/details/topics/quiz/result',
      builder: (_, state) {
        // Extract categoryId and topicId from the extra data (a Map).
        final extra = state.extra as Map<String, String>?;
        final categoryId = extra?['categoryId'];
        final topicId = extra?['topicId'];
        // If a categoryId and topicId is provided, show the QuizResultPage; otherwise, show the NotFoundPage.
        return categoryId != null && topicId != null
            ? QuizResultPage(categoryId: categoryId, topicId: topicId)
            : const NotFoundPage();
      },
    ),
  ],
);
