import 'package:logging/logging.dart';

abstract class LoggerUtil {
  static void setupLogging() {
    Logger.root.level = Level.ALL; // Enable all log levels

    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(
          '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    });
  }
}
