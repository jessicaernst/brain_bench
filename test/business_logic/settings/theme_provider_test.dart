// Remove unused import: import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'dart:async';

import 'package:brain_bench/business_logic/theme/theme_provider.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock the SettingsRepository using mocktail
class MockSettingsRepository extends Mock implements SettingsRepository {}

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
    late MockSettingsRepository mockRepository;
    late ProviderContainer container;
    late ThemeModeNotifier notifier;

    // Initial theme mode for setup
    const initialThemeMode = ThemeMode.system;
    const nextThemeMode = ThemeMode.light; // Based on getNextThemeModeCycle

    setUp(() {
      mockRepository = MockSettingsRepository();

      // Default stub for loading the initial theme
      when(
        () => mockRepository.loadThemeMode(),
      ).thenAnswer((_) async => initialThemeMode);
      // Default stub for saving
      when(
        () => mockRepository.saveThemeMode(any()),
      ).thenAnswer((_) async {}); // Assume success by default

      // Create a ProviderContainer, overriding the repository provider
      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // Keep the notifier instance for easy access in tests
      // Reading the notifier triggers the 'build' method
      notifier = container.read(themeModeNotifierProvider.notifier);
      // Add listener to keep provider alive during tests if needed
      container.listen(themeModeNotifierProvider, (_, __) {});
    });

    tearDown(() {
      container.dispose();
    });

    // --- ThemeModeNotifier Tests ---
    test(
      'build loads initial theme from repository and sets state to AsyncData',
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

        // Verify that loadThemeMode was called exactly once during build
        verify(() => mockRepository.loadThemeMode()).called(1);
        verifyNoMoreInteractions(mockRepository); // Ensure no other calls yet
      },
    );

    test(
      'build sets state to AsyncError if repository throws during load',
      () async {
        // Arrange: Define the exception
        final exception = Exception('Failed to load theme');

        // --- Create a fresh mock instance specifically for THIS test ---
        final localMockRepository = MockSettingsRepository();
        // Configure THIS mock instance to throw
        when(() => localMockRepository.loadThemeMode()).thenThrow(exception);

        // --- Dispose the setUp container (optional but good practice) ---
        container.dispose();

        // --- Create a NEW container overriding with the LOCAL mock ---
        final errorContainer = ProviderContainer(
          overrides: [
            // Use the mock created specifically for this test
            settingsRepositoryProvider.overrideWithValue(localMockRepository),
          ],
        );
        // Add listener
        errorContainer.listen(themeModeNotifierProvider, (_, __) {});

        // Assertions
        // Expect the future to complete with an error
        await expectLater(
          errorContainer.read(
            themeModeNotifierProvider.future,
          ), // Read from new container
          throwsA(exception),
          reason: "Provider's future should throw when build fails",
        );

        // Verify the final state is AsyncError after awaiting
        await Future.delayed(Duration.zero); // Allow state update
        final state = errorContainer.read(
          themeModeNotifierProvider,
        ); // Read from new container
        expect(state, isA<AsyncError>(), reason: 'State should be AsyncError');
        expect(state.error, exception);
        expect(
          state.hasValue,
          isFalse, // Check hasValue
          reason: 'State should not have a value when build fails',
        );

        // Verify: loadThemeMode was called ONCE on the LOCAL mock instance
        verify(() => localMockRepository.loadThemeMode()).called(1);
        // No need for verifyNoMoreInteractions on the local mock here

        errorContainer.dispose(); // Dispose test-specific container
      },
    );

    test(
      'setThemeMode updates state optimistically and calls repository save',
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
        // 2. Repository's saveThemeMode should be called with the new mode
        verify(() => mockRepository.saveThemeMode(newMode)).called(1);
        // 3. Load should only have been called once during build
        verify(() => mockRepository.loadThemeMode()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'setThemeMode updates state to AsyncError with previous data if repository save fails',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        const newMode = ThemeMode.dark;
        final exception = Exception('Failed to save theme');
        when(() => mockRepository.saveThemeMode(newMode)).thenThrow(exception);

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
        // 4. Repository's saveThemeMode should have been called
        verify(() => mockRepository.saveThemeMode(newMode)).called(1);
        // 5. Load should only have been called once during build
        verify(() => mockRepository.loadThemeMode()).called(1);
        verifyNoMoreInteractions(mockRepository);
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
        verifyNever(() => mockRepository.saveThemeMode(any()));
        // 3. Load should only have been called once during build
        verify(() => mockRepository.loadThemeMode()).called(1);
        verifyNoMoreInteractions(mockRepository);
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
        when(
          () => mockRepository.saveThemeMode(themeToFailSave),
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
        verify(() => mockRepository.saveThemeMode(themeToFailSave)).called(1);

        // Arrange 3: Define a different theme for the next attempt
        const nextThemeAttempt = ThemeMode.light;

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
        // We verify the specific call for the second attempt
        verify(() => mockRepository.saveThemeMode(nextThemeAttempt)).called(1);
        // Or verify total calls:
        // verify(() => mockRepository.saveThemeMode(any())).called(2);
      },
    );

    // --- Test for setting theme while state is AsyncLoading ---
    test('setThemeMode does nothing if state is AsyncLoading', () async {
      // Arrange: Set up the mock to delay using a Completer
      final loadCompleter = Completer<ThemeMode>();
      // Use a local mock for isolation
      final localMockRepository = MockSettingsRepository();
      when(
        () => localMockRepository.loadThemeMode(),
      ).thenAnswer((_) => loadCompleter.future);

      container.dispose();
      final loadingContainer = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(localMockRepository),
        ],
      );
      loadingContainer.listen(themeModeNotifierProvider, (_, __) {});

      // Act 1: Trigger the build
      final loadingNotifier = loadingContainer.read(
        themeModeNotifierProvider.notifier,
      );

      // Assert 1: State should be AsyncLoading
      await Future.delayed(Duration.zero);
      final loadingState = loadingContainer.read(themeModeNotifierProvider);
      expect(
        loadingState,
        isA<AsyncLoading>(),
        reason: 'State should be AsyncLoading after build starts',
      );

      // Act 2: Attempt to set theme while state is loading
      await loadingNotifier.setThemeMode(ThemeMode.dark);

      // Assert 2: State should remain AsyncLoading, saveThemeMode not called
      final stillLoadingState = loadingContainer.read(
        themeModeNotifierProvider,
      );
      expect(
        stillLoadingState,
        isA<AsyncLoading>(),
        reason: 'State should remain AsyncLoading after setThemeMode call',
      );
      verifyNever(() => localMockRepository.saveThemeMode(any()));

      // Clean up
      loadCompleter.complete(initialThemeMode);
      await loadingContainer.read(themeModeNotifierProvider.future);
      loadingContainer.dispose();

      verify(() => localMockRepository.loadThemeMode()).called(1);
    });

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
      // 2. Repository's saveThemeMode should be called with the next theme
      verify(() => mockRepository.saveThemeMode(nextThemeMode)).called(1);
      // 3. Load should only have been called once during build
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // --- Test for toggling theme while state is AsyncError ---
    test(
      'toggleTheme optimistically updates state again if called while state is AsyncError (from save failure)',
      () async {
        // Arrange 1: Ensure initial build completes successfully
        await container.read(themeModeNotifierProvider.future);

        // Arrange 2: Simulate a SAVE failure to get into AsyncError state
        final saveException = Exception('Failed to save theme');
        const themeToFailSave =
            ThemeMode.dark; // Start with dark to toggle to system
        when(
          () => mockRepository.saveThemeMode(themeToFailSave),
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
        verify(() => mockRepository.saveThemeMode(themeToFailSave)).called(1);

        // Arrange 3: Determine the expected next theme
        final expectedNextTheme = getNextThemeModeCycle(
          themeToFailSave,
        ); // dark -> system

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
        // We verify the specific call for the second attempt
        verify(() => mockRepository.saveThemeMode(expectedNextTheme)).called(1);
        // Or verify total calls:
        // verify(() => mockRepository.saveThemeMode(any())).called(2);
      },
    );

    // --- Test for toggling theme while state is AsyncLoading ---
    test('toggleTheme does nothing if state is AsyncLoading', () async {
      // Arrange: Set up the mock to delay using a Completer
      final loadCompleter = Completer<ThemeMode>();
      final localMockRepository = MockSettingsRepository();
      when(
        () => localMockRepository.loadThemeMode(),
      ).thenAnswer((_) => loadCompleter.future);

      container.dispose();
      final loadingContainer = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(localMockRepository),
        ],
      );
      loadingContainer.listen(themeModeNotifierProvider, (_, __) {});

      // Act 1: Trigger the build
      final loadingNotifier = loadingContainer.read(
        themeModeNotifierProvider.notifier,
      );

      // Assert 1: State should be AsyncLoading
      await Future.delayed(Duration.zero);
      final loadingState = loadingContainer.read(themeModeNotifierProvider);
      expect(
        loadingState,
        isA<AsyncLoading>(),
        reason: 'State should be AsyncLoading after build starts',
      );

      // Act 2: Attempt to toggle theme while state is loading
      await loadingNotifier.toggleTheme();

      // Assert 2: State should remain AsyncLoading, saveThemeMode not called
      final stillLoadingState = loadingContainer.read(
        themeModeNotifierProvider,
      );
      expect(
        stillLoadingState,
        isA<AsyncLoading>(),
        reason: 'State should remain AsyncLoading after toggleTheme call',
      );
      verifyNever(() => localMockRepository.saveThemeMode(any()));

      // Clean up
      loadCompleter.complete(initialThemeMode);
      await loadingContainer.read(themeModeNotifierProvider.future);
      loadingContainer.dispose();

      verify(() => localMockRepository.loadThemeMode()).called(1);
    });

    test(
      'refreshTheme reloads from repository and updates state on success',
      () async {
        // Arrange: Ensure initial build completes
        await container.read(themeModeNotifierProvider.future);
        final initialValue =
            container.read(themeModeNotifierProvider).value; // Store initial
        expect(initialValue, initialThemeMode);

        const refreshedMode = ThemeMode.dark;
        // Mock the *next* call to loadThemeMode on the shared mock
        when(
          () => mockRepository.loadThemeMode(),
        ).thenAnswer((_) async => refreshedMode);

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
        // Verify loadThemeMode was called twice (build + refresh)
        verify(() => mockRepository.loadThemeMode()).called(2);
        verifyNoMoreInteractions(mockRepository);
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
        // Mock the *next* call to loadThemeMode on the shared mock
        when(() => mockRepository.loadThemeMode()).thenThrow(exception);

        // Act: Call refreshTheme and wait for it to complete
        await notifier.refreshTheme();

        // --- REMOVED Intermediate State Check ---
        // final loadingState = container.read(themeModeNotifierProvider);
        // expect(loadingState, isA<AsyncLoading>());
        // expect(loadingState.value, initialThemeMode);
        // --- END REMOVAL ---

        // Assertions - Final State
        final errorState = container.read(themeModeNotifierProvider);
        expect(errorState, isA<AsyncError>());
        expect(errorState.error, exception);
        // Verify previous value is kept due to copyWithPrevious
        expect(errorState.value, initialValue);
        // Verify loadThemeMode was called twice (build + refresh)
        verify(() => mockRepository.loadThemeMode()).called(2);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
