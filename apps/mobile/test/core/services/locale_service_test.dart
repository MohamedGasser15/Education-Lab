import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/locale_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleService Tests', () {
    late LocaleService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = LocaleService();
    });

    test('default locale is Arabic (ar)', () {
      expect(service.locale.languageCode, 'ar');
    });

    test('loadLocale reads saved language from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'language': 'en'});
      await service.loadLocale();
      expect(service.locale.languageCode, 'en');
    });

    test(
      'setLocale updates locale state and persists to SharedPreferences',
      () async {
        await service.setLocale('fr');
        expect(service.locale.languageCode, 'fr');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('language'), 'fr');
      },
    );
  });
}
