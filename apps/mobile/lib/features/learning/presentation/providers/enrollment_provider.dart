import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/data/repositories/enrollment_repository.dart';

class EnrollmentProvider extends ChangeNotifier {
  final EnrollmentRepository _repository;

  EnrollmentProvider({EnrollmentRepository? repository})
    : _repository = repository ?? resolveOr(() => EnrollmentRepository());

  List<EnrollmentModel> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EnrollmentModel> get courses => _courses;
  List<EnrollmentModel> get enrollments => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get count => _courses.length;
  bool get isEmpty => _courses.isEmpty;

  bool isEnrolled(int courseId) {
    return _courses.any((c) => c.courseId == courseId || c.id == courseId);
  }

  List<EnrollmentModel> get inProgressCourses =>
      _courses.where((c) => !c.isCompleted).toList();

  List<EnrollmentModel> get completedCourses =>
      _courses.where((c) => c.isCompleted).toList();

  EnrollmentModel? get mostRecentCourse =>
      _courses.isNotEmpty ? _courses.first : null;

  Future<void> fetchEnrollments({bool forceRefresh = false}) async {
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!isLoggedIn) {
      _courses = [];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    if (_courses.isEmpty || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.getUserEnrollments();
    if (result is Success<List<EnrollmentModel>>) {
      _courses = result.data;
      _errorMessage = null;
    } else if (result is Failure<List<EnrollmentModel>>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _courses = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
