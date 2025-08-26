import 'package:brain_bench/core/utils/platform_utils.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart' as fb_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
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
      if (kIsWeb) {
        final provider =
            fb.GoogleAuthProvider()
              ..addScope('email')
              ..setCustomParameters({'prompt': 'select_account'});

        fb.UserCredential cred;
        try {
          cred = await _auth.signInWithPopup(provider);
        } on fb.FirebaseAuthException {
          // Fallback (Popup blockiert, z.B. Safari)
          await _auth.signInWithRedirect(provider);
          cred = await _auth.getRedirectResult();
        }

        final fb.User firebaseUser = cred.user!;
        final profileData = await _fetchFirestoreUserProfile(firebaseUser.uid);
        return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
      } else {
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
        final profileData = await _fetchFirestoreUserProfile(firebaseUser.uid);
        return _mapUserFromFirebaseAndFirestore(firebaseUser, profileData);
      }
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Anmelden mit Google: ${e.message}');
    } catch (e) {
      _logger.severe('Google Sign-In error: $e');
      throw Exception('Fehler beim Anmelden mit Google: $e');
    }
  }

  @override
  Future<AppUser> signInWithApple() async {
    try {
      if (!P.isIOS && !P.isMacOS) {
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

  @override
  Future<void> deleteAccount() async {
    final fb.User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      _logger.warning('No user signed in to delete the account.');
      throw Exception('No user signed in.');
    }

    final String userId = firebaseUser.uid;
    _logger.info('Starting account deletion process for user: $userId');

    try {
      // 1. Fetch Firestore user document to get photoUrl
      // and then delete it.
      String? photoUrlToDelete;
      try {
        final userDoc = _firestore.collection('users').doc(userId);
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists && docSnapshot.data() != null) {
          photoUrlToDelete = docSnapshot.data()!['photoUrl'] as String?;
        }
        await userDoc
            .delete(); // Delete the user document from 'users' collection
        _logger.info('Firestore document for user $userId deleted.');
      } catch (e, s) {
        _logger.severe(
          'Error deleting Firestore document for user $userId. Proceeding with other steps.',
          e,
          s,
        );
        // Continue anyway to try to delete the Auth user.
      }

      // 2. Delete profile picture from Firebase Storage, if present
      if (photoUrlToDelete != null && photoUrlToDelete.isNotEmpty) {
        try {
          // Attempt to delete the profile image from Firebase Storage
          final fb_storage.Reference photoRef = fb_storage
              .FirebaseStorage
              .instance
              .refFromURL(photoUrlToDelete);
          await photoRef.delete();
          _logger.info(
            'Profile picture for user $userId deleted from Storage: $photoUrlToDelete',
          );
        } catch (e, s) {
          _logger.severe(
            'Error deleting profile picture from Storage for user $userId ($photoUrlToDelete). Proceeding.',
            e, // Log the error
            s, // Log the stack trace
          );
        }
      }

      // 3. Delete associated quiz results
      // Assumption: The collection is named 'results' and documents have a 'userId' field.
      try {
        final resultsQuery = _firestore
            .collection('results')
            .where('userId', isEqualTo: userId);
        final resultsSnapshot = await resultsQuery.get();

        if (resultsSnapshot.docs.isNotEmpty) {
          // Check if there are any results to delete
          _logger.info(
            // Log how many documents will be deleted
            'Deleting ${resultsSnapshot.docs.length} result document(s) for user $userId.',
          );

          // Firestore batch writes have a limit (e.g., 500 operations).
          // Process deletions in chunks if necessary.
          const batchLimit = 499; // Keep it slightly below 500 for safety
          for (int i = 0; i < resultsSnapshot.docs.length; i += batchLimit) {
            final WriteBatch batch = _firestore.batch();
            final end =
                (i + batchLimit < resultsSnapshot.docs.length)
                    ? i + batchLimit
                    : resultsSnapshot.docs.length;

            for (int j = i; j < end; j++) {
              batch.delete(resultsSnapshot.docs[j].reference);
            }

            _logger.info(
              'Committing batch to delete results from index $i to ${end - 1} for user $userId.',
            );
            await batch.commit();
          }

          _logger.info('All result documents for user $userId deleted.');
        } else {
          _logger.info('No result documents found for user $userId.');
        }
      } catch (e, s) {
        _logger.severe(
          'Error deleting result documents for user $userId. Proceeding.',
          e,
          s,
        );
      }

      // 4. Delete Firebase Auth user
      await firebaseUser.delete();
      _logger.info('Firebase Auth user $userId successfully deleted.');
    } on fb.FirebaseAuthException catch (e, s) {
      _logger.severe(
        'FirebaseAuthException during account deletion for user $userId: ${e.code}',
        e,
        s,
      );
      if (e.code == 'requires-recent-login') {
        throw Exception(
          'This operation requires a recent sign-in. Please sign in again and retry.',
        );
      }
      throw Exception('Error deleting account: ${e.message}');
    } catch (e, s) {
      _logger.severe(
        'Unexpected error during account deletion for user $userId.',
        e,
        s,
      );
      throw Exception(
        'An unexpected error occurred while deleting the account.',
      );
    }
  }
}
