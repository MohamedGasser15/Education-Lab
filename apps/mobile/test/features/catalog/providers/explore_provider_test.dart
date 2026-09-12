import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/catalog/data/repositories/explore_repository.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class FakeExploreRepository extends ExploreRepository {
  List<String> mockRecentSearches = ['Flutter', 'Dart'];

  @override
  Future<List<String>> getRecentSearches() async => mockRecentSearches;

  @override
  Future<List<String>> addRecentSearch(String query) async {
    if (!mockRecentSearches.contains(query)) {
      mockRecentSearches.insert(0, query);
    }
    return mockRecentSearches;
  }

  @override
  Future<void> clearRecentSearches() async {
    mockRecentSearches.clear();
  }

  @override
  Future<Result<List<HomeCourseDTO>>> getCoursesByCategory(
    int categoryId, {
    int count = 50,
  }) async {
    return const Success([
      HomeCourseDTO(
        id: 1,
        title: 'Flutter Architecture',
        arabicTitle: 'معمارية فلاتر',
        instructorName: 'Eng. Mohamed',
      ),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExploreProvider Logic', () {
    late ExploreProvider provider;
    late FakeExploreRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeExploreRepository();
      provider = ExploreProvider(repository: fakeRepo);
    });

    test('initial state is clean and categories are pre-populated', () {
      expect(provider.categories, isNotEmpty);
      expect(provider.searchQuery, isEmpty);
      expect(provider.activeCategory, isNull);
      expect(provider.isViewingResults, isFalse);
    });

    test('loadRecentSearches populates recent searches list', () async {
      await provider.loadRecentSearches();
      expect(provider.recentSearches.length, 2);
      expect(provider.recentSearches.first, 'Flutter');
    });

    test(
      'selectCategory updates active category and isViewingResults',
      () async {
        const category = CategoryItem(
          id: '1',
          title: 'تطوير البرمجيات',
          subtitle: 'تعلم البرمجة',
          arabicTitle: 'تطوير البرمجيات',
          englishTitle: 'Software Development',
          coursesCount: '15 دورة',
          icon: Icons.code,
          color: Colors.blue,
        );

        await provider.selectCategory(category);

        expect(provider.activeCategory, category);
        expect(provider.isViewingResults, isTrue);
        expect(provider.loadedCourses.length, 1);
      },
    );

    test('clearFilters resets search state and category', () {
      provider.clearFilters();

      expect(provider.searchQuery, isEmpty);
      expect(provider.activeCategory, isNull);
      expect(provider.isViewingResults, isFalse);
    });
  });
}
