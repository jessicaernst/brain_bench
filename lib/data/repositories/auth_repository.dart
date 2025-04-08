import 'package:brain_bench/data/models/user/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> signUpWithEmail(String email, String password);
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithApple();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}
