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

  /// Formats course duration accurately into natural hours and minutes
  /// (e.g., "7 ساعات و 54 دقيقة", "8 ساعات", "ساعتان", "45 دقيقة").
  static String formatCourseDuration(
    int? rawSeconds, {
    String locale = 'ar',
    String? fallback,
  }) {
    final isAr = locale == 'ar';
    if (rawSeconds == null || rawSeconds <= 0) {
      return (fallback != null && fallback.isNotEmpty)
          ? fallback
          : (isAr ? 'دورة متكاملة' : 'Full Course');
    }

    // Small numbers (<= 50) may have been entered as hours directly
    if (rawSeconds <= 50) {
      if (isAr) {
        if (rawSeconds == 1) return 'ساعة واحدة';
        if (rawSeconds == 2) return 'ساعتان';
        if (rawSeconds <= 10) return '$rawSeconds ساعات';
        return '$rawSeconds ساعة';
      }
      return rawSeconds == 1 ? '1 hour' : '$rawSeconds hours';
    }

    int hours = rawSeconds ~/ 3600;
    int minutes = ((rawSeconds % 3600) / 60).round();
    if (minutes == 60) {
      hours += 1;
      minutes = 0;
    }

    if (isAr) {
      if (hours > 0) {
        final String hourText;
        if (hours == 1) {
          hourText = minutes > 0 ? 'ساعة' : 'ساعة واحدة';
        } else if (hours == 2) {
          hourText = 'ساعتان';
        } else if (hours <= 10) {
          hourText = '$hours ساعات';
        } else {
          hourText = '$hours ساعة';
        }

        if (minutes > 0) {
          final String minText;
          if (minutes == 1) {
            minText = 'دقيقة';
          } else if (minutes == 2) {
            minText = 'دقيقتان';
          } else if (minutes <= 10) {
            minText = '$minutes دقائق';
          } else {
            minText = '$minutes دقيقة';
          }
          return '$hourText و $minText';
        }
        return hourText;
      } else if (minutes > 0) {
        if (minutes == 1) return 'دقيقة واحدة';
        if (minutes == 2) return 'دقيقتان';
        if (minutes <= 10) return '$minutes دقائق';
        return '$minutes دقيقة';
      } else {
        return '$rawSeconds ثانية';
      }
    } else {
      if (hours > 0 && minutes > 0) {
        final h = hours == 1 ? '1 hour' : '$hours hours';
        final m = minutes == 1 ? '1 min' : '$minutes mins';
        return '$h $m';
      } else if (hours > 0) {
        return hours == 1 ? '1 hour' : '$hours hours';
      } else if (minutes > 0) {
        return minutes == 1 ? '1 min' : '$minutes mins';
      } else {
        return '$rawSeconds sec';
      }
    }
  }

  /// Converts an existing duration string between Arabic and English
  /// (e.g. "10 ساعات" <-> "10 hours", "ساعتان" <-> "2 hours", "ساعة واحدة" <-> "1 hour").
  static String localizeDurationString(String text, {required bool isArabic}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return isArabic ? 'دورة متكاملة' : 'Full Course';
    }

    if (isArabic) {
      if (trimmed.toLowerCase().contains('full course') ||
          trimmed.toLowerCase().contains('comprehensive')) {
        return 'دورة متكاملة';
      }

      final hourMatch = RegExp(r'(\d+)\s*(?:hours?|hrs?|h)\b', caseSensitive: false).firstMatch(trimmed);
      final minMatch = RegExp(r'(\d+)\s*(?:minutes?|mins?|m)\b', caseSensitive: false).firstMatch(trimmed);

      if (hourMatch != null) {
        final hours = int.parse(hourMatch.group(1)!);
        final String hourText;
        if (hours == 1) {
          hourText = minMatch != null ? 'ساعة' : 'ساعة واحدة';
        } else if (hours == 2) {
          hourText = 'ساعتان';
        } else if (hours <= 10) {
          hourText = '$hours ساعات';
        } else {
          hourText = '$hours ساعة';
        }

        if (minMatch != null) {
          final mins = int.parse(minMatch.group(1)!);
          final String minText;
          if (mins == 1) {
            minText = 'دقيقة';
          } else if (mins == 2) {
            minText = 'دقيقتان';
          } else if (mins <= 10) {
            minText = '$mins دقائق';
          } else {
            minText = '$mins دقيقة';
          }
          return '$hourText و $minText';
        }
        return hourText;
      }

      if (minMatch != null) {
        final mins = int.parse(minMatch.group(1)!);
        if (mins == 1) return 'دقيقة واحدة';
        if (mins == 2) return 'دقيقتان';
        if (mins <= 10) return '$mins دقائق';
        return '$mins دقيقة';
      }

      return trimmed;
    } else {
      if (trimmed.contains('متكاملة') || trimmed.contains('شاملة')) {
        return 'Full Course';
      }

      if (trimmed == 'ساعة واحدة' || trimmed == 'ساعة') {
        return '1 hour';
      }
      if (trimmed == 'ساعتان' || trimmed == 'ساعتين') {
        return '2 hours';
      }

      final hourMatch = RegExp(r'(\d+)\s*ساع(?:ات|ة)').firstMatch(trimmed);
      final minMatch = RegExp(r'(\d+)\s*دقيق(?:ة|ات|تين)').firstMatch(trimmed);

      if (hourMatch != null) {
        final hours = int.parse(hourMatch.group(1)!);
        final hourText = hours == 1 ? '1 hour' : '$hours hours';

        if (minMatch != null) {
          final mins = int.parse(minMatch.group(1)!);
          final minText = mins == 1 ? '1 min' : '$mins mins';
          return '$hourText $minText';
        }
        if (trimmed.contains('دقيقة واحدة')) {
          return '$hourText 1 min';
        }
        if (trimmed.contains('دقيقتان') || trimmed.contains('دقيقتين')) {
          return '$hourText 2 mins';
        }
        return hourText;
      }

      if (minMatch != null) {
        final mins = int.parse(minMatch.group(1)!);
        return mins == 1 ? '1 min' : '$mins mins';
      }

      if (trimmed == 'دقيقة واحدة') return '1 min';
      if (trimmed == 'دقيقتان' || trimmed == 'دقيقتين') return '2 mins';

      return trimmed;
    }
  }
}