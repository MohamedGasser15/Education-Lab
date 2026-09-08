import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';

class EnrollmentApiService {
  final ApiClient _client;

  EnrollmentApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Result<List<EnrollmentModel>>> getUserEnrollments() async {
    final result = await _client.getSafe(ApiConstants.enrollment);
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is List) {
          final items = data
              .map((item) => EnrollmentModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(items);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final items = (data['data'] as List)
              .map((item) => EnrollmentModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(items);
        }
        return const Success([]);
      } catch (e) {
        return Failure('فشل تحليل دورات المستخدم: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ غير متوقع أثناء جلب دوراتك');
  }

  Future<Result<EnrollmentModel>> getCourseEnrollment(int courseId) async {
    final result = await _client.getSafe(ApiConstants.enrollmentCoursePath(courseId));
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(EnrollmentModel.fromJson(data));
        }
        return const Failure('لم يتم العثور على اشتراك للدورة');
      } catch (e) {
        return Failure('فشل تحليل بيانات الاشتراك: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ أثناء جلب بيانات الدورة');
  }

  Future<Result<bool>> checkEnrollment(int courseId) async {
    final result = await _client.getSafe(ApiConstants.enrollmentCheckPath(courseId));
    if (result is Success<dynamic>) {
      final data = result.data;
      if (data is bool) return Success(data);
      if (data is Map<String, dynamic>) {
        return Success(data['isEnrolled'] as bool? ?? false);
      }
      return const Success(false);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل التحقق من حالة الاشتراك');
  }
}
