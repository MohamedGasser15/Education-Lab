class CategoryLocalizationHelper {
  /// Returns the localized category name based on the current language:
  /// - Arabic (`arName`) if language is Arabic.
  /// - English (`enName`) if language is anything else.
  static String getCategoryName({
    required String? arName,
    required String? enName,
    required String languageCode,
  }) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');

    final cleanAr = (arName ?? '').trim();
    final cleanEn = (enName ?? '').trim();

    if (isArabic) {
      return cleanAr.isNotEmpty ? cleanAr : cleanEn;
    } else {
      return cleanEn.isNotEmpty ? cleanEn : cleanAr;
    }
  }
}
