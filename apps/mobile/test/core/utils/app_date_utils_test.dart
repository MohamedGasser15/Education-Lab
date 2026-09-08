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
      expect(AppDateUtils.formatCourseDuration(36000, locale: 'ar'), '10 ساعات');
      expect(AppDateUtils.formatCourseDuration(36000, locale: 'en'), '10 hours');
    });

    test('localizeDurationString converts between Arabic and English', () {
      expect(AppDateUtils.localizeDurationString('10 ساعات', isArabic: false), '10 hours');
      expect(AppDateUtils.localizeDurationString('ساعة واحدة', isArabic: false), '1 hour');
      expect(AppDateUtils.localizeDurationString('ساعتان', isArabic: false), '2 hours');
      expect(AppDateUtils.localizeDurationString('10 hours', isArabic: true), '10 ساعات');
      expect(AppDateUtils.localizeDurationString('1 hour', isArabic: true), 'ساعة واحدة');
      expect(AppDateUtils.localizeDurationString('2 hours', isArabic: true), 'ساعتان');
    });
  });
}