import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/business_logic/auth/current_user_provider.dart';

part 'router_refresh_notifier.g.dart';

/// A [ChangeNotifier] used to signal GoRouter to refresh its route state.
///
/// This notifier listens to changes in the authentication state (`currentUserProvider`).
/// When the authentication state changes (e.g., user logs in or out), it calls
/// `notifyListeners()`.
///
/// GoRouter is configured to listen to this notifier via its `refreshListenable`
/// parameter. When notified, GoRouter re-evaluates its `redirect` logic,
/// ensuring the user is navigated to the correct page (e.g., `/login` or `/home`)
/// based on their new authentication status.
///
/// Using this notifier avoids the need to `ref.watch(currentUserProvider)` directly
/// within the `goRouterProvider` definition, which could cause the entire GoRouter
/// instance to be rebuilt on auth changes, potentially leading to unwanted UI
/// rebuilds (like the SplashPage rebuilding). It also provides the necessary
/// reactivity that would be missing if `redirect` only used `ref.read`.
class RouterRefreshNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _disposed = false; // Flag to prevent notifications after disposal

  /// Creates an instance of [RouterRefreshNotifier].
  ///
  /// It immediately starts listening to the [currentUserProvider].
  RouterRefreshNotifier(this._ref) {
    // Listen to the authentication state provider.
    // We use `listen` here because we only need to react to changes,
    // not rebuild this notifier based on the auth state value itself.
    _ref.listen<AsyncValue<dynamic>>(
      currentUserProvider, // The provider to listen to
      (_, next) {
        // When the auth state changes (loading, data, error), notify listeners.
        if (!_disposed) {
          notifyListeners();
        }
      },
    );
  }

  /// Cleans up resources when the notifier is disposed.
  ///
  /// Sets the [_disposed] flag to true to prevent further notifications.
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Provides the singleton instance of [RouterRefreshNotifier].
///
/// Annotated with `@Riverpod(keepAlive: true)`:
/// - `@Riverpod`: Generates the necessary provider code (`routerRefreshNotifierProvider`).
/// - `keepAlive: true`: Ensures that the [RouterRefreshNotifier] instance is
///   not automatically disposed when there are no active listeners from the UI.
///   This is crucial because GoRouter needs this listener to persist throughout
///   the app's lifecycle to react to auth changes at any time.
@Riverpod(keepAlive: true)
RouterRefreshNotifier routerRefreshNotifier(Ref ref) {
  // Create and return the RouterRefreshNotifier instance, passing the ref
  // so it can listen to other providers.
  return RouterRefreshNotifier(ref);
}
