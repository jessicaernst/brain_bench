import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:logging/logging.dart';

part 'router_refresh_notifier.g.dart';

final _log = Logger('RouterRefreshNotifier');

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
class RouterRefreshNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _disposed = false;

  /// Creates an instance of [RouterRefreshNotifier].
  ///
  /// It immediately starts listening to the [currentUserProvider].
  RouterRefreshNotifier(this._ref) {
    _log.fine(
        'Initializing RouterRefreshNotifier and listening to auth state.'); // Init-Log
    // Listen to the authentication state provider.
    _ref.listen<AsyncValue<AppUser?>>(currentUserProvider, (previous, next) {
      if (previous != next) {
        if (!_disposed) {
          _log.info(
              'Auth state changed: $previous -> $next. Notifying listeners.');
          notifyListeners(); // <-- Notify only when state differs
        } else {
          _log.fine('Notifier disposed, skipping notifyListeners.');
        }
      } else {
        _log.fine('Auth state did not change ($next). Skipping notification.');
      }
      // --- END FIX ---
    }, onError: (error, stackTrace) {
      // Also notify on errors. You could potentially add a check here too
      // if you wanted to avoid notifying on consecutive identical errors,
      // but notifying on any error is usually desired for routing.
      if (!_disposed) {
        _log.severe(
            'Error occurred in currentUserProvider stream', error, stackTrace);
        // Consider if previous == AsyncError(error, stackTrace) check is needed
        notifyListeners();
      }
    });
  }

  /// Cleans up resources when the notifier is disposed.
  ///
  /// Sets the [_disposed] flag to true to prevent further notifications.
  @override
  void dispose() {
    _log.fine('Disposing RouterRefreshNotifier.'); // Dispose-Log
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
