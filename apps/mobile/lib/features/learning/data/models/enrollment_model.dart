import 'package:flutter/widgets.dart';
import 'package:mobile/core/constants/api_constants.dart';

class EnrollmentModel {
  final int id;
  final int courseId;
  final String title;
  final String shortDescription;
  final String description;
  final String status;
  final double price;
  final double? discount;
  final String? thumbnailUrl;
  final DateTime? createdAt;
  final String instructorId;
  final String instructorName;
  final String instructorAbout;
  final String instructorTitle;
  final String? profileImageUrl;
  final int categoryId;
  final String categoryName;
  final String categoryEnglishName;
  final String level;
  final String language;
  final int duration; // in minutes
  final int totalLectures;
  final bool hasCertificate;
  final DateTime? enrolledAt;
  final int progressPercentage;
  final double finalPrice;
  final bool hasDiscount;
  final double averageRating;
  final int totalRatings;
  final bool isDownloaded;

  const EnrollmentModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.shortDescription = '',
    this.description = '',
    this.status = '',
    this.price = 0.0,
    this.discount,
    this.thumbnailUrl,
    this.createdAt,
    this.instructorId = '',
    this.instructorName = '',
    this.instructorAbout = '',
    this.instructorTitle = '',
    this.profileImageUrl,
    this.categoryId = 0,
    this.categoryName = '',
    this.categoryEnglishName = '',
    this.level = '',
    this.language = '',
    this.duration = 0,
    this.totalLectures = 0,
    this.hasCertificate = false,
    this.enrolledAt,
    this.progressPercentage = 0,
    this.finalPrice = 0.0,
    this.hasDiscount = false,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.isDownloaded = false,
  });

  bool get isCompleted => progressPercentage >= 100;
  double get progressRatio => (progressPercentage / 100).clamp(0.0, 1.0);
  int get completedLectures => totalLectures > 0
      ? (totalLectures * progressRatio).round()
      : (progressPercentage > 0 ? (progressRatio * 10).round().clamp(1, 10) : 0);

  double get remainingHours {
    if (isCompleted) return 0.0;
    if (duration > 0) {
      final rem = (duration * (1 - progressRatio)) / 60;
      return rem < 0.1 ? 0.1 : rem;
    }
    return ((1 - progressRatio) * 6.5).clamp(0.5, 20.0);
  }

  String get formattedDuration {
    if (duration > 0) {
      final hrs = duration / 60;
      return '${hrs.toStringAsFixed(1)} ساعة';
    }
    return '4.5 ساعة';
  }

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

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ??
        (json['coursePrice'] as num?)?.toDouble() ??
        0.0;
    final discount = (json['discount'] as num?)?.toDouble() ??
        (json['courseDiscount'] as num?)?.toDouble();
    final finalPrice = (json['finalPrice'] as num?)?.toDouble() ??
        (discount != null && discount > 0 ? (price * (1 - discount / 100)) : price);

    final rawThumb = json['thumbnailUrl']?.toString() ??
        json['thumbnail']?.toString() ??
        json['courseThumbnailUrl']?.toString();
    final formattedThumb = ApiConstants.formatImageUrl(rawThumb);

    final rawProfile = json['profileImageUrl']?.toString() ??
        json['instructorProfileImageUrl']?.toString();
    final formattedProfile = ApiConstants.formatImageUrl(rawProfile);

    final dur = json['duration'] as int? ??
        (json['durationHours'] as num?)?.toInt() ??
        (json['totalHours'] != null ? ((json['totalHours'] as num) * 60).toInt() : 0);
    final totalLec = json['totalLectures'] as int? ??
        json['lecturesCount'] as int? ??
        json['lectures'] as int? ??
        12;

    return EnrollmentModel(
      id: json['id'] as int? ?? 0,
      courseId: json['courseId'] as int? ?? json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? json['courseTitle']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ??
          json['courseShortDescription']?.toString() ??
          '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      price: price,
      discount: discount,
      thumbnailUrl: formattedThumb.isNotEmpty ? formattedThumb : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      instructorId: json['instructorId']?.toString() ?? '',
      instructorName: json['instructorName']?.toString() ??
          json['instructor']?.toString() ??
          '',
      instructorAbout: json['instructorAbout']?.toString() ?? '',
      instructorTitle: json['instructorTitle']?.toString() ?? '',
      profileImageUrl: formattedProfile.isNotEmpty ? formattedProfile : null,
      categoryId: json['categoryId'] as int? ?? 0,
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
      language: json['language']?.toString() ?? '',
      duration: dur,
      totalLectures: totalLec,
      hasCertificate: json['hasCertificate'] as bool? ?? false,
      enrolledAt: json['enrolledAt'] != null ? DateTime.tryParse(json['enrolledAt'].toString()) : null,
      progressPercentage: json['progressPercentage'] as int? ??
          json['progress'] as int? ??
          0,
      finalPrice: finalPrice,
      hasDiscount: json['hasDiscount'] as bool? ?? (discount != null && discount > 0),
      averageRating: (json['averageRating'] as num?)?.toDouble() ??
          (json['rating'] as num?)?.toDouble() ??
          4.9,
      totalRatings: json['totalRatings'] as int? ??
          json['reviewsCount'] as int? ??
          0,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'shortDescription': shortDescription,
        'description': description,
        'status': status,
        'price': price,
        'discount': discount,
        'thumbnailUrl': thumbnailUrl,
        'createdAt': createdAt?.toIso8601String(),
        'instructorId': instructorId,
        'instructorName': instructorName,
        'instructorAbout': instructorAbout,
        'instructorTitle': instructorTitle,
        'profileImageUrl': profileImageUrl,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'categoryEnglishName': categoryEnglishName,
        'level': level,
        'language': language,
        'duration': duration,
        'totalLectures': totalLectures,
        'hasCertificate': hasCertificate,
        'enrolledAt': enrolledAt?.toIso8601String(),
        'progressPercentage': progressPercentage,
        'finalPrice': finalPrice,
        'hasDiscount': hasDiscount,
        'averageRating': averageRating,
        'totalRatings': totalRatings,
        'isDownloaded': isDownloaded,
      };
}
