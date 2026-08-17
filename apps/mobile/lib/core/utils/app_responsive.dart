import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppResponsive {
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  static bool isLargePhone(BuildContext context) =>
      MediaQuery.of(context).size.width >= 414;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 390;

  static bool isExtraSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static T value<T>(
    BuildContext context, {
    T? tablet,
    required T phone,
    T? largePhone,
    T? smallPhone,
    T? extraSmallPhone,
  }) {
    if (tablet != null && isTablet(context)) return tablet;
    if (largePhone != null && isLargePhone(context)) return largePhone;
    if (extraSmallPhone != null && isExtraSmallPhone(context)) return extraSmallPhone;
    if (smallPhone != null && isSmallPhone(context)) return smallPhone;
    return phone;
  }

  static T valueBy<T>({
    required bool isTablet,
    T? tablet,
    required T phone,
    bool? isLargePhone,
    T? largePhone,
    bool? isSmallPhone,
    T? smallPhone,
    bool? isExtraSmallPhone,
    T? extraSmallPhone,
  }) {
    if (tablet != null && isTablet) return tablet;
    if (largePhone != null && isLargePhone == true) return largePhone;
    if (extraSmallPhone != null && isExtraSmallPhone == true) return extraSmallPhone;
    if (smallPhone != null && isSmallPhone == true) return smallPhone;
    return phone;
  }

  static double fontScale(BuildContext context) =>
      value(context, tablet: 1.15, phone: 1.0);

  static double screenHorizontalPadding(BuildContext context) =>
      value(context, tablet: 32, phone: 20);

  static double screenVerticalPadding(BuildContext context) =>
      value(context, tablet: 24, phone: 16);

  static EdgeInsets screenPadding(BuildContext context) =>
      isTablet(context)
          ? const EdgeInsets.symmetric(horizontal: 60, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  static double cardWidth(BuildContext context) =>
      isTablet(context)
          ? MediaQuery.of(context).size.width * 0.65
          : MediaQuery.of(context).size.width * 0.88;

  static double gridCrossAxisCount(BuildContext context) =>
      isTablet(context) ? 3 : 2;

  static double sectionTitleFontSize(BuildContext context) =>
      value(context, tablet: 22, phone: 18);

  static double cardTitleFontSize(BuildContext context) =>
      value(context, tablet: 18, phone: 15);

  static double cardBodyFontSize(BuildContext context) =>
      value(context, tablet: 15, phone: 13);

  static double cardImageHeight(BuildContext context) =>
      value(context, tablet: 200, phone: 150);

  static double statsRowHeight(BuildContext context) =>
      value(context, tablet: 140, phone: 110);

  static double avatarSize(BuildContext context) =>
      value(context, tablet: 80, phone: 60);

  static double bottomContentPadding(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return bottomInset + value<double>(context, tablet: 120.0, phone: 90.0);
  }

  static double bottomNavHeight(BuildContext context) =>
      value(context, tablet: 84, phone: 70);

  static double vSpacing(BuildContext context, {double tablet = 20, double phone = 15}) =>
      value(context, tablet: tablet, phone: phone);
}