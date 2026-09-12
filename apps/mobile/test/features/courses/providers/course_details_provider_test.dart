import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:mobile/features/courses/data/repositories/courses_repository.dart';
import 'package:mobile/features/courses/presentation/providers/course_details_provider.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class FakeCoursesRepository extends CoursesRepository {
  final bool shouldFail;
  FakeCoursesRepository({this.shouldFail = false});

  @override
  Future<Result<CourseDetailsModel>> getCourseDetails(int courseId) async {
    if (shouldFail) {
      return const Failure('Course not found');
    }
    return Success(CourseDetailsModel(
      id: courseId,
      title: 'Flutter Masterclass',
      shortDescription: 'Comprehensive Flutter course',
      description: 'Long description of Flutter course',
      status: 'Published',
      price: 99.99,
      instructorId: 'inst-1',
      instructorName: 'Dr. Sarah',
      categoryId: 5,
      categoryName: 'Programming',
      level: 'All Levels',
      language: 'Arabic',
      duration: 3600,
      totalLectures: 2,
      hasCertificate: true,
      targetAudience: 'Flutter Developers',
      sections: [
        CourseSectionModel(
          id: 1,
          courseId: courseId,
          title: 'Section 1',
          lectures: [
            const CourseLectureModel(id: 101, title: 'Lecture 1', sectionId: 1, duration: 600),
          ],
        ),
        CourseSectionModel(
          id: 2,
          courseId: courseId,
          title: 'Section 2',
          lectures: [
            const CourseLectureModel(id: 102, title: 'Lecture 2', sectionId: 2, duration: 900),
          ],
        ),
      ],
    ));
  }

  @override
  Future<Result<List<CourseRatingModel>>> getCourseRatings(int courseId, {int page = 1, int pageSize = 10}) async {
    return Success([
      CourseRatingModel(
        id: 1,
        courseId: courseId,
        userId: 'usr-1',
        userName: 'Ahmed',
        rating: 5.0,
        comment: 'Great course!',
        createdAt: DateTime(2026, 1, 1),
      ),
    ]);
  }

  @override
  Future<Result<CourseRatingSummaryModel>> getCourseRatingSummary(int courseId) async {
    return const Success(CourseRatingSummaryModel(
      averageRating: 4.9,
      totalRatings: 25,
      fiveStarCount: 20,
    ));
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getRelatedCourses(int categoryId, {int count = 6}) async {
    return const Success([
      HomeCourseDTO(id: 201, title: 'Related Course 1', arabicTitle: 'كورس مرتبط 1', instructorName: 'Dr. Sarah'),
      HomeCourseDTO(id: 100, title: 'Same Course (should filter)', arabicTitle: 'نفس الكورس', instructorName: 'Dr. Sarah'),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CourseDetailsProvider Tests', () {
    late CourseDetailsProvider provider;
    late FakeCoursesRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeCoursesRepository();
      provider = CourseDetailsProvider(repository: fakeRepo);
    });

    test('initial state has no course loaded and not loading', () {
      expect(provider.course, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.ratings, isEmpty);
      expect(provider.relatedCourses, isEmpty);
    });

    test('fetchCourseDetails successfully populates course, expands first section and fetches supplementary data', () async {
      await provider.fetchCourseDetails(100);

      expect(provider.course, isNotNull);
      expect(provider.course?.id, 100);
      expect(provider.course?.sections.first.isExpanded, isTrue);
      expect(provider.course?.sections[1].isExpanded, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.ratings.length, 1);
      expect(provider.ratingSummary.averageRating, 4.9);
      // Related courses filters out courseId 100
      expect(provider.relatedCourses.length, 1);
      expect(provider.relatedCourses.first.id, 201);
    });

    test('fetchCourseDetails handles failure properly', () async {
      final failRepo = FakeCoursesRepository(shouldFail: true);
      final failProvider = CourseDetailsProvider(repository: failRepo);

      await failProvider.fetchCourseDetails(999);

      expect(failProvider.course, isNull);
      expect(failProvider.isLoading, isFalse);
      expect(failProvider.errorMessage, 'Course not found');
    });

    test('toggleSection toggles section expanded state', () async {
      await provider.fetchCourseDetails(100);

      expect(provider.course!.sections[0].isExpanded, isTrue);
      provider.toggleSection(0);
      expect(provider.course!.sections[0].isExpanded, isFalse);
      provider.toggleSection(0);
      expect(provider.course!.sections[0].isExpanded, isTrue);
    });

    test('expandAllSections and collapseAllSections update all sections', () async {
      await provider.fetchCourseDetails(100);

      provider.collapseAllSections();
      expect(provider.course!.sections.every((s) => !s.isExpanded), isTrue);

      provider.expandAllSections();
      expect(provider.course!.sections.every((s) => s.isExpanded), isTrue);
    });
  });
}
