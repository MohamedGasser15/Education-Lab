import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/models/currency_info.dart';
import 'package:mobile/core/utils/app_logger.dart';

class CurrencyService extends ChangeNotifier {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  static CurrencyService get instance => _instance;

  CurrencyService._internal() {
    _currencies = _initDefaultCurrencies();
    _currentCurrency = _currencies['USD']!;
  }

  static const String prefKeyCurrency = 'preferred_currency';
  static const String prefKeyLiveRates = 'cached_live_exchange_rates';
  static const String prefKeyLastSync = 'last_rates_sync_timestamp';
  static const String liveApiUrl = 'https://open.er-api.com/v6/latest/USD';

  late Map<String, CurrencyInfo> _currencies;
  late CurrencyInfo _currentCurrency;
  bool _isLoadingRates = false;
  DateTime? _lastSyncTime;

  CurrencyInfo get currentCurrency => _currentCurrency;
  String get currentCurrencyCode => _currentCurrency.code;
  bool get isLoadingRates => _isLoadingRates;
  DateTime? get lastSyncTime => _lastSyncTime;

  List<CurrencyInfo> get supportedCurrencies => _currencies.values.toList();
  List<CurrencyInfo> get arabCurrencies =>
      _currencies.values.where((c) => c.isArabCurrency).toList();
  List<CurrencyInfo> get globalCurrencies =>
      _currencies.values.where((c) => !c.isArabCurrency).toList();

  Future<void> loadCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _loadCachedRates(prefs);

      final savedCode = prefs.getString(prefKeyCurrency);
      if (savedCode != null && _currencies.containsKey(savedCode.toUpperCase())) {
        _currentCurrency = _currencies[savedCode.toUpperCase()]!;
      } else {
        // Auto-detect based on platform locale
        final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
        final detected = _detectCurrencyFromLocale(platformLocale);
        if (_currencies.containsKey(detected)) {
          _currentCurrency = _currencies[detected]!;
        } else {
          _currentCurrency = _currencies['USD']!;
        }
      }

      notifyListeners();

      // Refresh live exchange rates in the background if older than 6 hours
      final lastSyncMs = prefs.getInt(prefKeyLastSync) ?? 0;
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      if (nowMs - lastSyncMs > 6 * 3600 * 1000) {
        syncLiveRates();
      }
    } catch (e) {
      AppLogger.w('Failed to load currency settings: $e', tag: 'CurrencyService');
    }
  }

  Future<void> setCurrency(String currencyCode) async {
    final code = currencyCode.trim().toUpperCase();
    if (!_currencies.containsKey(code) || _currentCurrency.code == code) {
      return;
    }

    _currentCurrency = _currencies[code]!;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKeyCurrency, code);
    } catch (e) {
      AppLogger.w('Failed to save preferred currency: $e', tag: 'CurrencyService');
    }
  }

  Future<void> syncLiveRates() async {
    if (_isLoadingRates) return;
    _isLoadingRates = true;

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );
      final response = await dio.get<Map<String, dynamic>>(liveApiUrl);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final rates = data['rates'] as Map<String, dynamic>?;

        if (rates != null) {
          final now = DateTime.now();
          _lastSyncTime = now;

          for (final entry in _currencies.entries) {
            final rate = rates[entry.key];
            if (rate is num && rate > 0) {
              entry.value.exchangeRate = rate.toDouble();
              entry.value.isLive = true;
              entry.value.lastSyncTime = now;
            }
          }

          // Cache rates locally
          final prefs = await SharedPreferences.getInstance();
          final rateMap = <String, double>{};
          for (final e in _currencies.entries) {
            rateMap[e.key] = e.value.exchangeRate;
          }
          await prefs.setString(prefKeyLiveRates, jsonEncode(rateMap));
          await prefs.setInt(prefKeyLastSync, now.millisecondsSinceEpoch);

          notifyListeners();
        }
      }
    } catch (e) {
      AppLogger.w('Failed to sync live exchange rates: $e', tag: 'CurrencyService');
    } finally {
      _isLoadingRates = false;
    }
  }

  void _loadCachedRates(SharedPreferences prefs) {
    try {
      final cachedJson = prefs.getString(prefKeyLiveRates);
      if (cachedJson != null) {
        final Map<String, dynamic> rateMap = jsonDecode(cachedJson);
        final lastSyncMs = prefs.getInt(prefKeyLastSync);
        if (lastSyncMs != null) {
          _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSyncMs);
        }

        for (final entry in rateMap.entries) {
          if (_currencies.containsKey(entry.key) && entry.value is num) {
            _currencies[entry.key]!.exchangeRate = (entry.value as num).toDouble();
            _currencies[entry.key]!.isLive = true;
            _currencies[entry.key]!.lastSyncTime = _lastSyncTime;
          }
        }
      }
    } catch (_) {}
  }

  double convertFromUsd(double usdAmount, [String? targetCurrencyCode]) {
    final target = (targetCurrencyCode != null && _currencies.containsKey(targetCurrencyCode.toUpperCase()))
        ? _currencies[targetCurrencyCode.toUpperCase()]!
        : _currentCurrency;

    return usdAmount * target.exchangeRate;
  }

  double convertToUsd(double amount, [String? sourceCurrencyCode]) {
    final code = (sourceCurrencyCode ?? _currentCurrency.code).trim().toUpperCase();
    final source = _currencies[code];
    if (source == null || source.exchangeRate <= 0) return amount;
    return amount / source.exchangeRate;
  }

  String formatPrice(
    double usdAmount, {
    String? targetCurrencyCode,
    bool? isArabic,
    bool showApproxUsd = false,
  }) {
    if (usdAmount <= 0) {
      return (isArabic ?? false) ? 'مجاناً' : 'Free';
    }

    final target = (targetCurrencyCode != null && _currencies.containsKey(targetCurrencyCode.toUpperCase()))
        ? _currencies[targetCurrencyCode.toUpperCase()]!
        : _currentCurrency;

    final arabic = isArabic ?? false;
    final converted = convertFromUsd(usdAmount, target.code);

    String formattedNumber;
    if (target.decimalPlaces == 0) {
      formattedNumber = converted.round().toString();
      formattedNumber = _addThousandsSeparators(formattedNumber);
    } else {
      formattedNumber = converted.toStringAsFixed(target.decimalPlaces);
      final parts = formattedNumber.split('.');
      parts[0] = _addThousandsSeparators(parts[0]);
      formattedNumber = parts.join('.');
    }

    final symbol = target.getSymbol(arabic);
    String mainPrice;

    if (target.code == 'USD' && !arabic) {
      mainPrice = '\$$formattedNumber';
    } else if (target.code == 'EUR' && !arabic) {
      mainPrice = '€$formattedNumber';
    } else if (target.code == 'GBP' && !arabic) {
      mainPrice = '£$formattedNumber';
    } else if (arabic) {
      mainPrice = '$formattedNumber $symbol';
    } else {
      mainPrice = '$formattedNumber $symbol';
    }

    if (showApproxUsd && target.code != 'USD') {
      return '$mainPrice (≈ \$${usdAmount.toStringAsFixed(2)} USD)';
    }

    return mainPrice;
  }

  static String _addThousandsSeparators(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static String _detectCurrencyFromLocale(Locale locale) {
    final country = locale.countryCode?.toUpperCase();
    if (country != null) {
      switch (country) {
        case 'EG':
          return 'EGP';
        case 'SA':
          return 'SAR';
        case 'AE':
          return 'AED';
        case 'KW':
          return 'KWD';
        case 'QA':
          return 'QAR';
        case 'BH':
          return 'BHD';
        case 'OM':
          return 'OMR';
        case 'JO':
          return 'JOD';
        case 'MA':
          return 'MAD';
        case 'DZ':
          return 'DZD';
        case 'TN':
          return 'TND';
        case 'LY':
          return 'LYD';
        case 'IQ':
          return 'IQD';
        case 'LB':
          return 'LBP';
        case 'SD':
          return 'SDG';
        case 'GB':
          return 'GBP';
        case 'US':
          return 'USD';
        case 'CA':
          return 'CAD';
        case 'AU':
          return 'AUD';
        case 'CH':
          return 'CHF';
        case 'JP':
          return 'JPY';
        case 'CN':
          return 'CNY';
        case 'TR':
          return 'TRY';
        case 'IN':
          return 'INR';
        case 'BR':
          return 'BRL';
        case 'RU':
          return 'RUB';
        case 'KR':
          return 'KRW';
        case 'MY':
          return 'MYR';
        case 'ID':
          return 'IDR';
        case 'SE':
          return 'SEK';
        case 'NO':
          return 'NOK';
        case 'DE':
        case 'FR':
        case 'IT':
        case 'ES':
        case 'NL':
        case 'BE':
        case 'AT':
        case 'IE':
        case 'PT':
        case 'GR':
        case 'FI':
          return 'EUR';
      }
    }

    if (locale.languageCode == 'ar') return 'EGP';
    return 'USD';
  }

  static Map<String, CurrencyInfo> _initDefaultCurrencies() {
    return {
      // Global Base & Major Currencies
      'USD': CurrencyInfo(
        code: 'USD',
        name: 'US Dollar',
        nameAr: 'دولار أمريكي',
        symbolEn: '\$',
        symbolAr: '\$',
        exchangeRate: 1.0,
        flagEmoji: '🇺🇸',
        decimalPlaces: 2,
      ),
      'EUR': CurrencyInfo(
        code: 'EUR',
        name: 'Euro',
        nameAr: 'يورو',
        symbolEn: '€',
        symbolAr: '€',
        exchangeRate: 0.88,
        flagEmoji: '🇪🇺',
        decimalPlaces: 2,
      ),
      'GBP': CurrencyInfo(
        code: 'GBP',
        name: 'British Pound',
        nameAr: 'جنيه إسترليني',
        symbolEn: '£',
        symbolAr: '£',
        exchangeRate: 0.75,
        flagEmoji: '🇬🇧',
        decimalPlaces: 2,
      ),
      'CAD': CurrencyInfo(
        code: 'CAD',
        name: 'Canadian Dollar',
        nameAr: 'دولار كندي',
        symbolEn: '\$',
        symbolAr: '\$',
        exchangeRate: 1.36,
        flagEmoji: '🇨🇦',
        decimalPlaces: 2,
      ),
      'AUD': CurrencyInfo(
        code: 'AUD',
        name: 'Australian Dollar',
        nameAr: 'دولار أسترالي',
        symbolEn: '\$',
        symbolAr: '\$',
        exchangeRate: 1.50,
        flagEmoji: '🇦🇺',
        decimalPlaces: 2,
      ),
      'CHF': CurrencyInfo(
        code: 'CHF',
        name: 'Swiss Franc',
        nameAr: 'فرنك سويسري',
        symbolEn: 'CHF',
        symbolAr: 'CHF',
        exchangeRate: 0.85,
        flagEmoji: '🇨🇭',
        decimalPlaces: 2,
      ),
      'JPY': CurrencyInfo(
        code: 'JPY',
        name: 'Japanese Yen',
        nameAr: 'ين ياباني',
        symbolEn: '¥',
        symbolAr: '¥',
        exchangeRate: 145.0,
        flagEmoji: '🇯🇵',
        decimalPlaces: 0,
      ),
      'CNY': CurrencyInfo(
        code: 'CNY',
        name: 'Chinese Yuan',
        nameAr: 'يوان صيني',
        symbolEn: '¥',
        symbolAr: '¥',
        exchangeRate: 7.15,
        flagEmoji: '🇨🇳',
        decimalPlaces: 2,
      ),
      'TRY': CurrencyInfo(
        code: 'TRY',
        name: 'Turkish Lira',
        nameAr: 'ليرة تركية',
        symbolEn: '₺',
        symbolAr: '₺',
        exchangeRate: 34.0,
        flagEmoji: '🇹🇷',
        decimalPlaces: 2,
      ),
      'INR': CurrencyInfo(
        code: 'INR',
        name: 'Indian Rupee',
        nameAr: 'روبية هندية',
        symbolEn: '₹',
        symbolAr: '₹',
        exchangeRate: 83.5,
        flagEmoji: '🇮🇳',
        decimalPlaces: 2,
      ),
      'BRL': CurrencyInfo(
        code: 'BRL',
        name: 'Brazilian Real',
        nameAr: 'ريال برازيلي',
        symbolEn: 'R\$',
        symbolAr: 'R\$',
        exchangeRate: 5.50,
        flagEmoji: '🇧🇷',
        decimalPlaces: 2,
      ),
      'RUB': CurrencyInfo(
        code: 'RUB',
        name: 'Russian Ruble',
        nameAr: 'روبل روسي',
        symbolEn: '₽',
        symbolAr: '₽',
        exchangeRate: 92.0,
        flagEmoji: '🇷🇺',
        decimalPlaces: 2,
      ),
      'KRW': CurrencyInfo(
        code: 'KRW',
        name: 'South Korean Won',
        nameAr: 'وون كوري',
        symbolEn: '₩',
        symbolAr: '₩',
        exchangeRate: 1350.0,
        flagEmoji: '🇰🇷',
        decimalPlaces: 0,
      ),
      'MYR': CurrencyInfo(
        code: 'MYR',
        name: 'Malaysian Ringgit',
        nameAr: 'رينغيت ماليزي',
        symbolEn: 'RM',
        symbolAr: 'RM',
        exchangeRate: 4.30,
        flagEmoji: '🇲🇾',
        decimalPlaces: 2,
      ),
      'IDR': CurrencyInfo(
        code: 'IDR',
        name: 'Indonesian Rupiah',
        nameAr: 'روبية إندونيسية',
        symbolEn: 'Rp',
        symbolAr: 'Rp',
        exchangeRate: 15300.0,
        flagEmoji: '🇮🇩',
        decimalPlaces: 0,
      ),
      'SEK': CurrencyInfo(
        code: 'SEK',
        name: 'Swedish Krona',
        nameAr: 'كرونة سويدية',
        symbolEn: 'kr',
        symbolAr: 'kr',
        exchangeRate: 10.3,
        flagEmoji: '🇸🇪',
        decimalPlaces: 2,
      ),
      'NOK': CurrencyInfo(
        code: 'NOK',
        name: 'Norwegian Krone',
        nameAr: 'كرونة نرويجية',
        symbolEn: 'kr',
        symbolAr: 'kr',
        exchangeRate: 10.6,
        flagEmoji: '🇳🇴',
        decimalPlaces: 2,
      ),

      // Arab & Middle East Currencies
      'EGP': CurrencyInfo(
        code: 'EGP',
        name: 'Egyptian Pound',
        nameAr: 'جنيه مصري',
        symbolEn: 'E£',
        symbolAr: 'ج.م',
        exchangeRate: 51.50,
        flagEmoji: '🇪🇬',
        decimalPlaces: 0,
      ),
      'SAR': CurrencyInfo(
        code: 'SAR',
        name: 'Saudi Riyal',
        nameAr: 'ريال سعودي',
        symbolEn: 'SR',
        symbolAr: 'ر.س',
        exchangeRate: 3.75,
        flagEmoji: '🇸🇦',
        decimalPlaces: 2,
      ),
      'AED': CurrencyInfo(
        code: 'AED',
        name: 'UAE Dirham',
        nameAr: 'درهم إماراتي',
        symbolEn: 'AED',
        symbolAr: 'د.إ',
        exchangeRate: 3.67,
        flagEmoji: '🇦🇪',
        decimalPlaces: 2,
      ),
      'KWD': CurrencyInfo(
        code: 'KWD',
        name: 'Kuwaiti Dinar',
        nameAr: 'دينار كويتي',
        symbolEn: 'KD',
        symbolAr: 'د.ك',
        exchangeRate: 0.31,
        flagEmoji: '🇰🇼',
        decimalPlaces: 3,
      ),
      'QAR': CurrencyInfo(
        code: 'QAR',
        name: 'Qatari Riyal',
        nameAr: 'ريال قطري',
        symbolEn: 'QR',
        symbolAr: 'ر.ق',
        exchangeRate: 3.64,
        flagEmoji: '🇶🇦',
        decimalPlaces: 2,
      ),
      'BHD': CurrencyInfo(
        code: 'BHD',
        name: 'Bahraini Dinar',
        nameAr: 'دينار بحريني',
        symbolEn: 'BD',
        symbolAr: 'د.ب',
        exchangeRate: 0.38,
        flagEmoji: '🇧🇭',
        decimalPlaces: 3,
      ),
      'OMR': CurrencyInfo(
        code: 'OMR',
        name: 'Omani Rial',
        nameAr: 'ريال عماني',
        symbolEn: 'OMR',
        symbolAr: 'ر.ع',
        exchangeRate: 0.38,
        flagEmoji: '🇴🇲',
        decimalPlaces: 3,
      ),
      'JOD': CurrencyInfo(
        code: 'JOD',
        name: 'Jordanian Dinar',
        nameAr: 'دينار أردني',
        symbolEn: 'JD',
        symbolAr: 'د.أ',
        exchangeRate: 0.71,
        flagEmoji: '🇯🇴',
        decimalPlaces: 2,
      ),
      'MAD': CurrencyInfo(
        code: 'MAD',
        name: 'Moroccan Dirham',
        nameAr: 'درهم مغربي',
        symbolEn: 'MAD',
        symbolAr: 'د.م',
        exchangeRate: 9.80,
        flagEmoji: '🇲🇦',
        decimalPlaces: 2,
      ),
      'DZD': CurrencyInfo(
        code: 'DZD',
        name: 'Algerian Dinar',
        nameAr: 'دينار جزائري',
        symbolEn: 'DZD',
        symbolAr: 'د.ج',
        exchangeRate: 133.0,
        flagEmoji: '🇩🇿',
        decimalPlaces: 0,
      ),
      'TND': CurrencyInfo(
        code: 'TND',
        name: 'Tunisian Dinar',
        nameAr: 'دينار تونسي',
        symbolEn: 'TND',
        symbolAr: 'د.ت',
        exchangeRate: 3.08,
        flagEmoji: '🇹🇳',
        decimalPlaces: 2,
      ),
      'LYD': CurrencyInfo(
        code: 'LYD',
        name: 'Libyan Dinar',
        nameAr: 'دينار ليبي',
        symbolEn: 'LYD',
        symbolAr: 'د.ل',
        exchangeRate: 4.80,
        flagEmoji: '🇱🇾',
        decimalPlaces: 2,
      ),
      'IQD': CurrencyInfo(
        code: 'IQD',
        name: 'Iraqi Dinar',
        nameAr: 'دينار عراقي',
        symbolEn: 'IQD',
        symbolAr: 'د.ع',
        exchangeRate: 1310.0,
        flagEmoji: '🇮🇶',
        decimalPlaces: 0,
      ),
      'LBP': CurrencyInfo(
        code: 'LBP',
        name: 'Lebanese Pound',
        nameAr: 'ليرة لبنانية',
        symbolEn: 'LBP',
        symbolAr: 'ل.ل',
        exchangeRate: 89500.0,
        flagEmoji: '🇱🇧',
        decimalPlaces: 0,
      ),
      'SDG': CurrencyInfo(
        code: 'SDG',
        name: 'Sudanese Pound',
        nameAr: 'جنيه سوداني',
        symbolEn: 'SDG',
        symbolAr: 'ج.س',
        exchangeRate: 600.0,
        flagEmoji: '🇸🇩',
        decimalPlaces: 0,
      ),
    };
  }
}
