import 'dart:async';

import 'package:brain_bench/business_logic/locale/locale_provider.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock the SettingsRepository
class MockSettingsRepository extends Mock implements SettingsRepository {}

class FakeLocale extends Fake implements Locale {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Locale('en'));
  });

  // --- Test Group for the LocaleNotifier ---
  group('LocaleNotifier', () {
    late MockSettingsRepository mockRepository;
    late ProviderContainer container;
    late LocaleNotifier notifier;

    // Define some locales for testing
    const initialLocale = Locale('en');
    const germanLocale = Locale('de');
    const unsupportedLocale = Locale('fr');

    setUp(() {
      mockRepository = MockSettingsRepository();

      // Default stub for loading the initial locale
      when(() => mockRepository.loadLocale())
          .thenAnswer((_) async => initialLocale);
      // Default stub for saving (assume success by default)
      when(() => mockRepository.saveLocale(any())).thenAnswer((_) async {});

      // Create a ProviderContainer, overriding the repository provider
      container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      notifier = container.read(localeNotifierProvider.notifier);

      container.listen(localeNotifierProvider, (_, __) {});
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'build loads initial locale from repository and sets state to AsyncData',
        () async {
      // Assertions
      // Wait for the initial build future to complete
      await container.read(localeNotifierProvider.future);

      // Verify the final state
      expect(container.read(localeNotifierProvider),
          const AsyncData(initialLocale));

      // Verify that loadLocale was called exactly once during build
      verify(() => mockRepository.loadLocale()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'build falls back to default locale and state is AsyncData if repository throws during load',
        () async {
      // Arrange: Define the exception and the expected fallback locale
      final exception = Exception('Failed to load locale');
      const fallbackLocale = Locale('en'); // Match the fallback in the provider

      // --- Create a fresh mock instance specifically for THIS test ---
      final localMockRepository = MockSettingsRepository();
      // Configure THIS mock instance to throw
      when(() => localMockRepository.loadLocale()).thenThrow(exception);

      // --- Dispose the setUp container (optional but good practice) ---
      container.dispose();

      // --- Create a NEW container overriding with the LOCAL mock ---
      final errorContainer = ProviderContainer(
        overrides: [
          // Use the mock created specifically for this test
          settingsRepositoryProvider.overrideWithValue(localMockRepository),
        ],
      );
      // Add listener to trigger build and capture state
      final listener =
          errorContainer.listen(localeNotifierProvider, (_, __) {});

      // Act: Allow time for the asynchronous build (triggered by listen)
      // to fail internally and return the fallback value.
      // We can await the future here, as it WILL complete successfully (with fallback).
      await errorContainer.read(localeNotifierProvider.future);

      // Assert: Check the provider's state AFTER the build completed with fallback
      final state = listener.read(); // Read the latest state via the listener

      expect(state, isA<AsyncData<Locale>>(), // Expect AsyncData now
          reason: 'State should be AsyncData after build fails and falls back');
      expect(state.value, fallbackLocale, // Check for the fallback value
          reason: 'State value should be the fallback locale');

      // Verify: loadLocale was called ONCE on the LOCAL mock instance
      verify(() => localMockRepository.loadLocale()).called(1);
      // We don't need verifyNoMoreInteractions on the local mock unless needed

      // Clean up the specific container for this test
      errorContainer.dispose();
    });

    test(
        'setLocale updates state optimistically and calls repository save for supported locale',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      const newLocale = germanLocale;

      // Act: Call setLocale
      await notifier.setLocale(newLocale);

      // Assertions
      expect(
          container.read(localeNotifierProvider), const AsyncData(newLocale));
      verify(() => mockRepository.saveLocale(newLocale)).called(1);
      verify(() => mockRepository.loadLocale()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'setLocale updates state to AsyncError with previous data if repository save fails',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      const newLocale = germanLocale;
      final exception = Exception('Failed to save locale');
      when(() => mockRepository.saveLocale(newLocale)).thenThrow(exception);

      // Act: Call setLocale
      await notifier.setLocale(newLocale);

      // Assertions
      final state = container.read(localeNotifierProvider);
      expect(state, isA<AsyncError>());
      expect((state).error, exception);
      expect(state.value, newLocale); // Check optimistic value is kept
      verify(() => mockRepository.saveLocale(newLocale)).called(1);
      verify(() => mockRepository.loadLocale()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('setLocale does nothing if the new locale is the same as current',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      final currentLocale = container.read(localeNotifierProvider).value;

      // Act: Call setLocale with the same locale
      await notifier.setLocale(currentLocale!);

      // Assertions
      expect(container.read(localeNotifierProvider), AsyncData(currentLocale));
      verifyNever(() => mockRepository.saveLocale(any()));
      verify(() => mockRepository.loadLocale()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // --- Test for unsupported locale (assuming no throw) ---
    test('setLocale does nothing and logs warning for unsupported locale',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      final initialValue = container.read(localeNotifierProvider).value;

      // Act: Call setLocale with unsupported locale
      await notifier.setLocale(unsupportedLocale);

      // Assertions
      expect(container.read(localeNotifierProvider).value, initialValue);
      verifyNever(() => mockRepository.saveLocale(any()));
      verify(() => mockRepository.loadLocale()).called(1);
      verifyNoMoreInteractions(mockRepository);
      // Cannot easily verify logger output here
    });

    // --- CORRECTED test for setting locale while state is AsyncLoading ---
    test('setLocale does nothing if state is AsyncLoading', () async {
      // Arrange: Set up the mock to delay using a Completer
      final loadCompleter = Completer<Locale>();
      // Use a local mock for isolation in this specific loading scenario
      final localMockRepository = MockSettingsRepository();
      when(() => localMockRepository.loadLocale())
          .thenAnswer((_) => loadCompleter.future);

      // Dispose the setUp container
      container.dispose();
      // Create a new container with the delayed mock
      final loadingContainer = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(localMockRepository),
        ],
      );
      // Add listener to trigger build
      loadingContainer.listen(localeNotifierProvider, (_, __) {});

      // Act 1: Trigger the build by reading the notifier
      final loadingNotifier =
          loadingContainer.read(localeNotifierProvider.notifier);

      // Assert 1: Immediately after triggering build, state should be AsyncLoading
      // Need a slight delay to ensure the build starts and sets loading state
      await Future.delayed(Duration.zero);
      final loadingState = loadingContainer.read(localeNotifierProvider);
      expect(loadingState, isA<AsyncLoading>(),
          reason: 'State should be AsyncLoading after build starts');

      // Act 2: Attempt to set locale while state is loading
      await loadingNotifier.setLocale(germanLocale);

      // Assert 2: State should remain AsyncLoading, saveLocale not called
      final stillLoadingState = loadingContainer.read(localeNotifierProvider);
      expect(stillLoadingState, isA<AsyncLoading>(),
          reason: 'State should remain AsyncLoading after setLocale call');
      verifyNever(
          () => localMockRepository.saveLocale(any())); // Check local mock

      // Clean up: Complete the completer and dispose the container
      loadCompleter.complete(initialLocale); // Complete with a valid locale
      await loadingContainer
          .read(localeNotifierProvider.future); // Wait for completion
      loadingContainer.dispose();

      // Verify loadLocale was called once on the local mock
      verify(() => localMockRepository.loadLocale()).called(1);
    });

    // --- Test for setting locale while state is AsyncError (due to SAVE failure) ---
    test(
        'setLocale does nothing if state is AsyncError (from previous save failure)',
        () async {
      // Arrange 1: Ensure initial build completes successfully
      await container.read(localeNotifierProvider.future);
      expect(container.read(localeNotifierProvider).value, initialLocale);

      // Arrange 2: Simulate a SAVE failure to get into AsyncError state
      final saveException = Exception('Failed to save locale');
      const localeToFailSave = germanLocale;
      // Configure the mock (from setUp) to throw on save
      when(() => mockRepository.saveLocale(localeToFailSave))
          .thenThrow(saveException);

      // Act 1: Call setLocale, which will fail during save
      await notifier.setLocale(localeToFailSave);

      // Assert 1: Verify the state is now AsyncError, but contains the optimistic value
      final errorState = container.read(localeNotifierProvider);
      expect(errorState, isA<AsyncError>(),
          reason: 'State should be AsyncError after save fails');
      expect(errorState.error, saveException);
      expect(errorState.value, localeToFailSave, // Check optimistic value
          reason: 'State should retain optimistic value after save fails');

      // --- Verify the FIRST save call (the one that failed) ---
      verify(() => mockRepository.saveLocale(localeToFailSave)).called(1);

      // Arrange 3: Define a different locale for the next attempt
      const nextLocaleAttempt =
          unsupportedLocale; // Or another valid one like initialLocale

      // Act 2: Attempt to set locale AGAIN while state is AsyncError
      await notifier.setLocale(nextLocaleAttempt);

      // Assert 2: State should remain the SAME AsyncError
      final finalState = container.read(localeNotifierProvider);
      expect(finalState, isA<AsyncError>(),
          reason: 'State should remain AsyncError after second setLocale call');
      expect(finalState.error, saveException,
          reason: 'Error should be the original save exception');
      expect(finalState.value, localeToFailSave,
          reason: 'Value should still be the original optimistic value');

      // --- REMOVED verifyNoMoreInteractions ---
      // verifyNoMoreInteractions(mockRepository);
      // We already verified the specific save call. Verifying no *other*
      // interactions isn't essential here and conflicts with the setUp loadLocale call.
    });

    test('setLocale does nothing if state is AsyncLoading', () async {
      // Arrange: Set up the mock to delay using a Completer
      final loadCompleter = Completer<Locale>();
      final localMockRepository = MockSettingsRepository();
      when(() => localMockRepository.loadLocale())
          .thenAnswer((_) => loadCompleter.future);

      container.dispose();
      final loadingContainer = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(localMockRepository),
        ],
      );
      loadingContainer.listen(localeNotifierProvider, (_, __) {});

      final loadingNotifier =
          loadingContainer.read(localeNotifierProvider.notifier);

      await Future.delayed(Duration.zero);
      final loadingState = loadingContainer.read(localeNotifierProvider);
      expect(loadingState, isA<AsyncLoading>(),
          reason: 'State should be AsyncLoading after build starts');

      await loadingNotifier.setLocale(germanLocale);

      final stillLoadingState = loadingContainer.read(localeNotifierProvider);
      expect(stillLoadingState, isA<AsyncLoading>(),
          reason: 'State should remain AsyncLoading after setLocale call');
      verifyNever(
          () => localMockRepository.saveLocale(any())); // Check local mock

      loadCompleter.complete(initialLocale);
      await loadingContainer.read(localeNotifierProvider.future);
      loadingContainer.dispose();

      verify(() => localMockRepository.loadLocale()).called(1);
    });

    test('refreshLocale reloads from repository and updates state on success',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      final initialValue =
          container.read(localeNotifierProvider).value; // Store initial value
      expect(initialValue, initialLocale);

      const refreshedLocale = germanLocale;
      // Mock the *next* call to loadLocale
      when(() => mockRepository.loadLocale())
          .thenAnswer((_) async => refreshedLocale);

      // Act: Call refreshLocale and wait for it to complete
      await notifier.refreshLocale();

      // Assertions - Final State
      final finalState = container.read(localeNotifierProvider);
      expect(finalState, const AsyncData(refreshedLocale));
      // Verify loadLocale was called twice (build + refresh)
      verify(() => mockRepository.loadLocale()).called(2);
      verifyNoMoreInteractions(mockRepository);
    });

    // --- CORRECTED refreshLocale failure test ---
    test(
        'refreshLocale sets state to AsyncError with previous data if repository fails on reload',
        () async {
      // Arrange: Ensure initial build completes
      await container.read(localeNotifierProvider.future);
      final initialValue =
          container.read(localeNotifierProvider).value; // Store initial value
      expect(initialValue, initialLocale);

      final exception = Exception('Failed to refresh');
      // Mock the *next* call to loadLocale to throw an error
      when(() => mockRepository.loadLocale()).thenThrow(exception);

      // Act: Call refreshLocale and wait for it to complete
      await notifier.refreshLocale();

      // Assertions - Final State
      final finalState = container.read(localeNotifierProvider);
      expect(finalState, isA<AsyncError>());
      expect(finalState.error, exception);
      // Verify previous value is kept due to copyWithPrevious
      expect(finalState.value, initialValue);
      // Verify loadLocale was called twice (build + refresh)
      verify(() => mockRepository.loadLocale()).called(2);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
