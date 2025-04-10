import 'package:brain_bench/data/infrastructure/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/data/models/user/app_user.dart' as model;
import 'package:logging/logging.dart';

final _logger = Logger('EnsureUser');

Future<void> ensureUserExistsIfNeeded(Ref ref, model.AppUser appUser) async {
  final db = await ref.read(quizMockDatabaseRepositoryProvider.future);

  final existingUser = await db.getUser(appUser.uid);
  if (existingUser == null) {
    final newUser = appUser.copyWith(
      themeMode: 'system',
      language: 'en',
      categoryProgress: {},
      isTopicDone: {},
    );

    await db.saveUser(newUser);
    _logger.info('🆕 Neuer User in user.json angelegt: ${appUser.uid}');
  } else {
    _logger.info('✅ User existiert bereits: ${appUser.uid}');
  }
}
