// REMOVED duplicate import: import 'package:brain_bench/data/repositories/auth_repository.dart';
// Ensure ONLY ONE import for AuthRepository is active and correct
import 'package:brain_bench/business_logic/auth/auth_view_model.dart';
import 'package:brain_bench/core/utils/ensure_user_exists.dart'
    as ensure_user_exists;
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  late Future<void> Function(ensure_user_exists.Reader, AppUser?)
      originalEnsureUserExists;

  setUpAll(() {
    originalEnsureUserExists = ensure_user_exists.ensureUserExistsIfNeeded;
  });

  setUp(() {
    ensure_user_exists.ensureUserExistsIfNeeded = (ref, _) async {
      // no-op for tests
    };
  });

  tearDown(() {
    ensure_user_exists.ensureUserExistsIfNeeded = originalEnsureUserExists;
  });

  // Test data
  final testUser = AppUser(
      uid: 'test-uid',
      displayName: 'Test User',
      photoUrl: 'test-url',
      email: 'test@example.com',
      id: 'test-uid');
  const testEmail = 'test@example.com';
  const testPassword = 'password';
  final testException = Exception('Test Exception');

  group('AuthViewModel Tests', () {
    // --- Initial State Test ---
    test('initial state is AsyncData(null)', () {
      mockAuthRepository = MockAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);
      expect(
          container.read(authViewModelProvider), const AsyncData<void>(null));
    });

    // --- signIn Tests (Already implemented) ---
    group('signIn', () {
      testWidgets('signIn - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signInWithEmail(any(), any()))
            .thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];

        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(
              home: Scaffold(body: Container()),
            ),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signIn(
          email: testEmail,
          password: testPassword,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]);
        verify(() =>
                mockAuthRepository.signInWithEmail(testEmail, testPassword))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signIn - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signInWithEmail(any(), any()))
            .thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];

        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(
              home: Scaffold(body: Container()),
            ),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signIn(
          email: testEmail,
          password: testPassword,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() =>
                mockAuthRepository.signInWithEmail(testEmail, testPassword))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signUp Tests ---
    group('signUp', () {
      testWidgets('signUp - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signUpWithEmail(any(), any()))
            .thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signUp(
          email: testEmail,
          password: testPassword,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]);
        verify(() =>
                mockAuthRepository.signUpWithEmail(testEmail, testPassword))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signUp - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signUpWithEmail(any(), any()))
            .thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signUp(
          email: testEmail,
          password: testPassword,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() =>
                mockAuthRepository.signUpWithEmail(testEmail, testPassword))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signInWithGoogle Tests ---
    group('signInWithGoogle', () {
      testWidgets('signInWithGoogle - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        // ViewModel now resets state on success, so we expect the final AsyncData
        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signInWithGoogle(realContext);
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

      // The failure test remains the same
      testWidgets('signInWithGoogle - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signInWithGoogle())
            .thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signInWithGoogle(realContext);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signInWithApple Tests ---
    group('signInWithApple', () {
      testWidgets('signInWithApple - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signInWithApple())
            .thenAnswer((_) async => testUser);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signInWithApple(realContext);
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
        when(() => mockAuthRepository.signInWithApple())
            .thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signInWithApple(realContext);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() => mockAuthRepository.signInWithApple()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- sendPasswordResetEmail Tests ---
    group('sendPasswordResetEmail', () {
      testWidgets('sendPasswordResetEmail - success',
          (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.sendPasswordResetEmail(any()))
            .thenAnswer((_) async {});

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.sendPasswordResetEmail(
          email: testEmail,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null), // ViewModel calls reset() on success
        ]);
        verify(() => mockAuthRepository.sendPasswordResetEmail(testEmail))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('sendPasswordResetEmail - failure',
          (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.sendPasswordResetEmail(any()))
            .thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.sendPasswordResetEmail(
          email: testEmail,
          context: realContext,
        );
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() => mockAuthRepository.sendPasswordResetEmail(testEmail))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- signOut Tests ---
    group('signOut', () {
      testWidgets('signOut - success', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signOut(realContext);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          const AsyncData<void>(null), // ViewModel resets state here
        ]);
        verify(() => mockAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });

      testWidgets('signOut - failure', (WidgetTester tester) async {
        // Arrange
        mockAuthRepository = MockAuthRepository();
        when(() => mockAuthRepository.signOut()).thenThrow(testException);

        final overrides = [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ];
        final states = <AsyncValue<void>>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        final sub = container.listen<AsyncValue<void>>(
            authViewModelProvider, (_, next) => states.add(next),
            fireImmediately: true);
        addTearDown(sub.close);

        final notifier = container.read(authViewModelProvider.notifier);
        final BuildContext realContext = tester.element(find.byType(Scaffold));

        // Act
        await notifier.signOut(realContext);
        await tester.pumpAndSettle();

        // Assert
        expect(states, [
          const AsyncData<void>(null),
          const AsyncLoading<void>(),
          isA<AsyncError<void>>()
              .having((e) => e.error, 'error', testException),
        ]);
        verify(() => mockAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      });
    });

    // --- reset Test (remains standard 'test') ---
    test('reset sets state to AsyncData(null)', () {
      mockAuthRepository = MockAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
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
