import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/models/instructor_profile_model.dart';
import 'package:mobile/features/home/data/services/home_api_service.dart';
import 'package:mobile/features/home/presentation/providers/instructor_profile_provider.dart';

class FakeHomeApiService extends HomeApiService {
  @override
  Future<Result<InstructorProfileModel>> getInstructorDetails(String instructorId) async {
    return Success(InstructorProfileModel(
      id: instructorId,
      name: 'Dr. Sarah',
      headline: 'AI & Data Science Expert',
      rating: 4.95,
      totalStudents: 3500,
      coursesCount: 3,
      about: 'Expert educator in artificial intelligence.',
    ));
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getInstructorCourses(String instructorId, {int count = 100}) async {
    return const Success([
      HomeCourseDTO(id: 1, title: 'Machine Learning A-Z', arabicTitle: 'تعلم الآلة', instructorName: 'Dr. Sarah', rating: 4.9, reviewsCount: 500),
      HomeCourseDTO(id: 2, title: 'Deep Learning with PyTorch', arabicTitle: 'التعلم العميق', instructorName: 'Dr. Sarah', rating: 4.8, reviewsCount: 300),
      HomeCourseDTO(id: 3, title: 'Intro to Python', arabicTitle: 'مقدمة لبايثون', instructorName: 'Dr. Sarah', rating: 5.0, reviewsCount: 800),
    ]);
  }

  @override
  Future<Result<InstructorRatingsOverviewModel>> getInstructorRatings(String instructorId) async {
    return const Success(InstructorRatingsOverviewModel(
      stats: InstructorRatingsStatsModel(
        averageRating: 4.95,
        totalReviews: 1600,
      ),
      reviews: [],
    ));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstructorProfileProvider Tests', () {
    late InstructorProfileProvider provider;
    late FakeHomeApiService fakeService;

    setUp(() {
      fakeService = FakeHomeApiService();
      provider = InstructorProfileProvider(apiService: fakeService);
    });

    test('initial state is uninitialized', () {
      expect(provider.profile, isNull);
      expect(provider.courses, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.selectedSortIndex, 0);
    });

    test('loadInstructorProfile loads details, courses and ratings properly', () async {
      await provider.loadInstructorProfile('inst-123');

      expect(provider.profile, isNotNull);
      expect(provider.profile?.name, 'Dr. Sarah');
      expect(provider.courses.length, 3);
      expect(provider.ratingsOverview?.stats.totalReviews, 1600);
      expect(provider.isLoading, isFalse);
    });

    test('sorting filteredCourses works correctly', () async {
      await provider.loadInstructorProfile('inst-123');

      // Sort by rating (index 1) -> id: 3 (5.0), id: 1 (4.9), id: 2 (4.8)
      provider.setSortIndex(1);
      expect(provider.filteredCourses.first.id, 3);
      expect(provider.filteredCourses.last.id, 2);

      // Sort by popularity / reviewsCount (index 2) -> id: 3 (800), id: 1 (500), id: 2 (300)
      provider.setSortIndex(2);
      expect(provider.filteredCourses.first.id, 3);
      expect(provider.filteredCourses[1].id, 1);
      expect(provider.filteredCourses[2].id, 2);
    });

    test('reset clears state cleanly', () async {
      await provider.loadInstructorProfile('inst-123');
      expect(provider.profile, isNotNull);

      provider.reset();
      expect(provider.profile, isNull);
      expect(provider.courses, isEmpty);
      expect(provider.ratingsOverview, isNull);
      expect(provider.selectedSortIndex, 0);
    });
  });
}
