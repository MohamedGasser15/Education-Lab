import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/string_utils.dart';

void main() {
  group('StringUtils', () {
    test('isNullOrEmpty', () {
      expect(StringUtils.isNullOrEmpty(null), true);
      expect(StringUtils.isNullOrEmpty(''), true);
      expect(StringUtils.isNullOrEmpty('x'), false);
    });

    test('isValidEmail', () {
      expect(StringUtils.isValidEmail('user@example.com'), true);
      expect(StringUtils.isValidEmail('user@@example.com'), false);
      expect(StringUtils.isValidEmail('user@example'), false);
    });

    test('maskEmail', () {
      expect(StringUtils.maskEmail('john@example.com'), 'jo**@example.com');
    });

    test('truncate', () {
      expect(StringUtils.truncate('hello', maxLength: 3), 'hel...');
      expect(StringUtils.truncate('hi', maxLength: 3), 'hi');
    });
  });
}
