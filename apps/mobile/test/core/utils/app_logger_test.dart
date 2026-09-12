import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/app_logger.dart';

void main() {
  group('AppLogger Tests', () {
    test('AppLogger methods execute without throwing exceptions', () {
      expect(
        () => AppLogger.d('Test debug message', tag: 'TestTag'),
        returnsNormally,
      );
      expect(
        () => AppLogger.i('Test info message', tag: 'TestTag'),
        returnsNormally,
      );
      expect(
        () => AppLogger.w(
          'Test warning message',
          tag: 'TestTag',
          error: 'Sample warning',
        ),
        returnsNormally,
      );
      expect(
        () => AppLogger.e(
          'Test error message',
          tag: 'TestTag',
          error: Exception('Test exception'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('AppLogger works with null tags and errors', () {
      expect(() => AppLogger.d('Simple debug'), returnsNormally);
      expect(() => AppLogger.i('Simple info'), returnsNormally);
      expect(() => AppLogger.w('Simple warn'), returnsNormally);
      expect(() => AppLogger.e('Simple error'), returnsNormally);
    });
  });
}
