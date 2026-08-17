import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Tajawal';
  static const List<String> _fontFallback = ['Inter'];

  static TextStyle _style({
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFallback,
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle heading({double size = 26, Color? color}) =>
      _style(size: size, weight: FontWeight.w700, color: color);

  static TextStyle subHeading({double size = 20, Color? color}) =>
      _style(size: size, weight: FontWeight.w600, color: color);

  static TextStyle title({double size = 17, Color? color}) =>
      _style(size: size, weight: FontWeight.w600, color: color);

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) =>
      _style(size: size, weight: weight, color: color, height: height);

  static TextStyle caption({double size = 12, Color? color}) =>
      _style(size: size, weight: FontWeight.w400, color: color);

  static TextStyle button({double size = 15, Color? color}) =>
      _style(size: size, weight: FontWeight.w600, color: color);

  static TextStyle overline({double size = 10, Color? color}) =>
      _style(size: size, weight: FontWeight.w500, color: color);
}