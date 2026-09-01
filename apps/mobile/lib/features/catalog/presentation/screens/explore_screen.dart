import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _FilterChipItem {
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const _FilterChipItem({
    required this.label,
    this.icon,
    this.iconColor,
  });
}

class _CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String coursesCount;

  const _CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.coursesCount,
  });
}

class _CourseItem {
  final String id;
  final String title;
  final String arabicTitle;
  final String instructor;
  final double rating;
  final String reviews;
  final String price;
  final String originalPrice;
  final String category;
  final bool isBestseller;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String duration;
  final IconData icon;
  final List<Color> gradient;

  const _CourseItem({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.instructor,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.isBestseller,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.duration,
    required this.icon,
    required this.gradient,
  });
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

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

  final List<String> _topSearches = [
    'Flutter',
    'Python',
    'React JS',
    'Figma UI/UX',
    'ASP.NET Core',
    'Machine Learning',
    'Docker & DevOps',
    'Cyber Security',
    'Power BI & Excel',
    'Node.js',
    'Graphic Design',
    'Digital Marketing',
  ];

  final List<_FilterChipItem> _filterChips = const [
    _FilterChipItem(label: 'الكل'),
    _FilterChipItem(
      label: 'الأعلى تقييماً',
      icon: Icons.star_rounded,
      iconColor: Color(0xFFE59819),
    ),
    _FilterChipItem(
      label: 'الأعلى مبيعاً',
      icon: Icons.local_fire_department_rounded,
      iconColor: Color(0xFFF97316),
    ),
    _FilterChipItem(
      label: 'أقل من 50 \$',
      icon: Icons.sell_rounded,
      iconColor: AppColors.primary,
    ),
  ];

  final List<_CategoryItem> _categories = const [
    _CategoryItem(
      id: 'dev',
      title: 'تطوير البرمجيات والويب',
      subtitle: 'Web & Mobile Development',
      icon: Icons.code_rounded,
      color: Color(0xFF1D61E7),
      coursesCount: '140+ دورة',
    ),
    _CategoryItem(
      id: 'ai',
      title: 'الذكاء الاصطناعي وعلوم البيانات',
      subtitle: 'AI, Machine Learning & Data',
      icon: Icons.psychology_rounded,
      color: Color(0xFF7C3AED),
      coursesCount: '85+ دورة',
    ),
    _CategoryItem(
      id: 'design',
      title: 'التصميم وتجربة المستخدم',
      subtitle: 'UI/UX & Product Design',
      icon: Icons.palette_rounded,
      color: Color(0xFFDB2777),
      coursesCount: '60+ دورة',
    ),
    _CategoryItem(
      id: 'business',
      title: 'إدارة الأعمال والريادة',
      subtitle: 'Business & Entrepreneurship',
      icon: Icons.business_center_rounded,
      color: Color(0xFFD97706),
      coursesCount: '50+ دورة',
    ),
    _CategoryItem(
      id: 'security',
      title: 'الأمن السيبراني والشبكات',
      subtitle: 'Cybersecurity & Ethical Hacking',
      icon: Icons.shield_rounded,
      color: Color(0xFF059669),
      coursesCount: '40+ دورة',
    ),
    _CategoryItem(
      id: 'marketing',
      title: 'التسويق الرقمي والتجارة',
      subtitle: 'Digital Marketing & Growth',
      icon: Icons.campaign_rounded,
      color: Color(0xFF0284C7),
      coursesCount: '35+ دورة',
    ),
    _CategoryItem(
      id: 'cloud',
      title: 'السحابة والـ DevOps',
      subtitle: 'Cloud Computing & CI/CD',
      icon: Icons.cloud_done_rounded,
      color: Color(0xFF4F46E5),
      coursesCount: '30+ دورة',
    ),
  ];

  final List<_CourseItem> _courses = const [
    _CourseItem(
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
    _CourseItem(
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
    _CourseItem(
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
    _CourseItem(
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
    _CourseItem(
      id: 'e5',
      title: 'Next.js 15 & Full-Stack Server Actions Bootcamp',
      arabicTitle: 'احتراف تطوير تطبيقات الويب بـ Next.js 15 و Server Actions',
      instructor: 'م. كريم سامي',
      rating: 4.9,
      reviews: '1,280',
      price: '44.99 \$',
      originalPrice: '74.99 \$',
      category: 'تطوير البرمجيات والويب',
      isBestseller: false,
      badgeText: 'جديد وحصري',
      badgeColor: Color(0xFFEFF4FF),
      badgeTextColor: Color(0xFF1D61E7),
      duration: '26.0 ساعة إجمالية',
      icon: Icons.rocket_launch_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ),
    _CourseItem(
      id: 'e6',
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
      icon: Icons.security_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _triggerFetchAnimation() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 360), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _onSearchSubmit(String value) {
    if (value.trim().isNotEmpty && !_recentSearches.contains(value.trim())) {
      setState(() {
        _recentSearches.insert(0, value.trim());
      });
    }
    _triggerFetchAnimation();
  }

  void _applySearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim();
      _searchController.text = query.trim();
      _activeCategoryName = null;
    });
    _searchFocusNode.unfocus();
    _triggerFetchAnimation();
  }

  void _openCategory(String categoryTitle) {
    setState(() {
      _activeCategoryName = categoryTitle;
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

  List<_CourseItem> _getFilteredCourses() {
    final List<_CourseItem> filtered = [];
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
    final List<_CourseItem> results = _getFilteredCourses();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar & Search Input
            _buildTopSearchBar(isViewingResults),

            // Content: Either Results View (with Skeleton Loading) or Clean Browse View
            Expanded(
              child: isViewingResults
                  ? _buildResultsListView(results)
                  : _buildDefaultBrowseView(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 1. TOP SEARCH BAR =================
  Widget _buildTopSearchBar(bool isViewingResults) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb if category selected
          if (_activeCategoryName != null) ...[
            Row(
              children: [
                IconButton(
                  onPressed: _clearSearchOrCategory,
                  icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _activeCategoryName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Search Field
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _searchFocusNode.hasFocus ? AppColors.primary : AppColors.border,
                      width: _searchFocusNode.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          textDirection: TextDirection.rtl,
                          onSubmitted: _onSearchSubmit,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن أي دورة، مدرب، أو مهارة...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12.5,
                              fontFamily: 'Tajawal',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty || isViewingResults)
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                          onPressed: _clearSearchOrCategory,
                          splashRadius: 18,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 2. DEFAULT BROWSE VIEW =================
  Widget _buildDefaultBrowseView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        // 1. Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'عمليات البحث الأخيرة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _recentSearches.clear()),
                child: const Text(
                  'مسح الكل',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((item) {
              return GestureDetector(
                onTap: () => _applySearchQuery(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // 2. Top Searches
        Row(
          children: const [
            Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 18),
            SizedBox(width: 6),
            Text(
              'المواضيع الأكثر بحثاً',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildTopSearches2Rows(),

        const SizedBox(height: 24),

        // 3. Browse by Categories
        Row(
          children: const [
            Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 17),
            SizedBox(width: 6),
            Text(
              'تصفح حسب الأقسام',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'استكشف أفضل الدورات المعتمدة في مجالك المفضل',
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 12),

        // Categories List
        ..._categories.map((cat) => _buildCategoryListItem(cat)),
      ],
    );
  }

  // 2-Row Top Searches
  Widget _buildTopSearches2Rows() {
    final columnCount = (_topSearches.length / 2).ceil();

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: columnCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, colIndex) {
          final topIndex = colIndex * 2;
          final bottomIndex = topIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchChip(_topSearches[topIndex]),
              const SizedBox(height: 8),
              if (bottomIndex < _topSearches.length)
                _buildSearchChip(_topSearches[bottomIndex])
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchChip(String topic) {
    return GestureDetector(
      onTap: () => _applySearchQuery(topic),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              topic,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category List Item
  Widget _buildCategoryListItem(_CategoryItem cat) {
    return GestureDetector(
      onTap: () => _openCategory(cat.title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Colored Icon Box
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(cat.icon, color: cat.color, size: 22),
            ),
            const SizedBox(width: 12),

            // Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    '${cat.subtitle} • ${cat.coursesCount}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ================= 3. RESULTS LIST VIEW =================
  Widget _buildResultsListView(List<_CourseItem> results) {
    return Column(
      children: [
        // Quick Filters Bar
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
            ),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filterChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedFilterIndex == index;
              final chip = _filterChips[index];

              return GestureDetector(
                onTap: () => _onFilterChipSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chip.icon != null) ...[
                        Icon(
                          chip.icon,
                          size: 13.5,
                          color: isSelected ? Colors.white : (chip.iconColor ?? AppColors.textSecondary),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        chip.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Results Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النتائج المتاحة (${results.length} دورة)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),

        // Animated Switcher between Skeleton Loading and Course Results
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: _isLoading
                ? _buildSkeletonLoadingList()
                : (results.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        key: ValueKey('results_${results.length}_$_selectedFilterIndex'),
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final course = results[index];
                          return _buildCourseResultCard(course);
                        },
                      )),
          ),
        ),
      ],
    );
  }

  // Skeleton Loading Shimmer Effect
  Widget _buildSkeletonLoadingList() {
    return ListView.separated(
      key: const ValueKey('skeleton_loading'),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFF1F5F9),
          highlightColor: Colors.white,
          period: const Duration(milliseconds: 900),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton Thumbnail Box
                Container(
                  width: 90,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),

                // Skeleton Lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Line 1
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title Line 2
                      Container(
                        height: 12,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Instructor & Rating Line
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 10,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Price Line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 14,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 14,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Course Result Card
  Widget _buildCourseResultCard(_CourseItem course) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/course-details'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16:9 Thumbnail
            Container(
              width: 90,
              height: 66,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: course.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  course.icon,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.arabicTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${course.instructor} • ${course.duration}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Rating Row
                  Row(
                    children: [
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB4690E),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 3),
                      ...List.generate(5, (_) {
                        return const Icon(
                          Icons.star_rounded,
                          size: 11.5,
                          color: Color(0xFFE59819),
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${course.reviews})',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Price & Badge
                  Row(
                    children: [
                      Text(
                        course.price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        course.originalPrice,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: course.badgeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.badgeText,
                          style: TextStyle(
                            color: course.badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.search_off_rounded, size: 30, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'لا توجد نتائج مطابقة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'جرب البحث بكلمات أخرى أو اختر قسماً آخر',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _clearSearchOrCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                elevation: 0,
              ),
              child: const Text(
                'العودة لكافة الأقسام',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
