import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/category_localization_helper.dart';

void main() {
  group('CategoryLocalizationHelper', () {
    test('returns Arabic name when languageCode starts with ar', () {
      final name = CategoryLocalizationHelper.getCategoryName(
        arName: 'برمجة وتطوير',
        enName: 'Development',
        languageCode: 'ar',
      );
      expect(name, 'برمجة وتطوير');

      final nameSaudi = CategoryLocalizationHelper.getCategoryName(
        arName: 'برمجة وتطوير',
        enName: 'Development',
        languageCode: 'ar_SA',
      );
      expect(nameSaudi, 'برمجة وتطوير');
    });

    test('returns English name when languageCode is non-Arabic', () {
      final nameEn = CategoryLocalizationHelper.getCategoryName(
        arName: 'برمجة وتطوير',
        enName: 'Development',
        languageCode: 'en',
      );
      expect(nameEn, 'Development');

      final nameFr = CategoryLocalizationHelper.getCategoryName(
        arName: 'برمجة وتطوير',
        enName: 'Development',
        languageCode: 'fr',
      );
      expect(nameFr, 'Development');
    });

    test('falls back to non-empty alternate if primary is empty or null', () {
      final fallbackToEn = CategoryLocalizationHelper.getCategoryName(
        arName: null,
        enName: 'Business',
        languageCode: 'ar',
      );
      expect(fallbackToEn, 'Business');

      final fallbackToAr = CategoryLocalizationHelper.getCategoryName(
        arName: 'إدارة الأعمال',
        enName: '',
        languageCode: 'en',
      );
      expect(fallbackToAr, 'إدارة الأعمال');
    });
  });
}
