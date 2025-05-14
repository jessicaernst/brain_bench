import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final _logger = Logger('FileCleanupUtils');

/// Cleans up old temporary files matching a specific prefix in the temporary directory.
///
/// [prefix] The prefix of the files to look for (e.g., "contact_image_ensure_user_").
/// [maxAge] The maximum age of a file before it's considered old and deleted.
Future<void> cleanupOldTempFiles({
  required String prefix,
  Duration maxAge = const Duration(days: 7), // Delete files older than 7 days
}) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();

    tempDir.listSync(recursive: false, followLinks: false).forEach((entity) {
      if (entity is File && p.basename(entity.path).startsWith(prefix)) {
        final fileStat = entity.statSync();
        if (now.difference(fileStat.modified).compareTo(maxAge) > 0) {
          entity.deleteSync();
          _logger.info('Deleted old temporary file: ${entity.path}');
        }
      }
    });
  } catch (e, stack) {
    _logger.warning('Error during temporary file cleanup: $e', e, stack);
  }
}
