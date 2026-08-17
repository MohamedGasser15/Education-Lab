import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(
    DateTime date, {
    String locale = 'ar',
    String pattern = 'dd MMMM yyyy',
  }) {
    return DateFormat(pattern, locale).format(date);
  }

  static String formatTime(DateTime date, {String locale = 'ar'}) {
    return DateFormat('hh:mm a', locale).format(date);
  }

  static String relativeTime(
    DateTime date, {
    String locale = 'ar',
  }) {
    final now = DateTime.now();
    final difference = now.difference(date);

    String unit;
    double value;

    if (difference.inMinutes < 1) {
      return locale == 'ar' ? 'الآن' : 'just now';
    } else if (difference.inHours < 1) {
      unit = locale == 'ar' ? 'دقيقة' : 'minute';
      value = difference.inMinutes.toDouble();
    } else if (difference.inDays < 1) {
      unit = locale == 'ar' ? 'ساعة' : 'hour';
      value = difference.inHours.toDouble();
    } else if (difference.inDays < 30) {
      unit = locale == 'ar' ? 'يوم' : 'day';
      value = difference.inDays.toDouble();
    } else {
      unit = locale == 'ar' ? 'شهر' : 'month';
      value = difference.inDays / 30;
    }

    final rounded = value.round();
    final suffix = locale == 'ar' ? 'منذ' : 'ago';
    if (locale == 'ar') {
      return '$suffix $rounded $unit';
    }
    final plural = rounded > 1 ? 's' : '';
    return '$rounded $unit$plural $suffix';
  }
}