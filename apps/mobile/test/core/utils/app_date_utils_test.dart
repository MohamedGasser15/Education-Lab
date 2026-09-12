import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/core/utils/app_date_utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  group('AppDateUtils', () {
    test('formats date', () {
      final date = DateTime(2026, 8, 17);
      final formatted = AppDateUtils.formatDate(date, pattern: 'dd/MM/yyyy');
      expect(formatted, '17/08/2026');
    });

    test('relative time just now', () {
      final date = DateTime.now();
      expect(AppDateUtils.relativeTime(date, locale: 'en'), 'just now');
    });

    test('formatCourseDuration in Arabic and English', () {
      expect(AppDateUtils.formatCourseDuration(10, locale: 'ar'), '10 ساعات');
      expect(AppDateUtils.formatCourseDuration(10, locale: 'en'), '10 hours');
      expect(AppDateUtils.formatCourseDuration(1, locale: 'ar'), 'ساعة واحدة');
      expect(AppDateUtils.formatCourseDuration(1, locale: 'en'), '1 hour');
      expect(AppDateUtils.formatCourseDuration(2, locale: 'ar'), 'ساعتان');
      expect(AppDateUtils.formatCourseDuration(2, locale: 'en'), '2 hours');
      expect(
        AppDateUtils.formatCourseDuration(36000, locale: 'ar'),
        '10 ساعات',
      );
      expect(
        AppDateUtils.formatCourseDuration(36000, locale: 'en'),
        '10 hours',
      );
    });

    test('localizeDurationString converts between Arabic and English', () {
      expect(
        AppDateUtils.localizeDurationString('10 ساعات', isArabic: false),
        '10 hours',
      );
      expect(
        AppDateUtils.localizeDurationString('ساعة واحدة', isArabic: false),
        '1 hour',
      );
      expect(
        AppDateUtils.localizeDurationString('ساعتان', isArabic: false),
        '2 hours',
      );
      expect(
        AppDateUtils.localizeDurationString('10 hours', isArabic: true),
        '10 ساعات',
      );
      expect(
        AppDateUtils.localizeDurationString('1 hour', isArabic: true),
        'ساعة واحدة',
      );
      expect(
        AppDateUtils.localizeDurationString('2 hours', isArabic: true),
        'ساعتان',
      );
    });

    test(
      'localizeRelativeTimeString translates English and Arabic phrases accurately',
      () {
        expect(
          AppDateUtils.localizeRelativeTimeString('2 hours ago'),
          'منذ ساعتين',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('1 hour ago'),
          'منذ ساعة',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('5 hours ago'),
          'منذ 5 ساعات',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('12 hours ago'),
          'منذ 12 ساعة',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('2 days ago'),
          'منذ يومين',
        );
        expect(AppDateUtils.localizeRelativeTimeString('1 day ago'), 'أمس');
        expect(
          AppDateUtils.localizeRelativeTimeString('5 days ago'),
          'منذ 5 أيام',
        );
        expect(AppDateUtils.localizeRelativeTimeString('just now'), 'الآن');
        expect(AppDateUtils.localizeRelativeTimeString('now'), 'الآن');
        expect(AppDateUtils.localizeRelativeTimeString('Sep 01'), '1 سبتمبر');
        expect(AppDateUtils.localizeRelativeTimeString('Aug 31'), '31 أغسطس');
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ 2 ساعة'),
          'منذ ساعتين',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ 1 ساعة'),
          'منذ ساعة',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ 5 ساعة'),
          'منذ 5 ساعات',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ 2 يوم'),
          'منذ يومين',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ 5 يوم'),
          'منذ 5 أيام',
        );
      },
    );

    test(
      'localizeRelativeTimeString translates Arabic phrases to English accurately',
      () {
        expect(
          AppDateUtils.localizeRelativeTimeString('الآن', isArabic: false),
          'just now',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('أمس', isArabic: false),
          'yesterday',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ ساعة', isArabic: false),
          '1 hour ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString(
            'منذ ساعتين',
            isArabic: false,
          ),
          '2 hours ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString(
            'منذ 5 ساعات',
            isArabic: false,
          ),
          '5 hours ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ يومين', isArabic: false),
          '2 days ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString(
            'منذ 5 أيام',
            isArabic: false,
          ),
          '5 days ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ شهر', isArabic: false),
          '1 month ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('منذ شهرين', isArabic: false),
          '2 months ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString(
            'منذ 3 أشهر',
            isArabic: false,
          ),
          '3 months ago',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('1 سبتمبر', isArabic: false),
          'Sep 1',
        );
        expect(
          AppDateUtils.localizeRelativeTimeString('31 أغسطس', isArabic: false),
          'Aug 31',
        );
      },
    );
  });
}
