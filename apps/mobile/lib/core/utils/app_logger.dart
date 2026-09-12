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

  /// Sanitizes sensitive patterns (passwords, tokens, credit card numbers) from log strings.
  static String sanitize(String input) {
    if (input.isEmpty) return input;
    var sanitized = input;

    // Redact Bearer tokens
    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(Bearer\s+)[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*', caseSensitive: false),
      (match) => '${match.group(1)}***REDACTED_TOKEN***',
    );

    // Redact JSON sensitive fields like "password": "...", "token": "..."
    final sensitiveKeys = [
      'password',
      'currentPassword',
      'newPassword',
      'confirmPassword',
      'cardNumber',
      'cvv',
      'cvc',
      'accessToken',
      'refreshToken',
      'secret',
      'otp',
      'twoFactorCode',
    ];

    for (final key in sensitiveKeys) {
      sanitized = sanitized.replaceAllMapped(
        RegExp('("$key"\\s*:\\s*)"([^"]+)"', caseSensitive: false),
        (match) => '${match.group(1)}"***REDACTED***"',
      );
    }

    return sanitized;
  }

  static void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final sanitizedMessage = sanitize(message);
    final prefix = tag != null ? '[$level][$tag]' : '[$level]';
    debugPrint('$prefix $sanitizedMessage');

    if (error != null) {
      final sanitizedError = sanitize(error.toString());
      debugPrint('$prefix Error: $sanitizedError');
    }
    if (stackTrace != null) {
      debugPrint('$prefix StackTrace: $stackTrace');
    }
  }
}
