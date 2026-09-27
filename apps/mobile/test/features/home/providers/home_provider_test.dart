import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/repositories/home_repository.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';

class FakeHomeRepository extends HomeRepository {
  @override
  Future<Result<List<HomeCategoryDTO>>> getCategories({int count = 10}) async {
    return const Success([
      HomeCategoryDTO(id: 1, nameAr: 'برمجة', nameEn: 'Coding'),
      HomeCategoryDTO(id: 2, nameAr: 'تصميم', nameEn: 'Design'),
    ]);
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getFeaturedCourses({
    int count = 8,
  }) async {
    return const Success([
      HomeCourseDTO(
        id: 10,
        title: 'Flutter 3 (Enrolled)',
        arabicTitle: 'فلاتر 3',
        instructorName: 'Eng. Mohamed',
      ),
      HomeCourseDTO(
        id: 20,
        title: 'Dart Basics (Unenrolled)',
        arabicTitle: 'أساسيات دارت',
        instructorName: 'Eng. Ali',
      ),
    ]);
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getNewCourses({int count = 8}) async {
    return const Success([
      HomeCourseDTO(
        id: 10,
        title: 'Flutter 3',
        arabicTitle: 'فلاتر 3',
        instructorName: 'Eng. Mohamed',
      ),
      HomeCourseDTO(
        id: 20,
        title: 'Dart Basics',
        arabicTitle: 'أساسيات دارت',
        instructorName: 'Eng. Ali',
      ),
    ]);
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getAllCourses({
    List<int>? categoryIds,
  }) async {
    return const Success([
      HomeCourseDTO(
        id: 10,
        title: 'Flutter 3',
        arabicTitle: 'فلاتر 3',
        instructorName: 'Eng. Mohamed',
      ),
      HomeCourseDTO(
        id: 20,
        title: 'Dart Basics',
        arabicTitle: 'أساسيات دارت',
        instructorName: 'Eng. Ali',
      ),
    ]);
  }

  @override
  Future<Result<HomeStatsDTO>> getPublicStats() async {
    return const Success(HomeStatsDTO(totalStudents: 1000, totalCourses: 25));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeProvider State and Categories', () {
    late HomeProvider provider;
    late FakeHomeRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeHomeRepository();
      provider = HomeProvider(repository: fakeRepo);
    });

    test('initial state has empty categories and not loading', () {
      expect(provider.categories, isEmpty);
      expect(provider.selectedCategoryId, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('selectCategory updates selected category ID', () {
      provider.selectCategory(5);
      expect(provider.selectedCategoryId, 5);

      provider.selectCategory(null);
      expect(provider.selectedCategoryId, isNull);
    });

    test('fetchHomeData loads categories, courses and stats', () async {
      await provider.fetchHomeData();

      expect(provider.categories.length, 2);
      expect(provider.bestsellers.length, 2);
      expect(provider.stats.totalStudents, 1000);
      expect(provider.isLoading, isFalse);
    });

    test('updateEnrolledCourseIds reorders courses so unenrolled appears first', () async {
      await provider.fetchHomeData();
      expect(provider.featuredCourses.first.id, 10);

      // Deprioritize course 10 since it's enrolled
      provider.updateEnrolledCourseIds({10});
      expect(provider.featuredCourses.first.id, 20);
      expect(provider.featuredCourses.last.id, 10);
    });
  });
}
