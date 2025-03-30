import 'package:brain_bench/data/models/auth/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'package:flutter/services.dart';

final Logger _logger = Logger('FirebaseAuthRepository');

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // for firebase sending email in correct languages for the user
  FirebaseAuthRepository() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    fb.FirebaseAuth.instance.setLanguageCode(locale.languageCode);
  }

  /// Map Firebase [User] to [AppUser]
  AppUser _mapFirebaseUser(fb.User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(
          (user) => user != null ? _mapFirebaseUser(user) : null,
        );
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(credential.user!);
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
      return _mapFirebaseUser(credential.user!);
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
          'Fehler beim Senden der E-Mail zum Zurücksetzen des Passworts: ${e.message}');
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
      return _mapFirebaseUser(userCredential.user!);
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
            'Apple Sign-In ist nur auf iOS/macOS verfügbar.');
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
      return _mapFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      _logger.severe('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw Exception('Fehler beim Anmelden mit Apple: ${e.message}');
    } on PlatformException catch (e) {
      _logger.severe(
          'Platform Exception during Apple Sign-In: ${e.code} - ${e.message}');
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
