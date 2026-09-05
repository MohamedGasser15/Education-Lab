import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class HomeApiService {
  final ApiClient _client;

  HomeApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Retrieves top categories or all categories
  Future<Result<List<HomeCategoryDTO>>> getCategories({int count = 10}) async {
    try {
      // 1. Try top categories first as MVC does
      final topResult = await _client.getSafe('Category/top?count=$count');
      if (topResult is Success<dynamic>) {
        final list = _parseCategoryList(topResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} categories from Category/top');
          return Success(list);
        }
      }

      // 2. Fallback to all categories
      final allResult = await _client.getSafe('Category');
      if (allResult is Success<dynamic>) {
        final list = _parseCategoryList(allResult.data);
        debugPrint('[HomeApiService] Retrieved ${list.length} categories from Category');
        return Success(list);
      } else if (allResult is Failure<dynamic>) {
        debugPrint('[HomeApiService] Category endpoint failed: ${allResult.message}');
        return Failure(allResult.message);
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getCategories error: $e');
      return Failure('فشل جلب التصنيفات: $e');
    }
  }

  /// Retrieves all approved learner courses (using LearnerCourse endpoint)
  Future<Result<List<HomeCourseDTO>>> getAllCourses({List<int>? categoryIds}) async {
    try {
      final ids = (categoryIds != null && categoryIds.isNotEmpty)
          ? categoryIds
          : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

      // 1. Primary: LearnerCourse/approved/by-categories (Approved learner courses only)
      final queryParams = ids.map((id) => 'categoryIds=$id').join('&');
      final url = 'LearnerCourse/approved/by-categories?$queryParams&countPerCategory=15';
      final byCatResult = await _client.getSafe(url);
      if (byCatResult is Success<dynamic>) {
        final list = _parseCourseList(byCatResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} approved learner courses from LearnerCourse/approved/by-categories');
          return Success(list);
        }
      }

      // 2. Fallback: LearnerCourse/approved/by-category for each category
      final List<HomeCourseDTO> fallbackCourses = [];
      for (final catId in ids) {
        final catResult = await _client.getSafe('LearnerCourse/approved/by-category/$catId?count=10');
        if (catResult is Success<dynamic>) {
          fallbackCourses.addAll(_parseCourseList(catResult.data));
        }
      }

      if (fallbackCourses.isNotEmpty) {
        final Map<int, HomeCourseDTO> uniqueMap = {};
        for (final c in fallbackCourses) {
          uniqueMap[c.id] = c;
        }
        debugPrint('[HomeApiService] Retrieved ${uniqueMap.length} unique approved learner courses from individual category endpoints');
        return Success(uniqueMap.values.toList());
      }

      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getAllCourses error: $e');
      return Failure('فشل جلب الدورات: $e');
    }
  }

  /// Retrieves approved courses by category IDs (matching MVC LearnerCourse)
  Future<Result<List<HomeCourseDTO>>> getApprovedCoursesByCategories(
    List<int> categoryIds, {
    int countPerCategory = 10,
  }) async {
    if (categoryIds.isEmpty) return const Success([]);

    try {
      final url = 'LearnerCourse/approved/by-categories?${categoryIds.map((id) => 'categoryIds=$id').join('&')}&countPerCategory=$countPerCategory';
      final result = await _client.getSafe(url);
      if (result is Success<dynamic>) {
        return Success(_parseCourseList(result.data));
      } else if (result is Failure<dynamic>) {
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب دورات التصنيفات: $e');
    }
  }

  /// Retrieves approved courses for a single category
  Future<Result<List<HomeCourseDTO>>> getApprovedCoursesByCategory(
    int categoryId, {
    int count = 10,
  }) async {
    try {
      final result = await _client.getSafe('LearnerCourse/approved/by-category/$categoryId?count=$count');
      if (result is Success<dynamic>) {
        return Success(_parseCourseList(result.data));
      } else if (result is Failure<dynamic>) {
        return Failure(result.message);
      }
      return const Success([]);
    } catch (e) {
      return Failure('فشل جلب دورات التصنيف: $e');
    }
  }

  /// Retrieves all instructors (matching MVC TopInstructorsViewComponent / InstructorService)
  Future<Result<List<HomeInstructorDTO>>> getInstructors() async {
    try {
      // 1. Try Top Instructors first (as MVC Home TopInstructorsViewComponent does)
      final topResult = await _client.getSafe('Instructor/top/4');
      if (topResult is Success<dynamic>) {
        final list = _parseInstructorList(topResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} instructors from Instructor/top/4');
          return Success(list);
        }
      }

      // 2. Fallback to Instructor
      final allResult = await _client.getSafe('Instructor');
      if (allResult is Success<dynamic>) {
        final list = _parseInstructorList(allResult.data);
        debugPrint('[HomeApiService] Retrieved ${list.length} instructors from Instructor');
        return Success(list);
      } else if (allResult is Failure<dynamic>) {
        return Failure(allResult.message);
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getInstructors error: $e');
      return Failure('فشل جلب بيانات المدربين: $e');
    }
  }

  /// Retrieves site statistics
  Future<Result<HomeStatsDTO>> getPublicStats() async {
    try {
      final result = await _client.getSafe(ApiConstants.publicStats);
      if (result is Success<dynamic>) {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(HomeStatsDTO.fromJson(data));
        }
      }
      return const Success(HomeStatsDTO());
    } catch (e) {
      return const Success(HomeStatsDTO());
    }
  }

  // --- Helpers for parsing ---

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

  List<HomeCategoryDTO> _parseCategoryList(dynamic rawData) {
    if (rawData == null) return [];
    List<dynamic> items = [];
    if (rawData is List) {
      items = rawData;
    } else if (rawData is Map<String, dynamic>) {
      if (rawData['data'] is List) {
        items = rawData['data'] as List;
      } else if (rawData['categories'] is List) {
        items = rawData['categories'] as List;
      } else if (rawData['items'] is List) {
        items = rawData['items'] as List;
      }
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => HomeCategoryDTO.fromJson(json))
        .toList();
  }

  List<HomeInstructorDTO> _parseInstructorList(dynamic rawData) {
    if (rawData == null) return [];
    List<dynamic> items = [];
    if (rawData is List) {
      items = rawData;
    } else if (rawData is Map<String, dynamic>) {
      if (rawData['instructors'] is List) {
        items = rawData['instructors'] as List;
      } else if (rawData['data'] is List) {
        items = rawData['data'] as List;
      } else if (rawData['items'] is List) {
        items = rawData['items'] as List;
      }
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => HomeInstructorDTO.fromJson(json))
        .toList();
  }
}
