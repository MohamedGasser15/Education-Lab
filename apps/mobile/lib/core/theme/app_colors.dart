import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1D61E7);
  static const Color primaryDark = Color(0xFF134BB8);
  static const Color primaryLight = Color(0xFFEFF4FF);
  static const Color accent = Color(0xFF3B82F6);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}