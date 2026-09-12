import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/data/repositories/enrollment_repository.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeEnrollmentRepository extends EnrollmentRepository {
  final List<EnrollmentModel> list;
  FakeEnrollmentRepository({required this.list});

  @override
  Future<Result<List<EnrollmentModel>>> getUserEnrollments() async {
    return Success(list);
  }

  @override
  Future<Result<EnrollmentModel>> getCourseEnrollment(int courseId) async {
    final item = list.firstWhere((e) => e.courseId == courseId);
    return Success(item);
  }

  @override
  Future<Result<bool>> checkEnrollment(int courseId) async {
    return Success(list.any((e) => e.courseId == courseId));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EnrollmentProvider Tests', () {
    late EnrollmentProvider provider;
    late FakeEnrollmentRepository fakeRepo;
    final List<EnrollmentModel> testCourses = [
      const EnrollmentModel(id: 1, courseId: 101, title: 'Course 1', progressPercentage: 100),
      const EnrollmentModel(id: 2, courseId: 102, title: 'Course 2', progressPercentage: 45),
    ];

    setUp(() async {
      SharedPreferences.setMockInitialValues({'is_logged_in': true});
      fakeRepo = FakeEnrollmentRepository(list: testCourses);
      provider = EnrollmentProvider(repository: fakeRepo);
    });

    test('initial state is empty before fetching', () {
      expect(provider.courses, isEmpty);
      expect(provider.count, 0);
      expect(provider.isEmpty, isTrue);
    });

    test('fetchEnrollments loads enrollments and calculates completed / in-progress lists', () async {
      await provider.fetchEnrollments();

      expect(provider.count, 2);
      expect(provider.isEmpty, isFalse);
      expect(provider.completedCourses.length, 1);
      expect(provider.completedCourses.first.courseId, 101);
      expect(provider.inProgressCourses.length, 1);
      expect(provider.inProgressCourses.first.courseId, 102);
      expect(provider.isEnrolled(101), isTrue);
      expect(provider.isEnrolled(999), isFalse);
      expect(provider.mostRecentCourse?.courseId, 101);
    });

    test('reset clears state cleanly', () async {
      await provider.fetchEnrollments();
      expect(provider.count, 2);

      provider.reset();
      expect(provider.courses, isEmpty);
      expect(provider.count, 0);
    });
  });
}
