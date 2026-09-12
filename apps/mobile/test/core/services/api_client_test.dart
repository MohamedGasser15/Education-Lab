import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/utils/app_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLogger Sanitization Tests', () {
    test('sanitizes Bearer tokens in headers and strings', () {
      const input = 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.t-ID';
      final sanitized = AppLogger.sanitize(input);
      expect(sanitized, contains('Bearer ***REDACTED_TOKEN***'));
      expect(sanitized, isNot(contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9')));
    });

    test('sanitizes sensitive json fields such as password and credit card', () {
      const input = '{"email": "user@test.com", "password": "SuperSecretPassword123", "cardNumber": "1234567890123456", "cvv": "123"}';
      final sanitized = AppLogger.sanitize(input);
      expect(sanitized, contains('"password": "***REDACTED***"'));
      expect(sanitized, contains('"cardNumber": "***REDACTED***"'));
      expect(sanitized, contains('"cvv": "***REDACTED***"'));
      expect(sanitized, isNot(contains('SuperSecretPassword123')));
      expect(sanitized, contains('"email": "user@test.com"'));
    });

    test('returns unmodified string when no sensitive patterns match', () {
      const input = '{"status": "ok", "count": 42}';
      expect(AppLogger.sanitize(input), input);
    });
  });

  group('ApiClient Logic Tests', () {
    test('initial network status is connected', () {
      expect(ApiClient.isConnected, isTrue);
      expect(ApiClient.networkStatus.value, NetworkStatus.connected);
    });

    test('clearCache empties in-memory cache without errors', () {
      expect(() => ApiClient.clearCache(), returnsNormally);
    });

    test('ApiException formats message and status code', () {
      const exception = ApiException(404, 'Course not found');
      expect(exception.statusCode, 404);
      expect(exception.responseBody, 'Course not found');
      expect(exception.toString(), 'ApiException(404): Course not found');
    });

    test('Result classes Success and Failure hold data and error state', () {
      const success = Success<String>('payload');
      expect(success.data, 'payload');

      const failure = Failure<String>('Something went wrong');
      expect(failure.message, 'Something went wrong');
      expect(failure.error, isNull);
    });
  });
}
