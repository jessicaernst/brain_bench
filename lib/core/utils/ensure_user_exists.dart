import 'package:brain_bench/data/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_bench/data/models/auth/app_user.dart';
import 'package:brain_bench/data/models/user/user.dart' as model;
import 'package:logging/logging.dart';

final _logger = Logger('EnsureUser');

/// Prüft, ob ein User bereits in user.json existiert.
/// Falls nicht, wird er mit Defaultwerten neu angelegt.
Future<void> ensureUserExistsIfNeeded(Ref ref, AppUser appUser) async {
  final db = await ref.read(quizMockDatabaseRepositoryProvider.future);

  final existingUser = await db.getUser(appUser.uid);
  if (existingUser == null) {
    final newUser = model.User(
      uid: appUser.uid,
      profileImageUrl: appUser.photoUrl,
      // optional: Sprache und Theme kannst du hier initial setzen,
      // z.B. locale auslesen oder aus App-Konfig übernehmen
    );

    await db.saveUser(newUser);
    _logger.info('🆕 Neuer User in user.json angelegt: ${appUser.uid}');
  } else {
    _logger.info('✅ User existiert bereits: ${appUser.uid}');
  }
}
