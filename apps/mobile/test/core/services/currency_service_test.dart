import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/models/currency_info.dart';
import 'package:mobile/core/services/currency_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CurrencyInfo Model Tests', () {
    test('Arab currencies are identified correctly', () {
      final egp = CurrencyInfo(
        code: 'EGP',
        name: 'Egyptian Pound',
        nameAr: 'جنيه مصري',
        symbolEn: 'EGP',
        symbolAr: 'ج.م',
        exchangeRate: 50.0,
        flagEmoji: '🇪🇬',
        decimalPlaces: 0,
      );

      final usd = CurrencyInfo(
        code: 'USD',
        name: 'US Dollar',
        nameAr: 'دولار أمريكي',
        symbolEn: '\$',
        symbolAr: '\$',
        exchangeRate: 1.0,
        flagEmoji: '🇺🇸',
        decimalPlaces: 2,
      );

      expect(egp.isArabCurrency, isTrue);
      expect(usd.isArabCurrency, isFalse);
      expect(egp.getSymbol(true), 'ج.م');
      expect(egp.getSymbol(false), 'EGP');
      expect(egp.getDisplayName(true), 'جنيه مصري');
      expect(egp.getDisplayName(false), 'Egyptian Pound');
    });

    test('Serialization to and from JSON', () {
      final sar = CurrencyInfo(
        code: 'SAR',
        name: 'Saudi Riyal',
        nameAr: 'ريال سعودي',
        symbolEn: 'SAR',
        symbolAr: 'ر.س',
        exchangeRate: 3.75,
        flagEmoji: '🇸🇦',
        decimalPlaces: 2,
      );

      final json = sar.toJson();
      final copy = CurrencyInfo.fromJson(json);

      expect(copy.code, 'SAR');
      expect(copy.exchangeRate, 3.75);
      expect(copy.symbolAr, 'ر.س');
      expect(copy.flagEmoji, '🇸🇦');
    });
  });

  group('CurrencyService Tests', () {
    late CurrencyService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({
        'last_rates_sync_timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      service = CurrencyService();
    });

    test('Initializes with comprehensive currencies list', () {
      expect(service.supportedCurrencies.length, greaterThanOrEqualTo(30));
      expect(service.arabCurrencies.length, greaterThanOrEqualTo(14));
      expect(service.globalCurrencies.length, greaterThanOrEqualTo(16));
    });

    test('Sets and persists preferred currency', () async {
      await service.setCurrency('SAR');
      expect(service.currentCurrencyCode, 'SAR');
      expect(service.currentCurrency.symbolAr, 'ر.س');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('preferred_currency'), 'SAR');
    });

    test('Loads saved currency from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'preferred_currency': 'EUR',
        'last_rates_sync_timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      await service.loadCurrency();

      expect(service.currentCurrencyCode, 'EUR');
      expect(service.currentCurrency.symbolEn, '€');
    });

    test('convertFromUsd and convertToUsd calculations', () async {
      await service.setCurrency('EGP');
      // Default rate for EGP is around 50.0
      final rate = service.currentCurrency.exchangeRate;
      final converted = service.convertFromUsd(100.0);
      expect(converted, closeTo(100.0 * rate, 0.01));

      final backToUsd = service.convertToUsd(converted);
      expect(backToUsd, closeTo(100.0, 0.01));
    });

    test('Price formatting with thousands separators and symbol placement', () async {
      await service.setCurrency('EGP');
      final formattedAr = service.formatPrice(100.0, isArabic: true);
      // EGP has 0 decimal places, so ~5000 ج.م
      expect(formattedAr.contains('ج.م'), isTrue);

      await service.setCurrency('USD');
      final formattedUsd = service.formatPrice(100.0, isArabic: false);
      expect(formattedUsd, '\$100.00');

      final formattedUsdAr = service.formatPrice(100.0, isArabic: true);
      expect(formattedUsdAr, '100.00 \$');
    });

    test('showApproxUsd displays US dollar equivalent for foreign currencies', () async {
      await service.setCurrency('SAR');
      final formatted = service.formatPrice(100.0, isArabic: false, showApproxUsd: true);
      expect(formatted.contains('SR'), isTrue);
      expect(formatted.contains('≈ \$100.00 USD'), isTrue);
    });
  });
}
