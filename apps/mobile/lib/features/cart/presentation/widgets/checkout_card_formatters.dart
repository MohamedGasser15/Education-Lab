import 'package:flutter/services.dart';

/// Formatter that automatically converts Arabic-Indic digits (٠-٩) to standard English digits (0-9).
class ArabicDigitsToEnglishFormatter extends TextInputFormatter {
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
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Validates credit card number authenticity using the standard Luhn checksum algorithm (Mod 10).
bool isValidLuhn(String cardNumber) {
  final clean = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (clean.length < 13 || clean.length > 19) return false;

  int sum = 0;
  bool isSecond = false;
  for (int i = clean.length - 1; i >= 0; i--) {
    int digit = int.parse(clean[i]);
    if (isSecond) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }
    sum += digit;
    isSecond = !isSecond;
  }
  return sum % 10 == 0;
}

/// Formatter for credit card numbers, handling Amex (4-6-5) and standard (4-4-4-4) spacing blocks.
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

/// Formatter for card expiration dates in `MM / YY` format with automatic leading zero addition.
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
