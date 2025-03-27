import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/auth/screens/login_sign_up_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_page.dart';
import 'package:brain_bench/presentation/results/Screens/quiz_result_page.dart';
import 'package:brain_bench/presentation/results/screens/result_page.dart';
import 'package:brain_bench/presentation/topics/screens/topics_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';
import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/navigation/router_refresh_provider.dart';

/// The main router for the BrainBench application, defining all navigation routes.
final goRouterProvider = Provider<GoRouter>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final routerRefresh = ref.watch(routerRefreshProvider);

  return GoRouter(
    // The initial location to navigate to when the app starts.
    initialLocation: '/home',

    // Listen to auth changes via notifier
    refreshListenable: routerRefresh,

    // Redirect based on auth state
    redirect: (context, state) {
      final user = userAsync.asData?.value;
      final isOnLogin = state.matchedLocation == '/login';

      if (user == null && !isOnLogin) return '/login';
      if (user != null && isOnLogin) return '/home';
      return null;
    },

    routes: [
      // Login page (shown if not authenticated)
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginSignUpPage(),
      ),

      // StatefulShellRoute with persistent bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TabsPage(navigationShell: navigationShell);
        },
        branches: [
          // The first branch represents the 'Home' tab.
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomePage()),
            ],
          ),

          // The second branch represents the 'Categories' tab.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (_, __) => const CategoriesPage(),
              ),
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
                },
              ),
            ],
          ),

          // The third branch represents the 'Results' tab.
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/results', builder: (_, __) => const ResultPage()),
            ],
          ),
        ],
      ),

      // The route for the quiz page (outside of bottom nav)
      GoRoute(
        path: '/categories/details/topics/quiz',
        builder: (_, state) {
          final extra = state.extra as Map<String, String>?;
          final topicId = extra?['topicId'];
          final categoryId = extra?['categoryId'];

          return topicId != null && categoryId != null
              ? QuizPage(topicId: topicId, categoryId: categoryId)
              : const NotFoundPage();
        },
      ),

      // The route for the quiz result page
      GoRoute(
        path: '/categories/details/topics/quiz/result',
        builder: (_, state) {
          final extra = state.extra as Map<String, String>?;
          final categoryId = extra?['categoryId'];
          final topicId = extra?['topicId'];

          return categoryId != null && topicId != null
              ? QuizResultPage(categoryId: categoryId, topicId: topicId)
              : const NotFoundPage();
        },
      ),
    ],
  );
});
