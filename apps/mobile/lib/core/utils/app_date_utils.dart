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

    if (difference.inMinutes < 1) {
      return locale == 'ar' ? 'الآن' : 'just now';
    }

    if (locale == 'ar') {
      if (difference.inMinutes < 60) {
        final m = difference.inMinutes;
        if (m == 1) return 'منذ دقيقة';
        if (m == 2) return 'منذ دقيقتين';
        if (m <= 10) return 'منذ $m دقائق';
        return 'منذ $m دقيقة';
      } else if (difference.inHours < 24) {
        final h = difference.inHours;
        if (h == 1) return 'منذ ساعة';
        if (h == 2) return 'منذ ساعتين';
        if (h <= 10) return 'منذ $h ساعات';
        return 'منذ $h ساعة';
      } else if (difference.inDays < 30) {
        final d = difference.inDays;
        if (d == 1) return 'أمس';
        if (d == 2) return 'منذ يومين';
        if (d <= 10) return 'منذ $d أيام';
        return 'منذ $d يوماً';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        if (months == 1) return 'منذ شهر';
        if (months == 2) return 'منذ شهرين';
        if (months <= 10) return 'منذ $months أشهر';
        return 'منذ $months شهراً';
      } else {
        final years = (difference.inDays / 365).floor();
        if (years == 1) return 'منذ سنة';
        if (years == 2) return 'منذ سنتين';
        if (years <= 10) return 'منذ $years سنوات';
        return 'منذ $years سنة';
      }
    } else {
      if (difference.inMinutes < 60) {
        final m = difference.inMinutes;
        return m <= 1 ? '1 min ago' : '$m mins ago';
      } else if (difference.inHours < 24) {
        final h = difference.inHours;
        return h <= 1 ? '1 hour ago' : '$h hours ago';
      } else if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 30) {
        final d = difference.inDays;
        return '$d days ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months <= 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years <= 1 ? '1 year ago' : '$years years ago';
      }
    }
  }

  /// Translates and normalizes any relative time string (Arabic or English)
  /// e.g. "2 hours ago" <-> "منذ ساعتين", "5 hours ago" <-> "منذ 5 ساعات",
  /// "منذ 2 ساعة" -> "منذ ساعتين", "منذ 2 يوم" -> "منذ يومين", "Sep 01" <-> "1 سبتمبر".
  static String localizeRelativeTimeString(String text, {bool isArabic = true}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';

    if (isArabic) {
      final lower = trimmed.toLowerCase();

      // Direct translations
      if (lower == 'just now' || lower == 'now') return 'الآن';
      if (lower == 'yesterday') return 'أمس';
      if (lower == 'today') return 'اليوم';

      // 1. English hours: "2 hours ago", "1 hr ago", "5 hours"
      final enHourMatch = RegExp(r'(\d+)\s*(?:hours?|hrs?|h)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enHourMatch != null) {
        final h = int.parse(enHourMatch.group(1)!);
        if (h == 1) return 'منذ ساعة';
        if (h == 2) return 'منذ ساعتين';
        if (h <= 10) return 'منذ $h ساعات';
        return 'منذ $h ساعة';
      }

      // 2. English minutes: "5 mins ago", "1 min ago", "20 minutes ago"
      final enMinMatch = RegExp(r'(\d+)\s*(?:minutes?|mins?|m)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enMinMatch != null) {
        final m = int.parse(enMinMatch.group(1)!);
        if (m == 1) return 'منذ دقيقة';
        if (m == 2) return 'منذ دقيقتين';
        if (m <= 10) return 'منذ $m دقائق';
        return 'منذ $m دقيقة';
      }

      // 3. English days: "1 day ago", "2 days ago", "5 days ago"
      final enDayMatch = RegExp(r'(\d+)\s*(?:days?|d)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enDayMatch != null) {
        final d = int.parse(enDayMatch.group(1)!);
        if (d == 1) return 'أمس';
        if (d == 2) return 'منذ يومين';
        if (d <= 10) return 'منذ $d أيام';
        return 'منذ $d يوماً';
      }

      // 4. English weeks: "1 week ago", "2 weeks ago"
      final enWeekMatch = RegExp(r'(\d+)\s*(?:weeks?|w)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enWeekMatch != null) {
        final w = int.parse(enWeekMatch.group(1)!);
        if (w == 1) return 'منذ أسبوع';
        if (w == 2) return 'منذ أسبوعين';
        if (w <= 10) return 'منذ $w أسابيع';
        return 'منذ $w أسبوعاً';
      }

      // 5. English months: "1 month ago", "2 months ago"
      final enMonthMatch = RegExp(r'(\d+)\s*(?:months?|mo)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enMonthMatch != null) {
        final m = int.parse(enMonthMatch.group(1)!);
        if (m == 1) return 'منذ شهر';
        if (m == 2) return 'منذ شهرين';
        if (m <= 10) return 'منذ $m أشهر';
        return 'منذ $m شهراً';
      }

      // 6. English years: "1 year ago", "2 years ago"
      final enYearMatch = RegExp(r'(\d+)\s*(?:years?|y|yrs?)\s*(?:ago)?', caseSensitive: false).firstMatch(trimmed);
      if (enYearMatch != null) {
        final y = int.parse(enYearMatch.group(1)!);
        if (y == 1) return 'منذ سنة';
        if (y == 2) return 'منذ سنتين';
        if (y <= 10) return 'منذ $y سنوات';
        return 'منذ $y سنة';
      }

      // 7. Fix ungrammatical Arabic hours: "منذ 2 ساعة", "منذ 1 ساعة", "منذ 5 ساعة"
      final arHourMatch = RegExp(r'منذ\s*(\d+)\s*(?:ساعات|ساعة)').firstMatch(trimmed);
      if (arHourMatch != null) {
        final h = int.parse(arHourMatch.group(1)!);
        if (h == 1) return 'منذ ساعة';
        if (h == 2) return 'منذ ساعتين';
        if (h <= 10) return 'منذ $h ساعات';
        return 'منذ $h ساعة';
      }

      // 8. Fix ungrammatical Arabic days: "منذ 2 يوم", "منذ 1 يوم", "منذ 5 يوم"
      final arDayMatch = RegExp(r'منذ\s*(\d+)\s*(?:أيام|يوم)').firstMatch(trimmed);
      if (arDayMatch != null) {
        final d = int.parse(arDayMatch.group(1)!);
        if (d == 1) return 'أمس';
        if (d == 2) return 'منذ يومين';
        if (d <= 10) return 'منذ $d أيام';
        return 'منذ $d يوماً';
      }

      // 9. Fix ungrammatical Arabic minutes: "منذ 2 دقيقة", "منذ 1 دقيقة"
      final arMinMatch = RegExp(r'منذ\s*(\d+)\s*(?:دقائق|دقيقة)').firstMatch(trimmed);
      if (arMinMatch != null) {
        final m = int.parse(arMinMatch.group(1)!);
        if (m == 1) return 'منذ دقيقة';
        if (m == 2) return 'منذ دقيقتين';
        if (m <= 10) return 'منذ $m دقائق';
        return 'منذ $m دقيقة';
      }

      // 10. Fix ungrammatical Arabic months: "منذ 2 شهر", "منذ 1 شهر"
      final arMonthMatch = RegExp(r'منذ\s*(\d+)\s*(?:أشهر|شهر)').firstMatch(trimmed);
      if (arMonthMatch != null) {
        final m = int.parse(arMonthMatch.group(1)!);
        if (m == 1) return 'منذ شهر';
        if (m == 2) return 'منذ شهرين';
        if (m <= 10) return 'منذ $m أشهر';
        return 'منذ $m شهراً';
      }

      // 11. Fix English month formats: "Sep 01", "Aug 31", "15 Aug", etc.
      const enMonths = {
        'Jan': 'يناير',
        'Feb': 'فبراير',
        'Mar': 'مارس',
        'Apr': 'أبريل',
        'May': 'مايو',
        'Jun': 'يونيو',
        'Jul': 'يوليو',
        'Aug': 'أغسطس',
        'Sep': 'سبتمبر',
        'Oct': 'أكتوبر',
        'Nov': 'نوفمبر',
        'Dec': 'ديسمبر',
      };
      for (final entry in enMonths.entries) {
        if (trimmed.contains(entry.key)) {
          final dayMatch = RegExp(r'\b(\d{1,2})\b').firstMatch(trimmed);
          if (dayMatch != null) {
            final day = int.parse(dayMatch.group(1)!);
            return '$day ${entry.value}';
          }
          return trimmed.replaceAll(entry.key, entry.value);
        }
      }

      return trimmed;
    } else {
      // isArabic == false: translate Arabic phrases to English
      if (trimmed == 'الآن' || trimmed == 'now' || trimmed == 'just now') return 'just now';
      if (trimmed == 'أمس' || trimmed == 'yesterday') return 'yesterday';
      if (trimmed == 'اليوم' || trimmed == 'today') return 'today';
      if (trimmed == 'منذ ساعة' || trimmed == 'منذ 1 ساعة') return '1 hour ago';
      if (trimmed == 'منذ ساعتين' || trimmed == 'منذ 2 ساعة') return '2 hours ago';
      if (trimmed == 'منذ دقيقة' || trimmed == 'منذ 1 دقيقة') return '1 min ago';
      if (trimmed == 'منذ دقيقتين' || trimmed == 'منذ 2 دقيقة') return '2 mins ago';
      if (trimmed == 'منذ يوم' || trimmed == 'منذ 1 يوم') return '1 day ago';
      if (trimmed == 'منذ يومين' || trimmed == 'منذ 2 يوم') return '2 days ago';
      if (trimmed == 'منذ أسبوع' || trimmed == 'منذ 1 أسبوع') return '1 week ago';
      if (trimmed == 'منذ أسبوعين' || trimmed == 'منذ 2 أسبوع') return '2 weeks ago';
      if (trimmed == 'منذ شهر' || trimmed == 'منذ 1 شهر') return '1 month ago';
      if (trimmed == 'منذ شهرين' || trimmed == 'منذ 2 شهر') return '2 months ago';
      if (trimmed == 'منذ سنة' || trimmed == 'منذ 1 سنة') return '1 year ago';
      if (trimmed == 'منذ سنتين' || trimmed == 'منذ 2 سنة') return '2 years ago';

      // Arabic hours regex: "منذ (\d+) ساعة/ساعات"
      final arHourMatch = RegExp(r'منذ\s*(\d+)\s*(?:ساعات|ساعة)').firstMatch(trimmed);
      if (arHourMatch != null) {
        final h = int.parse(arHourMatch.group(1)!);
        return h == 1 ? '1 hour ago' : '$h hours ago';
      }

      // Arabic days regex: "منذ (\d+) يوم/أيام/يوماً"
      final arDayMatch = RegExp(r'منذ\s*(\d+)\s*(?:أيام|يوماً|يوم)').firstMatch(trimmed);
      if (arDayMatch != null) {
        final d = int.parse(arDayMatch.group(1)!);
        return d == 1 ? '1 day ago' : '$d days ago';
      }

      // Arabic minutes regex: "منذ (\d+) دقيقة/دقائق"
      final arMinMatch = RegExp(r'منذ\s*(\d+)\s*(?:دقائق|دقيقة)').firstMatch(trimmed);
      if (arMinMatch != null) {
        final m = int.parse(arMinMatch.group(1)!);
        return m == 1 ? '1 min ago' : '$m mins ago';
      }

      // Arabic weeks regex: "منذ (\d+) أسابيع/أسبوع/أسبوعاً"
      final arWeekMatch = RegExp(r'منذ\s*(\d+)\s*(?:أسابيع|أسبوعاً|أسبوع)').firstMatch(trimmed);
      if (arWeekMatch != null) {
        final w = int.parse(arWeekMatch.group(1)!);
        return w == 1 ? '1 week ago' : '$w weeks ago';
      }

      // Arabic months regex: "منذ (\d+) أشهر/شهر/شهراً"
      final arMonthMatch = RegExp(r'منذ\s*(\d+)\s*(?:أشهر|شهراً|شهر)').firstMatch(trimmed);
      if (arMonthMatch != null) {
        final m = int.parse(arMonthMatch.group(1)!);
        return m == 1 ? '1 month ago' : '$m months ago';
      }

      // Arabic years regex: "منذ (\d+) سنوات/سنة"
      final arYearMatch = RegExp(r'منذ\s*(\d+)\s*(?:سنوات|سنة)').firstMatch(trimmed);
      if (arYearMatch != null) {
        final y = int.parse(arYearMatch.group(1)!);
        return y == 1 ? '1 year ago' : '$y years ago';
      }

      // Arabic month names -> English: "1 سبتمبر" -> "Sep 1", "31 أغسطس" -> "Aug 31"
      const arMonths = {
        'يناير': 'Jan',
        'فبراير': 'Feb',
        'مارس': 'Mar',
        'أبريل': 'Apr',
        'مايو': 'May',
        'يونيو': 'Jun',
        'يوليو': 'Jul',
        'أغسطس': 'Aug',
        'سبتمبر': 'Sep',
        'أكتوبر': 'Oct',
        'نوفمبر': 'Nov',
        'ديسمبر': 'Dec',
      };
      for (final entry in arMonths.entries) {
        if (trimmed.contains(entry.key)) {
          final dayMatch = RegExp(r'\b(\d{1,2})\b').firstMatch(trimmed);
          if (dayMatch != null) {
            final day = int.parse(dayMatch.group(1)!);
            return '${entry.value} $day';
          }
        }
      }

      return trimmed;
    }
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