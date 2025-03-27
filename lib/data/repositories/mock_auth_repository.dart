import 'dart:async';
import 'package:brain_bench/data/models/auth/app_user.dart';
import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final Logger _logger = Logger('MockAuthRepository');

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;
  // Store emails for which password reset was requested
  final Set<String> _passwordResetRequests = {};

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    _currentUser = AppUser(
      uid: const Uuid().v4(),
      email: email,
      displayName: 'Mock User',
      photoUrl: null,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) {
    return signInWithEmail(email, password);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    _currentUser = AppUser(
      uid: const Uuid().v4(),
      email: 'google@mock.com',
      displayName: 'Google User',
      photoUrl: null,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser> signInWithApple() async {
    _currentUser = AppUser(
      uid: const Uuid().v4(),
      email: 'apple@mock.com',
      displayName: 'Apple User',
      photoUrl: null,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate sending a password reset email
    await Future.delayed(const Duration(milliseconds: 300));

    // Check if the email is valid
    // In this mock, I just check if the email is not empty
    if (email.isNotEmpty) {
      // Add the email to the set of password reset requests
      _passwordResetRequests.add(email);
      _logger.info('Password reset email sent to: $email');
    } else {
      // Handle invalid email (e.g., throw an exception)
      _logger.warning('Invalid email for password reset: $email');
      throw Exception('Invalid email for password reset');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  // Method to check if a password reset email was requested for a specific email
  bool wasPasswordResetRequestedFor(String email) {
    return _passwordResetRequests.contains(email);
  }

  // Method to clear password reset requests (for testing purposes)
  void clearPasswordResetRequests() {
    _passwordResetRequests.clear();
  }
}
