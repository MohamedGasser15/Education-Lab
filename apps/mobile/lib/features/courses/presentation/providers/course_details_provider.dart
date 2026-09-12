import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/courses/data/repositories/courses_repository.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class CourseDetailsProvider extends ChangeNotifier {
  final CoursesRepository _repository;

  CourseDetailsProvider({CoursesRepository? repository})
      : _repository = repository ?? CoursesRepository();

  bool _isLoading = false;
  String? _errorMessage;

  CourseDetailsModel? _course;
  List<CourseRatingModel> _ratings = [];
  CourseRatingSummaryModel _ratingSummary = const CourseRatingSummaryModel();
  List<HomeCourseDTO> _relatedCourses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CourseDetailsModel? get course => _course;
  List<CourseRatingModel> get ratings => _ratings;
  CourseRatingSummaryModel get ratingSummary => _ratingSummary;
  List<HomeCourseDTO> get relatedCourses => _relatedCourses;

  Future<void> fetchCourseDetails(int courseId, {bool forceRefresh = false}) async {
    if (_course?.id == courseId && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getCourseDetails(courseId);

    if (result is Success<CourseDetailsModel>) {
      _course = result.data;
      _errorMessage = null;

      // Automatically expand first section if available
      if (_course!.sections.isNotEmpty) {
        _course!.sections.first.isExpanded = true;
      }

      // Fetch supplementary ratings & related in parallel
      await _fetchSupplementaryData(courseId, _course!.categoryId);
    } else if (result is Failure<CourseDetailsModel>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchSupplementaryData(int courseId, int categoryId) async {
    final ratingsRes = await _repository.getCourseRatings(courseId);
    if (ratingsRes is Success<List<CourseRatingModel>>) {
      _ratings = ratingsRes.data;
    }

    final summaryRes = await _repository.getCourseRatingSummary(courseId);
    if (summaryRes is Success<CourseRatingSummaryModel>) {
      _ratingSummary = summaryRes.data;
    }

    if (categoryId > 0) {
      final relatedRes = await _repository.getRelatedCourses(categoryId);
      if (relatedRes is Success<List<HomeCourseDTO>>) {
        _relatedCourses = relatedRes.data.where((c) => c.id != courseId).toList();
      }
    }

    notifyListeners();
  }

  void toggleSection(int sectionIndex) {
    if (_course == null || sectionIndex >= _course!.sections.length) return;
    _course!.sections[sectionIndex].isExpanded = !_course!.sections[sectionIndex].isExpanded;
    notifyListeners();
  }

  void expandAllSections() {
    if (_course == null) return;
    for (final s in _course!.sections) {
      s.isExpanded = true;
    }
    notifyListeners();
  }

  void collapseAllSections() {
    if (_course == null) return;
    for (final s in _course!.sections) {
      s.isExpanded = false;
    }
    notifyListeners();
  }
}
