class CurrencyInfo {
  final String code;
  final String name;
  final String nameAr;
  final String symbolEn;
  final String symbolAr;
  double exchangeRate;
  final String flagEmoji;
  final int decimalPlaces;
  bool isLive;
  DateTime? lastSyncTime;

  CurrencyInfo({
    required this.code,
    required this.name,
    required this.nameAr,
    required this.symbolEn,
    required this.symbolAr,
    this.exchangeRate = 1.0,
    required this.flagEmoji,
    this.decimalPlaces = 2,
    this.isLive = true,
    this.lastSyncTime,
  });

  String getSymbol(bool isArabic) => isArabic ? symbolAr : symbolEn;
  String getDisplayName(bool isArabic) => isArabic ? nameAr : name;

  bool get isArabCurrency {
    const arabCodes = {
      'EGP',
      'SAR',
      'AED',
      'KWD',
      'QAR',
      'BHD',
      'OMR',
      'JOD',
      'MAD',
      'DZD',
      'TND',
      'LYD',
      'IQD',
      'LBP',
      'SDG',
    };
    return arabCodes.contains(code.toUpperCase());
  }

  CurrencyInfo copyWith({
    String? code,
    String? name,
    String? nameAr,
    String? symbolEn,
    String? symbolAr,
    double? exchangeRate,
    String? flagEmoji,
    int? decimalPlaces,
    bool? isLive,
    DateTime? lastSyncTime,
  }) {
    return CurrencyInfo(
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      symbolEn: symbolEn ?? this.symbolEn,
      symbolAr: symbolAr ?? this.symbolAr,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      isLive: isLive ?? this.isLive,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'nameAr': nameAr,
    'symbolEn': symbolEn,
    'symbolAr': symbolAr,
    'exchangeRate': exchangeRate,
    'flagEmoji': flagEmoji,
    'decimalPlaces': decimalPlaces,
    'isLive': isLive,
    'lastSyncTime': lastSyncTime?.toIso8601String(),
  };

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      code: json['code'] as String? ?? 'USD',
      name: json['name'] as String? ?? 'US Dollar',
      nameAr: json['nameAr'] as String? ?? 'دولار أمريكي',
      symbolEn: json['symbolEn'] as String? ?? '\$',
      symbolAr: json['symbolAr'] as String? ?? '\$',
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble() ?? 1.0,
      flagEmoji: json['flagEmoji'] as String? ?? '🇺🇸',
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
      isLive: json['isLive'] as bool? ?? false,
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.tryParse(json['lastSyncTime'] as String)
          : null,
    );
  }
}
