import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/catalog/data/repositories/explore_repository.dart';
import 'package:mobile/features/catalog/data/services/explore_api_service.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class FakeExploreApiService extends ExploreApiService {
  @override
  Future<Result<List<HomeCourseDTO>>> getAllLearnerCourses({
    int count = 100,
  }) async {
    return const Success([
      HomeCourseDTO(
        id: 1,
        title: 'Flutter UI',
        arabicTitle: 'واجهات فلاتر',
        instructorName: 'Eng. Mohamed',
        categoryId: 10,
        categoryName: 'Mobile Development',
        categoryEnglishName: 'Mobile Development',
      ),
      HomeCourseDTO(
        id: 2,
        title: 'NodeJS Backend',
        arabicTitle: 'باك اند نود',
        instructorName: 'Eng. Mohamed',
        categoryId: 20,
        categoryName: 'Backend',
        categoryEnglishName: 'Backend',
      ),
    ]);
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getApprovedCoursesByCategory(
    int categoryId, {
    int count = 50,
  }) async {
    return const Success([
      HomeCourseDTO(
        id: 1,
        title: 'Flutter UI',
        arabicTitle: 'واجهات فلاتر',
        instructorName: 'Eng. Mohamed',
      ),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExploreRepository Tests', () {
    late ExploreRepository repository;
    late FakeExploreApiService fakeService;

    setUp(() {
      fakeService = FakeExploreApiService();
      repository = ExploreRepository(apiService: fakeService);
    });

    test('getCatalogCourses and getCoursesByCategory return courses', () async {
      final res = await repository.getCatalogCourses();
      expect(res is Success<List<HomeCourseDTO>>, isTrue);
      if (res is Success<List<HomeCourseDTO>>) {
        expect(res.data.length, 2);
      }

      final catRes = await repository.getCoursesByCategory(10);
      expect(catRes is Success<List<HomeCourseDTO>>, isTrue);
      if (catRes is Success<List<HomeCourseDTO>>) {
        expect(catRes.data.length, 1);
      }
    });

    test('extractCategories extracts unique categories from courses list', () {
      const courses = [
        HomeCourseDTO(
          id: 1,
          title: 'Course 1',
          arabicTitle: 'دورة 1',
          instructorName: 'Instructor 1',
          categoryId: 1,
          categoryName: 'Design',
          categoryEnglishName: 'Design',
        ),
        HomeCourseDTO(
          id: 2,
          title: 'Course 2',
          arabicTitle: 'دورة 2',
          instructorName: 'Instructor 2',
          categoryId: 1,
          categoryName: 'Design',
          categoryEnglishName: 'Design',
        ),
        HomeCourseDTO(
          id: 3,
          title: 'Course 3',
          arabicTitle: 'دورة 3',
          instructorName: 'Instructor 3',
          categoryId: 2,
          categoryName: 'Code',
          categoryEnglishName: 'Code',
        ),
      ];

      final categories = repository.extractCategories(courses);
      expect(categories.isNotEmpty, isTrue);
      expect(categories.any((c) => c.id == '1'), isTrue);
      expect(categories.any((c) => c.id == '2'), isTrue);
    });
  });
}
