import 'dart:async';

import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart'; // Import the provider definition
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart'; // Import the abstract class
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late StreamController<AppUser?> authStateController;

  // Test data
  final testUser = AppUser(
    uid: 'test-uid',
    id: 'test-uid',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authStateController = StreamController<AppUser?>();

    // Mock the authStateChanges stream
    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => authStateController.stream);
  });

  tearDown(() {
    authStateController.close();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('currentUserProvider emits null when authStateChanges emits null',
      () async {
    // Arrange
    final container = createContainer();
    final listener = Listener<AsyncValue<AppUser?>>();
    container.listen(
      currentUserProvider,
      listener.call,
      fireImmediately: true,
    );

    // Act
    authStateController.add(null); // Simulate user logging out

    // Allow stream to emit and listener to react
    await Future.value();

    // Assert
    // Verify the listener received the loading state and then the data state with null
    verifyInOrder([
      () => listener(null, const AsyncLoading()), // Initial loading state
      () => listener(const AsyncLoading(),
          const AsyncData(null)), // State after null emission
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('currentUserProvider emits AppUser when authStateChanges emits AppUser',
      () async {
    // Arrange
    final container = createContainer();
    final listener = Listener<AsyncValue<AppUser?>>();
    container.listen(
      currentUserProvider,
      listener.call,
      fireImmediately: true,
    );

    // Act
    authStateController.add(testUser); // Simulate user logging in

    // Allow stream to emit and listener to react
    await Future.value();

    // Assert
    // Verify the listener received the loading state and then the data state with the user
    verifyInOrder([
      () => listener(null, const AsyncLoading()), // Initial loading state
      () => listener(const AsyncLoading(),
          AsyncData(testUser)), // State after user emission
    ]);
    verifyNoMoreInteractions(listener);
  });
}

// Helper class to mock listener calls
class Listener<T> extends Mock {
  void call(T? previous, T next);
}
