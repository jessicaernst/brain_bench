import 'package:brain_bench/navigation/transitions/app_transitions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/presentation/auth/screens/login_sign_up_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/profile/screens/profile_page.dart';
import 'package:brain_bench/presentation/settings/screens/settings_page.dart';
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
    initialLocation: '/home',
    refreshListenable: routerRefresh,
    redirect: (context, state) {
      final user = userAsync.asData?.value;
      final isPublicPage = state.matchedLocation == '/login';

      if (user == null && !isPublicPage) return '/login';
      if (user != null && isPublicPage) return '/home';
      return null;
    },
    routes: [
      // Login Page Route (Cupertino Slide)
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginSignUpPage(),
          transitionsBuilder: buildCupertinoSlideTransition,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        ),
      ),

      // Profile Page Route (Slide Up)
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionsBuilder: buildSlideUpTransition,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        ),
      ),

      // Settings Page Route (Slide Up)
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsPage(),
          transitionsBuilder: buildSlideUpTransition,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        ),
      ),

      // StatefulShellRoute with persistent bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // The shell itself doesn't animate with these transitions
          return TabsPage(navigationShell: navigationShell);
        },
        branches: [
          // Home Tab Branch (Cupertino Slide)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(),
                  transitionsBuilder: buildCupertinoSlideTransition,
                  transitionDuration: transitionDuration,
                  reverseTransitionDuration: reverseTransitionDuration,
                ),
              ),
            ],
          ),
          // Categories Tab Branch (Cupertino Slide)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const CategoriesPage(),
                  transitionsBuilder: buildCupertinoSlideTransition,
                  transitionDuration: transitionDuration,
                  reverseTransitionDuration: reverseTransitionDuration,
                ),
              ),
              GoRoute(
                path: '/categories/details',
                pageBuilder: (context, state) {
                  final category = state.extra as Category?;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: category != null
                        ? CategoryDetailsPage(category: category)
                        : const NotFoundPage(onBack: null),
                    transitionsBuilder: buildCupertinoSlideTransition,
                    transitionDuration: transitionDuration,
                    reverseTransitionDuration: reverseTransitionDuration,
                  );
                },
              ),
              GoRoute(
                path: '/categories/details/topics',
                pageBuilder: (context, state) {
                  final categoryId = state.extra as String?;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: categoryId != null
                        ? TopicsPage(categoryId: categoryId)
                        : const NotFoundPage(onBack: null),
                    transitionsBuilder: buildCupertinoSlideTransition,
                    transitionDuration: transitionDuration,
                    reverseTransitionDuration: reverseTransitionDuration,
                  );
                },
              ),
            ],
          ),
          // Results Tab Branch (Cupertino Slide)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/results',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ResultPage(),
                  transitionsBuilder: buildCupertinoSlideTransition,
                  transitionDuration: transitionDuration,
                  reverseTransitionDuration: reverseTransitionDuration,
                ),
              ),
            ],
          ),
        ],
      ),

      // Quiz Page Route (Cupertino Slide)
      GoRoute(
        path: '/categories/details/topics/quiz',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          final topicId = extra?['topicId'];
          final categoryId = extra?['categoryId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: topicId != null && categoryId != null
                ? QuizPage(topicId: topicId, categoryId: categoryId)
                : const NotFoundPage(onBack: null),
            transitionsBuilder: buildCupertinoSlideTransition,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
          );
        },
      ),

      // Quiz Result Page Route (Cupertino Slide)
      GoRoute(
        path: '/categories/details/topics/quiz/result',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          final categoryId = extra?['categoryId'];
          final topicId = extra?['topicId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: categoryId != null && topicId != null
                ? QuizResultPage(categoryId: categoryId, topicId: topicId)
                : const NotFoundPage(onBack: null),
            transitionsBuilder: buildCupertinoSlideTransition,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
          );
        },
      ),
    ],
    // errorBuilder uses default transition unless customized
    errorBuilder: (context, state) => NotFoundPage(
      error: state.error,
      onBack: () => context.go('/home'),
    ),
  );
});
