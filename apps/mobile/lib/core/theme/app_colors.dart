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
  static const Color successDark = Color(0xFF065F46);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);

  // Role Badge Tokens
  static const Color roleAdmin = Color(0xFFDC2626);
  static const Color roleAdminBg = Color(0xFFFEF2F2);
  static const Color roleAdminBorder = Color(0xFFFECACA);
  static const Color darkRoleAdmin = Color(0xFFFCA5A5);
  static const Color darkRoleAdminBg = Color(0xFF451A1A);
  static const Color darkRoleAdminBorder = Color(0xFF7F1D1D);

  static const Color roleInstructor = Color(0xFF2563EB);
  static const Color roleInstructorBg = Color(0xFFEFF6FF);
  static const Color roleInstructorBorder = Color(0xFFBFDBFE);
  static const Color darkRoleInstructor = Color(0xFF93C5FD);
  static const Color darkRoleInstructorBg = Color(0xFF1E3A5F);
  static const Color darkRoleInstructorBorder = Color(0xFF1D4ED8);

  static const Color roleStudent = Color(0xFFD97706);
  static const Color roleStudentBg = Color(0xFFFFFBEB);
  static const Color roleStudentBorder = Color(0xFFFDE68A);
  static const Color darkRoleStudent = Color(0xFFFCD34D);
  static const Color darkRoleStudentBg = Color(0xFF452A0A);
  static const Color darkRoleStudentBorder = Color(0xFFB45309);

  // Dynamic Theme Resolvers
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBackground : background;

  static Color getSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : surface;

  static Color getSurfaceMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurfaceMuted : surfaceMuted;

  static Color getBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorder : border;

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : textPrimary;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : textSecondary;

  static Color getTextMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextMuted : textMuted;

  static Color getDivider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkDivider : divider;

  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}