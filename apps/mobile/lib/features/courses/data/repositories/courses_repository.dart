import 'dart:convert';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class CoursesRepository {
  final ApiClient _apiClient;

  CoursesRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Fetch full course details by ID
  Future<Result<CourseDetailsModel>> getCourseDetails(int courseId) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.courseDetailsPath(courseId),
      );

      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseDetailsModel.fromJson(jsonMap));
      }

      return const Failure('تعذر جلب تفاصيل الدورة');
    } catch (e) {
      return Failure('حدث خطأ أثناء تحميل بيانات الدورة: $e');
    }
  }

  /// Fetch student ratings and reviews for a course
  Future<Result<List<CourseRatingModel>>> getCourseRatings(
    int courseId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.ratingsCoursePath(courseId),
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      if (data != null) {
        final List<dynamic> list = data is String
            ? jsonDecode(data)
            : (data is List ? data : (data['items'] ?? data['data'] ?? []));

        final ratings = list
            .map(
              (item) =>
                  CourseRatingModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return Success(ratings);
      }

      return const Success([]);
    } catch (e) {
      return const Success([]);
    }
  }

  /// Fetch rating statistics summary
  Future<Result<CourseRatingSummaryModel>> getCourseRatingSummary(
    int courseId,
  ) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.ratingsSummaryPath(courseId),
      );

      if (data != null) {
        final Map<String, dynamic> jsonMap = data is String
            ? jsonDecode(data)
            : Map<String, dynamic>.from(data);
        return Success(CourseRatingSummaryModel.fromJson(jsonMap));
      }

      return const Success(CourseRatingSummaryModel());
    } catch (e) {
      return const Success(CourseRatingSummaryModel());
    }
  }

  /// Fetch related courses in the same category
  Future<Result<List<HomeCourseDTO>>> getRelatedCourses(
    int categoryId, {
    int count = 6,
  }) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.categoryCoursesPath(categoryId),
        queryParameters: {'count': count},
      );

      if (data != null) {
        final List<dynamic> list = data is String
            ? jsonDecode(data)
            : (data is List ? data : []);

        final courses = list
            .map(
              (item) => HomeCourseDTO.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return Success(courses);
      }

      return const Success([]);
    } catch (e) {
      return const Success([]);
    }
  }

  /// Fetch top-rated approved courses (featured)
  Future<Result<List<HomeCourseDTO>>> getFeaturedCourses({
    int count = 8,
  }) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.learnerCourseFeatured,
        queryParameters: {'count': count},
      );

      if (data != null) {
        final List<dynamic> list = data is String
            ? jsonDecode(data)
            : (data is List ? data : (data['items'] ?? data['data'] ?? []));

        final courses = list
            .map(
              (item) => HomeCourseDTO.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return Success(courses);
      }

      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب الدورات المميزة: $e');
    }
  }

  /// Fetch newest approved courses
  Future<Result<List<HomeCourseDTO>>> getNewCourses({int count = 8}) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.learnerCourseNew,
        queryParameters: {'count': count},
      );

      if (data != null) {
        final List<dynamic> list = data is String
            ? jsonDecode(data)
            : (data is List ? data : (data['items'] ?? data['data'] ?? []));

        final courses = list
            .map(
              (item) => HomeCourseDTO.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return Success(courses);
      }

      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب الدورات الجديدة: $e');
    }
  }

  /// Fetch recommended courses for the current user
  Future<Result<List<HomeCourseDTO>>> getRecommendedCourses({
    int count = 12,
  }) async {
    try {
      final data = await _apiClient.get(
        ApiConstants.learnerCourseRecommended,
        queryParameters: {'count': count},
      );

      if (data != null) {
        final List<dynamic> list = data is String
            ? jsonDecode(data)
            : (data is List ? data : (data['items'] ?? data['data'] ?? []));

        final courses = list
            .map(
              (item) => HomeCourseDTO.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return Success(courses);
      }

      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب الدورات المقترحة: $e');
    }
  }
}
