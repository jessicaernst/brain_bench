import 'package:brain_bench/core/utils/auth/ensure_user_exists.dart'
    as ensure_user_tool;
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ensure_user_exists_provider.g.dart';

/// Typedef for the ensureUserExistsIfNeeded function signature.
typedef EnsureUserExistsFn =
    Future<bool> Function(
      ensure_user_tool.Reader
      read, // Use the typedef from ensure_user_exists.dart
      AppUser? appUser,
    );

/// Provider that exposes the ensureUserExistsIfNeeded function.
@riverpod
EnsureUserExistsFn ensureUserExists(Ref ref) {
  return ensure_user_tool.ensureUserExistsIfNeeded;
}
