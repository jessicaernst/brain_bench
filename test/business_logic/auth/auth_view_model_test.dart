import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/business_logic/auth/ensure_user_exists_provider.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Mocks ---

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // Initialize the Flutter binding for unit tests that use platform channels or services
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepository;
  // Mock function for ensureUserExistsIfNeeded
  late EnsureUserExistsFn mockEnsureUserExistsFn;
  late MockSharedPreferences mockSharedPreferences;

  // Test data
  final testUser = AppUser(
    uid: 'test-uid',
    displayName: 'Test User',
    photoUrl: 'test-url',
    email: 'test@example.com',
    id: 'test-uid',
  );
  const testEmail = 'test@example.com';
  const testPassword = 'password';
  final testException = Exception('Test Exception');

  setUp(() {
    // It's good practice to reset mocks before each test
    mockSharedPreferences = MockSharedPreferences();
  });

  group('AuthViewModel Tests', () {
    // --- Initial State Test ---
    test('initial state is AsyncData(null)', () {
      // Setup mock for ensureUserExistsIfNeeded for this specific test or group if needed
      mockEnsureUserExistsFn =
          (read, appUser) async => true; // Default mock behavior

      mockAuthRepository = MockAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          // Override SharedPreferences for any provider that might need it.
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(authViewModelProvider),
        const AsyncData<void>(null),
      );
    });

    // --- signIn Tests (Already implemented) ---
    group('signIn', () {
      testWidgets('signIn - success', (WidgetTester tester) async {
        // Setup mock for ensureUserExistsIfNeeded
        mockEnsureUserExistsFn = (read, appUser) async => true;

        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signInWithEmail(any(), any()),
        ).thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];

        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signIn(email: testEmail, password: testPassword);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]);
        verify(
          () => mockAuthRepository.signInWithEmail(testEmail, testPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signIn - failure', (WidgetTester tester) async {
        // Arrange
        // No need to mock ensureUserExistsFn here as it won't be called on auth failure
        // mockEnsureUserExistsFn = (read, appUser) async => true; // Or keep a default

        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signInWithEmail(any(), any()),
        ).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];

        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signIn(email: testEmail, password: testPassword);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(
          () => mockAuthRepository.signInWithEmail(testEmail, testPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signUp Tests ---
    group('signUp', () {
      testWidgets('signUp - success', (WidgetTester tester) async {
        // Setup mock for ensureUserExistsIfNeeded
        mockEnsureUserExistsFn = (read, appUser) async => true;

        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signUpWithEmail(any(), any()),
        ).thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signUp(email: testEmail, password: testPassword);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]);
        verify(
          () => mockAuthRepository.signUpWithEmail(testEmail, testPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signUp - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signUpWithEmail(any(), any()),
        ).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signUp(email: testEmail, password: testPassword);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(
          () => mockAuthRepository.signUpWithEmail(testEmail, testPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signInWithGoogle Tests ---
    group('signInWithGoogle', () {
      testWidgets('signInWithGoogle - success', (WidgetTester tester) async {
        // Setup mock for ensureUserExistsIfNeeded
        mockEnsureUserExistsFn = (read, appUser) async => true;

        // Arrange
        mockAuthRepository = MockAuthRepository();
        // ViewModel now resets state on success, so we expect the final AsyncData
        when(
          () => mockAuthRepository.signInWithGoogle(),
        ).thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signInWithGoogle();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]);

        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signInWithGoogle - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signInWithGoogle(),
        ).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signInWithGoogle();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signInWithApple Tests ---
    group('signInWithApple', () {
      testWidgets('signInWithApple - success', (WidgetTester tester) async {
        // Setup mock for ensureUserExistsIfNeeded
        mockEnsureUserExistsFn = (read, appUser) async => true;

        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signInWithApple(),
        ).thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signInWithApple();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null), // ViewModel resets state here
        ]);
        verify(() => mockAuthRepository.signInWithApple()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signInWithApple - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.signInWithApple(),
        ).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signInWithApple();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(() => mockAuthRepository.signInWithApple()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- sendPasswordResetEmail Tests ---
    group('sendPasswordResetEmail', () {
      testWidgets('sendPasswordResetEmail - success', (
        WidgetTester tester,
      ) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.sendPasswordResetEmail(any()),
        ).thenAnswer((_) async {});

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.sendPasswordResetEmail(email: testEmail);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null), // ViewModel calls reset() on success
        ]);
        verify(
          () => mockAuthRepository.sendPasswordResetEmail(testEmail),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('sendPasswordResetEmail - failure', (
        WidgetTester tester,
      ) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(
          () => mockAuthRepository.sendPasswordResetEmail(any()),
        ).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.sendPasswordResetEmail(email: testEmail);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(
          () => mockAuthRepository.sendPasswordResetEmail(testEmail),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signOut Tests ---
    group('signOut', () {
      testWidgets('signOut - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
        // Mock the SharedPreferences calls that happen during signOut
        when(
          () => mockSharedPreferences.remove(any()),
        ).thenAnswer((_) async => true);
        when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);

        // After signOut, authStateChanges will be called (likely emitting null)
        when(
          () => mockAuthRepository.authStateChanges(),
        ).thenAnswer((_) => Stream.value(null));
        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signOut();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null), // ViewModel resets state here
        ]);
        verify(() => mockAuthRepository.signOut()).called(1);
        // Verify that authStateChanges was called due to provider invalidation and re-evaluation.
        // It might be called multiple times depending on provider interactions.
        verify(
          () => mockAuthRepository.authStateChanges(),
        ).called(greaterThanOrEqualTo(1));
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signOut - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signOut()).thenThrow(testException);
        // Mock the SharedPreferences calls that happen during signOut, even in failure cases
        // if they are attempted before the exception from authRepository.signOut() is thrown
        when(
          () => mockSharedPreferences.remove(any()),
        ).thenAnswer((_) async => true);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          // Crucial override for the failing test:
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          // If SettingsRepository is used directly and not via a provider that depends on sharedPreferencesProvider,
          // you might need to mock and override settingsRepositoryProvider as well.
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container = ProviderScope.containerOf(
          tester.element(find.byType(Scaffold)),
        );
        final sub = container.listen<AsyncValue<void>>(
          authViewModelProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);

        // Act
        await notifier.signOut();
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>().having(
            (e) => e.error,
            'error',
            testException,
          ),
        ]);
        verify(() => mockAuthRepository.signOut()).called(1);

        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- reset Test (remains standard 'test') ---
    test('reset sets state to AsyncData(null)', () {
      mockAuthRepository = MockAuthRepository();
      // Setup mock for ensureUserExistsIfNeeded if any operation before reset might call it
      mockEnsureUserExistsFn = (read, appUser) async => true;

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ensureUserExistsProvider.overrideWithValue(mockEnsureUserExistsFn),
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ],
      );
      addTearDown(container.dispose);
      final resetNotifier = container.read(authViewModelProvider.notifier);

      resetNotifier.state = const AsyncLoading();
      expect(resetNotifier.state, const AsyncLoading<void>());

      resetNotifier.reset();

      expect(resetNotifier.state, const AsyncData<void>(null));
    });
  });
}
