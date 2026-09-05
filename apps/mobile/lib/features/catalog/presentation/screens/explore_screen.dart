import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_categories_list.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_course_card.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_empty_state.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_filter_bar.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_recent_searches.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_search_bar.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_skeleton_loading.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_top_searches.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  final bool isTab;
  final bool autoFocusSearch;
  const ExploreScreen({
    super.key,
    this.isTab = false,
    this.autoFocusSearch = false,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  int _selectedFilterIndex = 0;
  String? _activeCategoryName;
  bool _isLoading = false;

  final List<String> _recentSearches = [
    'Flutter',
    'Figma UI/UX',
    'Python',
    'Next.js',
  ];

  final List<CourseItem> _courses = const [
    CourseItem(
      id: 'e1',
      title: 'The Complete Flutter & Dart Development Guide [2026]',
      arabicTitle: 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر',
      instructor: 'م. أحمد محمد',
      rating: 4.8,
      reviews: '18,420',
      price: '49.99 \$',
      originalPrice: '84.99 \$',
      category: 'تطوير البرمجيات والويب',
      isBestseller: true,
      badgeText: 'الأعلى مبيعاً',
      badgeColor: Color(0xFFFEF3C7),
      badgeTextColor: Color(0xFF92400E),
      duration: '38.5 ساعة إجمالية',
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF1D61E7), Color(0xFF2563EB)],
    ),
    CourseItem(
      id: 'e2',
      title: 'Figma UI/UX Design Essentials: From Zero to Pro',
      arabicTitle: 'تصميم واجهات وتجربة المستخدم الاحترافية بـ Figma',
      instructor: 'سارة أحمد',
      rating: 4.9,
      reviews: '9,850',
      price: '39.99 \$',
      originalPrice: '69.99 \$',
      category: 'التصميم وتجربة المستخدم',
      isBestseller: true,
      badgeText: 'الأعلى تقييماً',
      badgeColor: Color(0xFFEFF4FF),
      badgeTextColor: Color(0xFF1D61E7),
      duration: '22.0 ساعة إجمالية',
      icon: Icons.brush_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ),
    CourseItem(
      id: 'e3',
      title: 'Building Enterprise Cloud Apps with ASP.NET Core & Microservices',
      arabicTitle: 'بناء التطبيقات المؤسسية الحديثة بـ ASP.NET Core و Microservices',
      instructor: 'د. خالد العلي',
      rating: 4.8,
      reviews: '12,300',
      price: '54.99 \$',
      originalPrice: '99.99 \$',
      category: 'تطوير البرمجيات والويب',
      isBestseller: false,
      badgeText: 'جديد ومميز',
      badgeColor: Color(0xFFECFDF5),
      badgeTextColor: Color(0xFF065F46),
      duration: '45.0 ساعة إجمالية',
      icon: Icons.cloud_done_rounded,
      gradient: [Color(0xFF134BB8), Color(0xFF1D61E7)],
    ),
    CourseItem(
      id: 'e4',
      title: 'Mastering LLMs, Generative AI & Deep Learning with Python',
      arabicTitle: 'احتراف نماذج الذكاء الاصطناعي التوليدي والتعلم العميق بـ Python',
      instructor: 'م. يوسف محمود',
      rating: 4.7,
      reviews: '6,140',
      price: '59.99 \$',
      originalPrice: '89.99 \$',
      category: 'الذكاء الاصطناعي وعلوم البيانات',
      isBestseller: true,
      badgeText: 'الأعلى مبيعاً',
      badgeColor: Color(0xFFFEF3C7),
      badgeTextColor: Color(0xFF92400E),
      duration: '29.5 ساعة إجمالية',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF334155)],
    ),
    CourseItem(
      id: 'e5',
      title: 'Complete Ethical Hacking & Cyber Security Bootcamp',
      arabicTitle: 'المعسكر الشامل لاختبار الاختراق والأمن السيبراني الأخلاقي',
      instructor: 'م. عمر طارق',
      rating: 4.8,
      reviews: '8,900',
      price: '44.99 \$',
      originalPrice: '79.99 \$',
      category: 'الأمن السيبراني والشبكات',
      isBestseller: true,
      badgeText: 'الأعلى مبيعاً',
      badgeColor: Color(0xFFFEF3C7),
      badgeTextColor: Color(0xFF92400E),
      duration: '34.0 ساعة إجمالية',
      icon: Icons.shield_rounded,
      gradient: [Color(0xFF064E3B), Color(0xFF065F46)],
    ),
    CourseItem(
      id: 'e6',
      title: 'Digital Marketing & Growth Hacking Mastery 2026',
      arabicTitle: 'دبلومة التسويق الرقمي ونمو المبيعات المتكاملة للمشاريع',
      instructor: 'ريم عبد العزيز',
      rating: 4.6,
      reviews: '4,120',
      price: '34.99 \$',
      originalPrice: '64.99 \$',
      category: 'التسويق الرقمي والتجارة',
      isBestseller: false,
      badgeText: 'تطبيقي وعملي',
      badgeColor: Color(0xFFEFF4FF),
      badgeTextColor: Color(0xFF1D61E7),
      duration: '18.0 ساعة إجمالية',
      icon: Icons.campaign_rounded,
      gradient: [Color(0xFF075985), Color(0xFF0284C7)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    final clean = query.trim();
    if (clean.isEmpty) return;
    if (!_recentSearches.contains(clean)) {
      setState(() {
        _recentSearches.insert(0, clean);
        if (_recentSearches.length > 8) _recentSearches.removeLast();
      });
    }
    _triggerFetchAnimation();
  }

  void _triggerFetchAnimation() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _applySearchQuery(String text) {
    setState(() {
      _searchQuery = text;
      _searchController.text = text;
      _activeCategoryName = null;
    });
    _triggerFetchAnimation();
  }

  void _openCategory(CategoryItem category) {
    setState(() {
      _activeCategoryName = category.title;
      _searchQuery = '';
      _searchController.clear();
      _selectedFilterIndex = 0;
    });
    _triggerFetchAnimation();
  }

  void _onFilterChipSelected(int index) {
    if (_selectedFilterIndex == index) return;
    setState(() => _selectedFilterIndex = index);
    _triggerFetchAnimation();
  }

  void _clearSearchOrCategory() {
    setState(() {
      _searchQuery = '';
      _activeCategoryName = null;
      _searchController.clear();
      _selectedFilterIndex = 0;
      _isLoading = false;
    });
    _searchFocusNode.unfocus();
  }

  List<CourseItem> _getFilteredCourses() {
    final List<CourseItem> filtered = [];
    for (final course in _courses) {
      if (_activeCategoryName != null && course.category != _activeCategoryName) {
        continue;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = course.arabicTitle.toLowerCase().contains(q) ||
            course.title.toLowerCase().contains(q);
        final matchInstructor = course.instructor.toLowerCase().contains(q);
        final matchCat = course.category.toLowerCase().contains(q);

        if (!matchTitle && !matchInstructor && !matchCat) continue;
      }

      if (_selectedFilterIndex == 1 && course.rating < 4.8) {
        continue;
      }
      if (_selectedFilterIndex == 2 && !course.isBestseller) {
        continue;
      }
      if (_selectedFilterIndex == 3) {
        final priceNum = double.tryParse(course.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        if (priceNum >= 50) continue;
      }

      filtered.add(course);
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bool isViewingResults = _searchQuery.isNotEmpty || _activeCategoryName != null;
    final List<CourseItem> results = _getFilteredCourses();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar & Search Input
            ExploreSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              activeCategoryName: _activeCategoryName,
              isTab: widget.isTab,
              isViewingResults: isViewingResults,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              onSubmitted: _onSearchSubmit,
              onClear: _clearSearchOrCategory,
            ),

            // Content
            Expanded(
              child: isViewingResults
                  ? Column(
                      children: [
                        ExploreFilterBar(
                          selectedIndex: _selectedFilterIndex,
                          onFilterSelected: _onFilterChipSelected,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                          child: Row(
                            children: [
                              Text(
                                '${context.loc.exploreAvailableResults} (${results.length})',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 260),
                            child: _isLoading
                                ? const ExploreSkeletonLoading()
                                : (results.isEmpty
                                    ? ExploreEmptyState(onReset: _clearSearchOrCategory)
                                    : ListView.separated(
                                        key: ValueKey('results_${results.length}_$_selectedFilterIndex'),
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                                        itemCount: results.length,
                                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          return ExploreCourseCard(course: results[index]);
                                        },
                                      )),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                      children: [
                        ExploreRecentSearches(
                          searches: _recentSearches,
                          onSearchTap: _applySearchQuery,
                          onClearAll: () => setState(() => _recentSearches.clear()),
                        ),
                        if (_recentSearches.isNotEmpty) const SizedBox(height: 24),
                        ExploreTopSearches(
                          onSearchTap: _applySearchQuery,
                        ),
                        const SizedBox(height: 24),
                        ExploreCategoriesList(
                          categories: context.watch<HomeProvider>().categories.isNotEmpty
                              ? context.watch<HomeProvider>().categories.map((c) {
                                  return CategoryItem(
                                    id: c.id.toString(),
                                    title: c.getLocalizedName(context),
                                    subtitle: c.description ?? '',
                                    icon: c.icon,
                                    color: c.color,
                                    coursesCount: context.loc.coursesCountText(c.coursesCount.toString()),
                                  );
                                }).toList()
                              : null,
                          onCategoryTap: _openCategory,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
