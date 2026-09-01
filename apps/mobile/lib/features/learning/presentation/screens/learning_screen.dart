import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _MyCourseItem {
  final String id;
  final String title;
  final String instructor;
  final double progress; // 0.0 to 1.0
  final int completedLectures;
  final int totalLectures;
  final String remainingTime;
  final String lastLessonTitle;
  final IconData icon;
  final List<Color> gradient;
  final bool isDownloaded;
  final bool isCompleted;

  const _MyCourseItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.completedLectures,
    required this.totalLectures,
    required this.remainingTime,
    required this.lastLessonTitle,
    required this.icon,
    required this.gradient,
    this.isDownloaded = false,
    this.isCompleted = false,
  });
}

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int _selectedFilterIndex = 0;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isLoading = false;

  final List<String> _filters = [
    'جميع الدورات',
    'قيد التقدم',
    'المكتملة',
    'تم تنزيلها',
  ];

  final List<_MyCourseItem> _courses = const [
    _MyCourseItem(
      id: 'mc1',
      title: 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر [2026]',
      instructor: 'م. أحمد محمد',
      progress: 0.65,
      completedLectures: 184,
      totalLectures: 284,
      remainingTime: 'متبقي 4.5 ساعة',
      lastLessonTitle: 'الدرس 24: إدارة الحالة المتقدمة بـ Riverpod 3.0',
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF1D61E7), Color(0xFF2563EB)],
      isDownloaded: true,
      isCompleted: false,
    ),
    _MyCourseItem(
      id: 'mc2',
      title: 'تصميم واجهات وتجربة المستخدم الاحترافية من الصفر بـ Figma',
      instructor: 'سارة أحمد',
      progress: 0.35,
      completedLectures: 58,
      totalLectures: 165,
      remainingTime: 'متبقي 12.0 ساعة',
      lastLessonTitle: 'الدرس 12: بناء نظام التصميم الموحد (Design Tokens)',
      icon: Icons.brush_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
      isDownloaded: false,
      isCompleted: false,
    ),
    _MyCourseItem(
      id: 'mc3',
      title: 'احتراف نماذج الذكاء الاصطناعي التوليدي والتعلم العميق بـ Python',
      instructor: 'م. يوسف محمود',
      progress: 1.0,
      completedLectures: 190,
      totalLectures: 190,
      remainingTime: 'مكتملة بالكامل',
      lastLessonTitle: 'المشروع النهائي: بناء AI Agent متكامل',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF334155)],
      isDownloaded: true,
      isCompleted: true,
    ),
    _MyCourseItem(
      id: 'mc4',
      title: 'بناء التطبيقات المؤسسية الحديثة بـ ASP.NET Core و Microservices',
      instructor: 'د. خالد العلي',
      progress: 0.15,
      completedLectures: 46,
      totalLectures: 310,
      remainingTime: 'متبقي 38.0 ساعة',
      lastLessonTitle: 'الدرس 8: تصميم الـ Clean Architecture في C#',
      icon: Icons.cloud_done_rounded,
      gradient: [Color(0xFF134BB8), Color(0xFF1D61E7)],
      isDownloaded: false,
      isCompleted: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFilterSelected(int index) {
    if (_selectedFilterIndex == index) return;
    setState(() {
      _selectedFilterIndex = index;
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  List<_MyCourseItem> _getFilteredCourses() {
    return _courses.where((course) {
      // 1. Text Search Filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = course.title.toLowerCase().contains(q);
        final matchInstructor = course.instructor.toLowerCase().contains(q);
        if (!matchTitle && !matchInstructor) return false;
      }

      // 2. Tab Filter
      if (_selectedFilterIndex == 1) {
        // In Progress
        return !course.isCompleted;
      } else if (_selectedFilterIndex == 2) {
        // Completed
        return course.isCompleted;
      } else if (_selectedFilterIndex == 3) {
        // Downloaded
        return course.isDownloaded;
      }

      return true;
    }).toList();
  }

  _MyCourseItem get _mostRecentCourse => _courses.first;

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _getFilteredCourses();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  textDirection: TextDirection.rtl,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: const InputDecoration(
                    hintText: 'ابحث في دوراتي المسجلة...',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              )
            : const Text(
                'دوراتي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                } else {
                  _searchFocusNode.requestFocus();
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Udemy Horizontal Filter Pills
          _buildFilterTabsBar(),

          // 2. Main Content (Hero Continue Learning + Course List)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: _isLoading
                  ? _buildSkeletonLoadingView()
                  : (filteredCourses.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          key: ValueKey('courses_${_selectedFilterIndex}_${filteredCourses.length}'),
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                          children: [
                            // Hero "متابعة التعلم" Banner (Show on "All Courses" & "In Progress")
                            if (_searchQuery.isEmpty &&
                                (_selectedFilterIndex == 0 || _selectedFilterIndex == 1)) ...[
                              _buildContinueWatchingHeroCard(_mostRecentCourse),
                              const SizedBox(height: 20),
                            ],

                            // Section Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _filters[_selectedFilterIndex],
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                Text(
                                  '${filteredCourses.length} دورة',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // List of Course Cards
                            for (final course in filteredCourses) ...[
                              _buildUdemyLearningCard(course),
                              const SizedBox(height: 12),
                            ],
                          ],
                        )),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 1. FILTER TABS BAR =================
  Widget _buildFilterTabsBar() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => _onFilterSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= 2. HERO CONTINUE WATCHING CARD =================
  Widget _buildContinueWatchingHeroCard(_MyCourseItem course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/lesson-player'),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header with Live indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.play_circle_filled_rounded, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'متابعة التعلم من حيث توقفت',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      course.remainingTime,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Course Info Row
                Row(
                  children: [
                    // Thumbnail with Play Overlay
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: course.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(course.icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            course.lastLessonTitle,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(course.progress * 100).toInt()}% مكتمل',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '${course.completedLectures} من ${course.totalLectures} درس',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= 3. UDEMY LANDSCAPE LEARNING CARD =================
  Widget _buildUdemyLearningCard(_MyCourseItem course) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 Thumbnail with Play Button & Download Badge
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/lesson-player'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: course.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(course.icon, color: Colors.white.withValues(alpha: 0.95), size: 28),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    ),
                    if (course.isDownloaded)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.download_done_rounded,
                            size: 11,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 12.5,
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
                      course.instructor,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Progress Bar or Certificate Badge
                    if (course.isCompleted)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified_rounded, size: 12, color: Color(0xFF059669)),
                                SizedBox(width: 4),
                                Text(
                                  'دورة مكتملة 100%',
                                  style: TextStyle(
                                    color: Color(0xFF065F46),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/certificate_view'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF4FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'عرض الشهادة',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          minHeight: 4,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(course.progress * 100).toInt()}% مكتمل',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            '${course.completedLectures}/${course.totalLectures} درس',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          // Bottom Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Continue button or Review
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/lesson-player'),
                child: Row(
                  children: [
                    Icon(
                      course.isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.isCompleted ? 'إعادة مشاهدة الدورة' : 'متابعة التعلم',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),

              // Options Menu Popup (Share / Download / Details)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, size: 20, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onSelected: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم اختيار: $val'), behavior: SnackBarBehavior.floating),
                  );
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'تنزيل الدورة بالكامل',
                    child: Row(
                      children: [
                        Icon(Icons.download_for_offline_outlined, size: 18, color: AppColors.textPrimary),
                        SizedBox(width: 8),
                        Text('تنزيل الدورة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'مشاركة الدورة',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined, size: 18, color: AppColors.textPrimary),
                        SizedBox(width: 8),
                        Text('مشاركة الدورة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 4. SKELETON LOADING VIEW =================
  Widget _buildSkeletonLoadingView() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFF1F5F9),
          highlightColor: Colors.white,
          period: const Duration(milliseconds: 900),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 96,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 10),
                      Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
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

  // ================= 5. EMPTY STATE VIEW =================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.school_outlined, size: 36, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد دورات في هذا القسم',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'استكشف آلاف الدورات التعليمية وابدأ التعلم الآن!',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/main'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'استكشف الدورات ➔',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
