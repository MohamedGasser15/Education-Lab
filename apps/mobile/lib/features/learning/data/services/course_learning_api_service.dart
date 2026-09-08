import 'dart:convert';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';

class CourseLearningApiService {
  final ApiClient _apiClient;

  CourseLearningApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 1. Fetch full course details by course ID
  Future<Result<CourseDetailsModel>> getCourseDetails(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.courseDetailsPath(courseId));
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseDetailsModel.fromJson(jsonMap));
      }
      return const Failure('تعذر جلب بيانات الدورة');
    } catch (e) {
      return Failure('خطأ أثناء تحميل الدورة: $e');
    }
  }

  /// 2. Fetch course progress summary
  Future<Result<CourseProgressSummaryModel>> getCourseProgress(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.courseProgressPath(courseId));
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : (data is Map ? Map<String, dynamic>.from(data['data'] ?? data) : {});
        return Success(CourseProgressSummaryModel.fromJson(jsonMap));
      }
      return Success(CourseProgressSummaryModel(courseId: courseId));
    } catch (e) {
      return Success(CourseProgressSummaryModel(courseId: courseId));
    }
  }

  /// 3. Fetch lecture completion statuses dictionary (`Map<int, bool>`)
  Future<Result<Map<int, bool>>> getLectureStatuses(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.lectureStatusesPath(courseId));
      final Map<int, bool> result = {};
      if (data != null) {
        final dynamic source = data is String ? jsonDecode(data) : data;
        final dynamic rawMap = source is Map ? (source['data'] ?? source) : null;
        if (rawMap is Map) {
          rawMap.forEach((key, value) {
            final int? lectureId = int.tryParse(key.toString());
            if (lectureId != null) {
              result[lectureId] = value == true || value.toString().toLowerCase() == 'true';
            }
          });
        }
      }
      return Success(result);
    } catch (e) {
      return const Success({});
    }
  }

  /// 4. Mark lecture as completed
  Future<Result<bool>> markLectureCompleted(int courseId, int lectureId) async {
    try {
      await _apiClient.post(
        ApiConstants.courseProgressMarkCompleted,
        body: {
          'courseId': courseId,
          'CourseId': courseId,
          'lectureId': lectureId,
          'LectureId': lectureId,
          'watchedDuration': 0,
          'totalDuration': 0,
        },
      );
      return const Success(true);
    } catch (e) {
      return Failure('تعذر حفظ تقدم المحاضرة: $e');
    }
  }

  /// 5. Mark lecture as incomplete
  Future<Result<bool>> markLectureIncomplete(int courseId, int lectureId) async {
    try {
      await _apiClient.post(
        ApiConstants.courseProgressMarkIncomplete,
        body: {
          'courseId': courseId,
          'CourseId': courseId,
          'lectureId': lectureId,
          'LectureId': lectureId,
          'watchedDuration': 0,
          'totalDuration': 0,
        },
      );
      return const Success(true);
    } catch (e) {
      return Failure('تعذر تحديث حالة المحاضرة: $e');
    }
  }

  /// 6. Get single lecture completion status
  Future<bool> getLectureStatus(int courseId, int lectureId) async {
    try {
      final data = await _apiClient.get(ApiConstants.lectureStatusPath(lectureId), queryParameters: {
        'courseId': courseId,
      });
      if (data != null) {
        final dynamic jsonMap = data is String ? jsonDecode(data) : data;
        if (jsonMap is Map) {
          return jsonMap['isCompleted'] == true || jsonMap['IsCompleted'] == true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// 7. Fetch lecture resources
  Future<Result<List<LectureResourceModel>>> getLectureResources(int lectureId) async {
    return const Success([]);
  }

  /// 8. Fetch lecture comments & discussion
  Future<Result<List<LectureCommentModel>>> getLectureComments(int lectureId) async {
    try {
      final data = await _apiClient.get(ApiConstants.lectureCommentsPath(lectureId));
      if (data != null) {
        final dynamic listData = data is String ? jsonDecode(data) : data;
        final List<dynamic> list = listData is List ? listData : (listData['data'] ?? []);
        final comments = list
            .whereType<Map>()
            .map((item) => LectureCommentModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        return Success(comments);
      }
      return const Success([]);
    } catch (e) {
      return const Success([]);
    }
  }

  /// 9. Post comment to lecture
  Future<Result<LectureCommentModel>> addComment(int lectureId, String content) async {
    try {
      final data = await _apiClient.post(
        ApiConstants.comments,
        body: {
          'lectureId': lectureId,
          'LectureId': lectureId,
          'content': content,
          'Content': content,
        },
      );
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(LectureCommentModel.fromJson(jsonMap));
      }
      return const Failure('تعذر إضافة التعليق');
    } catch (e) {
      return Failure('خطأ أثناء إضافة التعليق: $e');
    }
  }

  /// 10. Reply to an existing comment
  Future<Result<LectureCommentModel>> replyToComment(int commentId, String content) async {
    try {
      final data = await _apiClient.post(
        ApiConstants.commentRepliesPath(commentId),
        body: {
          'content': content,
          'Content': content,
        },
      );
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(LectureCommentModel.fromJson(jsonMap));
      }
      return const Failure('تعذر إضافة الرد');
    } catch (e) {
      return Failure('خطأ أثناء إضافة الرد: $e');
    }
  }

  /// 11. Delete comment
  Future<Result<bool>> deleteComment(int commentId) async {
    try {
      await _apiClient.delete(ApiConstants.commentItemPath(commentId));
      return const Success(true);
    } catch (e) {
      return Failure('تعذر حذف التعليق: $e');
    }
  }

  /// 12. Check if user can rate course
  Future<Result<bool>> canUserRate(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.ratingsCanRatePath(courseId));
      if (data != null) {
        final dynamic res = data is String ? jsonDecode(data) : data;
        if (res is Map) {
          final canRate = res['canRate'] == true || res['CanRate'] == true || res['eligibleToRate'] == true;
          return Success(canRate);
        }
      }
      return const Success(true);
    } catch (_) {
      return const Success(true);
    }
  }

  /// 13. Get current user's rating for course
  Future<Result<CourseRatingModel?>> getMyRating(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.ratingsMyRatingPath(courseId));
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseRatingModel.fromJson(jsonMap));
      }
      return const Success(null);
    } catch (_) {
      return const Success(null);
    }
  }

  /// 14. Get all ratings for a course
  Future<Result<List<CourseRatingModel>>> getCourseRatings(int courseId, {int page = 1, int pageSize = 30}) async {
    try {
      final data = await _apiClient.get(ApiConstants.ratingsCoursePath(courseId), queryParameters: {
        'page': page,
        'pageSize': pageSize,
      });
      if (data != null) {
        final dynamic listData = data is String ? jsonDecode(data) : data;
        final List<dynamic> list = listData is List ? listData : (listData['data'] ?? []);
        final ratings = list
            .whereType<Map>()
            .map((item) => CourseRatingModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        return Success(ratings);
      }
      return const Success([]);
    } catch (e) {
      return const Success([]);
    }
  }

  /// 15. Get course rating summary (average & distribution)
  Future<Result<CourseRatingSummaryModel>> getCourseRatingSummary(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.ratingsSummaryPath(courseId));
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : (data is Map ? Map<String, dynamic>.from(data['data'] ?? data) : {});
        return Success(CourseRatingSummaryModel.fromJson(jsonMap));
      }
      return const Success(CourseRatingSummaryModel());
    } catch (_) {
      return const Success(CourseRatingSummaryModel());
    }
  }

  /// 16. Add course rating
  Future<Result<CourseRatingModel>> addRating(int courseId, int rating, String review) async {
    try {
      final data = await _apiClient.post(
        ApiConstants.ratings,
        body: {
          'courseId': courseId,
          'CourseId': courseId,
          'rating': rating,
          'Rating': rating,
          'review': review,
          'Review': review,
        },
      );
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseRatingModel.fromJson(jsonMap));
      }
      return const Failure('تعذر حفظ التقييم');
    } catch (e) {
      return Failure('خطأ أثناء حفظ التقييم: $e');
    }
  }

  /// 17. Update course rating
  Future<Result<CourseRatingModel>> updateRating(int ratingId, int rating, String review) async {
    try {
      final data = await _apiClient.put(
        ApiConstants.ratingItemPath(ratingId),
        body: {
          'rating': rating,
          'Rating': rating,
          'review': review,
          'Review': review,
        },
      );
      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseRatingModel.fromJson(jsonMap));
      }
      return const Failure('تعذر تعديل التقييم');
    } catch (e) {
      return Failure('خطأ أثناء تعديل التقييم: $e');
    }
  }

  /// 18. Delete course rating
  Future<Result<bool>> deleteRating(int ratingId) async {
    try {
      await _apiClient.delete(ApiConstants.ratingItemPath(ratingId));
      return const Success(true);
    } catch (e) {
      return Failure('تعذر حذف التقييم: $e');
    }
  }

  /// 19. Get Course Certificate Code
  Future<Result<CertificateModel?>> getCourseCertificate(int courseId) async {
    try {
      final data = await _apiClient.get(ApiConstants.myCertificates);
      if (data != null) {
        final dynamic listData = data is String ? jsonDecode(data) : data;
        final List<dynamic> list = listData is List ? listData : (listData['data'] ?? []);
        for (final item in list) {
          if (item is Map) {
            final cert = CertificateModel.fromJson(Map<String, dynamic>.from(item));
            if (cert.courseId == courseId) {
              return Success(cert);
            }
          }
        }
      }
      return const Success(null);
    } catch (_) {
      return const Success(null);
    }
  }
}
