import 'package:flutter/widgets.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/utils/app_date_utils.dart';

class WishlistItemModel {
  final int id;
  final int courseId;
  final String courseTitle;
  final String courseShortDescription;
  final double coursePrice;
  final double? courseDiscount;
  final String? thumbnailUrl;
  final String instructorName;
  final DateTime? addedAt;
  final double finalPrice;
  final double averageRating;
  final int totalRatings;
  final int duration; // in minutes
  final int totalLectures;
  final String categoryName;
  final String categoryEnglishName;
  final String level;

  const WishlistItemModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.courseShortDescription,
    required this.coursePrice,
    this.courseDiscount,
    this.thumbnailUrl,
    required this.instructorName,
    this.addedAt,
    required this.finalPrice,
    this.averageRating = 5.0,
    this.totalRatings = 0,
    this.duration = 0,
    this.totalLectures = 0,
    this.categoryName = '',
    this.categoryEnglishName = '',
    this.level = '',
  });

  bool get hasDiscount =>
      (courseDiscount != null && courseDiscount! > 0) ||
      (coursePrice > 0 && finalPrice < coursePrice);

  int get discountPercentage {
    if (courseDiscount != null &&
        courseDiscount! > 0 &&
        courseDiscount! < 100) {
      return courseDiscount!.round();
    }
    if (coursePrice > 0 && finalPrice < coursePrice) {
      final pct = (((coursePrice - finalPrice) / coursePrice) * 100).round();
      if (pct > 0 && pct <= 100) return pct;
    }
    return 0;
  }

  /// Returns the category directly from API:
  /// - Arabic (`categoryName`) if current locale is Arabic (`ar`).
  /// - English (`categoryEnglishName`) if current locale is anything else.
  String getLocalizedCategory(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return categoryName.isNotEmpty ? categoryName : categoryEnglishName;
    } else {
      return categoryEnglishName.isNotEmpty
          ? categoryEnglishName
          : categoryName;
    }
  }

  String getLocalizedBadge(BuildContext context) {
    final cat = getLocalizedCategory(context);
    if (cat.isNotEmpty) return cat;
    if (discountPercentage >= 15) {
      return context.loc.wishlistDiscountBadge(
        discountPercentage.toString(),
      );
    }
    if (averageRating >= 4.8) {
      return context.loc.wishlistTopRatedBadge;
    }
    return context.loc.wishlistFeaturedBadge;
  }

  String get formattedDuration {
    return AppDateUtils.formatCourseDuration(
      duration,
      fallback: 'دورة متكاملة',
    );
  }

  String getFormattedDuration(BuildContext context) {
    return AppDateUtils.formatCourseDuration(
      duration,
      locale: context.isArabic ? 'ar' : 'en',
      fallback: context.loc.exploreCompleteCourse,
    );
  }

  String get formattedLectures {
    if (totalLectures > 0) return '$totalLectures محاضرة';
    return '24 محاضرة';
  }

  String getFormattedLectures(BuildContext context) {
    final count = totalLectures > 0 ? totalLectures : 24;
    return context.loc.wishlistLecturesCount(count.toString());
  }

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    double price = double.tryParse(
      json['coursePrice']?.toString() ??
      json['CoursePrice']?.toString() ??
      json['price']?.toString() ??
      json['Price']?.toString() ??
      '0',
    ) ?? 0.0;

    final discount = double.tryParse(
      json['courseDiscount']?.toString() ??
      json['CourseDiscount']?.toString() ??
      json['discount']?.toString() ??
      json['Discount']?.toString() ??
      '',
    );

    final rawFinal = double.tryParse(
      json['finalPrice']?.toString() ??
      json['FinalPrice']?.toString() ??
      '',
    );

    double calcFinal = 0.0;
    if (rawFinal != null && rawFinal > price && price > 0) {
      // Swapped/inverted API response: rawFinal is the higher original price
      calcFinal = price;
      price = rawFinal;
    } else if (rawFinal != null && rawFinal > 0 && rawFinal < price) {
      calcFinal = rawFinal;
    } else if (discount != null && discount > 0) {
      if (discount < 100) {
        // Standard discount percentage (e.g. 20 for 20%)
        calcFinal = (price - (price * (discount / 100.0))).clamp(0.0, price);
      } else if (discount < price) {
        calcFinal = discount;
      } else {
        calcFinal = price;
      }
    } else {
      calcFinal = (rawFinal != null && rawFinal > 0) ? rawFinal : price;
    }

    if (calcFinal <= 0 && rawFinal == null && (discount == null || discount <= 0)) {
      calcFinal = price;
    }

    // Safety: ensure price is always the higher (original) price and calcFinal is the current/discounted price
    if (calcFinal > price && price > 0) {
      final temp = price;
      price = calcFinal;
      calcFinal = temp;
    }

    final rawThumb =
        json['thumbnailUrl']?.toString() ??
        json['ThumbnailUrl']?.toString() ??
        json['thumbnail']?.toString() ??
        json['courseThumbnailUrl']?.toString();

    final formattedThumb = ApiConstants.formatImageUrl(rawThumb);

    final dur =
        int.tryParse(json['duration']?.toString() ?? '') ??
        int.tryParse(json['Duration']?.toString() ?? '') ??
        (json['durationHours'] as num?)?.toInt() ??
        (json['totalHours'] != null
            ? ((json['totalHours'] as num) * 60).toInt()
            : 0);
    final totalLec =
        int.tryParse(json['totalLectures']?.toString() ?? '') ??
        int.tryParse(json['TotalLectures']?.toString() ?? '') ??
        int.tryParse(json['lecturesCount']?.toString() ?? '') ??
        int.tryParse(json['lectures']?.toString() ?? '') ??
        0;

    return WishlistItemModel(
      id: int.tryParse(json['id']?.toString() ?? json['Id']?.toString() ?? '') ?? 0,
      courseId: int.tryParse(
            json['courseId']?.toString() ??
            json['CourseId']?.toString() ??
            json['id']?.toString() ??
            json['Id']?.toString() ??
            '',
          ) ??
          0,
      courseTitle:
          json['courseTitle']?.toString() ??
          json['CourseTitle']?.toString() ??
          json['title']?.toString() ??
          json['Title']?.toString() ??
          '',
      courseShortDescription:
          json['courseShortDescription']?.toString() ??
          json['CourseShortDescription']?.toString() ??
          json['shortDescription']?.toString() ??
          json['ShortDescription']?.toString() ??
          '',
      coursePrice: price,
      courseDiscount: discount,
      thumbnailUrl: formattedThumb.isNotEmpty ? formattedThumb : null,
      instructorName:
          json['instructorName']?.toString() ??
          json['InstructorName']?.toString() ??
          json['instructor']?.toString() ??
          json['Instructor']?.toString() ??
          '',
      addedAt: (json['addedAt'] != null || json['AddedAt'] != null)
          ? DateTime.tryParse((json['addedAt'] ?? json['AddedAt']).toString())
          : null,
      finalPrice: calcFinal,
      averageRating:
          double.tryParse(
            json['averageRating']?.toString() ??
            json['AverageRating']?.toString() ??
            json['rating']?.toString() ??
            '',
          ) ??
          4.9,
      totalRatings:
          int.tryParse(
            json['totalRatings']?.toString() ??
            json['TotalRatings']?.toString() ??
            json['reviewsCount']?.toString() ??
            '',
          ) ??
          0,
      duration: dur,
      totalLectures: totalLec,
      categoryName:
          json['categoryName']?.toString() ??
          json['CategoryName']?.toString() ??
          json['category_Name']?.toString() ??
          json['category']?.toString() ??
          '',
      categoryEnglishName:
          json['categoryEnglishName']?.toString() ??
          json['CategoryEnglishName']?.toString() ??
          json['category_EnglishName']?.toString() ??
          json['categoryEnglish']?.toString() ??
          json['category_english']?.toString() ??
          json['categoryEn']?.toString() ??
          '',
      level: json['level']?.toString() ?? json['Level']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'courseShortDescription': courseShortDescription,
    'coursePrice': coursePrice,
    'courseDiscount': courseDiscount,
    'thumbnailUrl': thumbnailUrl,
    'instructorName': instructorName,
    'addedAt': addedAt?.toIso8601String(),
    'finalPrice': finalPrice,
    'averageRating': averageRating,
    'totalRatings': totalRatings,
    'duration': duration,
    'totalLectures': totalLectures,
    'categoryName': categoryName,
    'categoryEnglishName': categoryEnglishName,
    'level': level,
  };
}
