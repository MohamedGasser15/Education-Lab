import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_text_styles.dart';

void main() {
  group('AppTextStyles', () {
    test('uses Tajawal with Inter fallback', () {
      final style = AppTextStyles.body();
      expect(style.fontFamily, 'Tajawal');
      expect(style.fontFamilyFallback, contains('Inter'));
    });

    test('heading is bold', () {
      final style = AppTextStyles.heading();
      expect(style.fontWeight, FontWeight.w700);
    });
  });
}