import 'package:flutter/foundation.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/services/home_api_service.dart';

class HomeBundleData {
  final List<HomeCategoryDTO> categories;
  final List<HomeCourseDTO> allCourses;
  final List<HomeCourseDTO> featuredCourses;
  final List<HomeCourseDTO> bestsellers;
  final List<HomeCourseDTO> recommended;
  final List<HomeCourseDTO> newCourses;
  final List<HomeInstructorDTO> instructors;
  final HomeStatsDTO stats;

  const HomeBundleData({
    required this.categories,
    required this.allCourses,
    required this.featuredCourses,
    required this.bestsellers,
    required this.recommended,
    required this.newCourses,
    required this.instructors,
    required this.stats,
  });
}

class HomeRepository {
  final HomeApiService _service;

  HomeRepository({HomeApiService? service}) : _service = service ?? HomeApiService();

  Future<Result<HomeBundleData>> getHomeBundleData() async {
    try {
      // 1. Fetch categories, instructors, stats, and dedicated endpoint courses concurrently
      final results = await Future.wait([
        _service.getCategories(count: 10),
        _service.getInstructors(),
        _service.getPublicStats(),
        _service.getFeaturedCourses(count: 8),
        _service.getNewCourses(count: 8),
        _service.getRecommendedCourses(count: 12),
      ]);

      final categoriesRes = results[0] as Result<List<HomeCategoryDTO>>;
      final instructorsRes = results[1] as Result<List<HomeInstructorDTO>>;
      final statsRes = results[2] as Result<HomeStatsDTO>;
      final featuredRes = results[3] as Result<List<HomeCourseDTO>>;
      final newRes = results[4] as Result<List<HomeCourseDTO>>;
      final recommendedRes = results[5] as Result<List<HomeCourseDTO>>;

      List<HomeCategoryDTO> categories = [];
      if (categoriesRes is Success<List<HomeCategoryDTO>>) {
        categories = categoriesRes.data;
      }

      List<HomeInstructorDTO> instructors = [];
      if (instructorsRes is Success<List<HomeInstructorDTO>>) {
        instructors = instructorsRes.data;
      }

      HomeStatsDTO stats = const HomeStatsDTO();
      if (statsRes is Success<HomeStatsDTO>) {
        stats = statsRes.data;
      }

      // 2. Fetch courses with category IDs if available for the full list / browse tab
      final categoryIds = categories.map((c) => c.id).where((id) => id > 0).toList();
      final coursesRes = await _service.getAllCourses(
        categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
      );

      List<HomeCourseDTO> courses = [];
      if (coursesRes is Success<List<HomeCourseDTO>>) {
        courses = coursesRes.data;
      }

      // 3. Count courses per category from loaded courses to ensure accurate ordering & counts
      final Map<int, int> categoryCourseCounts = {};
      for (final course in courses) {
        if (course.categoryId != null && course.categoryId! > 0) {
          categoryCourseCounts[course.categoryId!] = (categoryCourseCounts[course.categoryId!] ?? 0) + 1;
        }
      }

      // Enrich categories with maximum detected course count and sort strictly descending
      categories = categories.map((cat) {
        final detectedCount = categoryCourseCounts[cat.id] ?? 0;
        final finalCount = cat.coursesCount > 0 ? cat.coursesCount : detectedCount;
        return cat.copyWith(coursesCount: finalCount);
      }).toList()
        ..sort((a, b) => b.coursesCount.compareTo(a.coursesCount));

      // Limit to top 10 categories with the most courses
      if (categories.length > 10) {
        categories = categories.take(10).toList();
      }

      debugPrint('[HomeRepository] Bundle loaded: ${categories.length} top categories, ${courses.length} courses, ${instructors.length} instructors');

      // 3. Featured Courses: Dedicated endpoint with fallback
      List<HomeCourseDTO> featuredCourses = [];
      if (featuredRes is Success<List<HomeCourseDTO>> && featuredRes.data.isNotEmpty) {
        featuredCourses = featuredRes.data;
      } else if (courses.isNotEmpty) {
        // Fallback: sort by AverageRating desc, then TotalRatings desc (Matching MVC)
        featuredCourses = List<HomeCourseDTO>.from(courses)
          ..sort((a, b) {
            final ratingComp = b.rating.compareTo(a.rating);
            if (ratingComp != 0) return ratingComp;
            return b.reviewsCount.compareTo(a.reviewsCount);
          });
      }

      // 4. Bestsellers: alias to featured/top courses
      final bestsellers = List<HomeCourseDTO>.from(featuredCourses);

      // 5. Recommended Courses: Dedicated endpoint with fallback
      List<HomeCourseDTO> recommended = [];
      if (recommendedRes is Success<List<HomeCourseDTO>> && recommendedRes.data.isNotEmpty) {
        recommended = recommendedRes.data;
      } else if (courses.isNotEmpty) {
        // Fallback: sorted by rating & isFeatured
        recommended = List<HomeCourseDTO>.from(courses)
          ..sort((a, b) {
            if (a.isFeatured && !b.isFeatured) return -1;
            if (!a.isFeatured && b.isFeatured) return 1;
            return b.rating.compareTo(a.rating);
          });
      }

      // 6. New Courses: Dedicated endpoint with fallback
      List<HomeCourseDTO> newCourses = [];
      if (newRes is Success<List<HomeCourseDTO>> && newRes.data.isNotEmpty) {
        newCourses = newRes.data;
      } else if (courses.isNotEmpty) {
        // Fallback: sorted by CreatedAt descending
        newCourses = List<HomeCourseDTO>.from(courses)
          ..sort((a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              return b.createdAt!.compareTo(a.createdAt!);
            }
            return b.id.compareTo(a.id);
          });
      }

      return Success(HomeBundleData(
        categories: categories,
        allCourses: courses,
        featuredCourses: featuredCourses,
        bestsellers: bestsellers,
        recommended: recommended,
        newCourses: newCourses,
        instructors: instructors,
        stats: stats,
      ));
    } catch (e) {
      debugPrint('[HomeRepository] getHomeBundleData error: $e');
      return Failure('حدث خطأ أثناء تحميل بيانات الصفحة الرئيسية: $e');
    }
  }

  Future<Result<List<HomeCourseDTO>>> getCoursesByCategory(int categoryId) async {
    return await _service.getApprovedCoursesByCategory(categoryId, count: 20);
  }

  Future<Result<List<HomeCategoryDTO>>> getCategories({int count = 10}) async {
    return await _service.getCategories(count: count);
  }

  Future<Result<List<HomeInstructorDTO>>> getTopInstructors({int count = 4}) async {
    return await _service.getTopInstructors(count: count);
  }

  Future<Result<List<HomeInstructorDTO>>> getAllInstructors() async {
    return await _service.getAllInstructors();
  }

  Future<Result<List<HomeInstructorDTO>>> getInstructors({int? count}) async {
    return await _service.getInstructors(count: count);
  }

  Future<Result<HomeStatsDTO>> getPublicStats() async {
    return await _service.getPublicStats();
  }

  Future<Result<List<HomeCourseDTO>>> getFeaturedCourses({int count = 8}) async {
    return await _service.getFeaturedCourses(count: count);
  }

  Future<Result<List<HomeCourseDTO>>> getNewCourses({int count = 8}) async {
    return await _service.getNewCourses(count: count);
  }

  Future<Result<List<HomeCourseDTO>>> getRecommendedCourses({int count = 12}) async {
    return await _service.getRecommendedCourses(count: count);
  }

  Future<Result<List<HomeCourseDTO>>> getAllCourses({List<int>? categoryIds}) async {
    return await _service.getAllCourses(categoryIds: categoryIds);
  }
}
