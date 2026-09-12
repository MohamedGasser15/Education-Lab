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
  String? get review => comment;

  String get formattedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  factory CourseRatingModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    final rawDate =
        json['createdAt'] ??
        json['CreatedAt'] ??
        json['createdDate'] ??
        json['CreatedDate'] ??
        json['date'] ??
        json['Date'];
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate.toString());
      } catch (_) {}
    }

    final double parsedRating =
        double.tryParse(
          json['value']?.toString() ??
              json['Value']?.toString() ??
              json['rating']?.toString() ??
              json['Rating']?.toString() ??
              json['score']?.toString() ??
              json['Score']?.toString() ??
              '5.0',
        ) ??
        5.0;

    return CourseRatingModel(
      id:
          int.tryParse(
            json['id']?.toString() ?? json['Id']?.toString() ?? '0',
          ) ??
          0,
      courseId:
          int.tryParse(
            json['courseId']?.toString() ?? json['CourseId']?.toString() ?? '0',
          ) ??
          0,
      userId: json['userId']?.toString() ?? json['UserId']?.toString() ?? '',
      userName:
          json['userName']?.toString() ??
          json['UserName']?.toString() ??
          json['studentName']?.toString() ??
          json['StudentName']?.toString() ??
          json['userFullName']?.toString() ??
          'طالب EduLab',
      userAvatarUrl:
          json['userProfileImage']?.toString() ??
          json['UserProfileImage']?.toString() ??
          json['userAvatarUrl']?.toString() ??
          json['UserAvatarUrl']?.toString() ??
          json['profileImageUrl']?.toString() ??
          json['ProfileImageUrl']?.toString(),
      rating: parsedRating,
      comment:
          json['comment']?.toString() ??
          json['Comment']?.toString() ??
          json['review']?.toString() ??
          json['Review']?.toString(),
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
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.fiveStarCount = 0,
    this.fourStarCount = 0,
    this.threeStarCount = 0,
    this.twoStarCount = 0,
    this.oneStarCount = 0,
  });

  double get fiveStarRatio =>
      totalRatings > 0 ? (fiveStarCount / totalRatings) : 0.0;
  double get fourStarRatio =>
      totalRatings > 0 ? (fourStarCount / totalRatings) : 0.0;
  double get threeStarRatio =>
      totalRatings > 0 ? (threeStarCount / totalRatings) : 0.0;
  double get twoStarRatio =>
      totalRatings > 0 ? (twoStarCount / totalRatings) : 0.0;
  double get oneStarRatio =>
      totalRatings > 0 ? (oneStarCount / totalRatings) : 0.0;

  factory CourseRatingSummaryModel.fromJson(Map<String, dynamic> json) {
    final dist =
        json['ratingDistribution'] ??
        json['RatingDistribution'] ??
        json['distribution'] ??
        json['Distribution'];
    int c5 =
        int.tryParse(
          json['fiveStarCount']?.toString() ??
              json['FiveStarCount']?.toString() ??
              '0',
        ) ??
        0;
    int c4 =
        int.tryParse(
          json['fourStarCount']?.toString() ??
              json['FourStarCount']?.toString() ??
              '0',
        ) ??
        0;
    int c3 =
        int.tryParse(
          json['threeStarCount']?.toString() ??
              json['ThreeStarCount']?.toString() ??
              '0',
        ) ??
        0;
    int c2 =
        int.tryParse(
          json['twoStarCount']?.toString() ??
              json['TwoStarCount']?.toString() ??
              '0',
        ) ??
        0;
    int c1 =
        int.tryParse(
          json['oneStarCount']?.toString() ??
              json['OneStarCount']?.toString() ??
              '0',
        ) ??
        0;

    if (dist is Map) {
      c5 =
          int.tryParse(dist['5']?.toString() ?? dist[5]?.toString() ?? '$c5') ??
          c5;
      c4 =
          int.tryParse(dist['4']?.toString() ?? dist[4]?.toString() ?? '$c4') ??
          c4;
      c3 =
          int.tryParse(dist['3']?.toString() ?? dist[3]?.toString() ?? '$c3') ??
          c3;
      c2 =
          int.tryParse(dist['2']?.toString() ?? dist[2]?.toString() ?? '$c2') ??
          c2;
      c1 =
          int.tryParse(dist['1']?.toString() ?? dist[1]?.toString() ?? '$c1') ??
          c1;
    }

    int sumDist = c5 + c4 + c3 + c2 + c1;
    final total =
        int.tryParse(
          json['totalRatings']?.toString() ??
              json['TotalRatings']?.toString() ??
              '0',
        ) ??
        sumDist;
    final avg =
        double.tryParse(
          json['averageRating']?.toString() ??
              json['AverageRating']?.toString() ??
              '0.0',
        ) ??
        0.0;

    if (total > 0 && sumDist == 0 && avg > 0) {
      // Estimate star distribution proportionally based on actual averageRating
      if (avg >= 4.5) {
        c5 = (total * 0.75).round();
        c4 = (total * 0.18).round();
        c3 = (total * 0.05).round();
        c2 = (total * 0.01).round();
        c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
      } else if (avg >= 4.0) {
        c5 = (total * 0.50).round();
        c4 = (total * 0.35).round();
        c3 = (total * 0.10).round();
        c2 = (total * 0.03).round();
        c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
      } else if (avg >= 3.0) {
        c5 = (total * 0.15).round();
        c4 = (total * 0.35).round();
        c3 = (total * 0.35).round();
        c2 = (total * 0.10).round();
        c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
      } else {
        c5 = 0;
        c4 = (total * 0.10).round();
        c3 = (total * 0.25).round();
        c2 = (total * 0.40).round();
        c1 = (total - (c4 + c3 + c2)).clamp(0, total);
      }
      sumDist = c5 + c4 + c3 + c2 + c1;
    }

    return CourseRatingSummaryModel(
      averageRating: avg,
      totalRatings: sumDist > 0 ? sumDist : (total > 0 ? total : 0),
      fiveStarCount: c5,
      fourStarCount: c4,
      threeStarCount: c3,
      twoStarCount: c2,
      oneStarCount: c1,
    );
  }

  factory CourseRatingSummaryModel.fromRatingsList(
    List<CourseRatingModel> ratings, {
    double? fallbackAvg,
    int? fallbackTotal,
  }) {
    if (ratings.isEmpty) {
      final total = fallbackTotal ?? 0;
      final avg = fallbackAvg ?? 0.0;
      if (total > 0 && avg > 0) {
        int c5 = 0, c4 = 0, c3 = 0, c2 = 0, c1 = 0;
        if (avg >= 4.5) {
          c5 = (total * 0.75).round();
          c4 = (total * 0.18).round();
          c3 = (total * 0.05).round();
          c2 = (total * 0.01).round();
          c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
        } else if (avg >= 4.0) {
          c5 = (total * 0.50).round();
          c4 = (total * 0.35).round();
          c3 = (total * 0.10).round();
          c2 = (total * 0.03).round();
          c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
        } else if (avg >= 3.0) {
          c5 = (total * 0.15).round();
          c4 = (total * 0.35).round();
          c3 = (total * 0.35).round();
          c2 = (total * 0.10).round();
          c1 = (total - (c5 + c4 + c3 + c2)).clamp(0, total);
        } else {
          c5 = 0;
          c4 = (total * 0.10).round();
          c3 = (total * 0.25).round();
          c2 = (total * 0.40).round();
          c1 = (total - (c4 + c3 + c2)).clamp(0, total);
        }
        return CourseRatingSummaryModel(
          averageRating: avg,
          totalRatings: total,
          fiveStarCount: c5,
          fourStarCount: c4,
          threeStarCount: c3,
          twoStarCount: c2,
          oneStarCount: c1,
        );
      }
      return const CourseRatingSummaryModel();
    }

    int c5 = 0, c4 = 0, c3 = 0, c2 = 0, c1 = 0;
    double sum = 0.0;

    for (final r in ratings) {
      sum += r.rating;
      final rounded = r.rating.round();
      if (rounded >= 5) {
        c5++;
      } else if (rounded == 4) {
        c4++;
      } else if (rounded == 3) {
        c3++;
      } else if (rounded == 2) {
        c2++;
      } else {
        c1++;
      }
    }

    final computedTotal = ratings.length;
    final computedAvg = computedTotal > 0
        ? (sum / computedTotal)
        : (fallbackAvg ?? 0.0);

    return CourseRatingSummaryModel(
      averageRating: computedAvg > 0 ? computedAvg : (fallbackAvg ?? 0.0),
      totalRatings: computedTotal,
      fiveStarCount: c5,
      fourStarCount: c4,
      threeStarCount: c3,
      twoStarCount: c2,
      oneStarCount: c1,
    );
  }
}
