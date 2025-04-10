import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/infrastructure/auth/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@riverpod
Stream<AppUser?> currentUser(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();
