import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/data/services/enrollment_api_service.dart';

class EnrollmentRepository {
  final EnrollmentApiService _service;

  EnrollmentRepository({EnrollmentApiService? service})
    : _service = service ?? EnrollmentApiService();

  Future<Result<List<EnrollmentModel>>> getUserEnrollments() {
    return _service.getUserEnrollments();
  }

  Future<Result<EnrollmentModel>> getCourseEnrollment(int courseId) {
    return _service.getCourseEnrollment(courseId);
  }

  Future<Result<bool>> checkEnrollment(int courseId) {
    return _service.checkEnrollment(courseId);
  }
}
