import 'package:brain_bench/business_logic/navigation/router_refresh_notifier.dart';
import 'package:brain_bench/navigation/transitions/app_transitions.dart';
import 'package:brain_bench/presentation/splash/screens/splash_page.dart';
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
import 'package:logging/logging.dart';

final Logger _logger = Logger('AuthRouter');

/// The main router for the BrainBench application, defining all navigation routes.
final goRouterProvider = Provider<GoRouter>((ref) {
  final routerRefreshListenable = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    //routerRefresh, // Listens for auth changes (though SplashPage handles exit)
    refreshListenable: routerRefreshListenable,
    redirect: (context, state) {
      final userAsyncValue = ref.read(currentUserProvider);
      // Get current location details
      final isSplashPage = state.matchedLocation == '/splash';
      final isLoginPage = state.matchedLocation == '/login';

      // Determine auth state details
      final authIsLoading = userAsyncValue is AsyncLoading;
      final user = userAsyncValue.valueOrNull;

      _logger.fine(
          'Redirect Check: Location="${state.matchedLocation}", isSplash=$isSplashPage, isLogin=$isLoginPage, authLoading=$authIsLoading, userPresent=${user != null}');

      // --- Refined Redirection Logic ---

      // 1. If auth is still loading FOR THE VERY FIRST TIME (we are on /splash):
      //    Stay on splash. Let SplashPage handle the exit via context.replace.
      if (isSplashPage && authIsLoading) {
        // This condition is primarily for the initial app start.
        // If we somehow land on /splash later while auth is loading,
        // this also prevents an immediate redirect away.
        _logger.fine('Redirect Result: null (Rule 1: Initial Splash Load)');
        return null;
      }

      // 2. If we are on splash, BUT auth has already resolved:
      //    This means SplashPage is about to navigate or has just navigated.
      //    Return null to let SplashPage's context.replace finish its job without interference.
      if (isSplashPage && !authIsLoading) {
        _logger.fine(
            'Redirect Result: null (Rule 2: Splash resolved, let SplashPage navigate)');
        return null;
      }

      // --- At this point, we are GUARANTEED NOT to be on /splash ---

      // 3. If auth is still loading AFTER leaving splash (unlikely but possible):
      //    Do nothing and wait for auth to resolve. Avoids unnecessary redirects.
      if (authIsLoading) {
        _logger.fine(
            'Redirect Result: null (Rule 3: Not on Splash, Auth loading)');
        return null;
      }

      // --- At this point, auth is resolved, and we are NOT on /splash ---

      // 4. Apply standard redirection rules:
      // Rule 4a: User is logged out, but NOT on the login page? -> Redirect to login.
      if (user == null && !isLoginPage) {
        _logger.info(
            'Redirect Result: "/login" (Rule 4a: Logged out, not on login)');
        return '/login';
      }
      // Rule 4b: User is logged in, but IS on the login page? -> Redirect to home.
      if (user != null && isLoginPage) {
        _logger.info('Redirect Result: "/home" (Rule 4b: Logged in, on login)');
        return '/home';
      }

      // 5. Default Case: No redirection needed.
      //    (User logged in and on a protected page, or user logged out and on login page)
      _logger.fine('Redirect Result: null (Rule 5: No redirect needed)');
      return null;
    },

    routes: [
      // Splash Screen Route
      GoRoute(
        path: '/splash',
        // Use simple builder, no transition needed for the initial screen
        builder: (context, state) => SplashPage(),
      ),

      // Login Page Route (Cupertino Slide)
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginSignUpPage(),
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
          child: ProfilePage(),
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
          child: SettingsPage(),
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
                  child: HomePage(),
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
                  child: CategoriesPage(),
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
                    // Handle case where category might be null if navigated incorrectly
                    child: category != null
                        ? CategoryDetailsPage(category: category)
                        : NotFoundPage(
                            onBack: () => context
                                .go('/categories')), // Provide a way back
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
                    // Handle case where categoryId might be null
                    child: categoryId != null
                        ? TopicsPage(categoryId: categoryId)
                        : NotFoundPage(
                            onBack: () => context
                                .go('/categories')), // Provide a way back
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
                  child: ResultPage(),
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
            // Handle case where extras might be null or incomplete
            child: topicId != null && categoryId != null
                ? QuizPage(topicId: topicId, categoryId: categoryId)
                // Navigate back to topics if data is missing
                : NotFoundPage(
                    onBack: () => context.go('/categories/details/topics',
                        extra: categoryId)),
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
            // Handle case where extras might be null or incomplete
            child: categoryId != null && topicId != null
                ? QuizResultPage(categoryId: categoryId, topicId: topicId)
                // Navigate back to topics if data is missing
                : NotFoundPage(
                    onBack: () => context.go('/categories/details/topics',
                        extra: categoryId)),
            transitionsBuilder: buildCupertinoSlideTransition,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
          );
        },
      ),
    ],
    // Error page: Define where the back button should lead
    errorBuilder: (context, state) => NotFoundPage(
      error: state.error,
      // Go back to home seems like a reasonable default for unexpected errors
      onBack: () => context.go('/home'),
    ),
  );
});
