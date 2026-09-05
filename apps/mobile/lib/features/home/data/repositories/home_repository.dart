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
      // 1. Fetch categories, instructors, and stats first
      final results = await Future.wait([
        _service.getCategories(count: 10),
        _service.getInstructors(),
        _service.getPublicStats(),
      ]);

      final categoriesRes = results[0] as Result<List<HomeCategoryDTO>>;
      final instructorsRes = results[1] as Result<List<HomeInstructorDTO>>;
      final statsRes = results[2] as Result<HomeStatsDTO>;

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

      // 2. Fetch courses with category IDs if available
      final categoryIds = categories.map((c) => c.id).where((id) => id > 0).toList();
      final coursesRes = await _service.getAllCourses(
        categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
      );

      List<HomeCourseDTO> courses = [];
      if (coursesRes is Success<List<HomeCourseDTO>>) {
        courses = coursesRes.data;
      }

      debugPrint('[HomeRepository] Bundle loaded: ${categories.length} categories, ${courses.length} courses, ${instructors.length} instructors');

      // 3. Featured Courses (Matching MVC FeaturedCoursesViewComponent.cs):
      // Sorted primarily by AverageRating descending, then by TotalRatings descending
      List<HomeCourseDTO> featuredCourses = [];
      List<HomeCourseDTO> bestsellers = [];
      List<HomeCourseDTO> recommended = [];
      List<HomeCourseDTO> newCourses = [];

      if (courses.isNotEmpty) {
        // Featured courses: top-rated approved courses
        featuredCourses = List<HomeCourseDTO>.from(courses)
          ..sort((a, b) {
            final ratingComp = b.rating.compareTo(a.rating);
            if (ratingComp != 0) return ratingComp;
            return b.reviewsCount.compareTo(a.reviewsCount);
          });

        // Bestsellers: alias to featured/top courses
        bestsellers = List<HomeCourseDTO>.from(featuredCourses);

        // Recommended: sorted by rating & balance
        recommended = List<HomeCourseDTO>.from(courses)
          ..sort((a, b) {
            if (a.isFeatured && !b.isFeatured) return -1;
            if (!a.isFeatured && b.isFeatured) return 1;
            return b.rating.compareTo(a.rating);
          });

        // New Courses (Matching MVC NewCoursesViewComponent.cs):
        // Sorted by CreatedAt descending
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
}
