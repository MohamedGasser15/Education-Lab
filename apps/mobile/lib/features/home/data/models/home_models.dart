import 'package:flutter/material.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';

class HomeCourseDTO {
  final int id;
  final String title;
  final String arabicTitle;
  final String? description;
  final String instructorName;
  final String? instructorAvatarUrl;
  final double rating;
  final int reviewsCount;
  final double price;
  final double? originalPrice;
  final String? categoryName;
  final String? categoryEnglishName;
  final int? categoryId;
  final bool isBestseller;
  final bool isFeatured;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String? duration;
  final String? thumbnailUrl;
  final IconData icon;
  final List<Color> gradient;
  final DateTime? createdAt;

  const HomeCourseDTO({
    required this.id,
    required this.title,
    required this.arabicTitle,
    this.description,
    required this.instructorName,
    this.instructorAvatarUrl,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.price = 0.0,
    this.originalPrice,
    this.categoryName,
    this.categoryEnglishName,
    this.categoryId,
    this.isBestseller = false,
    this.isFeatured = false,
    this.badgeText = 'الأعلى تقييماً',
    this.badgeColor = const Color(0xFFEFF4FF),
    this.badgeTextColor = const Color(0xFF1D61E7),
    this.duration,
    this.thumbnailUrl,
    this.icon = Icons.school_rounded,
    this.gradient = const [Color(0xFF1D61E7), Color(0xFF2563EB)],
    this.createdAt,
  });

  String getLocalizedTitle(BuildContext context) {
    if (context.isArabic) {
      return arabicTitle.isNotEmpty ? arabicTitle : title;
    }
    return title.isNotEmpty ? title : arabicTitle;
  }

  String getLocalizedCategory(BuildContext context) {
    if (context.isArabic) {
      return (categoryName != null && categoryName!.isNotEmpty)
          ? categoryName!
          : (categoryEnglishName ?? '');
    } else {
      return (categoryEnglishName != null && categoryEnglishName!.isNotEmpty)
          ? categoryEnglishName!
          : (categoryName ?? '');
    }
  }

  factory HomeCourseDTO.fromJson(Map<String, dynamic> json) {
    final int id = int.tryParse(json['id']?.toString() ?? '') ??
        int.tryParse(json['courseId']?.toString() ?? '') ??
        int.tryParse(json['course_Id']?.toString() ?? '') ??
        0;

    final String title = json['title']?.toString() ??
        json['name']?.toString() ??
        json['courseTitle']?.toString() ??
        'دورة تعليمية';

    final String arabicTitle = json['arabicTitle']?.toString() ??
        json['titleArabic']?.toString() ??
        title;

    final String? description = json['shortDescription']?.toString() ??
        json['description']?.toString() ??
        json['summary']?.toString();

    final String instructor = json['instructorName']?.toString() ??
        json['instructor']?['fullName']?.toString() ??
        json['instructor']?['name']?.toString() ??
        'م. مدرب معتمد';

    final String? rawInstructorImg = json['instructorProfileImageUrl']?.toString() ??
        json['profileImageUrl']?.toString() ??
        json['instructorAvatarUrl']?.toString() ??
        json['instructor']?['profileImageUrl']?.toString();

    final double rating = (json['averageRating'] as num?)?.toDouble() ??
        (json['rating'] as num?)?.toDouble() ??
        double.tryParse(json['averageRating']?.toString() ?? '') ??
        double.tryParse(json['rating']?.toString() ?? '') ??
        4.8;

    final int reviewsCount = (json['totalRatings'] as num?)?.toInt() ??
        (json['reviewsCount'] as num?)?.toInt() ??
        (json['enrollmentCount'] as num?)?.toInt() ??
        int.tryParse(json['totalRatings']?.toString() ?? '') ??
        120;

    final double price = (json['price'] as num?)?.toDouble() ??
        double.tryParse(json['price']?.toString() ?? '') ??
        0.0;

    final double? discount = (json['discount'] as num?)?.toDouble() ??
        double.tryParse(json['discount']?.toString() ?? '');

    double? origPrice;
    if (json['originalPrice'] != null) {
      origPrice = (json['originalPrice'] as num?)?.toDouble() ??
          double.tryParse(json['originalPrice']?.toString() ?? '');
    } else if (discount != null && discount > 0) {
      origPrice = price > 0 ? (price / (1 - discount / 100)) : null;
    }

    final String? category = json['category_Name']?.toString() ??
        json['categoryName']?.toString() ??
        json['category']?['name']?.toString();

    final String? categoryEn = json['category_EnglishName']?.toString() ??
        json['categoryEnglishName']?.toString() ??
        json['category']?['englishName']?.toString();

    final int? catId = (json['category_Id'] as num?)?.toInt() ??
        (json['categoryId'] as num?)?.toInt() ??
        int.tryParse(json['categoryId']?.toString() ?? '') ??
        (json['category']?['id'] as num?)?.toInt();

    final bool isFeatured = json['isFeatured'] == true || rating >= 4.8;
    final bool isBest = json['isBestseller'] == true || (rating >= 4.7 && reviewsCount > 30);

    final String? rawThumb = json['thumbnailUrl']?.toString() ??
        json['thumbnail']?.toString() ??
        json['imageUrl']?.toString() ??
        json['image']?.toString();

    final int? durMinutes = (json['duration'] as num?)?.toInt() ??
        int.tryParse(json['duration']?.toString() ?? '');

    final String duration = durMinutes != null && durMinutes > 0
        ? '${(durMinutes / 60).toStringAsFixed(1)} ساعة'
        : (json['totalDuration']?.toString() ?? '10 ساعات');

    DateTime? created;
    if (json['createdAt'] != null) {
      created = DateTime.tryParse(json['createdAt'].toString());
    } else if (json['createdDate'] != null) {
      created = DateTime.tryParse(json['createdDate'].toString());
    }

    final List<List<Color>> paletteGradients = [
      [const Color(0xFF1D61E7), const Color(0xFF2563EB)],
      [const Color(0xFF0F172A), const Color(0xFF1E293B)],
      [const Color(0xFF134BB8), const Color(0xFF1D61E7)],
      [const Color(0xFF064E3B), const Color(0xFF065F46)],
      [const Color(0xFF075985), const Color(0xFF0284C7)],
      [const Color(0xFF7C3AED), const Color(0xFF9333EA)],
    ];
    final gradient = paletteGradients[id.abs() % paletteGradients.length];

    final List<IconData> paletteIcons = [
      Icons.code_rounded,
      Icons.brush_rounded,
      Icons.cloud_done_rounded,
      Icons.shield_rounded,
      Icons.campaign_rounded,
      Icons.auto_awesome_rounded,
    ];
    final icon = paletteIcons[id.abs() % paletteIcons.length];

    final String badge = isFeatured
        ? 'الأعلى تقييماً'
        : (isBest ? 'الأعلى مبيعاً' : 'مميز');
    final Color badgeBg = isFeatured
        ? const Color(0xFFEFF4FF)
        : (isBest ? const Color(0xFFFEF3C7) : const Color(0xFFECFDF5));
    final Color badgeTextCol = isFeatured
        ? const Color(0xFF1D61E7)
        : (isBest ? const Color(0xFF92400E) : const Color(0xFF065F46));

    return HomeCourseDTO(
      id: id,
      title: title,
      arabicTitle: arabicTitle,
      description: description,
      instructorName: instructor,
      instructorAvatarUrl: ApiConstants.formatImageUrl(rawInstructorImg),
      rating: rating,
      reviewsCount: reviewsCount,
      price: price,
      originalPrice: origPrice,
      categoryName: category,
      categoryEnglishName: categoryEn,
      categoryId: catId,
      isBestseller: isBest,
      isFeatured: isFeatured,
      badgeText: badge,
      badgeColor: badgeBg,
      badgeTextColor: badgeTextCol,
      duration: duration,
      thumbnailUrl: ApiConstants.formatImageUrl(rawThumb),
      icon: icon,
      gradient: gradient,
      createdAt: created,
    );
  }

  Map<String, dynamic> toUiMap([BuildContext? context]) {
    final String resolvedTitle;
    final String resolvedBadge;
    final String resolvedPrice;
    final String resolvedDuration;
    final String resolvedInstructor;

    if (context != null) {
      final isArabic = context.isArabic;
      resolvedTitle = isArabic
          ? (arabicTitle.isNotEmpty ? arabicTitle : title)
          : (title.isNotEmpty ? title : arabicTitle);

      resolvedBadge = isFeatured
          ? context.loc.badgeTopRated
          : (isBestseller ? context.loc.badgeBestseller : context.loc.badgeFeatured);

      resolvedPrice = price == 0
          ? context.loc.courseFree
          : '\$${price.toStringAsFixed(2)}';

      resolvedDuration = duration ?? context.loc.hoursCountText('10');

      resolvedInstructor = instructorName.isNotEmpty
          ? instructorName
          : context.loc.certifiedInstructor;
    } else {
      resolvedTitle = arabicTitle.isNotEmpty ? arabicTitle : title;
      resolvedBadge = isFeatured ? 'الأعلى تقييماً' : (isBestseller ? 'الأعلى مبيعاً' : 'مميز');
      resolvedPrice = price == 0 ? 'مجاناً' : '\$${price.toStringAsFixed(2)}';
      resolvedDuration = duration ?? '10 ساعات';
      resolvedInstructor = instructorName.isNotEmpty ? instructorName : 'مدرب معتمد';
    }

    final resolvedOriginalPrice = (originalPrice != null && originalPrice! > price)
        ? '\$${originalPrice!.toStringAsFixed(2)}'
        : null;

    return {
      'id': id.toString(),
      'courseId': id,
      'title': resolvedTitle,
      'arabicTitle': arabicTitle.isNotEmpty ? arabicTitle : title,
      'instructor': resolvedInstructor,
      'instructorAvatarUrl': instructorAvatarUrl,
      'rating': rating,
      'reviews': reviewsCount.toString(),
      'price': resolvedPrice,
      'originalPrice': resolvedOriginalPrice,
      'isBestseller': isBestseller,
      'isFeatured': isFeatured,
      'badgeText': resolvedBadge,
      'badgeColor': badgeColor,
      'badgeTextColor': badgeTextColor,
      'duration': resolvedDuration,
      'thumbnailUrl': thumbnailUrl,
      'icon': icon,
      'gradient': gradient,
      'accentColor': gradient.first,
    };
  }
}

class HomeCategoryDTO {
  final int id;
  final String nameAr;
  final String nameEn;
  final String? description;
  final String? iconName;
  final IconData icon;
  final Color color;
  final int coursesCount;

  const HomeCategoryDTO({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.description,
    this.iconName,
    this.icon = Icons.category_rounded,
    this.color = const Color(0xFF1D61E7),
    this.coursesCount = 0,
  });

  String get name => nameAr.isNotEmpty ? nameAr : nameEn;

  /// Returns the category name localized based on current application language:
  /// - Arabic (`nameAr`) if locale is `ar`
  /// - English (`nameEn`) for any other locale
  String getLocalizedName(BuildContext context) {
    if (context.isArabic) {
      return nameAr.isNotEmpty ? nameAr : (nameEn.isNotEmpty ? nameEn : context.loc.categoryWord);
    } else {
      return nameEn.isNotEmpty ? nameEn : (nameAr.isNotEmpty ? nameAr : context.loc.categoryWord);
    }
  }

  factory HomeCategoryDTO.fromJson(Map<String, dynamic> json) {
    final int id = int.tryParse(json['category_Id']?.toString() ?? '') ??
        int.tryParse(json['categoryId']?.toString() ?? '') ??
        int.tryParse(json['id']?.toString() ?? '') ??
        0;

    final String nameAr = json['category_Name']?.toString() ??
        json['categoryName']?.toString() ??
        json['name']?.toString() ??
        json['title']?.toString() ??
        '';

    final String nameEn = json['category_EnglishName']?.toString() ??
        json['categoryEnglishName']?.toString() ??
        json['englishName']?.toString() ??
        json['nameEn']?.toString() ??
        '';

    final String? description = json['description']?.toString() ??
        json['subtitle']?.toString();

    final int count = (json['coursesCount'] as num?)?.toInt() ??
        (json['courseCount'] as num?)?.toInt() ??
        (json['totalCourses'] as num?)?.toInt() ??
        int.tryParse(json['coursesCount']?.toString() ?? '') ??
        0;

    final List<Color> colors = [
      const Color(0xFF1D61E7),
      const Color(0xFF7C3AED),
      const Color(0xFFDB2777),
      const Color(0xFFD97706),
      const Color(0xFF059669),
      const Color(0xFF0284C7),
      const Color(0xFF4F46E5),
      const Color(0xFFE11D48),
    ];
    final color = colors[id.abs() % colors.length];

    final List<IconData> icons = [
      Icons.code_rounded,
      Icons.psychology_rounded,
      Icons.palette_rounded,
      Icons.business_center_rounded,
      Icons.shield_rounded,
      Icons.campaign_rounded,
      Icons.cloud_done_rounded,
      Icons.analytics_rounded,
    ];
    final icon = icons[id.abs() % icons.length];

    return HomeCategoryDTO(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      description: description,
      iconName: json['icon']?.toString(),
      icon: icon,
      color: color,
      coursesCount: count,
    );
  }
}

class HomeInstructorDTO {
  final String id;
  final String name;
  final String headline;
  final String? profileImageUrl;
  final double rating;
  final int totalStudents;
  final int coursesCount;
  final bool isTopRated;

  const HomeInstructorDTO({
    required this.id,
    required this.name,
    required this.headline,
    this.profileImageUrl,
    this.rating = 4.8,
    this.totalStudents = 100,
    this.coursesCount = 1,
    this.isTopRated = false,
  });

  String getLocalizedHeadline(BuildContext context) {
    if (headline.isEmpty ||
        headline == 'خبير ومدرب معتمد' ||
        headline == 'مدرب محترف' ||
        headline == 'مدرب معتمد') {
      return context.loc.expertCertifiedInstructor;
    }
    return headline;
  }

  factory HomeInstructorDTO.fromJson(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ??
        json['instructorId']?.toString() ??
        '';

    final String name = json['fullName']?.toString() ??
        json['name']?.toString() ??
        json['userName']?.toString() ??
        '';

    final String headline = json['headline']?.toString() ??
        json['jobTitle']?.toString() ??
        json['instructorTitle']?.toString() ??
        json['specialization']?.toString() ??
        '';

    final String? rawImg = json['profileImageUrl']?.toString() ??
        json['avatarUrl']?.toString() ??
        json['image']?.toString();

    final double rating = (json['rating'] as num?)?.toDouble() ??
        (json['averageRating'] as num?)?.toDouble() ??
        double.tryParse(json['rating']?.toString() ?? '') ??
        4.8;

    final int students = (json['totalStudents'] as num?)?.toInt() ??
        (json['studentsCount'] as num?)?.toInt() ??
        int.tryParse(json['totalStudents']?.toString() ?? '') ??
        150;

    final int courses = (json['coursesCount'] as num?)?.toInt() ??
        (json['totalCourses'] as num?)?.toInt() ??
        int.tryParse(json['coursesCount']?.toString() ?? '') ??
        1;

    return HomeInstructorDTO(
      id: id,
      name: name.isNotEmpty ? name : 'مدرب المنصة',
      headline: headline,
      profileImageUrl: ApiConstants.formatImageUrl(rawImg),
      rating: rating,
      totalStudents: students,
      coursesCount: courses,
      isTopRated: rating >= 4.85 || students > 500,
    );
  }
}

class HomeStatsDTO {
  final int totalStudents;
  final int totalCourses;
  final int totalInstructors;
  final double satisfactionRate;

  const HomeStatsDTO({
    this.totalStudents = 0,
    this.totalCourses = 0,
    this.totalInstructors = 0,
    this.satisfactionRate = 98.5,
  });

  factory HomeStatsDTO.fromJson(Map<String, dynamic> json) {
    final students = (json['studentsCount'] as num?)?.toInt() ??
        (json['totalStudents'] as num?)?.toInt() ??
        int.tryParse(json['studentsCount']?.toString() ?? '') ??
        0;

    final courses = (json['coursesCount'] as num?)?.toInt() ??
        (json['totalCourses'] as num?)?.toInt() ??
        int.tryParse(json['coursesCount']?.toString() ?? '') ??
        0;

    final instructors = (json['instructorsCount'] as num?)?.toInt() ??
        (json['totalInstructors'] as num?)?.toInt() ??
        int.tryParse(json['instructorsCount']?.toString() ?? '') ??
        0;

    final satisfaction = (json['satisfactionPercent'] as num?)?.toDouble() ??
        (json['satisfactionRate'] as num?)?.toDouble() ??
        double.tryParse(json['satisfactionPercent']?.toString() ?? '') ??
        98.5;

    return HomeStatsDTO(
      totalStudents: students,
      totalCourses: courses,
      totalInstructors: instructors,
      satisfactionRate: satisfaction,
    );
  }
}
