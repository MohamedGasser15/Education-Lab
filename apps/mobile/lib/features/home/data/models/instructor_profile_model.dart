import 'package:flutter/widgets.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/utils/app_date_utils.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class InstructorProfileModel {
  final String id;
  final String name;
  final String headline;
  final String? profileImageUrl;
  final double rating;
  final int totalStudents;
  final int coursesCount;
  final String about;
  final String? location;
  final List<String> subjects;
  final String? gitHubUrl;
  final String? linkedInUrl;
  final String? twitterUrl;
  final String? facebookUrl;
  final String? websiteUrl;
  final List<HomeCourseDTO> courses;
  final InstructorRatingsOverviewModel? ratingsOverview;

  const InstructorProfileModel({
    required this.id,
    required this.name,
    required this.headline,
    this.profileImageUrl,
    this.rating = 4.8,
    this.totalStudents = 0,
    this.coursesCount = 0,
    this.about = '',
    this.location,
    this.subjects = const [],
    this.gitHubUrl,
    this.linkedInUrl,
    this.twitterUrl,
    this.facebookUrl,
    this.websiteUrl,
    this.courses = const [],
    this.ratingsOverview,
  });

  factory InstructorProfileModel.fromJson(
    Map<String, dynamic> json, {
    List<HomeCourseDTO> courses = const [],
  }) {
    final String id =
        json['id']?.toString() ?? json['instructorId']?.toString() ?? '';

    final String name =
        json['fullName']?.toString() ??
        json['name']?.toString() ??
        json['userName']?.toString() ??
        '';

    final String headline =
        json['title']?.toString() ??
        json['headline']?.toString() ??
        json['jobTitle']?.toString() ??
        json['specialization']?.toString() ??
        '';

    final String? rawImg =
        json['profileImageUrl']?.toString() ??
        json['avatarUrl']?.toString() ??
        json['image']?.toString();

    final double rating =
        (json['rating'] as num?)?.toDouble() ??
        (json['averageRating'] as num?)?.toDouble() ??
        double.tryParse(json['rating']?.toString() ?? '') ??
        4.8;

    final int students =
        (json['totalStudents'] as num?)?.toInt() ??
        (json['studentsCount'] as num?)?.toInt() ??
        int.tryParse(json['totalStudents']?.toString() ?? '') ??
        0;

    final int coursesCount =
        (json['totalCourses'] as num?)?.toInt() ??
        (json['coursesCount'] as num?)?.toInt() ??
        int.tryParse(json['totalCourses']?.toString() ?? '') ??
        int.tryParse(json['coursesCount']?.toString() ?? '') ??
        courses.length;

    final String about =
        json['about']?.toString() ??
        json['bio']?.toString() ??
        json['description']?.toString() ??
        '';

    final String? location = json['location']?.toString();

    List<String> subjects = [];
    if (json['instructorSubjects'] is List) {
      subjects = (json['instructorSubjects'] as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['subjects'] is List) {
      subjects = (json['subjects'] as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return InstructorProfileModel(
      id: id,
      name: name,
      headline: headline,
      profileImageUrl: ApiConstants.formatImageUrl(rawImg),
      rating: rating,
      totalStudents: students,
      coursesCount: coursesCount,
      about: about,
      location: location,
      subjects: subjects,
      gitHubUrl: json['gitHubUrl']?.toString(),
      linkedInUrl: json['linkedInUrl']?.toString(),
      twitterUrl: json['twitterUrl']?.toString(),
      facebookUrl: json['facebookUrl']?.toString(),
      websiteUrl: json['websiteUrl']?.toString(),
      courses: courses,
    );
  }

  factory InstructorProfileModel.fromHomeInstructorDTO(
    HomeInstructorDTO dto, {
    List<HomeCourseDTO> courses = const [],
    String? about,
    List<String>? subjects,
  }) {
    return InstructorProfileModel(
      id: dto.id,
      name: dto.name,
      headline: dto.headline,
      profileImageUrl: dto.profileImageUrl,
      rating: dto.rating,
      totalStudents: dto.totalStudents,
      coursesCount: dto.coursesCount > 0 ? dto.coursesCount : courses.length,
      about: about ?? '',
      subjects: subjects ?? const [],
      courses: courses,
    );
  }

  InstructorProfileModel copyWith({
    String? id,
    String? name,
    String? headline,
    String? profileImageUrl,
    double? rating,
    int? totalStudents,
    int? coursesCount,
    String? about,
    String? location,
    List<String>? subjects,
    String? gitHubUrl,
    String? linkedInUrl,
    String? twitterUrl,
    String? facebookUrl,
    String? websiteUrl,
    List<HomeCourseDTO>? courses,
    InstructorRatingsOverviewModel? ratingsOverview,
  }) {
    return InstructorProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      headline: headline ?? this.headline,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalStudents: totalStudents ?? this.totalStudents,
      coursesCount: coursesCount ?? this.coursesCount,
      about: about ?? this.about,
      location: location ?? this.location,
      subjects: subjects ?? this.subjects,
      gitHubUrl: gitHubUrl ?? this.gitHubUrl,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      courses: courses ?? this.courses,
      ratingsOverview: ratingsOverview ?? this.ratingsOverview,
    );
  }
}

class InstructorRatingsOverviewModel {
  final InstructorRatingsStatsModel stats;
  final List<InstructorRatingCourseModel> courses;
  final List<InstructorReviewItemModel> reviews;

  const InstructorRatingsOverviewModel({
    this.stats = const InstructorRatingsStatsModel(),
    this.courses = const [],
    this.reviews = const [],
  });

  factory InstructorRatingsOverviewModel.fromJson(Map<String, dynamic> json) {
    return InstructorRatingsOverviewModel(
      stats: json['stats'] != null && json['stats'] is Map<String, dynamic>
          ? InstructorRatingsStatsModel.fromJson(
              json['stats'] as Map<String, dynamic>,
            )
          : json['stats'] != null && json['stats'] is Map
          ? InstructorRatingsStatsModel.fromJson(
              Map<String, dynamic>.from(json['stats'] as Map),
            )
          : const InstructorRatingsStatsModel(),
      courses:
          (json['courses'] as List<dynamic>?)
              ?.map(
                (e) => InstructorRatingCourseModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map(
                (e) => InstructorReviewItemModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class InstructorRatingsStatsModel {
  final int totalReviews;
  final double averageRating;
  final int thisMonthReviews;
  final int reviewedCourses;
  final Map<int, int> distribution;

  const InstructorRatingsStatsModel({
    this.totalReviews = 0,
    this.averageRating = 0.0,
    this.thisMonthReviews = 0,
    this.reviewedCourses = 0,
    this.distribution = const {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
  });

  factory InstructorRatingsStatsModel.fromJson(Map<String, dynamic> json) {
    final distMap = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    if (json['distribution'] != null && json['distribution'] is Map) {
      final rawDist = json['distribution'] as Map;
      rawDist.forEach((k, v) {
        final key = int.tryParse(k.toString());
        final val = int.tryParse(v.toString()) ?? 0;
        if (key != null) {
          distMap[key] = val;
        }
      });
    }

    return InstructorRatingsStatsModel(
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      thisMonthReviews: (json['thisMonthReviews'] as num?)?.toInt() ?? 0,
      reviewedCourses: (json['reviewedCourses'] as num?)?.toInt() ?? 0,
      distribution: distMap,
    );
  }
}

class InstructorRatingCourseModel {
  final int courseId;
  final String courseName;

  const InstructorRatingCourseModel({
    required this.courseId,
    required this.courseName,
  });

  factory InstructorRatingCourseModel.fromJson(Map<String, dynamic> json) {
    return InstructorRatingCourseModel(
      courseId: (json['courseId'] as num?)?.toInt() ?? 0,
      courseName: json['courseName']?.toString() ?? '',
    );
  }
}

class InstructorReviewItemModel {
  final int id;
  final int courseId;
  final String courseName;
  final String studentName;
  final String? studentAvatar;
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final String timeAgo;

  const InstructorReviewItemModel({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.studentName,
    this.studentAvatar,
    required this.rating,
    required this.comment,
    this.createdAt,
    required this.timeAgo,
  });

  factory InstructorReviewItemModel.fromJson(Map<String, dynamic> json) {
    final rawAvatar = json['studentAvatar']?.toString();
    String? fullAvatar;
    if (rawAvatar != null && rawAvatar.isNotEmpty) {
      if (rawAvatar.startsWith('http://') || rawAvatar.startsWith('https://')) {
        fullAvatar = rawAvatar;
      } else {
        fullAvatar = '${ApiConstants.baseUrl}/$rawAvatar';
      }
    }

    final rawTimeAgo = json['timeAgo']?.toString() ?? '';
    final parsedCreatedAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;

    final resolvedTimeAgo = formatReviewTimeAgo(parsedCreatedAt, rawTimeAgo);

    return InstructorReviewItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      courseId: (json['courseId'] as num?)?.toInt() ?? 0,
      courseName: json['courseName']?.toString() ?? '',
      studentName: json['studentName']?.toString() ?? '',
      studentAvatar: fullAvatar,
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment']?.toString() ?? '',
      createdAt: parsedCreatedAt,
      timeAgo: resolvedTimeAgo,
    );
  }

  String getLocalizedTimeAgo(BuildContext context) {
    return formatReviewTimeAgo(createdAt, timeAgo, isArabic: context.isArabic);
  }

  static String formatReviewTimeAgo(
    DateTime? date,
    String serverTimeAgo, {
    bool isArabic = true,
  }) {
    if (date == null) {
      return AppDateUtils.localizeRelativeTimeString(
        serverTimeAgo,
        isArabic: isArabic,
      );
    }

    final now = DateTime.now();
    final localDate = date.isUtc ? date.toLocal() : date;

    // Handle future dates (from database seed data or clock drift)
    if (localDate.isAfter(now)) {
      final diff = localDate.difference(now);
      if (diff.inMinutes <= 5) {
        return isArabic ? 'الآن' : 'just now';
      }
      final days = diff.inDays;
      if (days < 1) {
        return isArabic ? 'منذ ساعات قليلة' : 'a few hours ago';
      } else if (days == 1) {
        return isArabic ? 'أمس' : 'yesterday';
      } else if (days == 2) {
        return isArabic ? 'منذ يومين' : '2 days ago';
      } else if (days <= 10) {
        return isArabic ? 'منذ $days أيام' : '$days days ago';
      } else {
        return isArabic ? 'منذ $days يوماً' : '$days days ago';
      }
    }

    return AppDateUtils.relativeTime(localDate, locale: isArabic ? 'ar' : 'en');
  }
}
