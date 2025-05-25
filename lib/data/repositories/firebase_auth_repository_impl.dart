import 'dart:io';

import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'auth_repository.dart';

final Logger _logger = Logger('FirebaseAuthRepository');

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({fb.FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? fb.FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    _auth.setLanguageCode(locale.languageCode);
  }

  /// Maps Firebase user and Firestore data to an AppUser.
  AppUser _mapUserFromFirebaseAndFirestore(
    fb.User firebaseUser,
    Map<String, dynamic>? firestoreData,
  ) {
    // Default theme if not found in Firestore or if firestoreData is null
    String themeMode = ThemeMode.system.name; // Default value
    if (firestoreData != null && firestoreData['themeMode'] is String) {
      themeMode = firestoreData['themeMode'] as String;
    } else if (firestoreData != null && firestoreData['themeMode'] != null) {
      // Field exists but is not a String
      _logger.warning(
        'Firestore "themeMode" field is not a String for user ${firebaseUser.uid}. Using default.',
      );
    }

    // Default language if not found in Firestore or if firestoreData is null
    // Read 'language' field from Firestore, consistent with how LocaleNotifier likely saves it.
    String languageValue = 'en'; // Default value
    if (firestoreData != null && firestoreData['language'] is String) {
      languageValue = firestoreData['language'] as String;
    } else if (firestoreData != null && firestoreData['language'] != null) {
      // Field exists but is not a String
      _logger.warning(
        'Firestore "language" field is not a String for user ${firebaseUser.uid}. Using default.',
      );
    }

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      id: firebaseUser.uid,
      themeMode: themeMode,
      language: languageValue,
    );
  }

  /// Helper to fetch Firestore user profile data.
  /// Returns null if the document doesn't exist or an error occurs.
  Future<Map<String, dynamic>?> _fetchFirestoreUserProfile(
    String userId,
  ) async {
    if (userId.isEmpty) {
      _logger.warning('Cannot fetch Firestore profile for empty userId.');
      return null;
    }
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      return docSnapshot.data();
    } catch (e, s) {
      _logger.warning(
        'Failed to fetch Firestore profile for user $userId immediately. Using defaults for initial AppUser.',
        e,
        s,
      );
      return null; // Fallback to null if fetch fails
    }
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().switchMap((fb.User? firebaseUser) {
      if (firebaseUser == null) {
        _logger.fine('authStateChanges: No Firebase user. Emitting null.');
        return Stream.value(null);
      } else {
        _logger.fine(
          'authStateChanges: Firebase user ${firebaseUser.uid} found. Listening to Firestore document.',
        );
        try {
          // It's good practice to ensure uid is not empty, as Firestore paths cannot be empty.
          if (firebaseUser.uid.isEmpty) {
            _logger.severe(
              'Firebase user UID is empty. Cannot fetch Firestore document. Falling back to defaults.',
            );
            return Stream.value(
              _mapUserFromFirebaseAndFirestore(firebaseUser, null),
            );
          }
          // Listen to the user's document in Firestore
          return _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .snapshots()
              .map((docSnapshot) {
                _logger.fine(
                  'authStateChanges: Firestore snapshot received for user ${firebaseUser.uid}. Document exists: ${docSnapshot.exists}',
                );
                return _mapUserFromFirebaseAndFirestore(
                  firebaseUser,
                  docSnapshot.data(),
                );
              })
              .handleError((Object error, StackTrace stackTrace) {
                _logger.severe(
                  'Error listening to Firestore snapshots for user ${firebaseUser.uid}. Falling back to default profile settings.',
                  error,
                  stackTrace,
                );
                // Emit an AppUser based on the authenticated Firebase user but with null Firestore data,
                // which will result in default theme/language being used.
                return _mapUserFromFirebaseAndFirestore(firebaseUser, null);
              });
        } catch (e, s) {
          // Catch synchronous errors during stream setup (e.g., invalid UID for doc path)
          _logger.severe(
            'Synchronous error setting up Firestore stream for user ${firebaseUser.uid}. Falling back to default profile settings.',
            e,
            s,
          );
          return Stream.value(
            _mapUserFromFirebaseAndFirestore(firebaseUser, null),
          );
        }
      }
    });
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fb.User firebaseUser = credential.user!;
      final Map<String, dynamic>? profileData =
          await _fetchFirestoreUserProfile(firebaseUser.uid);
      return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
    } on fb.FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Anmelden: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      _logger.severe('Unexpected error during sign-in: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fb.User firebaseUser = credential.user!;
      final Map<String, dynamic>? profileData =
          await _fetchFirestoreUserProfile(firebaseUser.uid);
      return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Registrieren: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error during sign-up: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception(
        'Fehler beim Senden der E-Mail zum Zurücksetzen des Passworts: ${e.message}',
      );
    } catch (e) {
      _logger.severe('Unexpected error during password reset: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.severe('Unexpected error during sign-out: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In abgebrochen');
      }

      final googleAuth = await googleUser.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final fb.User firebaseUser = userCredential.user!;
      final Map<String, dynamic>? profileData =
          await _fetchFirestoreUserProfile(firebaseUser.uid);
      return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Anmelden mit Google: ${e.message}');
    } on Exception catch (e) {
      _logger.severe('Google Sign-In error: $e');
      throw Exception('Fehler beim Anmelden mit Google: $e');
    } catch (e) {
      _logger.severe('Unexpected error during Google sign-in: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  @override
  Future<AppUser> signInWithApple() async {
    try {
      if (!Platform.isIOS && !Platform.isMacOS) {
        throw UnsupportedError(
          'Apple Sign-In ist nur auf iOS/macOS verfügbar.',
        );
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final fb.User firebaseUser = userCredential.user!;
      final Map<String, dynamic>? profileData =
          await _fetchFirestoreUserProfile(firebaseUser.uid);
      return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Anmelden mit Apple: ${e.message}');
    } on PlatformException catch (e) {
      _logger.severe(
        'Platform Exception during Apple Sign-In: ${e.code} - ${e.message}',
      );
      throw Exception('Fehler beim Anmelden mit Apple: ${e.message}');
    } on UnsupportedError catch (e) {
      _logger.severe('Unsupported Error during Apple Sign-In: $e');
      throw Exception('Apple Sign-In ist auf diesem Gerät nicht verfügbar.');
    } catch (e) {
      _logger.severe('Unsupported Error during Apple Sign-In: $e');
      throw Exception('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }
}
