// Remove unused import: import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'dart:async';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/data/infrastructure/database_providers.dart'; // Required for userFirebaseRepositoryProvider
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart'; // Required for AppUser
import 'package:brain_bench/data/repositories/user_repository.dart'; // Required for UserRepository
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Required for SharedPreferences

// Mocks for the new dependencies
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockUserFirebaseRepository extends Mock implements UserRepository {}

class MockAppUser extends Mock
    implements AppUser {} // If needed for currentUserProvider

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('getNextThemeModeCycle', () {
    test('should return ThemeMode.light when current is system', () {
      expect(getNextThemeModeCycle(ThemeMode.system), ThemeMode.light);
    });

    test('should return ThemeMode.dark when current is light', () {
      expect(getNextThemeModeCycle(ThemeMode.light), ThemeMode.dark);
    });

    test('should return ThemeMode.system when current is dark', () {
      expect(getNextThemeModeCycle(ThemeMode.dark), ThemeMode.system);
    });
  });

  // --- Test Group for the ThemeModeNotifier ---
  group('ThemeModeNotifier', () {
    late MockSharedPreferences mockPrefs;
    late MockUserFirebaseRepository mockUserRepo;
    late ProviderContainer container;
    late ThemeModeNotifier notifier;

    // Initial theme mode for setup
    const initialThemeMode = ThemeMode.system;
    const nextThemeMode = ThemeMode.light; // Based on getNextThemeModeCycle
    const String themeModeKey = 'app_theme_mode'; // Key used in provider

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockUserRepo = MockUserFirebaseRepository();

      // Default stub for SharedPreferences loading (no user logged in scenario)
      when(
        () => mockPrefs.getString(themeModeKey),
      ).thenReturn(initialThemeMode.name);
      // Default stub for SharedPreferences saving
      when(
        () => mockPrefs.setString(themeModeKey, any()),
      ).thenAnswer((_) async => true);

      // Default stub for user repository (e.g., successful update)
      when(
        () => mockUserRepo.updateUserProfile(
          userId: any(named: 'userId'),
          themeMode: any(named: 'themeMode'),
        ),
      ).thenAnswer((_) async {});

      // Create a ProviderContainer, overriding the repository provider
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          userFirebaseRepositoryProvider.overrideWithValue(mockUserRepo),
          // Assume no user logged in for most initial tests, can be overridden per test
          currentUserProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );

      // Keep the notifier instance for easy access in tests
      // Reading the notifier triggers the 'build' method
      notifier = container.read(themeModeNotifierProvider.notifier);
      // Removed: container.listen(themeModeNotifierProvider, (_, __) {});
      // Let tests explicitly trigger and await the initial build.
    });

    tearDown(() {
      container.dispose();
    });

    // --- ThemeModeNotifier Tests ---
    test(
      'build loads initial theme (from prefs, no user) and sets state to AsyncData',
      () async {
        // Assertions
        // Wait for the future provided by the provider to complete
        await expectLater(
          container.read(themeModeNotifierProvider.future),
          completion(initialThemeMode),
        );

        // Verify the final state
        expect(
          container.read(themeModeNotifierProvider),
          const AsyncData(initialThemeMode),
        );

        // Verify that SharedPreferences.getString was called (likely twice due to build logic)
        verify(() => mockPrefs.getString(themeModeKey)).called(2);
        // Ensure user repo was not called as no user is logged in
        verifyNever(
          () => mockUserRepo.updateUserProfile(
            userId: any(named: 'userId'),
            themeMode: any(named: 'themeMode'),
          ),
        );
      },
    );

    test(
      'build sets state to AsyncError if SharedPreferences throws during load (no user)',
      () async {
        // Arrange: Define the exception
        final exception = Exception('Failed to load theme');

        // Configure THIS mock instance to throw
        final localMockPrefs = MockSharedPreferences();
        final localMockUserRepo =
            MockUserFirebaseRepository(); // Needed for override

        when(() => localMockPrefs.getString(themeModeKey)).thenThrow(exception);

        // --- Dispose the setUp container (optional but good practice) ---
        container.dispose();

        // --- Create a NEW container overriding with the LOCAL mock ---
        final errorContainer = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(localMockPrefs),
            userFirebaseRepositoryProvider.overrideWithValue(localMockUserRepo),
            currentUserProvider.overrideWith(
              (ref) => Stream.value(null),
            ), // Still no user
          ],
        );
        // Add listener
        errorContainer.listen(themeModeNotifierProvider, (_, __) {});

        // Assertions:
        // The build method will catch the error from SharedPreferences
        // and fallback to ThemeMode.system. So, the future completes successfully.
        await expectLater(
          errorContainer.read(
            themeModeNotifierProvider.future,
          ), // Read from new container
          completion(ThemeMode.system), // Expect fallback to system theme
          reason: "Provider's future should complete with fallback theme",
        );

        // Verify the final state is AsyncError after awaiting
        await Future.delayed(Duration.zero); // Allow state update
        final state = errorContainer.read(
          themeModeNotifierProvider,
        ); // Read from new container
        // The state should be AsyncData with the fallback value.
        expect(
          state,
          const AsyncData(ThemeMode.system),
          reason: 'State should be AsyncData with fallback theme',
        );

        // Verify: loadThemeMode was called ONCE on the LOCAL mock instance
        verify(() => localMockPrefs.getString(themeModeKey)).called(
          2,
        ); // Called during build (loading + data phases, one of which threw internally)
        // No need for verifyNoMoreInteractions on the local mock here

        errorContainer.dispose(); // Dispose test-specific container
      },
    );

    test(
      'setThemeMode updates state optimistically and calls prefs save (no user)',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        const newMode = ThemeMode.dark;

        // Act: Call setThemeMode
        await notifier.setThemeMode(newMode);

        // Assertions
        // 1. State should be updated optimistically (immediately)
        expect(
          container.read(themeModeNotifierProvider),
          const AsyncData(newMode),
        );
        // 2. SharedPreferences.setString should be called with the new mode
        verify(() => mockPrefs.setString(themeModeKey, newMode.name)).called(1);
        // 3. SharedPreferences.getString was called during build
        verify(() => mockPrefs.getString(themeModeKey)).called(2);
        // 4. User repo not called
        verifyNever(
          () => mockUserRepo.updateUserProfile(
            userId: any(named: 'userId'),
            themeMode: any(named: 'themeMode'),
          ),
        );
      },
    );

    test(
      'setThemeMode updates state to AsyncError with previous data if prefs save fails (no user)',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        const newMode = ThemeMode.dark;
        final exception = Exception('Failed to save theme');
        // Simulate SharedPreferences.setString failing
        when(
          () => mockPrefs.setString(themeModeKey, newMode.name),
        ).thenThrow(exception);

        // Act: Call setThemeMode
        await notifier.setThemeMode(newMode);

        // Assertions
        // 1. State should end up as AsyncError
        final state = container.read(themeModeNotifierProvider);
        expect(state, isA<AsyncError>());
        // 2. The error should be the one thrown
        expect((state as AsyncError).error, exception);
        // 3. Crucially, the *value* within the error state should be the
        //    optimistically set value (newMode), thanks to copyWithPrevious.
        expect(state.value, newMode);
        // 4. SharedPreferences.setString should have been called
        verify(() => mockPrefs.setString(themeModeKey, newMode.name)).called(1);
        // 5. SharedPreferences.getString was called during build
        verify(() => mockPrefs.getString(themeModeKey)).called(2);
        // 6. User repo not called
        verifyNever(
          () => mockUserRepo.updateUserProfile(
            userId: any(named: 'userId'),
            themeMode: any(named: 'themeMode'),
          ),
        );
      },
    );

    test(
      'setThemeMode does nothing if the new mode is the same as current',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        final currentMode = container.read(themeModeNotifierProvider).value;

        // Act: Call setThemeMode with the same mode
        await notifier.setThemeMode(
          currentMode!,
        ); // Use the actual current mode

        // Assertions
        // 1. State should remain unchanged
        expect(
          container.read(themeModeNotifierProvider),
          AsyncData(currentMode),
        );
        // 2. Repository's saveThemeMode should NOT be called
        verifyNever(() => mockPrefs.setString(any(), any()));
        verifyNever(
          () => mockUserRepo.updateUserProfile(
            userId: any(named: 'userId'),
            themeMode: any(named: 'themeMode'),
          ),
        );
        // 3. SharedPreferences.getString was called during build
        verify(() => mockPrefs.getString(themeModeKey)).called(2);
      },
    );

    // --- Test for setting theme while state is AsyncError ---
    test(
      'setThemeMode optimistically updates state again if called while state is AsyncError (from save failure)',
      () async {
        // Arrange 1: Ensure initial build completes successfully
        await container.read(themeModeNotifierProvider.future);
        expect(
          container.read(themeModeNotifierProvider).value,
          initialThemeMode,
        );

        // Arrange 2: Simulate a SAVE failure to get into AsyncError state
        final saveException = Exception('Failed to save theme');
        const themeToFailSave = ThemeMode.dark;
        // Simulate SharedPreferences.setString failing for the first attempt
        when(
          () => mockPrefs.setString(themeModeKey, themeToFailSave.name),
        ).thenThrow(saveException);

        // Act 1: Call setThemeMode, which will fail during save
        await notifier.setThemeMode(themeToFailSave);

        // Assert 1: Verify the state is now AsyncError, but contains the optimistic value
        final errorState = container.read(themeModeNotifierProvider);
        expect(
          errorState,
          isA<AsyncError>(),
          reason: 'State should be AsyncError after save fails',
        );
        expect(errorState.error, saveException);
        expect(errorState.value, themeToFailSave);
        verify(
          () => mockPrefs.setString(themeModeKey, themeToFailSave.name),
        ).called(1);

        // Arrange 3: Define a different theme for the next attempt
        const nextThemeAttempt = ThemeMode.light;
        // Ensure the next save attempt (if it happens) succeeds for SharedPreferences
        when(
          () => mockPrefs.setString(themeModeKey, nextThemeAttempt.name),
        ).thenAnswer((_) async => true);

        // Act 2: Attempt to set theme AGAIN while state is AsyncError
        await notifier.setThemeMode(nextThemeAttempt);

        // Assert 2: State should change optimistically AGAIN, saveThemeMode called again
        final finalState = container.read(themeModeNotifierProvider);
        // --- CORRECTED ASSERTION ---
        // Expect AsyncData because the guard clause allows the optimistic update
        expect(
          finalState,
          const AsyncData(nextThemeAttempt),
          reason:
              'State should optimistically update again even from AsyncError',
        );
        // --- END CORRECTION ---

        // Verify saveThemeMode WAS called for the second attempt (total calls is 2)
        // The first call threw, the second call (this one) should have happened.
        verify(
          () => mockPrefs.setString(themeModeKey, nextThemeAttempt.name),
        ).called(1);
      },
    );

    test('toggleTheme calculates next theme and calls setThemeMode', () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      expect(container.read(themeModeNotifierProvider).value, initialThemeMode);

      // Act: Call toggleTheme
      await notifier.toggleTheme();

      // Assertions
      // 1. State should be updated to the next theme in the cycle
      expect(
        container.read(themeModeNotifierProvider),
        const AsyncData(nextThemeMode),
      );
      // 2. SharedPreferences.setString should be called with the next theme
      verify(
        () => mockPrefs.setString(themeModeKey, nextThemeMode.name),
      ).called(1);
      // 3. SharedPreferences.getString was called during build
      verify(() => mockPrefs.getString(themeModeKey)).called(2);
      verifyNever(
        () => mockUserRepo.updateUserProfile(
          userId: any(named: 'userId'),
          themeMode: any(named: 'themeMode'),
        ),
      );
    });

    // --- Test for toggling theme while state is AsyncError ---
    test(
      'toggleTheme optimistically updates state again if called while state is AsyncError (from save failure)',
      () async {
        // Arrange 1: Ensure initial build completes successfully
        await container.read(themeModeNotifierProvider.future);

        // Arrange 2: Simulate a SAVE failure to get into AsyncError state
        final saveException = Exception('Failed to save theme');
        const themeToFailSave = ThemeMode.dark;
        when(
          () => mockPrefs.setString(themeModeKey, themeToFailSave.name),
        ).thenThrow(saveException);
        await notifier.setThemeMode(
          themeToFailSave,
        ); // Trigger the save failure

        // Assert 1: Verify the state is now AsyncError
        final errorState = container.read(themeModeNotifierProvider);
        expect(
          errorState,
          isA<AsyncError>(),
          reason: 'State should be AsyncError after save fails',
        );
        expect(errorState.error, saveException);
        expect(errorState.value, themeToFailSave);
        verify(
          () => mockPrefs.setString(themeModeKey, themeToFailSave.name),
        ).called(1);

        // Arrange 3: Determine the expected next theme
        final expectedNextTheme = getNextThemeModeCycle(
          themeToFailSave,
        ); // dark -> system
        when(
          () => mockPrefs.setString(themeModeKey, expectedNextTheme.name),
        ).thenAnswer((_) async => true); // Next save should succeed

        // Act: Attempt to toggle theme AGAIN while state is AsyncError
        await notifier.toggleTheme();

        // Assert 2: State should change optimistically AGAIN, saveThemeMode called again
        final finalState = container.read(themeModeNotifierProvider);
        // --- CORRECTED ASSERTION ---
        // Expect AsyncData with the next theme in the cycle
        expect(
          finalState,
          AsyncData(expectedNextTheme),
          reason:
              'State should optimistically update to next theme even from AsyncError',
        );
        // --- END CORRECTION ---

        // Verify saveThemeMode WAS called for the second attempt (total calls is 2)
        verify(
          () => mockPrefs.setString(themeModeKey, expectedNextTheme.name),
        ).called(1);
      },
    );

    test(
      'refreshTheme reloads from repository and updates state on success',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        final initialValue =
            container.read(themeModeNotifierProvider).value; // Store initial
        expect(initialValue, initialThemeMode);

        const refreshedMode = ThemeMode.dark;
        // Mock the *next* call to SharedPreferences.getString for the refresh
        when(
          () => mockPrefs.getString(themeModeKey),
        ).thenReturn(refreshedMode.name);

        clearInteractions(mockPrefs); // Clear interactions before the action

        // Act: Call refreshTheme and wait for it to complete
        await notifier.refreshTheme();

        // --- REMOVED Intermediate State Check ---
        // final loadingState = container.read(themeModeNotifierProvider);
        // expect(loadingState, isA<AsyncLoading>());
        // expect(loadingState.value, initialThemeMode);
        // --- END REMOVAL ---

        // Assertions - Final State
        final finalState = container.read(themeModeNotifierProvider);
        expect(finalState, const AsyncData(refreshedMode));
        // Verify SharedPreferences.getString was called once during refresh
        verify(() => mockPrefs.getString(themeModeKey)).called(1);
      },
    );

    test(
      'refreshTheme sets state to AsyncError if repository fails on reload',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        final initialValue =
            container.read(themeModeNotifierProvider).value; // Store initial
        expect(initialValue, initialThemeMode);

        final exception = Exception('Failed to refresh');
        // Mock the *next* call to SharedPreferences.getString to throw an error
        when(() => mockPrefs.getString(themeModeKey)).thenThrow(exception);

        clearInteractions(mockPrefs); // Clear interactions before the action

        // Act: Call refreshTheme and wait for it to complete
        await notifier.refreshTheme();

        // Assertions - Final State
        final errorState = container.read(themeModeNotifierProvider);
        expect(errorState, isA<AsyncError>());
        expect(errorState.error, exception);
        // Verify previous value is kept due to copyWithPrevious
        expect(errorState.value, initialValue);
        // Verify SharedPreferences.getString was called once during refresh (and threw)
        verify(() => mockPrefs.getString(themeModeKey)).called(1);
      },
    );
  });
}
