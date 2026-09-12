import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Standalone implementation matching checkout_screen logic for testing
class CardNumberFormatter extends TextInputFormatter {
  static const _arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];
  static const _englishDigits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    for (int i = 0; i < _arabicDigits.length; i++) {
      text = text.replaceAll(_arabicDigits[i], _englishDigits[i]);
    }
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    final isAmex = text.startsWith('34') || text.startsWith('37');
    final maxLen = isAmex ? 15 : 16;
    if (text.length > maxLen) text = text.substring(0, maxLen);

    final buffer = StringBuffer();
    if (isAmex) {
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if ((i == 3 || i == 9) && i != text.length - 1) {
          buffer.write(' ');
        }
      }
    } else {
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if ((i + 1) % 4 == 0 && (i + 1) != text.length) {
          buffer.write(' ');
        }
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  static const _arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];
  static const _englishDigits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    for (int i = 0; i < _arabicDigits.length; i++) {
      text = text.replaceAll(_arabicDigits[i], _englishDigits[i]);
    }
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) text = text.substring(0, 4);

    final isDeleting = oldValue.text.length > newValue.text.length;

    if (!isDeleting && text.length == 1) {
      final firstDigit = int.tryParse(text) ?? 0;
      if (firstDigit > 1) {
        text = '0$text';
      }
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && (text.length > 2 || (!isDeleting && text.length == 2))) {
        buffer.write(' / ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

bool isValidLuhn(String cardNumber) {
  final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
  if (clean.length < 13 || clean.length > 19) return false;
  int sum = 0;
  bool alternate = false;
  for (int i = clean.length - 1; i >= 0; i--) {
    int digit = int.tryParse(clean[i]) ?? -1;
    if (digit == -1) return false;
    if (alternate) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }
    sum += digit;
    alternate = !alternate;
  }
  return (sum % 10) == 0;
}

bool isExpiryDateValid(String text) {
  final clean = text.replaceAll(RegExp(r'\s+'), '').replaceAll('/', '');
  if (clean.length != 4) return false;
  final month = int.tryParse(clean.substring(0, 2)) ?? 0;
  final year = int.tryParse(clean.substring(2, 4)) ?? 0;
  if (month < 1 || month > 12) return false;

  final now = DateTime.now();
  final currentYear = now.year % 100;
  final currentMonth = now.month;

  if (year < currentYear) return false;
  if (year == currentYear && month < currentMonth) return false;
  return true;
}

void main() {
  group('CardNumberFormatter', () {
    final formatter = CardNumberFormatter();

    test('formats 16-digit card into 4-4-4-4 blocks', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '4111222233334444'),
      );
      expect(result.text, '4111 2222 3333 4444');
    });

    test('formats 15-digit Amex card into 4-6-5 blocks', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '341234567890123'),
      );
      expect(result.text, '3412 345678 90123');
    });

    test('converts Arabic numerals to English digits automatically', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '٤١١١٢٢٢٢٣٣٣٣٤٤٤٤'),
      );
      expect(result.text, '4111 2222 3333 4444');
    });

    test('truncates inputs exceeding max card length', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '4111222233334444999999'),
      );
      expect(result.text, '4111 2222 3333 4444');
    });
  });

  group('CardExpiryFormatter', () {
    final formatter = CardExpiryFormatter();

    test('adds leading zero if single digit > 1 entered for month', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '5'),
      );
      expect(result.text, '05 / ');
    });

    test('formats MM/YY correctly', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '1228'),
      );
      expect(result.text, '12 / 28');
    });

    test('converts Arabic numerals for expiry date', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '٠٨٣٠'),
      );
      expect(result.text, '08 / 30');
    });
  });

  group('Luhn Algorithm Validation', () {
    test('validates authentic test card numbers', () {
      expect(isValidLuhn('4532015112830366'), isTrue);
      expect(isValidLuhn('4532 0151 1283 0366'), isTrue);
    });

    test('rejects invalid card numbers', () {
      expect(isValidLuhn('4532015112830367'), isFalse);
      expect(isValidLuhn('1234567812345678'), isFalse);
      expect(isValidLuhn(''), isFalse);
    });
  });

  group('Expiry Date Validation', () {
    test('validates valid future dates', () {
      expect(isExpiryDateValid('12 / 35'), isTrue);
      expect(isExpiryDateValid('06 / 29'), isTrue);
    });

    test('rejects invalid months (e.g. month 00 or > 12)', () {
      expect(isExpiryDateValid('00 / 28'), isFalse);
      expect(isExpiryDateValid('13 / 28'), isFalse);
      expect(isExpiryDateValid('99 / 30'), isFalse);
    });

    test('rejects expired past years', () {
      expect(isExpiryDateValid('01 / 20'), isFalse);
      expect(isExpiryDateValid('12 / 22'), isFalse);
    });
  });
}
