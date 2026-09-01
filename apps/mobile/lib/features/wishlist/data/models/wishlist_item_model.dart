import 'package:flutter/widgets.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';

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

  /// Returns the category directly from API:
  /// - Arabic (`categoryName`) if current locale is Arabic (`ar`).
  /// - English (`categoryEnglishName`) if current locale is anything else.
  String getLocalizedCategory(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return categoryName.isNotEmpty ? categoryName : categoryEnglishName;
    } else {
      return categoryEnglishName.isNotEmpty ? categoryEnglishName : categoryName;
    }
  }

  String getLocalizedBadge(BuildContext context) {
    final cat = getLocalizedCategory(context);
    if (cat.isNotEmpty) return cat;
    if (courseDiscount != null && courseDiscount! >= 15) {
      return context.loc.wishlistDiscountBadge(courseDiscount!.round().toString());
    }
    if (averageRating >= 4.8) {
      return context.loc.wishlistTopRatedBadge;
    }
    return context.loc.wishlistFeaturedBadge;
  }

  String get formattedDuration {
    if (duration > 0) {
      final hrs = duration / 60;
      return '${hrs.toStringAsFixed(1)} ساعة';
    }
    return '18.5 ساعة';
  }

  String get formattedLectures {
    if (totalLectures > 0) return '$totalLectures محاضرة';
    return '24 محاضرة';
  }

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final price = (json['coursePrice'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0;
    final discount = (json['courseDiscount'] as num?)?.toDouble() ??
        (json['discount'] as num?)?.toDouble();
    final calcFinal = (json['finalPrice'] as num?)?.toDouble() ??
        (discount != null && discount > 0 ? (price * (1 - discount / 100)) : price);

    final rawThumb = json['thumbnailUrl']?.toString() ??
        json['thumbnail']?.toString() ??
        json['courseThumbnailUrl']?.toString();

    final formattedThumb = ApiConstants.formatImageUrl(rawThumb);

    final dur = json['duration'] as int? ??
        (json['durationHours'] as num?)?.toInt() ??
        (json['totalHours'] != null ? ((json['totalHours'] as num) * 60).toInt() : 0);
    final totalLec = json['totalLectures'] as int? ??
        json['lecturesCount'] as int? ??
        json['lectures'] as int? ??
        0;

    return WishlistItemModel(
      id: json['id'] as int? ?? 0,
      courseId: json['courseId'] as int? ?? json['id'] as int? ?? 0,
      courseTitle: json['courseTitle']?.toString() ?? json['title']?.toString() ?? '',
      courseShortDescription: json['courseShortDescription']?.toString() ??
          json['shortDescription']?.toString() ??
          '',
      coursePrice: price,
      courseDiscount: discount,
      thumbnailUrl: formattedThumb.isNotEmpty ? formattedThumb : null,
      instructorName: json['instructorName']?.toString() ??
          json['instructor']?.toString() ??
          '',
      addedAt: json['addedAt'] != null ? DateTime.tryParse(json['addedAt'].toString()) : null,
      finalPrice: calcFinal,
      averageRating: (json['averageRating'] as num?)?.toDouble() ??
          (json['rating'] as num?)?.toDouble() ??
          4.9,
      totalRatings: json['totalRatings'] as int? ??
          json['reviewsCount'] as int? ??
          0,
      duration: dur,
      totalLectures: totalLec,
      categoryName: json['categoryName']?.toString() ??
          json['category_Name']?.toString() ??
          json['category']?.toString() ??
          '',
      categoryEnglishName: json['categoryEnglishName']?.toString() ??
          json['category_EnglishName']?.toString() ??
          json['categoryEnglish']?.toString() ??
          json['category_english']?.toString() ??
          json['categoryEn']?.toString() ??
          '',
      level: json['level']?.toString() ?? '',
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
