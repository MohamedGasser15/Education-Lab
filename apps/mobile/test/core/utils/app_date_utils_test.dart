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
  });
}