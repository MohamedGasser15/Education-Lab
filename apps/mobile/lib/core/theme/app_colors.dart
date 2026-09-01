import 'package:flutter/material.dart';

class AppColors {
  // Primary & Brand Colors
  static const Color primary = Color(0xFF1D61E7);
  static const Color primaryDark = Color(0xFF134BB8);
  static const Color primaryLight = Color(0xFFEFF4FF);
  static const Color accent = Color(0xFF3B82F6);

  // Light Palette
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Dark Palette (Slate / Zinc modern dark scheme)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF161E2E);
  static const Color darkSurfaceMuted = Color(0xFF1F2937);
  static const Color darkCard = Color(0xFF182234);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  static const Color darkBorder = Color(0xFF263348);
  static const Color darkDivider = Color(0xFF1E293B);

  // Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}