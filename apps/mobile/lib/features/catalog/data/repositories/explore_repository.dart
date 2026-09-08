import 'package:flutter/material.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/catalog/data/services/explore_api_service.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreRepository {
  final ExploreApiService _apiService;
  static const String _recentSearchesKey = 'recent_explore_searches';

  ExploreRepository({ExploreApiService? apiService})
      : _apiService = apiService ?? ExploreApiService();

  /// Fetches all learner approved courses without touching Admin or Instructor controllers.
  Future<Result<List<HomeCourseDTO>>> getCatalogCourses() async {
    return await _apiService.getAllLearnerCourses();
  }

  /// Fetches courses for a specific category using LearnerCourse
  Future<Result<List<HomeCourseDTO>>> getCoursesByCategory(int categoryId, {int count = 50}) async {
    return await _apiService.getApprovedCoursesByCategory(categoryId, count: count);
  }

  /// Extracts unique categories from courses list, similar to MVC's dynamic category extraction.
  List<CategoryItem> extractCategories(List<HomeCourseDTO> courses) {
    if (courses.isEmpty) return ExploreCategoriesListDefaults.defaults;

    final Map<int, _CategoryAggregator> aggMap = {};

    for (final course in courses) {
      final catId = course.categoryId;
      if (catId != null && catId > 0) {
        final existing = aggMap[catId];
        if (existing == null) {
          aggMap[catId] = _CategoryAggregator(
            id: catId,
            name: course.categoryName ?? 'تصنيف عام',
            englishName: course.categoryEnglishName ?? 'General',
            count: 1,
          );
        } else {
          existing.count++;
          if (existing.name.isEmpty && course.categoryName != null) {
            existing.name = course.categoryName!;
          }
          if (existing.englishName.isEmpty && course.categoryEnglishName != null) {
            existing.englishName = course.categoryEnglishName!;
          }
        }
      }
    }

    if (aggMap.isEmpty) {
      return ExploreCategoriesListDefaults.defaults;
    }

    final List<CategoryItem> result = [];
    final sortedAggs = aggMap.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    for (final agg in sortedAggs) {
      final style = _resolveCategoryStyle(agg.name, agg.englishName, agg.id);
      final (subAr, subEn) = _resolveCategorySubtitles(agg.name, agg.englishName);
      result.add(
        CategoryItem(
          id: agg.id.toString(),
          title: agg.name,
          subtitle: subEn,
          arabicTitle: agg.name,
          englishTitle: agg.englishName,
          arabicSubtitle: subAr,
          englishSubtitle: subEn,
          icon: style.icon,
          color: style.color,
          coursesCount: '${agg.count} ${agg.count == 1 ? "دورة" : "دورات"}',
          englishTag: '${agg.count} ${agg.count == 1 ? "course" : "courses"}',
          rawCount: agg.count,
        ),
      );
    }

    return result;
  }

  /// Retrieves persisted recent searches from SharedPreferences
  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentSearchesKey) ?? ['Flutter', 'Figma UI/UX', 'Python', 'Next.js'];
    } catch (_) {
      return ['Flutter', 'Figma UI/UX', 'Python', 'Next.js'];
    }
  }

  /// Adds a query to recent searches and persists it
  Future<List<String>> addRecentSearch(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return await getRecentSearches();

    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_recentSearchesKey) ?? ['Flutter', 'Figma UI/UX', 'Python', 'Next.js'];
      list.remove(clean);
      list.insert(0, clean);
      if (list.length > 8) {
        list.removeRange(8, list.length);
      }
      await prefs.setStringList(_recentSearchesKey, list);
      return list;
    } catch (_) {
      return [clean];
    }
  }

  /// Removes a query from recent searches
  Future<List<String>> removeRecentSearch(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_recentSearchesKey) ?? [];
      list.remove(query);
      await prefs.setStringList(_recentSearchesKey, list);
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Clears all recent searches
  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchesKey);
    } catch (_) {}
  }

  _CategoryStyle _resolveCategoryStyle(String name, String engName, int id) {
    final combined = '$name $engName'.toLowerCase();

    if (combined.contains('برمج') || combined.contains('web') || combined.contains('code') || combined.contains('mobile') || combined.contains('تطوير')) {
      return const _CategoryStyle(Icons.code_rounded, Color(0xFF1D61E7));
    }
    if (combined.contains('ذكاء') || combined.contains('بيانات') || combined.contains('ai') || combined.contains('data') || combined.contains('python')) {
      return const _CategoryStyle(Icons.psychology_rounded, Color(0xFF7C3AED));
    }
    if (combined.contains('تصميم') || combined.contains('design') || combined.contains('ui') || combined.contains('ux') || combined.contains('figma')) {
      return const _CategoryStyle(Icons.palette_rounded, Color(0xFFDB2777));
    }
    if (combined.contains('أعمال') || combined.contains('business') || combined.contains('إدارة') || combined.contains('ريادة') || combined.contains('تسويق')) {
      return const _CategoryStyle(Icons.business_center_rounded, Color(0xFFD97706));
    }
    if (combined.contains('أمن') || combined.contains('security') || combined.contains('cyber') || combined.contains('شبكات')) {
      return const _CategoryStyle(Icons.shield_rounded, Color(0xFF059669));
    }
    if (combined.contains('سحاب') || combined.contains('cloud') || combined.contains('devops')) {
      return const _CategoryStyle(Icons.cloud_done_rounded, Color(0xFF4F46E5));
    }

    // Default color palette based on ID
    final palette = [
      const _CategoryStyle(Icons.school_rounded, Color(0xFF1D61E7)),
      const _CategoryStyle(Icons.auto_stories_rounded, Color(0xFF0284C7)),
      const _CategoryStyle(Icons.lightbulb_rounded, Color(0xFFF59E0B)),
      const _CategoryStyle(Icons.terminal_rounded, Color(0xFF10B981)),
      const _CategoryStyle(Icons.workspace_premium_rounded, Color(0xFF8B5CF6)),
    ];
    return palette[id % palette.length];
  }
  static (String ar, String en) _resolveCategorySubtitles(String name, String engName) {
    final combined = '$name $engName'.toLowerCase();

    if (combined.contains('موبايل') || combined.contains('تطبيقات') || combined.contains('mobile') || combined.contains('flutter') || combined.contains('ios') || combined.contains('android')) {
      return ('تطبيقات Flutter و iOS و Android', 'Flutter, iOS & Android Apps');
    }
    if (combined.contains('ويب') || combined.contains('web') || combined.contains('frontend') || combined.contains('backend')) {
      return ('تطوير الواجهات الأمامية والخلفية', 'Frontend & Backend Web Development');
    }
    if (combined.contains('برمج') || combined.contains('code') || combined.contains('software') || combined.contains('تطوير')) {
      return ('تطوير البرمجيات ومواقع وتطبيقات الويب', 'Software, Web & Mobile Development');
    }
    if (combined.contains('ذكاء') || combined.contains('ai') || combined.contains('machine learning') || combined.contains('deep learning')) {
      return ('تعلم الآلة والشبكات العصبية وتطبيقات AI', 'Machine Learning, Deep Learning & AI');
    }
    if (combined.contains('بيانات') || combined.contains('data') || combined.contains('analytics') || combined.contains('python')) {
      return ('تحليل البيانات، بيج داتا والتعلم الإحصائي', 'Data Analysis, Big Data & Statistics');
    }
    if (combined.contains('تصميم') || combined.contains('design') || combined.contains('ui') || combined.contains('ux') || combined.contains('figma')) {
      return ('تصميم واجهات وتجربة المستخدم والمنتجات', 'UI/UX & Product Design');
    }
    if (combined.contains('أمن') || combined.contains('security') || combined.contains('cyber') || combined.contains('هكر') || combined.contains('شبكات')) {
      return ('الأمن السيبراني، حماية الأنظمة والشبكات', 'Cybersecurity, System & Network Security');
    }
    if (combined.contains('سحاب') || combined.contains('cloud') || combined.contains('devops') || combined.contains('docker')) {
      return ('البنية السحابية وإدارة النظم و DevOps', 'Cloud Computing, DevOps & CI/CD');
    }
    if (combined.contains('أعمال') || combined.contains('business') || combined.contains('إدارة') || combined.contains('ريادة') || combined.contains('مشاريع')) {
      return ('ريادة الأعمال وإدارة المشاريع والقيادة', 'Business, Project Management & Leadership');
    }
    if (combined.contains('تسويق') || combined.contains('marketing') || combined.contains('seo') || combined.contains('نمو')) {
      return ('التسويق الرقمي واستراتيجيات النمو', 'Digital Marketing & Growth Strategies');
    }

    final enFallback = engName.isNotEmpty ? engName : 'Comprehensive Courses & Tracks';
    final arFallback = name.isNotEmpty ? name : 'دورات شاملة ومسارات تعليمية';
    return (arFallback, enFallback);
  }
}

class _CategoryAggregator {
  final int id;
  String name;
  String englishName;
  int count;

  _CategoryAggregator({
    required this.id,
    required this.name,
    required this.englishName,
    required this.count,
  });
}

class _CategoryStyle {
  final IconData icon;
  final Color color;
  const _CategoryStyle(this.icon, this.color);
}

class ExploreCategoriesListDefaults {
  static const List<CategoryItem> topCategories = [
    CategoryItem(
      id: '1',
      title: 'البرمجة وتطوير البرمجيات',
      subtitle: 'Programming & Software Development',
      arabicTitle: 'البرمجة وتطوير البرمجيات',
      englishTitle: 'Programming & Software Development',
      arabicSubtitle: 'تطوير البرمجيات والأنظمة والخوارزميات',
      englishSubtitle: 'Software Engineering, Systems & Algorithms',
      icon: Icons.terminal_rounded,
      color: Color(0xFF1D61E7),
      coursesCount: 'الأعلى طلباً',
      englishTag: 'Highest Demand',
    ),
    CategoryItem(
      id: '2',
      title: 'تطوير الويب',
      subtitle: 'Web Development (Frontend & Backend)',
      arabicTitle: 'تطوير الويب',
      englishTitle: 'Web Development',
      arabicSubtitle: 'تطوير الواجهات الأمامية والخلفية للمواقع',
      englishSubtitle: 'Frontend, Backend & Fullstack Web',
      icon: Icons.language_rounded,
      color: Color(0xFF0284C7),
      coursesCount: 'الأكثر شعبية',
      englishTag: 'Most Popular',
    ),
    CategoryItem(
      id: '3',
      title: 'تطوير تطبيقات الموبايل',
      subtitle: 'Mobile Apps (Flutter & iOS/Android)',
      arabicTitle: 'تطوير تطبيقات الموبايل',
      englishTitle: 'Mobile App Development',
      arabicSubtitle: 'تطبيقات Flutter و iOS و Android الهجينة والأصلية',
      englishSubtitle: 'Flutter, iOS & Android Mobile Apps',
      icon: Icons.phone_android_rounded,
      color: Color(0xFF059669),
      coursesCount: 'شائع ومطلوب',
      englishTag: 'Trending',
    ),
    CategoryItem(
      id: '10',
      title: 'الذكاء الاصطناعي',
      subtitle: 'Artificial Intelligence & Deep Learning',
      arabicTitle: 'الذكاء الاصطناعي',
      englishTitle: 'Artificial Intelligence',
      arabicSubtitle: 'تعلم الآلة والتعلم العميق وتطبيقات AI',
      englishSubtitle: 'Machine Learning, Deep Learning & AI',
      icon: Icons.psychology_rounded,
      color: Color(0xFF7C3AED),
      coursesCount: 'الأسرع نمواً',
      englishTag: 'Fastest Growing',
    ),
    CategoryItem(
      id: '7',
      title: 'علوم البيانات وتحليلها',
      subtitle: 'Data Science & Big Data',
      arabicTitle: 'علوم البيانات وتحليلها',
      englishTitle: 'Data Science & Analytics',
      arabicSubtitle: 'تحليل البيانات، الإحصاء والبيانات الضخمة',
      englishSubtitle: 'Data Analysis, Statistics & Big Data',
      icon: Icons.analytics_rounded,
      color: Color(0xFF6366F1),
      coursesCount: 'مطلوب جداً',
      englishTag: 'High Demand',
    ),
    CategoryItem(
      id: '31',
      title: 'تصميم واجهات المستخدم UI/UX',
      subtitle: 'UI/UX & Product Design',
      arabicTitle: 'تصميم واجهات المستخدم UI/UX',
      englishTitle: 'UI/UX & Product Design',
      arabicSubtitle: 'تصميم واجهات وتجربة المستخدم والنماذج الأولية',
      englishSubtitle: 'UI/UX, Prototyping & Product Design',
      icon: Icons.palette_rounded,
      color: Color(0xFFDB2777),
      coursesCount: 'الأعلى تقييماً',
      englishTag: 'Top Rated',
    ),
    CategoryItem(
      id: '13',
      title: 'أمن المعلومات والسيبراني',
      subtitle: 'Cyber Security & Ethical Hacking',
      arabicTitle: 'أمن المعلومات والسيبراني',
      englishTitle: 'Cyber Security',
      arabicSubtitle: 'أمن المعلومات والاختراق الأخلاقي والشبكات',
      englishSubtitle: 'Cybersecurity, Ethical Hacking & Networks',
      icon: Icons.shield_rounded,
      color: Color(0xFFDC2626),
      coursesCount: 'شديد الأهمية',
      englishTag: 'Essential',
    ),
    CategoryItem(
      id: '15',
      title: 'الحوسبة السحابية و DevOps',
      subtitle: 'Cloud Computing & DevOps',
      arabicTitle: 'الحوسبة السحابية و DevOps',
      englishTitle: 'Cloud Computing & DevOps',
      arabicSubtitle: 'البنية السحابية وإدارة النظم و DevOps و Docker',
      englishSubtitle: 'Cloud Infrastructure, DevOps & CI/CD',
      icon: Icons.cloud_done_rounded,
      color: Color(0xFF2563EB),
      coursesCount: 'مستوى متقدم',
      englishTag: 'Advanced',
    ),
    CategoryItem(
      id: '16',
      title: 'إدارة الأعمال والمشاريع',
      subtitle: 'Business & Project Management',
      arabicTitle: 'إدارة الأعمال والمشاريع',
      englishTitle: 'Business & Project Management',
      arabicSubtitle: 'ريادة الأعمال وإدارة المشاريع والقيادة',
      englishSubtitle: 'Business Management, Agile & Leadership',
      icon: Icons.business_center_rounded,
      color: Color(0xFFD97706),
      coursesCount: 'رواد الأعمال',
      englishTag: 'Entrepreneurs',
    ),
    CategoryItem(
      id: '21',
      title: 'التسويق الرقمي',
      subtitle: 'Digital Marketing & Growth',
      arabicTitle: 'التسويق الرقمي',
      englishTitle: 'Digital Marketing',
      arabicSubtitle: 'التسويق الرقمي، محركات البحث وإعلانات النمو',
      englishSubtitle: 'Digital Marketing, SEO & Growth Strategies',
      icon: Icons.campaign_rounded,
      color: Color(0xFFEA580C),
      coursesCount: 'نمو المبيعات',
      englishTag: 'Sales Growth',
    ),
  ];

  static List<CategoryItem> get defaults => topCategories;
}
