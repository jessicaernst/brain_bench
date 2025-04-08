import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:brain_bench/data/providers/auth/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@riverpod
Stream<model.AppUser?> currentUser(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
