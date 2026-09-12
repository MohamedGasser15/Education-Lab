import 'package:flutter/foundation.dart';

/// Centralized application logger for EduLab.
/// Automatically silences log outputs in production release builds (`kReleaseMode`),
/// and provides structured, tagged log messages for debugging and monitoring.
class AppLogger {
  AppLogger._();

  /// Logs a debug message
  static void d(String message, {String? tag}) {
    _log('DEBUG', message, tag: tag);
  }

  /// Logs an informational message
  static void i(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Logs a warning message
  static void w(String message, {String? tag, Object? error}) {
    _log('WARN', message, tag: tag, error: error);
  }

  /// Logs an error message with optional error object and stack trace
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final prefix = tag != null ? '[$level][$tag]' : '[$level]';
    debugPrint('$prefix $message');

    if (error != null) {
      debugPrint('$prefix Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('$prefix StackTrace: $stackTrace');
    }
  }
}
