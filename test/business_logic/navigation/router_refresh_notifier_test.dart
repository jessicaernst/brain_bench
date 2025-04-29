import 'dart:async'; // Import async library for StreamController

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/navigation/router_refresh_notifier.dart';
// Import the generated file if routerRefreshNotifierProvider is generated
// import 'package:brain_bench/business_logic/navigation/router_refresh_notifier.g.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Using mocktail for AppUser mock

// --- Mocks ---

// Mock AppUser for testing different auth states
class MockAppUser extends Mock implements AppUser {}

void main() {
  // --- Test Data ---
  final mockUser1 = MockAppUser();
  final mockUser2 = MockAppUser();
  final testException = Exception('Auth failed');

  // --- Test Setup ---
  // Use a StreamController to manually emit auth states
  late StreamController<AppUser?>
      authStateController; // <--- Use StreamController

  late ProviderContainer container;
  late RouterRefreshNotifier notifier;
  late List<VoidCallback> listeners; // To track notifyListeners calls

  setUp(() {
    // Create a new StreamController for each test
    // Use .broadcast() if the stream might be listened to multiple times, safer for tests
    authStateController = StreamController<
        AppUser?>.broadcast(); // <--- Initialize StreamController

    // Reset the fake provider's state before each test
    container = ProviderContainer(
      overrides: [
        // Override the actual currentUserProvider with our controlled stream
        currentUserProvider.overrideWith(
          // Provide the stream from the controller
          (ref) => authStateController.stream, // <--- Return the stream here
        ),
      ],
    );

    // Read the notifier instance using its provider.
    // This automatically creates the notifier and makes it listen
    // to the (overridden) currentUserProvider's stream.
    notifier = container.read(routerRefreshNotifierProvider);

    // Listener setup to track notifications
    listeners = [];
    notifier.addListener(() {
      listeners.add(() {}); // Add a dummy callback to count calls
    });

    // Ensure container is disposed after each test
    addTearDown(container.dispose);
    // Ensure the stream controller is closed
    addTearDown(authStateController.close); // <--- Close the controller
    // Ensure notifier listeners are removed (though dispose should handle this)
    // addTearDown(notifier.dispose); // Keep if notifier is not autoDispose or for clarity
  });

  // --- Test Group ---
  group('RouterRefreshNotifier', () {
    test(
        'initializes and listens to currentUserProvider (starts in loading state)',
        () {
      // Arrange: Setup is done in setUp()
      // Act: Reading the provider in setUp initializes the listener.
      // Assert: Expect no notifications initially.
      expect(listeners.isEmpty, isTrue);
      // Verify the initial state of the overridden provider (will be loading until stream emits)
      final initialState = container.read(currentUserProvider);
      expect(initialState, isA<AsyncLoading<AppUser?>>());
    });

    test('notifies listeners when user logs in (null -> user)', () async {
      // Arrange: Stream is initially empty (loading state). Add initial null state.
      authStateController.add(null); // <--- Emit initial null state
      await Future.microtask(() {}); // Allow initial null state to process
      listeners.clear(); // Clear listener calls from initial null emission
      expect(listeners.isEmpty, isTrue);

      // Act: Emit a user object on the stream to simulate login
      authStateController.add(mockUser1); // <--- Use controller to emit

      // Allow microtasks to complete (Riverpod processes stream events)
      await Future.microtask(() {});

      // Assert: Listener should have been called once for the change (null -> user)
      expect(listeners.length, 1);
      // Optional: Verify the state of the provider itself
      expect(
          container.read(currentUserProvider), AsyncData<AppUser?>(mockUser1));
    });

    test('notifies listeners when user logs out (user -> null)', () async {
      // Arrange: Set initial state to logged in
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {}); // Let initial state process
      listeners.clear(); // Clear listeners after initial setup state change

      // Act: Emit null on the stream to simulate logout
      authStateController.add(null); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should have been called once
      expect(listeners.length, 1);
      // Optional: Verify the state of the provider itself
      expect(
          container.read(currentUserProvider), const AsyncData<AppUser?>(null));
    });

    test('notifies listeners when user changes (user1 -> user2)', () async {
      // Arrange: Set initial state to logged in with user1
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});
      listeners.clear();

      // Act: Emit a different user object
      authStateController.add(mockUser2); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should have been called once
      expect(listeners.length, 1);
      // Optional: Verify the state of the provider itself
      expect(
          container.read(currentUserProvider), AsyncData<AppUser?>(mockUser2));
    });

    test('notifies listeners when auth stream emits an error', () async {
      // Arrange: Start logged in
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});
      listeners.clear();

      // Act: Emit an error on the stream
      authStateController.addError(
          testException, StackTrace.empty); // <--- Use controller to emit error
      await Future.microtask(() {});

      // Assert: Listener should have been called once
      expect(listeners.length, 1);
      // Optional: Verify the state of the provider itself
      expect(container.read(currentUserProvider), isA<AsyncError<AppUser?>>());
      expect(container.read(currentUserProvider).error, testException);
    });

    test('notifies listeners when auth state recovers from error', () async {
      // Arrange: Start with error state
      authStateController.addError(
          testException, StackTrace.empty); // <--- Use controller to emit error
      await Future.microtask(() {});
      listeners.clear();

      // Act: Emit a valid state (e.g., logged in again)
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should have been called once
      expect(listeners.length, 1);
      // Optional: Verify the state of the provider itself
      expect(
          container.read(currentUserProvider), AsyncData<AppUser?>(mockUser1));
    });

    test(
        'does NOT notify listeners if auth stream emits the same value consecutively',
        () async {
      // Arrange: Set initial state
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});
      listeners.clear();

      // Act: Emit the *same* user object again
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should NOT have been called if Riverpod optimizes/compares
      expect(listeners.isEmpty, isTrue);
    });

    test(
        'does NOT notify listeners if auth stream emits equivalent null value consecutively',
        () async {
      // Arrange: Set initial state to null
      authStateController.add(null); // <--- Use controller to emit
      await Future.microtask(() {});
      listeners.clear();

      // Act: Emit null again
      authStateController.add(null); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should NOT have been called
      expect(listeners.isEmpty, isTrue);
    });

    test('does NOT notify listeners after dispose is called', () async {
      // Arrange: Set initial state
      authStateController.add(null); // <--- Use controller to emit
      await Future.microtask(() {});
      listeners.clear();

      // Act: Dispose the notifier FIRST
      notifier.dispose(); // Manually dispose the notifier to stop its listeners

      // THEN try to emit a new auth state
      authStateController.add(mockUser1); // <--- Use controller to emit
      await Future.microtask(() {});

      // Assert: Listener should NOT have been called because the notifier was disposed
      expect(listeners.isEmpty, isTrue);
    });

    // KeepAlive test remains the same - it's about the provider definition
    test('provider is keepAlive', () {
      // Arrange: Read the provider definition directly
      final provider = routerRefreshNotifierProvider;
      // Assert: We assume the @Riverpod(keepAlive: true) annotation works.
      // Check if it's NOT AutoDispose if keepAlive=true
      // Adjust based on your actual annotation
      expect(
          provider,
          isNot(
              isA<AutoDisposeNotifierProvider>())); // Example if keepAlive=true
      // expect(provider, isA<AutoDisposeNotifierProvider>()); // Example if keepAlive=false (default)
    });
  });
}
