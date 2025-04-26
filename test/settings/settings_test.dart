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
  // --- Test Group for the pure function `getNextThemeModeCycle` ---
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
      when(() => mockRepository.loadThemeMode())
          .thenAnswer((_) async => initialThemeMode);
      // Default stub for saving (can be overridden in specific tests)
      when(() => mockRepository.saveThemeMode(any()))
          .thenAnswer((_) async {}); // Assume success by default

      // Create a ProviderContainer, overriding the repository provider
      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // Keep the notifier instance for easy access in tests
      // Reading the notifier triggers the 'build' method
      notifier = container.read(themeModeNotifierProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'build loads initial theme from repository and sets state to AsyncData',
        () async {
      // Assertions
      // Wait for the future provided by the provider to complete
      await expectLater(container.read(themeModeNotifierProvider.future),
          completion(initialThemeMode));

      // Verify the final state
      expect(container.read(themeModeNotifierProvider),
          const AsyncData(initialThemeMode));

      // Verify that loadThemeMode was called exactly once during build
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository); // Ensure no other calls yet
    });

    test('build sets state to AsyncError if repository throws during load',
        () async {
      // Arrange: Override the default stub to throw an error
      final exception = Exception('Failed to load theme');
      when(() => mockRepository.loadThemeMode()).thenThrow(exception);

      // Re-create container and notifier with the error setup
      container.dispose(); // Dispose previous container
      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      notifier = container.read(themeModeNotifierProvider.notifier);

      // Assertions
      // Expect the future to complete with an error
      await expectLater(container.read(themeModeNotifierProvider.future),
          throwsA(isA<Exception>()));

      // Verify the final state is AsyncError
      final state = container.read(themeModeNotifierProvider);
      expect(state, isA<AsyncError>());
      expect((state as AsyncError).error, exception);

      // Verify loadThemeMode was called
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('setThemeMode updates state optimistically and calls repository save',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      const newMode = ThemeMode.dark;

      // Act: Call setThemeMode
      await notifier.setThemeMode(newMode);

      // Assertions
      // 1. State should be updated optimistically (immediately)
      expect(
          container.read(themeModeNotifierProvider), const AsyncData(newMode));
      // 2. Repository's saveThemeMode should be called with the new mode
      verify(() => mockRepository.saveThemeMode(newMode)).called(1);
      // 3. Load should only have been called once during build
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

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
    });

    test('setThemeMode does nothing if the new mode is the same as current',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      final currentMode = container.read(themeModeNotifierProvider).value;

      // Act: Call setThemeMode with the same mode
      await notifier.setThemeMode(currentMode!); // Use the actual current mode

      // Assertions
      // 1. State should remain unchanged
      expect(container.read(themeModeNotifierProvider), AsyncData(currentMode));
      // 2. Repository's saveThemeMode should NOT be called
      verifyNever(() => mockRepository.saveThemeMode(any()));
      // 3. Load should only have been called once during build
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'setThemeMode does nothing if state is not AsyncData (e.g., loading/error)',
        () async {
      // Arrange: Set state to loading manually for test (or use error setup)
      container.read(themeModeNotifierProvider.notifier).state =
          const AsyncLoading();

      // Act
      await notifier.setThemeMode(ThemeMode.dark);

      // Assert
      expect(container.read(themeModeNotifierProvider), isA<AsyncLoading>());
      verifyNever(() => mockRepository.saveThemeMode(any()));
      // Note: loadThemeMode might have been called if triggered by initial read
      // verifyNever(() => mockRepository.loadThemeMode()); // This might fail depending on setup timing
    });

    test('toggleTheme calculates next theme and calls setThemeMode', () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      expect(container.read(themeModeNotifierProvider).value, initialThemeMode);

      // Act: Call toggleTheme
      await notifier.toggleTheme();

      // Assertions
      // 1. State should be updated to the next theme in the cycle
      expect(container.read(themeModeNotifierProvider),
          const AsyncData(nextThemeMode));
      // 2. Repository's saveThemeMode should be called with the next theme
      verify(() => mockRepository.saveThemeMode(nextThemeMode)).called(1);
      // 3. Load should only have been called once during build
      verify(() => mockRepository.loadThemeMode()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('toggleTheme does nothing if state is not AsyncData', () async {
      // Arrange: Set state to loading
      container.read(themeModeNotifierProvider.notifier).state =
          const AsyncLoading();

      // Act
      await notifier.toggleTheme();

      // Assert
      expect(container.read(themeModeNotifierProvider), isA<AsyncLoading>());
      verifyNever(() => mockRepository.saveThemeMode(any()));
    });

    test('refreshTheme reloads from repository and updates state on success',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      expect(container.read(themeModeNotifierProvider).value, initialThemeMode);

      const refreshedMode = ThemeMode.dark;
      // Mock the *next* call to loadThemeMode
      when(() => mockRepository.loadThemeMode())
          .thenAnswer((_) async => refreshedMode);

      // Act: Call refreshTheme
      final refreshFuture = notifier.refreshTheme();

      // Assertions - Intermediate State
      // Immediately after calling, state should be loading but retain previous value
      final loadingState = container.read(themeModeNotifierProvider);
      expect(loadingState, isA<AsyncLoading>());
      expect(
          loadingState.value, initialThemeMode); // Check previous value is kept

      // Wait for the refresh to complete
      await refreshFuture;

      // Assertions - Final State
      // 1. Final state should be AsyncData with the refreshed mode
      expect(container.read(themeModeNotifierProvider),
          const AsyncData(refreshedMode));
      // 2. loadThemeMode should have been called twice (build + refresh)
      verify(() => mockRepository.loadThemeMode()).called(2);
      verifyNoMoreInteractions(mockRepository);
    });

    test('refreshTheme sets state to AsyncError if repository fails on reload',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(themeModeNotifierProvider.future);
      expect(container.read(themeModeNotifierProvider).value, initialThemeMode);

      final exception = Exception('Failed to refresh');
      // Mock the *next* call to loadThemeMode to throw an error
      when(() => mockRepository.loadThemeMode()).thenThrow(exception);

      // Act: Call refreshTheme
      final refreshFuture = notifier.refreshTheme();

      // Assertions - Intermediate State
      final loadingState = container.read(themeModeNotifierProvider);
      expect(loadingState, isA<AsyncLoading>());
      expect(loadingState.value, initialThemeMode);

      // Wait for the refresh to complete
      await refreshFuture;

      // Assertions - Final State
      // 1. Final state should be AsyncError
      final errorState = container.read(themeModeNotifierProvider);
      expect(errorState, isA<AsyncError>());
      expect((errorState as AsyncError).error, exception);
      // 2. The value should still be the one from *before* the refresh attempt
      expect(errorState.value, initialThemeMode);
      // 3. loadThemeMode should have been called twice (build + refresh)
      verify(() => mockRepository.loadThemeMode()).called(2);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
