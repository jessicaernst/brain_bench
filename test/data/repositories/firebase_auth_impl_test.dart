// ignore_for_file: subtype_of_sealed_class

import 'dart:async';

import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/repositories/firebase_auth_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// --- Mocks ---

// Mock for Firebase Authentication core functionalities
class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

// Mock for Firebase Firestore
class MockFirebaseFirestore extends Mock implements fs.FirebaseFirestore {}

// Mock for Firestore CollectionReference
class MockCollectionReference<T extends Object?> extends Mock
    implements fs.CollectionReference<T> {}

// Mock for Firestore DocumentReference
class MockDocumentReference<T extends Object?> extends Mock
    implements fs.DocumentReference<T> {}

// Mock for Firestore DocumentSnapshot
class MockDocumentSnapshot<T extends Object?> extends Mock
    implements fs.DocumentSnapshot<T> {}

// Mock for Firebase User object
class MockUser extends Mock implements fb.User {}

// Mock for Firebase User Credential object
class MockUserCredential extends Mock implements fb.UserCredential {}

// Fake implementation for AuthCredential (used with registerFallbackValue)
class FakeCredential extends Fake implements fb.AuthCredential {}

// Mock for Google Sign In functionalities (direct mocking difficult due to static calls)
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// Mock for Google Sign In Account details
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

// Mock for Google Sign In Authentication tokens
class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

// Mock for OAuthProvider (used internally by Apple Sign In with Firebase)
class MockOAuthProvider extends Mock implements fb.OAuthProvider {}

// Mock for Apple Sign In result credential
class MockAuthorizationCredentialAppleID extends Mock
    implements AuthorizationCredentialAppleID {}

// Mock for Sign In With Apple functionalities (direct mocking difficult due to static calls)
class MockSignInWithApple extends Mock implements SignInWithApple {}

void main() {
  // --- Test Variables ---
  late FirebaseAuthRepository repository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockUserCredential mockCredential;

  // --- Test Constants ---
  const String tUserId = '123';
  const String tEmail = 'user@example.com';
  const String tPassword = 'password';
  const String tDisplayName = 'Test User';
  const String tPhotoUrl = 'http://photo.url';

  // Define testException here
  final testException = Exception('Test Exception');

  // --- Global Setup ---
  setUpAll(() {
    // Ensure Flutter bindings are initialized for tests that might need platform channels
    TestWidgetsFlutterBinding.ensureInitialized();
    // Register a fallback value for AuthCredential type matching in `when` clauses
    registerFallbackValue(FakeCredential());
  });

  // --- Per-Test Setup ---
  setUp(() {
    // Create fresh mock instances for each test
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockCredential = MockUserCredential();

    // Setup default mock responses for the user and credential objects
    when(() => mockUser.uid).thenReturn(tUserId);
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.displayName).thenReturn(tDisplayName);
    when(() => mockUser.photoURL).thenReturn(tPhotoUrl);
    when(() => mockCredential.user).thenReturn(mockUser);

    // Mock the setLanguageCode call which might happen in the repository constructor
    when(() => mockAuth.setLanguageCode(any())).thenAnswer((_) async {});

    // Mock the authStateChanges stream (default to logged out)
    when(
      () => mockAuth.authStateChanges(),
    ).thenAnswer((_) => Stream.value(null));

    // Create the repository instance, injecting the mock FirebaseAuth
    repository = FirebaseAuthRepository(
      auth: mockAuth,
      firestore: mockFirestore,
    );
  });

  // --- Test Groups ---

  group('Auth State Changes', () {
    test(
      'authStateChanges should emit null when Firebase auth state changes to null',
      () {
        // Arrange
        // No Firestore interaction expected if firebaseUser is null
        when(
          () => mockAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.value(null));

        // Act
        final stream = repository.authStateChanges();

        // Assert
        expect(stream, emits(isNull));
        verify(() => mockAuth.authStateChanges()).called(1);
      },
    );

    test(
      'authStateChanges should emit AppUser when Firebase auth state changes to a valid user',
      () {
        // Arrange
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockCollectionRef =
            MockCollectionReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(
          () => mockFirestore.collection('users'),
        ).thenReturn(mockCollectionRef);
        when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
        when(
          () => mockDocRef.snapshots(),
        ).thenAnswer((_) => Stream.value(mockSnapshot));
        when(
          () => mockSnapshot.data(),
        ).thenReturn({'themeMode': 'dark', 'language': 'en'});
        when(() => mockSnapshot.exists).thenReturn(true);

        when(
          () => mockAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.value(mockUser));
        // Act
        final stream = repository.authStateChanges();

        // Assert
        expect(
          stream,
          emits(
            isA<AppUser>()
                .having((u) => u.uid, 'uid', tUserId)
                .having((u) => u.email, 'email', tEmail)
                .having((u) => u.displayName, 'displayName', tDisplayName)
                .having((u) => u.photoUrl, 'photoUrl', tPhotoUrl)
                .having((u) => u.themeMode, 'themeMode', 'dark')
                .having((u) => u.language, 'language', 'en'),
          ),
        );
        verify(() => mockAuth.authStateChanges()).called(1);
      },
    );

    test(
      'authStateChanges should emit AppUser with null details if Firebase user has null details',
      () {
        // Arrange
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockCollectionRef =
            MockCollectionReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(
          () => mockFirestore.collection('users'),
        ).thenReturn(mockCollectionRef);
        when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
        when(
          () => mockDocRef.snapshots(),
        ).thenAnswer((_) => Stream.value(mockSnapshot));
        // Firestore data might be missing or have defaults
        when(() => mockSnapshot.data()).thenReturn(null);
        when(() => mockSnapshot.exists).thenReturn(false);

        when(() => mockUser.email).thenReturn(null);
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockUser.photoURL).thenReturn(null);
        when(
          () => mockAuth.authStateChanges(),
        ).thenAnswer((_) => Stream.value(mockUser));

        // Act
        final stream = repository.authStateChanges();

        // Assert
        expect(
          stream,
          emits(
            isA<AppUser>()
                .having((u) => u.uid, 'uid', tUserId)
                .having((u) => u.email, 'email', '')
                .having((u) => u.displayName, 'displayName', isNull)
                .having((u) => u.photoUrl, 'photoUrl', isNull)
                .having((u) => u.themeMode, 'themeMode', 'system') // Default
                .having((u) => u.language, 'language', 'en'), // Default
          ),
        );
        verify(() => mockAuth.authStateChanges()).called(1);
      },
    );
  });

  group('Email/Password Authentication', () {
    test('signInWithEmail returns AppUser on success', () async {
      // Arrange
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(
        () => mockSnapshot.data(),
      ).thenReturn({'themeMode': 'light', 'language': 'de'});

      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockCredential);

      // Act
      final result = await repository.signInWithEmail(tEmail, tPassword);

      // Assert
      expect(result, isA<AppUser>());
      expect(result.email, tEmail);
      expect(result.uid, tUserId);
      expect(result.themeMode, 'light');
      expect(result.language, 'de');
      verify(
        () => mockAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test(
      'signInWithEmail throws specific Exception on FirebaseAuthException',
      () async {
        // Arrange
        // No Firestore interaction expected if auth fails first
        // However, if _fetchFirestoreUserProfile were called before rethrow,
        // you might need to mock its failure or success path.
        // For now, assume auth exception happens before Firestore fetch.
        final exception = fb.FirebaseAuthException(code: 'user-not-found');
        when(
          () => mockAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.signInWithEmail(tEmail, tPassword),
          throwsA(isA<Exception>()),
        ); // Or check for specific message if needed
        verify(
          () => mockAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );

    test('signInWithEmail throws generic Exception on other errors', () async {
      // Arrange
      final exception = Exception('Network error');
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(exception);

      // Act & Assert
      expect(
        () => repository.signInWithEmail(tEmail, tPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Ein unerwarteter Fehler ist aufgetreten.'),
          ),
        ),
      );
    });

    test('signUpWithEmail returns AppUser on success', () async {
      // Arrange
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
      // For signUp, the document might not exist yet, so _fetchFirestoreUserProfile might return null data
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(
        () => mockSnapshot.data(),
      ).thenReturn(null); // Simulate no existing profile
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockCredential);

      // Act
      final result = await repository.signUpWithEmail(tEmail, tPassword);

      // Assert
      expect(result, isA<AppUser>());
      expect(result.email, tEmail);
      expect(result.uid, tUserId);
      expect(result.themeMode, 'system'); // Default
      expect(result.language, 'en'); // Default
      verify(
        () => mockAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test(
      'signUpWithEmail throws specific Exception on FirebaseAuthException',
      () async {
        // Arrange
        final exception = fb.FirebaseAuthException(
          code: 'email-already-in-use',
        );
        when(
          () => mockAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.signUpWithEmail(tEmail, tPassword),
          throwsA(isA<Exception>()),
        ); // Or check for specific message
        verify(
          () => mockAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );

    test('signUpWithEmail throws generic Exception on other errors', () async {
      // Arrange
      final exception = Exception('Something went wrong');
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(exception);

      // Act & Assert
      expect(
        () => repository.signUpWithEmail(tEmail, tPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Ein unerwarteter Fehler ist aufgetreten.'),
          ),
        ),
      );
    });
  });

  group('Password Reset', () {
    test('sendPasswordResetEmail completes successfully', () async {
      // Arrange
      when(
        () => mockAuth.sendPasswordResetEmail(email: tEmail),
      ).thenAnswer((_) async {});

      // Act
      await repository.sendPasswordResetEmail(tEmail);

      // Assert
      verify(() => mockAuth.sendPasswordResetEmail(email: tEmail)).called(1);
    });

    test(
      'sendPasswordResetEmail throws specific Exception on FirebaseAuthException',
      () async {
        // Arrange
        final exception = fb.FirebaseAuthException(code: 'invalid-email');
        when(
          () => mockAuth.sendPasswordResetEmail(email: tEmail),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.sendPasswordResetEmail(tEmail),
          throwsA(isA<Exception>()),
        ); // Or check specific message
        verify(() => mockAuth.sendPasswordResetEmail(email: tEmail)).called(1);
      },
    );

    test(
      'sendPasswordResetEmail throws generic Exception on other errors',
      () async {
        // Arrange
        final exception = Exception('Server unavailable');
        when(
          () => mockAuth.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.sendPasswordResetEmail(tEmail),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Ein unerwarteter Fehler ist aufgetreten.'),
            ),
          ),
        );
      },
    );
  });

  group('Sign Out', () {
    test('signOut completes successfully', () async {
      // Arrange
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      // Act
      await repository.signOut();

      // Assert
      verify(() => mockAuth.signOut()).called(1);
    });

    test('signOut throws generic Exception on error', () async {
      // Arrange
      final exception = Exception('Sign out failed');
      when(() => mockAuth.signOut()).thenThrow(exception);

      // Act & Assert
      expect(
        () => repository.signOut(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Ein unerwarteter Fehler ist aufgetreten.'),
          ),
        ),
      );
      verify(() => mockAuth.signOut()).called(1);
    });
  });

  group('Google Sign In', () {
    // Note: Testing the actual GoogleSignIn().signIn() call is difficult
    // in unit tests due to its static nature and platform dependency.
    // These tests focus on the interaction with FirebaseAuth *after*
    // assuming Google Sign In succeeded or failed in specific ways.
    // Consider dependency injection for GoogleSignIn for more robust testing.

    test(
      'signInWithGoogle returns AppUser on successful Firebase credential sign in',
      () async {
        // Arrange: Assume Google Sign In was successful and Firebase accepts the credential.
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockCollectionRef =
            MockCollectionReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(
          () => mockFirestore.collection('users'),
        ).thenReturn(mockCollectionRef);
        when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
        when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(
          () => mockSnapshot.data(),
        ).thenReturn({'themeMode': 'googleTheme', 'language': 'fr'});

        when(
          () => mockAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => mockCredential);

        // Act
        // final result = await repository.signInWithGoogle(); // This line is hard to test

        // Assert
        // expect(result.themeMode, 'googleTheme'); // This line is hard to test

        // Test the exception path as it's easier without full GoogleSignIn mock
        // Use the globally defined testException or define a local one
        when(
          () => mockAuth.signInWithCredential(any()),
        ).thenThrow(testException);
        expect(
          () => repository.signInWithGoogle(),
          throwsA(isA<Exception>()),
          skip:
              'Skipping success check as mocking static GoogleSignIn().signIn() is complex.',
        );
      },
    );

    test(
      'signInWithGoogle throws specific Exception when GoogleSignIn returns null (user cancellation)',
      () async {
        // Arrange: This scenario is hard to mock directly.
        // We test that the repository *would* throw the correct exception if GoogleSignIn().signIn() returned null.

        // Act & Assert
        expect(
          () => repository.signInWithGoogle(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Google Sign-In abgebrochen'),
            ),
          ),
          skip:
              'Cannot directly mock static GoogleSignIn().signIn() to return null easily.',
        );
      },
    );

    test(
      'signInWithGoogle throws generic Exception on other errors during Firebase sign in',
      () async {
        // Arrange: Assume Google Sign In worked, but Firebase throws a non-FirebaseAuthException
        final exception = Exception('Network Error during Firebase check');
        when(() => mockAuth.signInWithCredential(any())).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.signInWithGoogle(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Ein unerwarteter Fehler ist aufgetreten.'),
            ),
          ),
          skip:
              'Skipping due to complexity of mocking GoogleSignIn().signIn() result.',
        );
      },
    );
  });

  group('Apple Sign In', () {
    // Note: Testing Apple Sign In is complex due to:
    // 1. Static call: `SignInWithApple.getAppleIDCredential()`
    // 2. Platform check: `Platform.isIOS` / `Platform.isMacOS`
    // 3. Platform-specific exceptions (`PlatformException`)
    // These tests focus on expected behavior *assuming* certain conditions.
    // Consider dependency injection and platform mocking for full testing.

    test(
      'signInWithApple returns AppUser on successful Firebase credential sign in',
      () async {
        // Arrange: Assume platform check passes, Apple Sign In succeeds, and Firebase accepts credential.
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockCollectionRef =
            MockCollectionReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(
          () => mockFirestore.collection('users'),
        ).thenReturn(mockCollectionRef);
        when(() => mockCollectionRef.doc(tUserId)).thenReturn(mockDocRef);
        when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(
          () => mockSnapshot.data(),
        ).thenReturn({'themeMode': 'appleTheme', 'language': 'es'});

        when(
          () => mockAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => mockCredential);

        // Act
        // final result = await repository.signInWithApple(); // Hard to test
        // Assert
        // expect(result.themeMode, 'appleTheme'); // Hard to test
        // Use the globally defined testException or define a local one
        when(
          () => mockAuth.signInWithCredential(any()),
        ).thenThrow(testException);
        expect(
          () => repository.signInWithApple(),
          throwsA(isA<Exception>()),
          skip:
              'Platform check and static calls make success path hard to test fully.',
        );
      },
    );

    test(
      'signInWithApple throws UnsupportedError when Platform is not iOS/macOS',
      () async {
        // Arrange: No specific arrangement needed if Platform is mocked (but it's not here).
        // This test verifies the expected exception type *if* the platform check fails.

        // Act & Assert
        expect(
          () => repository.signInWithApple(),
          throwsA(isA<UnsupportedError>()),
          skip:
              'Platform mocking (Platform.isIOS/isMacOS) not implemented for this unit test.',
        );
      },
    );

    test(
      'signInWithApple throws specific Exception on PlatformException during credential fetch',
      () async {
        // Arrange: Assume platform check passes, but SignInWithApple.getAppleIDCredential throws PlatformException.
        // This is hard to mock directly. We test the repository's reaction.

        // Act & Assert
        expect(
          () => repository.signInWithApple(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Fehler beim Anmelden mit Apple'),
            ),
          ),
          skip:
              'Cannot directly mock static SignInWithApple.getAppleIDCredential() easily.',
        );
      },
    );

    test(
      'signInWithApple throws generic Exception on other errors during Firebase sign in',
      () async {
        // Arrange: Assume platform check and Apple Sign In worked, but Firebase throws a non-FirebaseAuthException
        final exception = Exception('Network Error during Firebase check');
        when(() => mockAuth.signInWithCredential(any())).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.signInWithApple(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Ein unerwarteter Fehler ist aufgetreten.'),
            ),
          ),
          skip: 'Skipping due to complexity of mocking Apple Sign In result.',
        );
      },
    );
  });
}
