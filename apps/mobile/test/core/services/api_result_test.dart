import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';

void main() {
  group('Result<T> sealed class', () {
    test('Success holds data properly', () {
      const result = Success<String>('Hello World');
      expect(result.data, 'Hello World');
      expect(result, isA<Result<String>>());
      expect(result, isA<Success<String>>());
    });

    test('Failure holds message and optional error object', () {
      final customError = Exception('Timeout');
      final result = Failure<int>('Failed to fetch data', error: customError);

      expect(result.message, 'Failed to fetch data');
      expect(result.error, customError);
      expect(result, isA<Result<int>>());
      expect(result, isA<Failure<int>>());
    });

    test('Pattern matching on Result handles both branches', () {
      Result<int> getResult(bool pass) {
        return pass ? const Success(42) : const Failure('Error occurred');
      }

      final successResult = getResult(true);
      final failureResult = getResult(false);

      final successValue = switch (successResult) {
        Success(data: final d) => d,
        Failure() => 0,
      };

      final failureMsg = switch (failureResult) {
        Success() => '',
        Failure(message: final m) => m,
      };

      expect(successValue, 42);
      expect(failureMsg, 'Error occurred');
    });
  });
}
