import 'package:mobile/core/constants/api_constants.dart';

class CourseRatingModel {
  final int id;
  final int courseId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const CourseRatingModel({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  String get avatarUrl => ApiConstants.formatImageUrl(userAvatarUrl);

  String get formattedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  factory CourseRatingModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null || json['createdDate'] != null) {
      try {
        parsedDate = DateTime.parse((json['createdAt'] ?? json['createdDate']).toString());
      } catch (_) {}
    }

    return CourseRatingModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: int.tryParse(json['courseId']?.toString() ?? '0') ?? 0,
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? json['studentName']?.toString() ?? 'طالب EduLab',
      userAvatarUrl: json['userAvatarUrl']?.toString() ?? json['profileImageUrl']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      comment: json['comment']?.toString() ?? json['review']?.toString(),
      createdAt: parsedDate,
    );
  }
}

class CourseRatingSummaryModel {
  final double averageRating;
  final int totalRatings;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  const CourseRatingSummaryModel({
    this.averageRating = 5.0,
    this.totalRatings = 0,
    this.fiveStarCount = 0,
    this.fourStarCount = 0,
    this.threeStarCount = 0,
    this.twoStarCount = 0,
    this.oneStarCount = 0,
  });

  double get fiveStarRatio => totalRatings > 0 ? (fiveStarCount / totalRatings) : 0.8;
  double get fourStarRatio => totalRatings > 0 ? (fourStarCount / totalRatings) : 0.15;
  double get threeStarRatio => totalRatings > 0 ? (threeStarCount / totalRatings) : 0.05;
  double get twoStarRatio => totalRatings > 0 ? (twoStarCount / totalRatings) : 0.0;
  double get oneStarRatio => totalRatings > 0 ? (oneStarCount / totalRatings) : 0.0;

  factory CourseRatingSummaryModel.fromJson(Map<String, dynamic> json) {
    final dist = json['ratingDistribution'] ?? json['distribution'];
    int c5 = int.tryParse(json['fiveStarCount']?.toString() ?? '0') ?? 0;
    int c4 = int.tryParse(json['fourStarCount']?.toString() ?? '0') ?? 0;
    int c3 = int.tryParse(json['threeStarCount']?.toString() ?? '0') ?? 0;
    int c2 = int.tryParse(json['twoStarCount']?.toString() ?? '0') ?? 0;
    int c1 = int.tryParse(json['oneStarCount']?.toString() ?? '0') ?? 0;

    if (dist is Map) {
      c5 = int.tryParse(dist['5']?.toString() ?? dist[5]?.toString() ?? '$c5') ?? c5;
      c4 = int.tryParse(dist['4']?.toString() ?? dist[4]?.toString() ?? '$c4') ?? c4;
      c3 = int.tryParse(dist['3']?.toString() ?? dist[3]?.toString() ?? '$c3') ?? c3;
      c2 = int.tryParse(dist['2']?.toString() ?? dist[2]?.toString() ?? '$c2') ?? c2;
      c1 = int.tryParse(dist['1']?.toString() ?? dist[1]?.toString() ?? '$c1') ?? c1;
    }

    final total = int.tryParse(json['totalRatings']?.toString() ?? '0') ?? (c5 + c4 + c3 + c2 + c1);

    return CourseRatingSummaryModel(
      averageRating: double.tryParse(json['averageRating']?.toString() ?? '4.8') ?? 4.8,
      totalRatings: total,
      fiveStarCount: c5,
      fourStarCount: c4,
      threeStarCount: c3,
      twoStarCount: c2,
      oneStarCount: c1,
    );
  }
}
