import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/models/instructor_profile_model.dart';
import 'package:mobile/features/home/data/services/home_api_service.dart';

class InstructorProfileProvider extends ChangeNotifier {
  final HomeApiService _apiService;

  InstructorProfileProvider({HomeApiService? apiService})
      : _apiService = apiService ?? HomeApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  InstructorProfileModel? _profile;
  InstructorProfileModel? get profile => _profile;

  InstructorRatingsOverviewModel? _ratingsOverview;
  InstructorRatingsOverviewModel? get ratingsOverview => _ratingsOverview;

  List<HomeCourseDTO> _courses = [];
  List<HomeCourseDTO> get courses => _courses;

  int _selectedSortIndex = 0; // 0: All, 1: Highest Rated, 2: Most Popular, 3: Newest
  int get selectedSortIndex => _selectedSortIndex;

  List<HomeCourseDTO> get filteredCourses {
    final list = List<HomeCourseDTO>.from(_courses);
    switch (_selectedSortIndex) {
      case 1: // Highest Rated
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 2: // Most Popular / Reviews
        list.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case 3: // Newest
        list.sort((a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            return b.createdAt!.compareTo(a.createdAt!);
          }
          return b.id.compareTo(a.id);
        });
        break;
      default:
        break;
    }
    return list;
  }

  void setSortIndex(int index) {
    if (_selectedSortIndex != index) {
      _selectedSortIndex = index;
      notifyListeners();
    }
  }

  Future<void> loadInstructorProfile(
    String instructorId, {
    HomeInstructorDTO? initialDto,
    Map<String, dynamic>? rawData,
  }) async {
    _errorMessage = null;

    // Seed initial display for zero-delay UX
    if (initialDto != null) {
      _profile = InstructorProfileModel.fromHomeInstructorDTO(initialDto);
    } else if (rawData != null) {
      final name = rawData['name']?.toString() ?? '';
      final role = rawData['role']?.toString() ?? '';
      final rating = (rawData['rating'] as num?)?.toDouble() ?? 4.8;
      final students = int.tryParse(rawData['students']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '') ?? 150;
      final coursesCount = (rawData['coursesCount'] as num?)?.toInt() ?? 1;
      final avatarUrl = rawData['avatarUrl']?.toString();

      _profile = InstructorProfileModel(
        id: instructorId,
        name: name,
        headline: role,
        rating: rating,
        totalStudents: students,
        coursesCount: coursesCount,
        profileImageUrl: avatarUrl,
      );
    }

    // Always show skeleton loading when fetching full profile data
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch Instructor Details, Courses & Ratings in parallel
      final detailsFuture = _apiService.getInstructorDetails(instructorId);
      final coursesFuture = _apiService.getInstructorCourses(instructorId);
      final ratingsFuture = _apiService.getInstructorRatings(instructorId);

      final results = await Future.wait([detailsFuture, coursesFuture, ratingsFuture]);
      final detailsResult = results[0] as Result<InstructorProfileModel>;
      final coursesResult = results[1] as Result<List<HomeCourseDTO>>;
      final ratingsResult = results[2] as Result<InstructorRatingsOverviewModel>;

      if (detailsResult is Success<InstructorProfileModel>) {
        _profile = detailsResult.data;
      }

      if (coursesResult is Success<List<HomeCourseDTO>>) {
        _courses = coursesResult.data;
      }

      if (ratingsResult is Success<InstructorRatingsOverviewModel>) {
        _ratingsOverview = ratingsResult.data;
      }

      // Ensure the courses count accurately reflects the profile's real count from database
      final int accurateCoursesCount = (_profile != null && _profile!.coursesCount > 0)
          ? (_courses.length > _profile!.coursesCount ? _courses.length : _profile!.coursesCount)
          : _courses.length;

      // If bio/about was empty, supply default subjects if needed
      if (_profile != null && (_profile!.about.trim().isEmpty)) {
        final defaultSubjects = _profile!.subjects.isNotEmpty
            ? _profile!.subjects
            : ['Flutter & Dart', 'Clean Architecture', 'REST APIs', 'UI/UX Design'];

        _profile = _profile!.copyWith(
          subjects: defaultSubjects,
          coursesCount: accurateCoursesCount,
          courses: _courses,
          ratingsOverview: _ratingsOverview,
          rating: (_ratingsOverview != null && _ratingsOverview!.stats.totalReviews > 0)
              ? _ratingsOverview!.stats.averageRating
              : _profile!.rating,
        );
      } else if (_profile != null) {
        _profile = _profile!.copyWith(
          courses: _courses,
          coursesCount: accurateCoursesCount,
          ratingsOverview: _ratingsOverview,
          rating: (_ratingsOverview != null && _ratingsOverview!.stats.totalReviews > 0)
              ? _ratingsOverview!.stats.averageRating
              : _profile!.rating,
        );
      }
    } catch (e) {
      debugPrint('[InstructorProfileProvider] load error: $e');
      if (_profile == null) {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _profile = null;
    _ratingsOverview = null;
    _courses = [];
    _isLoading = false;
    _errorMessage = null;
    _selectedSortIndex = 0;
  }
}
