import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/extensions/course_display_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/repositories/home_repository.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/data/repositories/enrollment_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository;
  final EnrollmentRepository _enrollmentRepository;

  HomeProvider({
    HomeRepository? repository,
    EnrollmentRepository? enrollmentRepository,
  })  : _repository = repository ?? resolveOr(() => HomeRepository()),
        _enrollmentRepository =
            enrollmentRepository ?? resolveOr(() => EnrollmentRepository());

  bool _isLoadingCategories = false;
  bool _isLoadingFeatured = false;
  bool _isLoadingRecommended = false;
  bool _isLoadingNewCourses = false;
  bool _isLoadingInstructors = false;
  bool _isLoadingAllInstructors = false;
  bool _isLoadingAllCourses = false;
  bool _isLoadingStats = false;
  String? _errorMessage;

  Set<int> _enrolledCourseIds = {};
  Set<int> get enrolledCourseIds => _enrolledCourseIds;

  List<HomeCategoryDTO> _categories = [];
  int? _selectedCategoryId;

  List<HomeCourseDTO> _allCourses = [];
  List<HomeCourseDTO> _featuredCourses = [];
  List<HomeCourseDTO> _bestsellers = [];
  List<HomeCourseDTO> _recommended = [];
  List<HomeCourseDTO> _newCourses = [];
  List<HomeInstructorDTO> _topInstructors = [];
  List<HomeInstructorDTO> _allInstructors = [];
  HomeStatsDTO _stats = const HomeStatsDTO();

  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingFeatured => _isLoadingFeatured;
  bool get isLoadingRecommended => _isLoadingRecommended;
  bool get isLoadingNewCourses => _isLoadingNewCourses;
  bool get isLoadingInstructors => _isLoadingInstructors;
  bool get isLoadingAllInstructors => _isLoadingAllInstructors;
  bool get isLoadingAllCourses => _isLoadingAllCourses;
  bool get isLoadingStats => _isLoadingStats;

  bool get isLoading =>
      _isLoadingCategories ||
      _isLoadingFeatured ||
      _isLoadingRecommended ||
      _isLoadingNewCourses ||
      _isLoadingInstructors ||
      _isLoadingAllCourses;

  String? get errorMessage => _errorMessage;

  List<HomeCategoryDTO> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;

  List<HomeCourseDTO> get allCourses => _allCourses;
  List<HomeCourseDTO> get featuredCourses =>
      _featuredCourses.isNotEmpty ? _featuredCourses : _bestsellers;
  List<HomeCourseDTO> get bestsellers =>
      _featuredCourses.isNotEmpty ? _featuredCourses : _bestsellers;
  List<HomeCourseDTO> get recommended => _recommended;
  List<HomeCourseDTO> get newCourses => _newCourses;
  List<HomeInstructorDTO> get instructors =>
      _allInstructors.isNotEmpty ? _allInstructors : _topInstructors;
  List<HomeInstructorDTO> get topInstructors =>
      _topInstructors.isNotEmpty ? _topInstructors : _allInstructors;
  HomeStatsDTO get stats => _stats;

  void updateEnrolledCourseIds(Set<int> ids) {
    _enrolledCourseIds = ids;
    _reorderCourses();
    notifyListeners();
  }

  void _reorderCourses() {
    if (_enrolledCourseIds.isEmpty) return;
    _featuredCourses = _featuredCourses.prioritizeUnenrolled(_enrolledCourseIds);
    _bestsellers = _featuredCourses;
    _recommended = _recommended.where((c) => !_enrolledCourseIds.contains(c.id)).toList();
    _newCourses = _newCourses.prioritizeUnenrolled(_enrolledCourseIds);
    _allCourses = _allCourses.prioritizeUnenrolled(_enrolledCourseIds);
  }

  Future<void> fetchHomeData({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) return;

    _isLoadingCategories = true;
    _isLoadingFeatured = true;
    _isLoadingRecommended = true;
    _isLoadingNewCourses = true;
    _isLoadingInstructors = true;
    _isLoadingAllCourses = true;
    _isLoadingStats = true;
    _errorMessage = null;
    notifyListeners();

    // 0. Fetch user enrollments if logged in to deprioritize already purchased courses
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (isLoggedIn) {
      try {
        final enrollRes = await _enrollmentRepository.getUserEnrollments();
        if (enrollRes is Success<List<EnrollmentModel>>) {
          _enrolledCourseIds = enrollRes.data
              .expand((c) => [c.courseId, c.id])
              .where((id) => id > 0)
              .toSet();
        }
      } catch (_) {}
    } else {
      _enrolledCourseIds = {};
    }

    // 1. Fetch categories
    final categoriesFuture = _repository
        .getCategories(count: 10)
        .then((res) {
          if (res is Success<List<HomeCategoryDTO>>) {
            _categories = res.data;
            _enrichCategories();
          }
          _isLoadingCategories = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingCategories = false;
          notifyListeners();
        });

    // 2. Fetch featured / bestsellers courses (fetch 16 so unenrolled occupy top slots)
    final featuredFuture = _repository
        .getFeaturedCourses(count: _enrolledCourseIds.isNotEmpty ? 16 : 8)
        .then((res) {
          if (res is Success<List<HomeCourseDTO>>) {
            _featuredCourses = res.data.prioritizeUnenrolled(_enrolledCourseIds);
            _bestsellers = _featuredCourses;
          }
          _isLoadingFeatured = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingFeatured = false;
          notifyListeners();
        });

    // 3. Fetch recommended courses (exclude enrolled courses)
    final recommendedFuture = _repository
        .getRecommendedCourses(count: 16)
        .then((res) {
          if (res is Success<List<HomeCourseDTO>>) {
            _recommended = res.data
                .where((c) => !_enrolledCourseIds.contains(c.id))
                .toList();
          }
          _isLoadingRecommended = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingRecommended = false;
          notifyListeners();
        });

    // 4. Fetch new courses (fetch 16 so unenrolled occupy top slots)
    final newCoursesFuture = _repository
        .getNewCourses(count: _enrolledCourseIds.isNotEmpty ? 16 : 8)
        .then((res) {
          if (res is Success<List<HomeCourseDTO>>) {
            _newCourses = res.data.prioritizeUnenrolled(_enrolledCourseIds);
          }
          _isLoadingNewCourses = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingNewCourses = false;
          notifyListeners();
        });

    // 5. Fetch instructors (top 4 for home section)
    final instructorsFuture = _repository
        .getTopInstructors(count: 4)
        .then((res) {
          if (res is Success<List<HomeInstructorDTO>>) {
            _topInstructors = res.data;
          }
          _isLoadingInstructors = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingInstructors = false;
          notifyListeners();
        });

    // 6. Fetch stats
    final statsFuture = _repository
        .getPublicStats()
        .then((res) {
          if (res is Success<HomeStatsDTO>) {
            _stats = res.data;
          }
          _isLoadingStats = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingStats = false;
          notifyListeners();
        });

    // 7. Fetch all courses (for Popular Topics, category counts enrichment, and fallbacks)
    final allCoursesFuture = _repository
        .getAllCourses()
        .then((res) {
          if (res is Success<List<HomeCourseDTO>>) {
            _allCourses = res.data.prioritizeUnenrolled(_enrolledCourseIds);
            _enrichCategories();
            if (_featuredCourses.isEmpty) {
              final sorted = List<HomeCourseDTO>.from(_allCourses)
                ..sort((a, b) {
                  final r = b.rating.compareTo(a.rating);
                  return r != 0 ? r : b.reviewsCount.compareTo(a.reviewsCount);
                });
              _featuredCourses = sorted.prioritizeUnenrolled(_enrolledCourseIds);
              _bestsellers = _featuredCourses;
            }
            if (_recommended.isEmpty) {
              _recommended = _allCourses
                  .where((c) => !_enrolledCourseIds.contains(c.id))
                  .toList()
                ..sort((a, b) => b.rating.compareTo(a.rating));
            }
            if (_newCourses.isEmpty) {
              final sorted = List<HomeCourseDTO>.from(_allCourses)
                ..sort(
                  (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
                    a.createdAt ?? DateTime(0),
                  ),
                );
              _newCourses = sorted.prioritizeUnenrolled(_enrolledCourseIds);
            }
          }
          _isLoadingAllCourses = false;
          notifyListeners();
        })
        .catchError((_) {
          _isLoadingAllCourses = false;
          notifyListeners();
        });

    await Future.wait([
      categoriesFuture,
      featuredFuture,
      recommendedFuture,
      newCoursesFuture,
      instructorsFuture,
      statsFuture,
      allCoursesFuture,
    ]);
  }

  void _enrichCategories() {
    if (_categories.isEmpty || _allCourses.isEmpty) return;

    final Map<int, int> categoryCourseCounts = {};
    for (final course in _allCourses) {
      if (course.categoryId != null && course.categoryId! > 0) {
        categoryCourseCounts[course.categoryId!] =
            (categoryCourseCounts[course.categoryId!] ?? 0) + 1;
      }
    }

    _categories = _categories.map((cat) {
      final detectedCount = categoryCourseCounts[cat.id] ?? 0;
      final finalCount = cat.coursesCount > 0
          ? cat.coursesCount
          : detectedCount;
      return cat.copyWith(coursesCount: finalCount);
    }).toList()..sort((a, b) => b.coursesCount.compareTo(a.coursesCount));

    if (_categories.length > 10) {
      _categories = _categories.take(10).toList();
    }
  }

  Future<void> fetchAllInstructors({bool forceRefresh = false}) async {
    if (_allInstructors.isNotEmpty && !forceRefresh) return;

    _isLoadingAllInstructors = true;
    notifyListeners();

    final result = await _repository.getAllInstructors();
    if (result is Success<List<HomeInstructorDTO>>) {
      _allInstructors = result.data;
      if (_topInstructors.isEmpty) {
        _topInstructors = _allInstructors.take(4).toList();
      }
    }
    _isLoadingAllInstructors = false;
    notifyListeners();
  }

  void selectCategory(int? categoryId) {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null;
    } else {
      _selectedCategoryId = categoryId;
    }
    notifyListeners();
  }
}
