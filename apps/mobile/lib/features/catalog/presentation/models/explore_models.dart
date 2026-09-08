import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/utils/app_date_utils.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class FilterChipItem {
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const FilterChipItem({
    required this.label,
    this.icon,
    this.iconColor,
  });
}

class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final String? arabicTitle;
  final String? englishTitle;
  final String? arabicSubtitle;
  final String? englishSubtitle;
  final IconData icon;
  final Color color;
  final String coursesCount;
  final String? englishTag;
  final int? rawCount;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.arabicTitle,
    this.englishTitle,
    this.arabicSubtitle,
    this.englishSubtitle,
    required this.icon,
    required this.color,
    required this.coursesCount,
    this.englishTag,
    this.rawCount,
  });

  /// Returns the category title localized:
  /// - Arabic title when locale is Arabic
  /// - English title for any other language
  String getLocalizedTitle(BuildContext context) {
    switch (id) {
      case '1':
      case 'dev':
        return context.loc.catDevTitle;
      case '2':
      case 'web':
        return context.loc.catWebTitle;
      case '3':
      case 'mobile':
        return context.loc.catMobileTitle;
      case '10':
      case 'ai':
        return context.loc.catAiTitle;
      case '7':
      case 'data':
        return context.loc.catDataTitle;
      case '31':
      case 'design':
        return context.loc.catDesignTitle;
      case '13':
      case 'security':
        return context.loc.catSecurityTitle;
      case '15':
      case 'cloud':
        return context.loc.catCloudTitle;
      case '16':
      case 'business':
        return context.loc.catBusinessTitle;
      case '21':
      case 'marketing':
        return context.loc.catMarketingTitle;
    }

    if (context.isArabic) {
      if (arabicTitle != null && arabicTitle!.isNotEmpty) return arabicTitle!;
      return title;
    } else {
      if (englishTitle != null && englishTitle!.isNotEmpty) return englishTitle!;
      return subtitle.isNotEmpty ? subtitle : title;
    }
  }

  /// Returns the category subtitle / description localized:
  /// - Arabic description when locale is Arabic
  /// - English description for any other language
  String getLocalizedSubtitle(BuildContext context) {
    switch (id) {
      case '1':
      case 'dev':
        return context.loc.catDevSubtitle;
      case '2':
      case 'web':
        return context.loc.catWebSubtitle;
      case '3':
      case 'mobile':
        return context.loc.catMobileSubtitle;
      case '10':
      case 'ai':
        return context.loc.catAiSubtitle;
      case '7':
      case 'data':
        return context.loc.catDataSubtitle;
      case '31':
      case 'design':
        return context.loc.catDesignSubtitle;
      case '13':
      case 'security':
        return context.loc.catSecuritySubtitle;
      case '15':
      case 'cloud':
        return context.loc.catCloudSubtitle;
      case '16':
      case 'business':
        return context.loc.catBusinessSubtitle;
      case '21':
      case 'marketing':
        return context.loc.catMarketingSubtitle;
    }

    if (context.isArabic) {
      if (arabicSubtitle != null && arabicSubtitle!.isNotEmpty) {
        return arabicSubtitle!;
      }
      if (_hasArabic(subtitle)) return subtitle;
      if (_hasArabic(title)) return title;
      return arabicTitle ?? title;
    } else {
      if (englishSubtitle != null && englishSubtitle!.isNotEmpty) {
        return englishSubtitle!;
      }
      if (!_hasArabic(subtitle) && subtitle.isNotEmpty) return subtitle;
      if (englishTitle != null && englishTitle!.isNotEmpty) return englishTitle!;
      return subtitle;
    }
  }

  static bool _hasArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  /// Returns the tag/count localized using context.loc across all 20 languages
  String getLocalizedTag(BuildContext context) {
    final trimmed = coursesCount.trim();
    if (trimmed == 'الأعلى طلباً' || trimmed.toLowerCase() == 'highest demand') {
      return context.loc.catTagHighestDemand;
    }
    if (trimmed == 'الأكثر شعبية' || trimmed.toLowerCase() == 'most popular' || trimmed.toLowerCase() == 'bestseller') {
      return context.loc.catTagMostPopular;
    }
    if (trimmed == 'شائع ومطلوب' || trimmed.toLowerCase() == 'trending') {
      return context.loc.catTagTrending;
    }
    if (trimmed == 'الأسرع نمواً' || trimmed.toLowerCase() == 'fastest growing') {
      return context.loc.catTagFastestGrowing;
    }
    if (trimmed == 'مطلوب جداً' || trimmed.toLowerCase() == 'high demand') {
      return context.loc.catTagHighDemand;
    }
    if (trimmed == 'الأعلى تقييماً' || trimmed.toLowerCase() == 'top rated') {
      return context.loc.catTagTopRated;
    }
    if (trimmed == 'شديد الأهمية' || trimmed.toLowerCase() == 'essential') {
      return context.loc.catTagEssential;
    }
    if (trimmed == 'مستوى متقدم' || trimmed.toLowerCase() == 'advanced') {
      return context.loc.catTagAdvanced;
    }
    if (trimmed == 'رواد الأعمال' || trimmed.toLowerCase() == 'entrepreneurs') {
      return context.loc.catTagEntrepreneurs;
    }
    if (trimmed == 'نمو المبيعات' || trimmed.toLowerCase() == 'sales growth') {
      return context.loc.catTagSalesGrowth;
    }

    if (context.isArabic) {
      return coursesCount;
    }
    if (englishTag != null && englishTag!.isNotEmpty) {
      return englishTag!;
    }
    if (rawCount != null && rawCount! > 0) {
      return rawCount == 1 ? '1 course' : '$rawCount courses';
    }
    return localizeCategoryTag(coursesCount, isArabic: false);
  }

  static String localizeCategoryTag(String tag, {required bool isArabic}) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return tag;

    if (isArabic) {
      switch (trimmed.toLowerCase()) {
        case 'highest demand':
        case 'most in demand':
          return 'الأعلى طلباً';
        case 'most popular':
        case 'bestseller':
          return 'الأكثر شعبية';
        case 'trending':
        case 'trending & popular':
          return 'شائع ومطلوب';
        case 'fastest growing':
          return 'الأسرع نمواً';
        case 'high demand':
          return 'مطلوب جداً';
        case 'top rated':
          return 'الأعلى تقييماً';
        case 'essential':
        case 'crucial':
          return 'شديد الأهمية';
        case 'advanced':
        case 'advanced level':
          return 'مستوى متقدم';
        case 'entrepreneurs':
          return 'رواد الأعمال';
        case 'sales growth':
          return 'نمو المبيعات';
        default:
          if (trimmed.contains('course')) {
            final numPart = trimmed.replaceAll(RegExp(r'[^0-9+]'), '').trim();
            if (numPart.isNotEmpty) return '$numPart دورة';
          }
          return tag;
      }
    } else {
      switch (trimmed) {
        case 'الأعلى طلباً':
        case 'الاعلى طلبا':
          return 'Highest Demand';
        case 'الأكثر شعبية':
        case 'الاكثر شعبيه':
        case 'الأكثر مبيعاً':
        case 'الأكثر مبيعا':
          return 'Most Popular';
        case 'شائع ومطلوب':
          return 'Trending';
        case 'الأسرع نمواً':
        case 'الاسرع نموا':
          return 'Fastest Growing';
        case 'مطلوب جداً':
        case 'مطلوب جدا':
          return 'High Demand';
        case 'الأعلى تقييماً':
        case 'الاعلى تقييما':
          return 'Top Rated';
        case 'شديد الأهمية':
        case 'شديد الاهمية':
          return 'Essential';
        case 'مستوى متقدم':
          return 'Advanced';
        case 'رواد الأعمال':
        case 'رواد الاعمال':
          return 'Entrepreneurs';
        case 'نمو المبيعات':
          return 'Sales Growth';
        default:
          if (trimmed.contains('دورة') || trimmed.contains('دورات')) {
            final numPart = trimmed.replaceAll(RegExp(r'[^0-9+]'), '').trim();
            if (numPart.isNotEmpty) {
              return numPart == '1' ? '1 course' : '$numPart courses';
            }
            if (trimmed == 'دورة واحدة') return '1 course';
            if (trimmed == 'دورتان') return '2 courses';
            return 'Courses';
          }
          return tag;
      }
    }
  }
}

class CourseItem {
  final String id;
  final int rawId;
  final String title;
  final String arabicTitle;
  final String instructor;
  final double rating;
  final String reviews;
  final String price;
  final String originalPrice;
  final String category;
  final int? categoryId;
  final bool isBestseller;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String duration;
  final int? rawDuration;
  final IconData icon;
  final List<Color> gradient;
  final String? thumbnailUrl;

  const CourseItem({
    required this.id,
    this.rawId = 0,
    required this.title,
    required this.arabicTitle,
    required this.instructor,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.originalPrice,
    required this.category,
    this.categoryId,
    required this.isBestseller,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.duration,
    this.rawDuration,
    required this.icon,
    required this.gradient,
    this.thumbnailUrl,
  });

  factory CourseItem.fromHomeCourse(HomeCourseDTO dto, [BuildContext? context]) {
    final bool isAr = context?.isArabic ?? true;
    final String freeLabel = context != null ? context.loc.explorePriceFree : (isAr ? 'مجاناً' : 'Free');
    final String defaultCat = context != null ? context.loc.exploreGeneralCategory : (isAr ? 'تصنيف عام' : 'General');
    final String defaultDuration = context != null ? context.loc.exploreCompleteCourse : (isAr ? 'دورة متكاملة' : 'Full Course');

    final String formattedPrice = dto.price <= 0 ? freeLabel : '\$${dto.price.toStringAsFixed(2)}';
    final String formattedOrigPrice = (dto.originalPrice != null && dto.originalPrice! > dto.price)
        ? '\$${dto.originalPrice!.toStringAsFixed(2)}'
        : '';

    final String localizedCat = (context != null && context.isArabic)
        ? ((dto.categoryName != null && dto.categoryName!.isNotEmpty)
            ? dto.categoryName!
            : (dto.categoryEnglishName ?? defaultCat))
        : ((dto.categoryEnglishName != null && dto.categoryEnglishName!.isNotEmpty)
            ? dto.categoryEnglishName!
            : (dto.categoryName ?? defaultCat));

    final String localizedDuration = (dto.rawDuration != null && dto.rawDuration! > 0)
        ? AppDateUtils.formatCourseDuration(
            dto.rawDuration,
            locale: isAr ? 'ar' : 'en',
            fallback: defaultDuration,
          )
        : (dto.duration != null && dto.duration!.isNotEmpty
            ? AppDateUtils.localizeDurationString(dto.duration!, isArabic: isAr)
            : defaultDuration);

    final String localizedBadge = context != null
        ? (dto.isFeatured
            ? context.loc.badgeTopRated
            : (dto.isBestseller ? context.loc.badgeBestseller : context.loc.badgeFeatured))
        : (isAr
            ? (dto.isFeatured ? 'الأعلى تقييماً' : (dto.isBestseller ? 'الأعلى مبيعاً' : 'مميز'))
            : (dto.isFeatured ? 'Top Rated' : (dto.isBestseller ? 'Bestseller' : 'Featured')));

    return CourseItem(
      id: dto.id.toString(),
      rawId: dto.id,
      title: dto.title,
      arabicTitle: dto.arabicTitle.isNotEmpty ? dto.arabicTitle : dto.title,
      instructor: dto.instructorName,
      rating: dto.rating,
      reviews: dto.reviewsCount.toString(),
      price: formattedPrice,
      originalPrice: formattedOrigPrice,
      category: localizedCat,
      categoryId: dto.categoryId,
      isBestseller: dto.isBestseller,
      badgeText: localizedBadge,
      badgeColor: dto.badgeColor,
      badgeTextColor: dto.badgeTextColor,
      duration: localizedDuration,
      rawDuration: dto.rawDuration,
      icon: dto.icon,
      gradient: dto.gradient,
      thumbnailUrl: dto.thumbnailUrl,
    );
  }
}

