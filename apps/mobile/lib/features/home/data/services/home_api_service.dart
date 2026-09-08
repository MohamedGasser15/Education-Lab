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
      final topResult = await _client.getSafe(ApiConstants.topCategoriesPath(count));
      if (topResult is Success<dynamic>) {
        final list = _parseCategoryList(topResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} categories from ${ApiConstants.categoryTop}');
          return Success(list);
        }
      }

      // 2. Fallback to all categories
      final allResult = await _client.getSafe(ApiConstants.category);
      if (allResult is Success<dynamic>) {
        final list = _parseCategoryList(allResult.data);
        debugPrint('[HomeApiService] Retrieved ${list.length} categories from ${ApiConstants.category}');
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
      final url = '${ApiConstants.learnerCourseApprovedByCategories}?$queryParams&countPerCategory=15';
      final byCatResult = await _client.getSafe(url);
      if (byCatResult is Success<dynamic>) {
        final list = _parseCourseList(byCatResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} approved learner courses from ${ApiConstants.learnerCourseApprovedByCategories}');
          return Success(list);
        }
      }

      // 2. Fallback: LearnerCourse/approved/by-category for each category
      final List<HomeCourseDTO> fallbackCourses = [];
      for (final catId in ids) {
        final catResult = await _client.getSafe('${ApiConstants.categoryCoursesPath(catId)}?count=10');
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
      final url = '${ApiConstants.learnerCourseApprovedByCategories}?${categoryIds.map((id) => 'categoryIds=$id').join('&')}&countPerCategory=$countPerCategory';
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
      final result = await _client.getSafe('${ApiConstants.categoryCoursesPath(categoryId)}?count=$count');
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

  /// Retrieves top-rated approved courses (featured) from LearnerCourse/featured
  Future<Result<List<HomeCourseDTO>>> getFeaturedCourses({int count = 8}) async {
    try {
      final result = await _client.getSafe('${ApiConstants.learnerCourseFeatured}?count=$count');
      if (result is Success<dynamic>) {
        final list = _parseCourseList(result.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} featured courses from ${ApiConstants.learnerCourseFeatured}');
          return Success(list);
        }
      } else if (result is Failure<dynamic>) {
        debugPrint('[HomeApiService] ${ApiConstants.learnerCourseFeatured} failed: ${result.message}');
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getFeaturedCourses error: $e');
      return Failure('فشل جلب الدورات المميزة: $e');
    }
  }

  /// Retrieves newest approved courses from LearnerCourse/new
  Future<Result<List<HomeCourseDTO>>> getNewCourses({int count = 8}) async {
    try {
      final result = await _client.getSafe('${ApiConstants.learnerCourseNew}?count=$count');
      if (result is Success<dynamic>) {
        final list = _parseCourseList(result.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} new courses from ${ApiConstants.learnerCourseNew}');
          return Success(list);
        }
      } else if (result is Failure<dynamic>) {
        debugPrint('[HomeApiService] ${ApiConstants.learnerCourseNew} failed: ${result.message}');
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getNewCourses error: $e');
      return Failure('فشل جلب الدورات الجديدة: $e');
    }
  }

  /// Retrieves recommended approved courses for the user from LearnerCourse/recommended
  Future<Result<List<HomeCourseDTO>>> getRecommendedCourses({int count = 12}) async {
    try {
      final result = await _client.getSafe('${ApiConstants.learnerCourseRecommended}?count=$count');
      if (result is Success<dynamic>) {
        final list = _parseCourseList(result.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} recommended courses from ${ApiConstants.learnerCourseRecommended}');
          return Success(list);
        }
      } else if (result is Failure<dynamic>) {
        debugPrint('[HomeApiService] ${ApiConstants.learnerCourseRecommended} failed: ${result.message}');
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getRecommendedCourses error: $e');
      return Failure('فشل جلب الدورات المقترحة: $e');
    }
  }

  /// Retrieves top-rated instructors for the home page carousel
  Future<Result<List<HomeInstructorDTO>>> getTopInstructors({int count = 4}) async {
    try {
      final topResult = await _client.getSafe(ApiConstants.topInstructorsPath(count));
      if (topResult is Success<dynamic>) {
        final list = _parseInstructorList(topResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} top instructors from ${ApiConstants.instructorTop}');
          return Success(list);
        }
      }

      // Fallback to all instructors taking count
      final allResult = await getAllInstructors();
      if (allResult is Success<List<HomeInstructorDTO>>) {
        return Success(allResult.data.take(count).toList());
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getTopInstructors error: $e');
      return Failure('فشل جلب أفضل المدربين: $e');
    }
  }

  /// Retrieves ALL instructors from the system (matching MVC InstructorsController Index)
  Future<Result<List<HomeInstructorDTO>>> getAllInstructors() async {
    try {
      // 1. Primary: GET api/Instructor (returns InstructorListDTO with all instructors)
      final allResult = await _client.getSafe(ApiConstants.instructor);
      if (allResult is Success<dynamic>) {
        final list = _parseInstructorList(allResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} all instructors from ${ApiConstants.instructor}');
          return Success(list);
        }
      }

      // 2. Fallback: Try top instructors with high count (50)
      final topResult = await _client.getSafe(ApiConstants.topInstructorsPath(50));
      if (topResult is Success<dynamic>) {
        final list = _parseInstructorList(topResult.data);
        if (list.isNotEmpty) {
          debugPrint('[HomeApiService] Retrieved ${list.length} instructors from ${ApiConstants.instructorTop} (fallback)');
          return Success(list);
        }
      } else if (allResult is Failure<dynamic>) {
        return Failure(allResult.message);
      }
      return const Success([]);
    } catch (e) {
      debugPrint('[HomeApiService] getAllInstructors error: $e');
      return Failure('فشل جلب جميع المدربين: $e');
    }
  }

  /// Retrieves instructors (count ? top : all)
  Future<Result<List<HomeInstructorDTO>>> getInstructors({int? count}) async {
    if (count != null && count > 0) {
      return getTopInstructors(count: count);
    }
    return getAllInstructors();
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
