import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';
import 'package:mobile/features/learning/data/repositories/course_learning_repository.dart';
import 'package:mobile/features/learning/presentation/providers/course_learning_provider.dart';

class FakeCourseLearningRepository extends CourseLearningRepository {
  @override
  Future<Result<CourseDetailsModel>> getCourseDetails(int courseId) async {
    final model = CourseDetailsModel.fromJson({
      'id': 100,
      'title': 'Flutter Architecture',
      'shortDescription': 'Learn Clean Architecture',
      'description': 'Full description of the course',
      'status': 'Published',
      'price': 49.99,
      'instructorId': 'inst-1',
      'instructorName': 'Eng. Mohamed',
      'categoryId': 1,
      'categoryName': 'Development',
      'level': 'Intermediate',
      'language': 'Arabic',
      'duration': 120,
      'sections': [
        {
          'id': 1,
          'title': 'Section 1',
          'courseId': 100,
          'lectures': [
            {'id': 101, 'title': 'L1', 'sectionId': 1, 'duration': 300},
            {'id': 102, 'title': 'L2', 'sectionId': 1, 'duration': 400},
          ],
        },
        {
          'id': 2,
          'title': 'Section 2',
          'courseId': 100,
          'lectures': [
            {'id': 201, 'title': 'L3', 'sectionId': 2, 'duration': 500},
          ],
        },
      ],
    });
    return Success(model);
  }

  @override
  Future<Result<CourseProgressSummaryModel>> getCourseProgress(
    int courseId,
  ) async {
    return const Success(
      CourseProgressSummaryModel(
        courseId: 100,
        totalLectures: 3,
        completedLectures: 1,
        progressPercentage: 33.3,
      ),
    );
  }

  @override
  Future<Result<Map<int, bool>>> getLectureStatuses(int courseId) async {
    return const Success({101: true, 102: false, 201: false});
  }

  @override
  Future<Result<CourseRatingModel?>> getMyRating(int courseId) async {
    return const Success(null);
  }

  @override
  Future<Result<bool>> canUserRate(int courseId) async {
    return const Success(true);
  }

  @override
  Future<Result<CertificateModel?>> getCourseCertificate(int courseId) async {
    return const Success(null);
  }

  @override
  Future<Result<List<CourseRatingModel>>> getCourseRatings(
    int courseId, {
    int page = 1,
    int pageSize = 30,
  }) async {
    return const Success([]);
  }

  @override
  Future<Result<CourseRatingSummaryModel>> getCourseRatingSummary(
    int courseId,
  ) async {
    return const Success(
      CourseRatingSummaryModel(
        averageRating: 4.8,
        totalRatings: 15,
        fiveStarCount: 10,
      ),
    );
  }

  @override
  Future<Result<List<LectureCommentModel>>> getLectureComments(
    int lectureId,
  ) async {
    return const Success([]);
  }

  @override
  Future<Result<List<LectureResourceModel>>> getLectureResources(
    int lectureId,
  ) async {
    return const Success([]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CourseLearningProvider Navigation & Progress', () {
    late CourseLearningProvider provider;
    late FakeCourseLearningRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeCourseLearningRepository();
      provider = CourseLearningProvider(repository: fakeRepo);
    });

    test('initial state before loading course is empty', () {
      expect(provider.course, isNull);
      expect(provider.hasPreviousLesson, isFalse);
      expect(provider.hasNextLesson, isFalse);
      expect(provider.currentLecture, isNull);
    });

    test(
      'loadCourse sets current lecture to first uncompleted and calculates next/prev flags',
      () async {
        await provider.loadCourse(100);

        expect(provider.course, isNotNull);
        expect(provider.currentLecture?.id, 102);
        expect(provider.isLectureCompleted(101), isTrue);
        expect(provider.isLectureCompleted(102), isFalse);
      },
    );
  });
}
