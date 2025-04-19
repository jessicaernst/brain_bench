import 'package:brain_bench/data/repositories/auth_repository.dart';
import 'package:brain_bench/data/repositories/firebase_auth_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
