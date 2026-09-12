import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';
import 'package:mobile/features/learning/data/repositories/course_learning_repository.dart';
import 'package:mobile/features/learning/data/services/course_learning_api_service.dart';

class FakeCourseLearningApiService extends CourseLearningApiService {
  @override
  Future<Result<CourseProgressSummaryModel>> getCourseProgress(
    int courseId,
  ) async {
    return const Success(
      CourseProgressSummaryModel(
        courseId: 100,
        totalLectures: 10,
        completedLectures: 5,
        progressPercentage: 50.0,
      ),
    );
  }

  @override
  Future<Result<Map<int, bool>>> getLectureStatuses(int courseId) async {
    return const Success({101: true, 102: false});
  }

  @override
  Future<Result<bool>> markLectureCompleted(int courseId, int lectureId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> markLectureIncomplete(
    int courseId,
    int lectureId,
  ) async {
    return const Success(true);
  }

  @override
  Future<Result<List<LectureCommentModel>>> getLectureComments(
    int lectureId,
  ) async {
    return Success([
      LectureCommentModel(
        id: 1,
        lectureId: lectureId,
        userId: 'usr-1',
        userName: 'Ahmed',
        content: 'Great explanation!',
        createdAt: DateTime(2026, 1, 1),
      ),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CourseLearningRepository Tests', () {
    late CourseLearningRepository repository;
    late FakeCourseLearningApiService fakeService;

    setUp(() {
      fakeService = FakeCourseLearningApiService();
      repository = CourseLearningRepository(apiService: fakeService);
    });

    test('getCourseProgress returns progress summary', () async {
      final res = await repository.getCourseProgress(100);
      expect(res is Success<CourseProgressSummaryModel>, isTrue);
      if (res is Success<CourseProgressSummaryModel>) {
        expect(res.data.progressPercentage, 50.0);
        expect(res.data.completedLectures, 5);
      }
    });

    test(
      'getLectureStatuses and markLecture methods delegate properly',
      () async {
        final statusRes = await repository.getLectureStatuses(100);
        expect((statusRes as Success<Map<int, bool>>).data[101], isTrue);

        final completeRes = await repository.markLectureCompleted(100, 102);
        expect((completeRes as Success<bool>).data, isTrue);

        final incompleteRes = await repository.markLectureIncomplete(100, 101);
        expect((incompleteRes as Success<bool>).data, isTrue);
      },
    );

    test('getLectureComments returns comments list', () async {
      final res = await repository.getLectureComments(101);
      expect(res is Success<List<LectureCommentModel>>, isTrue);
      if (res is Success<List<LectureCommentModel>>) {
        expect(res.data.length, 1);
        expect(res.data.first.userName, 'Ahmed');
      }
    });
  });
}
