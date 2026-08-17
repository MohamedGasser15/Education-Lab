import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('primary color defined', () {
      expect(AppColors.primary, const Color(0xFF1D61E7));
    });

    test('withOpacity uses alpha', () {
      final c = AppColors.withOpacity(AppColors.primary, 0.5);
      expect(c.a, 0.5);
    });
  });
}