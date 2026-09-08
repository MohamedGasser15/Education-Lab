import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

/// API service for Explore catalog operations.
/// Strictly uses LearnerCourse endpoints from Learner controllers.
class ExploreApiService {
  final ApiClient _client;

  ExploreApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Retrieves approved courses for given category IDs using LearnerCourse
  Future<Result<List<HomeCourseDTO>>> getApprovedCoursesByCategories(
    List<int> categoryIds, {
    int countPerCategory = 25,
  }) async {
    try {
      if (categoryIds.isEmpty) return const Success([]);
      final query = categoryIds.map((id) => 'categoryIds=$id').join('&');
      final url = '${ApiConstants.learnerCourseApprovedByCategories}?$query&countPerCategory=$countPerCategory';

      final result = await _client.getSafe(url);
      if (result is Success<dynamic>) {
        final courses = _parseCourseList(result.data);
        debugPrint('[ExploreApiService] Retrieved ${courses.length} courses from by-categories');
        return Success(courses);
      } else if (result is Failure<dynamic>) {
        debugPrint('[ExploreApiService] by-categories failed: ${result.message}');
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[ExploreApiService] getApprovedCoursesByCategories error: $e');
      return Failure('فشل جلب دورات التصنيفات: $e');
    }
  }

  /// Retrieves approved courses for a specific category using LearnerCourse
  Future<Result<List<HomeCourseDTO>>> getApprovedCoursesByCategory(
    int categoryId, {
    int count = 50,
  }) async {
    try {
      final url = '${ApiConstants.categoryCoursesPath(categoryId)}?count=$count';
      final result = await _client.getSafe(url);
      if (result is Success<dynamic>) {
        final courses = _parseCourseList(result.data);
        debugPrint('[ExploreApiService] Retrieved ${courses.length} courses for category $categoryId');
        return Success(courses);
      } else if (result is Failure<dynamic>) {
        debugPrint('[ExploreApiService] by-category failed: ${result.message}');
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[ExploreApiService] getApprovedCoursesByCategory error: $e');
      return Failure('فشل جلب دورات التصنيف: $e');
    }
  }

  /// Retrieves top-rated featured courses using LearnerCourse/featured
  Future<Result<List<HomeCourseDTO>>> getFeaturedCourses({int count = 25}) async {
    try {
      final url = '${ApiConstants.learnerCourseFeatured}?count=$count';
      final result = await _client.getSafe(url);
      if (result is Success<dynamic>) {
        final courses = _parseCourseList(result.data);
        return Success(courses);
      } else if (result is Failure<dynamic>) {
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب الدورات المميزة: $e');
    }
  }

  /// Retrieves newest courses using LearnerCourse/new
  Future<Result<List<HomeCourseDTO>>> getNewCourses({int count = 25}) async {
    try {
      final url = '${ApiConstants.learnerCourseNew}?count=$count';
      final result = await _client.getSafe(url);
      if (result is Success<dynamic>) {
        final courses = _parseCourseList(result.data);
        return Success(courses);
      } else if (result is Failure<dynamic>) {
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب الدورات الجديدة: $e');
    }
  }

  /// Aggregates all learner courses by querying LearnerCourse endpoints
  /// and combining unique results without any admin or instructor endpoints.
  Future<Result<List<HomeCourseDTO>>> getAllLearnerCourses() async {
    try {
      final Map<int, HomeCourseDTO> uniqueCourses = {};

      // 1. Query by-categories with standard category IDs
      final defaultCategoryIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
      final byCategoriesResult = await getApprovedCoursesByCategories(defaultCategoryIds, countPerCategory: 20);
      if (byCategoriesResult is Success<List<HomeCourseDTO>>) {
        for (final c in byCategoriesResult.data) {
          uniqueCourses[c.id] = c;
        }
      }

      // 2. Query featured courses to supplement
      final featuredResult = await getFeaturedCourses(count: 30);
      if (featuredResult is Success<List<HomeCourseDTO>>) {
        for (final c in featuredResult.data) {
          uniqueCourses[c.id] = c;
        }
      }

      // 3. Query new courses to supplement
      final newResult = await getNewCourses(count: 30);
      if (newResult is Success<List<HomeCourseDTO>>) {
        for (final c in newResult.data) {
          uniqueCourses[c.id] = c;
        }
      }

      final list = uniqueCourses.values.toList();
      debugPrint('[ExploreApiService] Total unique approved learner courses fetched: ${list.length}');
      return Success(list);
    } catch (e) {
      debugPrint('[ExploreApiService] getAllLearnerCourses error: $e');
      return Failure('فشل جلب دورات الاستكشاف: $e');
    }
  }

  List<HomeCourseDTO> _parseCourseList(dynamic rawData) {
    if (rawData == null) return [];
    List<dynamic> items = [];
    if (rawData is List) {
      items = rawData;
    } else if (rawData is Map<String, dynamic>) {
      if (rawData['data'] is List) {
        items = rawData['data'] as List;
      } else if (rawData['courses'] is List) {
        items = rawData['courses'] as List;
      } else if (rawData['items'] is List) {
        items = rawData['items'] as List;
      }
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => HomeCourseDTO.fromJson(json))
        .toList();
  }
}
