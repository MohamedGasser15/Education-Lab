import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository;

  HomeProvider({HomeRepository? repository})
      : _repository = repository ?? HomeRepository();

  bool _isLoading = false;
  String? _errorMessage;

  List<HomeCategoryDTO> _categories = [];
  int? _selectedCategoryId;

  List<HomeCourseDTO> _allCourses = [];
  List<HomeCourseDTO> _featuredCourses = [];
  List<HomeCourseDTO> _bestsellers = [];
  List<HomeCourseDTO> _recommended = [];
  List<HomeCourseDTO> _newCourses = [];
  List<HomeInstructorDTO> _instructors = [];
  HomeStatsDTO _stats = const HomeStatsDTO();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<HomeCategoryDTO> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;

  List<HomeCourseDTO> get allCourses => _allCourses;
  List<HomeCourseDTO> get featuredCourses => _featuredCourses.isNotEmpty ? _featuredCourses : _bestsellers;
  List<HomeCourseDTO> get bestsellers => _featuredCourses.isNotEmpty ? _featuredCourses : _bestsellers;
  List<HomeCourseDTO> get recommended => _recommended;
  List<HomeCourseDTO> get newCourses => _newCourses;
  List<HomeInstructorDTO> get instructors => _instructors;
  HomeStatsDTO get stats => _stats;

  Future<void> fetchHomeData({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getHomeBundleData();
    if (result is Success<HomeBundleData>) {
      final bundle = result.data;
      _categories = bundle.categories;
      _allCourses = bundle.allCourses;
      _featuredCourses = bundle.featuredCourses;
      _bestsellers = bundle.bestsellers;
      _recommended = bundle.recommended;
      _newCourses = bundle.newCourses;
      _instructors = bundle.instructors;
      _stats = bundle.stats;
      _errorMessage = null;
    } else if (result is Failure<HomeBundleData>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
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
