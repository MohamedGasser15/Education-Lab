import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/catalog/data/repositories/explore_repository.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

class ExploreProvider extends ChangeNotifier {
  final ExploreRepository _repository;

  ExploreProvider({ExploreRepository? repository})
      : _repository = repository ?? ExploreRepository();

  bool _isLoading = false;
  String? _errorMessage;

  // Categories ordered from most popular to least
  final List<CategoryItem> _categories = ExploreCategoriesListDefaults.topCategories;
  List<String> _recentSearches = [];

  // Courses loaded on demand for the active category or global search
  List<HomeCourseDTO> _loadedCourses = [];
  final Map<int, List<HomeCourseDTO>> _categoryCache = {};
  List<HomeCourseDTO>? _searchPoolCache;

  String _searchQuery = '';
  CategoryItem? _activeCategory;
  int _selectedFilterIndex = 0;
  bool _isShowingAllResults = false;

  // --- Getters ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CategoryItem> get categories => _categories;
  List<String> get recentSearches => _recentSearches;
  List<HomeCourseDTO> get loadedCourses => _loadedCourses;

  String get searchQuery => _searchQuery;
  CategoryItem? get activeCategory => _activeCategory;
  int get selectedFilterIndex => _selectedFilterIndex;
  bool get isViewingResults =>
      _isShowingAllResults || _searchQuery.isNotEmpty || _activeCategory != null;

  /// Loads recent searches from local SharedPreferences without fetching any course network API
  Future<void> loadRecentSearches() async {
    _recentSearches = await _repository.getRecentSearches();
    notifyListeners();
  }

  /// Tapping a category card: uses by-category endpoint on demand
  Future<void> selectCategory(CategoryItem? category, {bool forceRefresh = false}) async {
    _isShowingAllResults = false;
    _activeCategory = category;
    _selectedFilterIndex = 0;
    _searchQuery = '';

    if (category == null) {
      _loadedCourses = [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    final int? catId = int.tryParse(category.id);
    if (catId == null) {
      notifyListeners();
      return;
    }

    // Check cache first if not forced
    if (!forceRefresh && _categoryCache.containsKey(catId)) {
      _loadedCourses = _categoryCache[catId]!;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getCoursesByCategory(catId, count: 50);
      if (result is Success<List<HomeCourseDTO>>) {
        _loadedCourses = result.data;
        _categoryCache[catId] = result.data;
      } else if (result is Failure<List<HomeCourseDTO>>) {
        _errorMessage = result.message;
        _loadedCourses = [];
      }
    } catch (e) {
      _errorMessage = 'فشل جلب دورات التصنيف: $e';
      _loadedCourses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets the search query
  Future<void> setSearchQuery(String query) async {
    _isShowingAllResults = false;
    _searchQuery = query.trim();
    if (_searchQuery.isNotEmpty && _activeCategory == null && _searchPoolCache == null) {
      await _fetchSearchPool();
    }
    notifyListeners();
  }

  /// When user submits a search query
  Future<void> onSearchSubmitted(String query) async {
    _isShowingAllResults = false;
    final clean = query.trim();
    _searchQuery = clean;
    if (clean.isNotEmpty) {
      _recentSearches = await _repository.addRecentSearch(clean);
      if (_activeCategory == null && _searchPoolCache == null) {
        await _fetchSearchPool();
      }
    }
    notifyListeners();
  }

  /// Opens results view for all courses or with a specific filter chip (e.g. from "View All" on Home)
  Future<void> showAllCoursesWithFilter({int filterIndex = 0}) async {
    _isShowingAllResults = true;
    _selectedFilterIndex = filterIndex;
    _activeCategory = null;
    _searchQuery = '';
    _errorMessage = null;

    if (_searchPoolCache != null && _searchPoolCache!.isNotEmpty) {
      _loadedCourses = _searchPoolCache!;
      notifyListeners();
      return;
    }

    await _fetchSearchPool();
  }

  /// Finds a matching category in Explore by id or title, or creates one
  CategoryItem findOrCreateCategory({
    required String id,
    required String title,
    String? subtitle,
    String? arabicTitle,
    String? englishTitle,
    String? arabicSubtitle,
    String? englishSubtitle,
    IconData? icon,
    Color? color,
    String? coursesCount,
    String? englishTag,
  }) {
    for (final cat in _categories) {
      if (cat.id == id ||
          cat.title == title ||
          cat.subtitle == title ||
          (arabicTitle != null && cat.arabicTitle == arabicTitle) ||
          (englishTitle != null && cat.englishTitle == englishTitle)) {
        return cat;
      }
    }
    return CategoryItem(
      id: id,
      title: title,
      subtitle: subtitle ?? englishSubtitle ?? '',
      arabicTitle: arabicTitle ?? title,
      englishTitle: englishTitle ?? subtitle,
      arabicSubtitle: arabicSubtitle,
      englishSubtitle: englishSubtitle ?? subtitle,
      icon: icon ?? Icons.category_rounded,
      color: color ?? const Color(0xFF1D61E7),
      coursesCount: coursesCount ?? '',
      englishTag: englishTag,
    );
  }

  /// Lazy loads a pool of courses for global search when no category is active
  Future<void> _fetchSearchPool() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.getCatalogCourses();
      if (res is Success<List<HomeCourseDTO>>) {
        _searchPoolCache = res.data;
        _loadedCourses = res.data;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selecting a filter chip (All, Top Rated, Bestseller, Under $50)
  void selectFilterChip(int index) {
    if (_selectedFilterIndex == index) return;
    _selectedFilterIndex = index;
    notifyListeners();
  }

  /// Clears active search or category filter instantly without reload
  void clearFilters() {
    _isShowingAllResults = false;
    _searchQuery = '';
    _activeCategory = null;
    _selectedFilterIndex = 0;
    _loadedCourses = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes current results (e.g. pull to refresh)
  Future<void> refreshCurrentResults() async {
    if (_activeCategory != null) {
      await selectCategory(_activeCategory, forceRefresh: true);
    } else if (_searchQuery.isNotEmpty) {
      _searchPoolCache = null;
      await _fetchSearchPool();
    }
  }

  /// Removes a single recent search query
  Future<void> removeRecentSearch(String query) async {
    _recentSearches = await _repository.removeRecentSearch(query);
    notifyListeners();
  }

  /// Clears all recent searches
  Future<void> clearRecentSearches() async {
    await _repository.clearRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  /// Returns the filtered and sorted list of CourseItems based on the current state
  List<CourseItem> getFilteredCourses([BuildContext? context]) {
    final List<HomeCourseDTO> sourceCourses = _activeCategory != null
        ? _loadedCourses
        : (_searchPoolCache ?? _loadedCourses);

    final List<CourseItem> results = [];

    for (final course in sourceCourses) {
      // 1. Category filter
      if (_activeCategory != null) {
        final catId = course.categoryId?.toString();
        final matchesId = catId == _activeCategory!.id;
        final matchesName = course.categoryName == _activeCategory!.title ||
            course.categoryEnglishName == _activeCategory!.title ||
            course.categoryName == _activeCategory!.subtitle ||
            course.categoryEnglishName == _activeCategory!.subtitle ||
            (course.categoryName != null &&
                _activeCategory!.arabicTitle != null &&
                course.categoryName == _activeCategory!.arabicTitle) ||
            (course.categoryEnglishName != null &&
                _activeCategory!.englishTitle != null &&
                course.categoryEnglishName == _activeCategory!.englishTitle);
        if (!matchesId && !matchesName) continue;
      }

      // 2. Search query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = course.title.toLowerCase().contains(q) ||
            course.arabicTitle.toLowerCase().contains(q);
        final matchInstructor = course.instructorName.toLowerCase().contains(q);
        final matchCat = (course.categoryName?.toLowerCase().contains(q) ?? false) ||
            (course.categoryEnglishName?.toLowerCase().contains(q) ?? false);
        final matchDesc = course.description?.toLowerCase().contains(q) ?? false;

        if (!matchTitle && !matchInstructor && !matchCat && !matchDesc) {
          continue;
        }
      }

      // 3. Filter chip
      // Index 1: Top Rated (Rating >= 4.7)
      if (_selectedFilterIndex == 1 && course.rating < 4.7) {
        continue;
      }
      // Index 2: Bestseller / Popular
      if (_selectedFilterIndex == 2 && !course.isBestseller && course.reviewsCount < 20) {
        continue;
      }
      // Index 3: Under $50
      if (_selectedFilterIndex == 3 && course.price >= 50.0) {
        continue;
      }

      results.add(CourseItem.fromHomeCourse(course, context));
    }

    // Sort according to active filter if needed
    if (_selectedFilterIndex == 1) {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_selectedFilterIndex == 2) {
      results.sort((a, b) => (int.tryParse(b.reviews) ?? 0).compareTo(int.tryParse(a.reviews) ?? 0));
    }

    return results;
  }
}
