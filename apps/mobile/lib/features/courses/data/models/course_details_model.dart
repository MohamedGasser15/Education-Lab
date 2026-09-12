import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/utils/app_date_utils.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';

bool _parseBool(dynamic val) {
  if (val == null) return false;
  if (val is bool) return val;
  if (val is num) return val != 0;
  if (val is String) {
    final s = val.trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

List<String> _parseStringList(dynamic raw) {
  if (raw == null) return [];
  if (raw is List) {
    return raw
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  if (raw is String) {
    final str = raw.trim();
    if (str.startsWith('[') && str.endsWith(']')) {
      try {
        final decoded = jsonDecode(str);
        if (decoded is List) {
          return decoded
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
      } catch (_) {}
    }
    return str
        .split(RegExp(r'[,;\n•\-]'))
        .map((e) => e.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  return [];
}

class CourseLectureModel {
  final int id;
  final String title;
  final String? videoUrl;
  final String? articleContent;
  final int? quizId;
  final int sectionId;
  final String contentType;
  final int duration; // in seconds or minutes
  final int order;
  final bool isFreePreview;
  final List<LectureResourceModel> resources;

  const CourseLectureModel({
    required this.id,
    required this.title,
    this.videoUrl,
    this.articleContent,
    this.quizId,
    required this.sectionId,
    this.contentType = 'Video',
    this.duration = 0,
    this.order = 0,
    this.isFreePreview = false,
    this.resources = const [],
  });

  bool get isArticle =>
      contentType.toLowerCase() == 'article' ||
      contentType.toLowerCase() == 'text' ||
      ((articleContent != null && articleContent!.trim().isNotEmpty) &&
          (videoUrl == null || videoUrl!.trim().isEmpty));

  bool get isQuiz => contentType.toLowerCase() == 'quiz' || quizId != null;

  bool get isVideo => !isArticle && !isQuiz;

  String get formattedDuration {
    if (duration <= 0) return isArticle ? '03:00' : '05:00';
    if (duration < 60) {
      return '${duration.toString().padLeft(2, '0')}:00';
    }
    final mins = duration ~/ 60;
    final secs = duration % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  factory CourseLectureModel.fromJson(
    Map<String, dynamic> json, {
    bool inheritFreePreview = false,
  }) {
    final bool explicitFree = _parseBool(
      json['isFreePreview'] ??
          json['IsFreePreview'] ??
          json['freePreview'] ??
          json['FreePreview'] ??
          json['isFree'] ??
          json['IsFree'] ??
          json['isPreview'] ??
          json['IsPreview'] ??
          json['isDemo'] ??
          json['IsDemo'],
    );

    return CourseLectureModel(
      id:
          int.tryParse(
            json['id']?.toString() ?? json['Id']?.toString() ?? '0',
          ) ??
          0,
      title:
          json['title']?.toString() ??
          json['Title']?.toString() ??
          'درس تعليمي',
      videoUrl: ApiConstants.formatImageUrl(
        json['videoUrl']?.toString() ??
            json['VideoUrl']?.toString() ??
            json['video']?.toString() ??
            json['Video']?.toString(),
      ),
      articleContent:
          json['articleContent']?.toString() ??
          json['ArticleContent']?.toString() ??
          json['content']?.toString() ??
          json['Content']?.toString() ??
          json['article']?.toString() ??
          json['Article']?.toString() ??
          json['text']?.toString() ??
          json['Text']?.toString() ??
          json['body']?.toString() ??
          json['Body']?.toString(),
      quizId: int.tryParse(
        json['quizId']?.toString() ?? json['QuizId']?.toString() ?? '',
      ),
      sectionId:
          int.tryParse(
            json['sectionId']?.toString() ??
                json['SectionId']?.toString() ??
                '0',
          ) ??
          0,
      contentType:
          json['contentType']?.toString() ??
          json['ContentType']?.toString() ??
          json['type']?.toString() ??
          json['Type']?.toString() ??
          'Video',
      duration:
          int.tryParse(
            json['duration']?.toString() ?? json['Duration']?.toString() ?? '0',
          ) ??
          0,
      order:
          int.tryParse(
            json['order']?.toString() ?? json['Order']?.toString() ?? '0',
          ) ??
          0,
      isFreePreview: explicitFree || inheritFreePreview,
      resources:
          (json['resources'] as List? ?? json['Resources'] as List? ?? [])
              .whereType<Map>()
              .map(
                (e) =>
                    LectureResourceModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
    );
  }
}

class CourseSectionModel {
  final int id;
  final String title;
  final int order;
  final int courseId;
  final bool isFreePreview;
  final List<CourseLectureModel> lectures;
  bool isExpanded;

  CourseSectionModel({
    required this.id,
    required this.title,
    this.order = 0,
    required this.courseId,
    this.isFreePreview = false,
    this.lectures = const [],
    this.isExpanded = false,
  });

  int get totalDurationMinutes {
    int total = 0;
    for (final l in lectures) {
      total += (l.duration > 0
          ? (l.duration >= 60 ? (l.duration ~/ 60) : l.duration)
          : 5);
    }
    return total;
  }

  String getFormattedDuration(BuildContext context) {
    return AppDateUtils.formatCourseDuration(
      totalDurationMinutes * 60,
      locale: context.isArabic ? 'ar' : 'en',
    );
  }

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    final bool sectionFree = _parseBool(
      json['isFreePreview'] ??
          json['IsFreePreview'] ??
          json['freePreview'] ??
          json['FreePreview'] ??
          json['isFree'] ??
          json['IsFree'],
    );

    final dynamic rawLectures = json['lectures'] ?? json['Lectures'];
    List<CourseLectureModel> lecturesList = [];
    if (rawLectures is List) {
      for (final item in rawLectures) {
        if (item is Map) {
          lecturesList.add(
            CourseLectureModel.fromJson(
              Map<String, dynamic>.from(item),
              inheritFreePreview: sectionFree,
            ),
          );
        }
      }
    }

    return CourseSectionModel(
      id:
          int.tryParse(
            json['id']?.toString() ?? json['Id']?.toString() ?? '0',
          ) ??
          0,
      title:
          json['title']?.toString() ??
          json['Title']?.toString() ??
          'القسم التعليمي',
      order:
          int.tryParse(
            json['order']?.toString() ?? json['Order']?.toString() ?? '0',
          ) ??
          0,
      courseId:
          int.tryParse(
            json['courseId']?.toString() ?? json['CourseId']?.toString() ?? '0',
          ) ??
          0,
      isFreePreview: sectionFree,
      lectures: lecturesList,
    );
  }
}

class CourseDetailsModel {
  final int id;
  final String title;
  final String shortDescription;
  final String description;
  final String status;
  final double price;
  final double? discount;
  final String? rawThumbnailUrl;
  final DateTime? createdAt;
  final String instructorId;
  final String instructorName;
  final String? instructorAbout;
  final String? instructorTitle;
  final List<String> instructorSubjects;
  final String? rawProfileImageUrl;
  final int categoryId;
  final String categoryName;
  final String? categoryEnglishName;
  final String level;
  final String language;
  final int duration; // total in minutes
  final int totalLectures;
  final bool hasCertificate;
  final List<String> requirements;
  final List<String> learnings;
  final String targetAudience;
  final List<CourseSectionModel> sections;
  final double averageRating;
  final int totalRatings;
  final int enrollmentCount;

  const CourseDetailsModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.status,
    required this.price,
    this.discount,
    this.rawThumbnailUrl,
    this.createdAt,
    required this.instructorId,
    required this.instructorName,
    this.instructorAbout,
    this.instructorTitle,
    this.instructorSubjects = const [],
    this.rawProfileImageUrl,
    required this.categoryId,
    required this.categoryName,
    this.categoryEnglishName,
    required this.level,
    required this.language,
    required this.duration,
    required this.totalLectures,
    required this.hasCertificate,
    this.requirements = const [],
    this.learnings = const [],
    required this.targetAudience,
    this.sections = const [],
    this.averageRating = 4.8,
    this.totalRatings = 0,
    this.enrollmentCount = 0,
  });

  bool get hasFreePreview {
    return sections.any(
      (s) => s.isFreePreview || s.lectures.any((l) => l.isFreePreview),
    );
  }

  String get thumbnailUrl => ApiConstants.formatImageUrl(rawThumbnailUrl);
  String get instructorAvatarUrl =>
      ApiConstants.formatImageUrl(rawProfileImageUrl);

  bool get hasDiscount =>
      discount != null && discount! > 0 && discount! < price;
  double get finalPrice => hasDiscount ? (price - discount!) : price;
  int get discountPercent {
    if (!hasDiscount || price <= 0) return 0;
    return (((price - finalPrice) / price) * 100).round();
  }

  String getLocalizedCategory(BuildContext context) {
    if (context.isArabic) {
      return categoryName.isNotEmpty
          ? categoryName
          : (categoryEnglishName ?? '');
    }
    return (categoryEnglishName != null && categoryEnglishName!.isNotEmpty)
        ? categoryEnglishName!
        : categoryName;
  }

  String getFormattedDuration(BuildContext context) {
    final isAr = context.isArabic;
    if (duration <= 0) {
      int calculated = 0;
      for (final s in sections) {
        calculated += s.totalDurationMinutes;
      }
      if (calculated > 0) {
        return AppDateUtils.formatCourseDuration(
          calculated * 60,
          locale: isAr ? 'ar' : 'en',
        );
      }
      return isAr ? 'دورة متكاملة' : 'Full Course';
    }

    return AppDateUtils.formatCourseDuration(
      duration,
      locale: isAr ? 'ar' : 'en',
    );
  }

  int get calculatedTotalLectures {
    if (totalLectures > 0) return totalLectures;
    int count = 0;
    for (final s in sections) {
      count += s.lectures.length;
    }
    return count > 0 ? count : 12;
  }

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawSections = json['sections'] ?? json['Sections'];
    List<CourseSectionModel> sectionsList = [];
    if (rawSections is List) {
      for (final item in rawSections) {
        if (item is Map) {
          sectionsList.add(
            CourseSectionModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    final reqs = _parseStringList(json['requirements'] ?? json['Requirements']);
    final learnings = _parseStringList(json['learnings'] ?? json['Learnings']);
    final subjects = _parseStringList(
      json['instructorSubjects'] ??
          json['InstructorSubjects'] ??
          json['subjects'],
    );

    DateTime? parsedDate;
    final dynamic rawDate = json['createdAt'] ?? json['CreatedAt'];
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate.toString());
      } catch (_) {}
    }

    return CourseDetailsModel(
      id:
          int.tryParse(
            json['id']?.toString() ?? json['Id']?.toString() ?? '0',
          ) ??
          0,
      title:
          json['title']?.toString() ??
          json['Title']?.toString() ??
          json['courseTitle']?.toString() ??
          'دورة تدريبية',
      shortDescription:
          json['shortDescription']?.toString() ??
          json['ShortDescription']?.toString() ??
          json['summary']?.toString() ??
          '',
      description:
          json['description']?.toString() ??
          json['Description']?.toString() ??
          '',
      status:
          json['status']?.toString() ??
          json['Status']?.toString() ??
          'Approved',
      price:
          double.tryParse(
            json['price']?.toString() ?? json['Price']?.toString() ?? '0',
          ) ??
          0.0,
      discount: (json['discount'] ?? json['Discount']) != null
          ? double.tryParse((json['discount'] ?? json['Discount']).toString())
          : null,
      rawThumbnailUrl:
          json['thumbnailUrl']?.toString() ??
          json['ThumbnailUrl']?.toString() ??
          json['imageUrl']?.toString() ??
          json['ImageUrl']?.toString(),
      createdAt: parsedDate,
      instructorId:
          json['instructorId']?.toString() ??
          json['InstructorId']?.toString() ??
          '',
      instructorName:
          json['instructorName']?.toString() ??
          json['InstructorName']?.toString() ??
          json['instructor']?['fullName']?.toString() ??
          'مدرب معتمد',
      instructorAbout:
          json['instructorAbout']?.toString() ??
          json['InstructorAbout']?.toString() ??
          json['instructorBio']?.toString(),
      instructorTitle:
          json['instructorTitle']?.toString() ??
          json['InstructorTitle']?.toString() ??
          'خبير ومدرب معتمد في المجال',
      instructorSubjects: subjects,
      rawProfileImageUrl:
          json['profileImageUrl']?.toString() ??
          json['ProfileImageUrl']?.toString() ??
          json['instructorProfileImageUrl']?.toString(),
      categoryId:
          int.tryParse(
            json['categoryId']?.toString() ??
                json['CategoryId']?.toString() ??
                '0',
          ) ??
          0,
      categoryName:
          json['categoryName']?.toString() ??
          json['CategoryName']?.toString() ??
          '',
      categoryEnglishName:
          json['categoryEnglishName']?.toString() ??
          json['CategoryEnglishName']?.toString(),
      level: json['level']?.toString() ?? json['Level']?.toString() ?? 'مبتدئ',
      language:
          json['language']?.toString() ??
          json['Language']?.toString() ??
          'العربية',
      duration:
          int.tryParse(
            json['duration']?.toString() ?? json['Duration']?.toString() ?? '0',
          ) ??
          0,
      totalLectures:
          int.tryParse(
            json['totalLectures']?.toString() ??
                json['TotalLectures']?.toString() ??
                '0',
          ) ??
          0,
      hasCertificate:
          (json['hasCertificate'] ?? json['HasCertificate']) != false,
      requirements: reqs,
      learnings: learnings,
      targetAudience:
          json['targetAudience']?.toString() ??
          json['TargetAudience']?.toString() ??
          '',
      sections: sectionsList,
      averageRating:
          double.tryParse(
            json['averageRating']?.toString() ??
                json['AverageRating']?.toString() ??
                '4.8',
          ) ??
          4.8,
      totalRatings:
          int.tryParse(
            json['totalRatings']?.toString() ??
                json['TotalRatings']?.toString() ??
                '0',
          ) ??
          0,
      enrollmentCount:
          int.tryParse(
            json['enrollmentCount']?.toString() ??
                json['EnrollmentCount']?.toString() ??
                '0',
          ) ??
          0,
    );
  }
}
