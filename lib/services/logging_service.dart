// ignore_for_file: avoid_print

import 'package:logging/logging.dart';

/// A service for logging messages, warnings, and errors.
class LoggingService {
  final Logger _logger;

  /// Creates a new instance of the [LoggingService] with the given [name].
  LoggingService(String name) : _logger = Logger(name);

  /// Initializes the logging service.
  void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message}',
      );
      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    });
  }

  /// Logs a very detailed message with an optional [error] and [stackTrace].
  void finest(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.finest(message, error, stackTrace);
  }

  /// Logs a detailed message with an optional [error] and [stackTrace].
  void finer(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.finer(message, error, stackTrace);
  }

  /// Logs a detailed message with an optional [error] and [stackTrace].
  void fine(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Logs a configuration message with an optional [error] and [stackTrace].
  void config(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.config(message, error, stackTrace);
  }

  /// Logs an informational message with an optional [error] and [stackTrace].
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Logs a warning message with an optional [error] and [stackTrace].
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Logs a severe error message with an optional [error] and [stackTrace].
  void severe(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Logs a very severe error message with an optional [error] and [stackTrace].
  void shout(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.shout(message, error, stackTrace);
  }
}
