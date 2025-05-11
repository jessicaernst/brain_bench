import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/navigation/router_refresh_notifier.dart';
import 'package:brain_bench/navigation/routes/not_found_page.dart';
import 'package:brain_bench/navigation/tabs/screens/tabs_page.dart';
import 'package:brain_bench/navigation/transitions/app_transitions.dart';
import 'package:brain_bench/presentation/auth/screens/login_sign_up_page.dart';
import 'package:brain_bench/presentation/categories/screens/categories_page.dart';
import 'package:brain_bench/presentation/categories/screens/category_details_page.dart';
import 'package:brain_bench/presentation/home/screens/article_detail_page.dart'; // Import für die neue Seite
import 'package:brain_bench/presentation/home/screens/home_page.dart';
import 'package:brain_bench/presentation/profile/screens/profile_page.dart';
import 'package:brain_bench/presentation/quiz/screens/quiz_page.dart';
import 'package:brain_bench/presentation/results/Screens/quiz_result_page.dart';
import 'package:brain_bench/presentation/results/screens/result_page.dart';
import 'package:brain_bench/presentation/settings/screens/settings_page.dart';
import 'package:brain_bench/presentation/splash/screens/splash_page.dart';
import 'package:brain_bench/presentation/topics/screens/topics_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('AuthRouter');

class AppRouteNames {
  static const splash = 'splash';
  static const login = 'login';
  static const profile = 'profile';
  static const settings = 'settings';
  static const home = 'home';
  static const categories = 'categories';
  static const categoryDetails = 'categoryDetails';
  static const topics = 'topics';
  static const results = 'results';
  static const quiz = 'quiz';
  static const articleDetail = 'articleDetail';
  static const quizResult = 'quizResult';
}

/// The main router for the BrainBench application, defining all navigation routes.
final goRouterProvider = Provider<GoRouter>((ref) {
  final routerRefreshListenable = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    // Listens for auth changes to trigger redirection logic
    refreshListenable: routerRefreshListenable,
    redirect: (context, state) {
      final userAsyncValue = ref.read(currentUserProvider);
      // Use state.name for comparison with named routes
      final currentLocation = state.matchedLocation;
      final isSplashPage = currentLocation == '/splash';
      final isLoginPage = currentLocation == '/login';

      // Determine auth state details
      final authIsLoading = userAsyncValue is AsyncLoading;
      final user = userAsyncValue.valueOrNull;

      _logger.fine(
        'Redirect Check: Location="$currentLocation", PathParams="${state.pathParameters}", isSplash=$isSplashPage, isLogin=$isLoginPage, authLoading=$authIsLoading, userPresent=${user != null}',
      );

      // 1. If auth is still loading FOR THE VERY FIRST TIME (we are on /splash):
      //    Stay on splash. Let SplashPage handle the exit via context.replace.
      if (isSplashPage && authIsLoading) {
        _logger.fine('Redirect Result: null (Rule 1: Initial Splash Load)');
        return null;
      }

      // 2. If we are on splash, BUT auth has already resolved:
      //    This means SplashPage is about to navigate or has just navigated.
      //    Return null to let SplashPage's context.replace finish its job without interference.
      if (isSplashPage && !authIsLoading) {
        _logger.fine(
          'Redirect Result: null (Rule 2: Splash resolved, let SplashPage navigate)',
        );
        return null;
      }

      // 3. If auth is still loading AFTER leaving splash (unlikely but possible):
      //    Do nothing and wait for auth to resolve. Avoids unnecessary redirects.
      if (authIsLoading) {
        _logger.fine(
          'Redirect Result: null (Rule 3: Not on Splash, Auth loading)',
        );
        return null;
      }

      // 4. Apply standard redirection rules:
      // Rule 4a: User is logged out, but NOT on the login page? -> Redirect to login.
      if (user == null && !isLoginPage) {
        _logger.info(
          'Redirect Result: -> "${AppRouteNames.login}" (Rule 4a: Logged out, not on login)',
        );
        // Use namedLocation to get the path for the name
        return state.namedLocation(AppRouteNames.login);
      }
      // Rule 4b: User is logged in, but IS on the login page? -> Redirect to home.
      if (user != null && isLoginPage) {
        _logger.info(
          'Redirect Result: -> "${AppRouteNames.home}" (Rule 4b: Logged in, on login)',
        );
        return state.namedLocation(AppRouteNames.home);
      }

      // 5. Default Case: No redirection needed.
      //    (User logged in and on a protected page, or user logged out and on login page)
      _logger.fine('Redirect Result: null (Rule 5: No redirect needed)');
      return null;
    },

    routes: [
      // Splash Screen Route
      GoRoute(
        name: AppRouteNames.splash,
        path: '/splash',
        // Use simple builder, no transition needed for the initial screen
        builder: (context, state) => SplashPage(),
      ),

      // Login Page Route (Cupertino Slide)
      GoRoute(
        name: AppRouteNames.login,
        path: '/login',
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: LoginSignUpPage(),
              transitionsBuilder: buildCupertinoSlideTransition,
              transitionDuration: transitionDuration,
              reverseTransitionDuration: reverseTransitionDuration,
            ),
      ),

      // Profile Page Route (Slide Up)
      GoRoute(
        name: AppRouteNames.profile,
        path: '/profile',
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ProfilePage(),
              transitionsBuilder: buildSlideUpTransition,
              transitionDuration: transitionDuration,
              reverseTransitionDuration: reverseTransitionDuration,
            ),
      ),

      // Settings Page Route (Slide Up)
      GoRoute(
        name: AppRouteNames.settings,
        path: '/settings',
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: SettingsPage(),
              transitionsBuilder: buildSlideUpTransition,
              transitionDuration: transitionDuration,
              reverseTransitionDuration: reverseTransitionDuration,
            ),
      ),

      // Article Detail Page Route (Cupertino Slide) - Als Top-Level-Route
      GoRoute(
        name: AppRouteNames.articleDetail,
        path: '/article/:articleId', // Eigener Pfad, nicht mehr unter /home
        pageBuilder: (context, state) {
          final articleId = state.pathParameters['articleId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child:
                articleId != null
                    ? ArticleDetailPage(articleId: articleId)
                    : NotFoundPage(
                      // Fallback, falls articleId fehlt
                      onBack: () => context.goNamed(AppRouteNames.home),
                    ),
            transitionsBuilder: buildCupertinoSlideTransition,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
          );
        },
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
                name: AppRouteNames.home,
                path: '/home',
                pageBuilder:
                    (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: HomePage(),
                      transitionsBuilder: buildCupertinoSlideTransition,
                      transitionDuration: transitionDuration,
                      reverseTransitionDuration: reverseTransitionDuration,
                    ),
                // Die ArticleDetail-Route wurde nach oben verschoben
              ),
            ],
          ),
          // Categories Tab Branch (Cupertino Slide)
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouteNames.categories,
                path: '/categories',
                pageBuilder:
                    (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: CategoriesPage(),
                      transitionsBuilder: buildCupertinoSlideTransition,
                      transitionDuration: transitionDuration,
                      reverseTransitionDuration: reverseTransitionDuration,
                    ),
                // --- Sub-routes for Categories using Path Parameters ---
                routes: [
                  GoRoute(
                    name: AppRouteNames.categoryDetails,
                    path: ':categoryId/details',
                    pageBuilder: (context, state) {
                      final categoryId = state.pathParameters['categoryId'];
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child:
                            categoryId != null
                                ? CategoryDetailsPage(categoryId: categoryId)
                                : NotFoundPage(
                                  onBack:
                                      () => context.goNamed(
                                        AppRouteNames.categories,
                                      ),
                                ),
                        transitionsBuilder: buildCupertinoSlideTransition,
                        transitionDuration: transitionDuration,
                        reverseTransitionDuration: reverseTransitionDuration,
                      );
                    },
                    routes: [
                      GoRoute(
                        name: AppRouteNames.topics,
                        path: 'topics',
                        pageBuilder: (context, state) {
                          // Extract categoryId from path parameters
                          final categoryId = state.pathParameters['categoryId'];
                          return CustomTransitionPage(
                            key: state.pageKey,
                            // Pass only the ID to the page
                            child:
                                categoryId != null
                                    ? TopicsPage(categoryId: categoryId)
                                    : NotFoundPage(
                                      onBack:
                                          () => context.goNamed(
                                            AppRouteNames.categories,
                                          ),
                                    ),
                            transitionsBuilder: buildCupertinoSlideTransition,
                            transitionDuration: transitionDuration,
                            reverseTransitionDuration:
                                reverseTransitionDuration,
                          );
                        },
                        routes: [
                          GoRoute(
                            name: AppRouteNames.quiz,
                            path: ':topicId/quiz',
                            pageBuilder: (context, state) {
                              // Extract parameters
                              final categoryId =
                                  state.pathParameters['categoryId'];
                              final topicId = state.pathParameters['topicId'];
                              return CustomTransitionPage(
                                key: state.pageKey,
                                // Pass IDs to the page
                                child:
                                    topicId != null && categoryId != null
                                        ? QuizPage(
                                          topicId: topicId,
                                          categoryId: categoryId,
                                        )
                                        : NotFoundPage(
                                          // Back to Topics page for this category
                                          onBack:
                                              () => context.goNamed(
                                                AppRouteNames.topics,
                                                pathParameters: {
                                                  'categoryId':
                                                      categoryId ?? '',
                                                },
                                              ),
                                        ),
                                transitionsBuilder:
                                    buildCupertinoSlideTransition,
                                transitionDuration: transitionDuration,
                                reverseTransitionDuration:
                                    reverseTransitionDuration,
                              );
                            },
                            routes: [
                              GoRoute(
                                name: AppRouteNames.quizResult,
                                path: 'result',
                                pageBuilder: (context, state) {
                                  // Extract parameters
                                  final categoryId =
                                      state.pathParameters['categoryId'];
                                  final topicId =
                                      state.pathParameters['topicId'];
                                  return CustomTransitionPage(
                                    key: state.pageKey,
                                    // Pass IDs to the page
                                    child:
                                        categoryId != null && topicId != null
                                            ? QuizResultPage(
                                              categoryId: categoryId,
                                              topicId: topicId,
                                            )
                                            : NotFoundPage(
                                              onBack:
                                                  () => context.goNamed(
                                                    AppRouteNames.topics,
                                                    pathParameters: {
                                                      'categoryId':
                                                          categoryId ?? '',
                                                    },
                                                  ),
                                            ),
                                    transitionsBuilder:
                                        buildCupertinoSlideTransition,
                                    transitionDuration: transitionDuration,
                                    reverseTransitionDuration:
                                        reverseTransitionDuration,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Results Tab Branch (Cupertino Slide)
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouteNames.results, // Name added
                path: '/results',
                pageBuilder:
                    (context, state) => CustomTransitionPage(
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
    ],
    // Error page: Define where the back button should lead
    errorBuilder:
        (context, state) => NotFoundPage(
          error: state.error,
          // Go back to home seems like a reasonable default for unexpected errors
          onBack: () => context.goNamed(AppRouteNames.home), // Use goNamed
        ),
  );
});
