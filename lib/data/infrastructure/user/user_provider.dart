import 'package:brain_bench/business_logic/auth/current_user_provider.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Future<model.AppUser?> currentUserModel(Ref ref) async {
  final appUser = await ref.watch(currentUserProvider.future);
  if (appUser == null) return null;

  final db = await ref.watch(quizMockDatabaseRepositoryProvider.future);
  return db.getUser(appUser.uid);
}
