import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Responsive design utilities and device breakpoint helpers for EduLab.
class AppResponsive {
  AppResponsive._();

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static bool isLargePhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 414;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 380;

  /// Select a value based on the device form-factor.
  static T value<T>(
    BuildContext context, {
    required T phone,
    T? tablet,
    T? largePhone,
    T? smallPhone,
  }) {
    if (tablet != null && isTablet(context)) return tablet;
    if (largePhone != null && isLargePhone(context)) return largePhone;
    if (smallPhone != null && isSmallPhone(context)) return smallPhone;
    return phone;
  }

  static double fontScale(BuildContext context) =>
      value(context, phone: 1.0, tablet: 1.15, smallPhone: 0.92);

  static double screenPadding(BuildContext context) =>
      value(context, phone: 16.0, tablet: 28.0, smallPhone: 12.0);
}
