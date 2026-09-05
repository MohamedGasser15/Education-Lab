import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';
import 'package:mobile/features/courses/presentation/screens/certificate_view_screen.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';

enum LearningMainSection { myCourses, myFavourite, myCertificates }
enum CourseStatusFilter { all, inProgress, completed, notStarted }
enum CourseSortOption { recentAccess, recentEnrolled, titleAZ, progressHigh }

class LearningScreen extends StatefulWidget {
  final bool isTab;
  final int initialTab;
  final bool showTabs;

  const LearningScreen({
    super.key,
    this.isTab = false,
    this.initialTab = 0,
    this.showTabs = true,
  });

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  // Main Section (My Courses, My Favourite, My Certificates)
  LearningMainSection _currentSection = LearningMainSection.myCourses;

  // Search State
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Courses Filter & Sort (Udemy style)
  CourseStatusFilter _statusFilter = CourseStatusFilter.all;
  CourseSortOption _sortOption = CourseSortOption.recentAccess;

  // Certificates State
  final _certRepo = CertificatesRepository();
  bool _isLoadingCerts = false;
  List<CertificateModel> _certificates = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTab == 1) {
      _currentSection = LearningMainSection.myFavourite;
    } else if (widget.initialTab == 2) {
      _currentSection = LearningMainSection.myCertificates;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EnrollmentProvider>().fetchEnrollments();
        context.read<WishlistProvider>().fetchWishlist();
        _fetchCertificates();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCertificates() async {
    setState(() => _isLoadingCerts = true);
    final result = await _certRepo.getMyCertificates();
    if (!mounted) return;
    if (result is Success<List<CertificateModel>>) {
      setState(() {
        _certificates = result.data;
        _isLoadingCerts = false;
      });
    } else {
      setState(() => _isLoadingCerts = false);
    }
  }

  List<EnrollmentModel> _processCourses(List<EnrollmentModel> allCourses) {
    List<EnrollmentModel> list = allCourses;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((c) {
        final title = c.title.toLowerCase();
        final instructor = c.instructorName.toLowerCase();
        final category = c.categoryName.toLowerCase();
        return title.contains(q) || instructor.contains(q) || category.contains(q);
      }).toList();
    }

    switch (_statusFilter) {
      case CourseStatusFilter.inProgress:
        list = list.where((c) => c.progressPercentage > 0 && c.progressPercentage < 100).toList();
        break;
      case CourseStatusFilter.completed:
        list = list.where((c) => c.isCompleted || c.progressPercentage >= 100).toList();
        break;
      case CourseStatusFilter.notStarted:
        list = list.where((c) => c.progressPercentage == 0).toList();
        break;
      case CourseStatusFilter.all:
      default:
        break;
    }

    switch (_sortOption) {
      case CourseSortOption.recentEnrolled:
        list.sort((a, b) => (b.enrolledAt ?? b.createdAt ?? DateTime(2000))
            .compareTo(a.enrolledAt ?? a.createdAt ?? DateTime(2000)));
        break;
      case CourseSortOption.titleAZ:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case CourseSortOption.progressHigh:
        list.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
        break;
      case CourseSortOption.recentAccess:
      default:
        list.sort((a, b) => (b.enrolledAt ?? b.createdAt ?? DateTime(2000))
            .compareTo(a.enrolledAt ?? a.createdAt ?? DateTime(2000)));
        break;
    }

    return list;
  }

  List<WishlistItemModel> _processWishlist(List<WishlistItemModel> items) {
    if (_searchQuery.trim().isEmpty) return items;
    final q = _searchQuery.toLowerCase().trim();
    return items.where((item) {
      final title = item.courseTitle.toLowerCase();
      final instructor = item.instructorName.toLowerCase();
      return title.contains(q) || instructor.contains(q);
    }).toList();
  }

  List<CertificateModel> _processCertificates(List<CertificateModel> certs) {
    if (_searchQuery.trim().isEmpty) return certs;
    final q = _searchQuery.toLowerCase().trim();
    return certs.where((cert) {
      return cert.courseTitle.toLowerCase().contains(q) ||
          cert.certificateCode.toLowerCase().contains(q);
    }).toList();
  }

  void _showFilterModal(BuildContext context, bool isDark, bool isAr) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        CourseStatusFilter tempStatus = _statusFilter;
        CourseSortOption tempSort = _sortOption;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
            final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
            final dividerColor = isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9);

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.paddingOf(context).bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: textSubColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'تصفية وترتيب الدورات' : 'Filter & Sort Courses',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempStatus = CourseStatusFilter.all;
                            tempSort = CourseSortOption.recentAccess;
                          });
                        },
                        child: Text(
                          isAr ? 'إعادة ضبط' : 'Reset',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: dividerColor),
                  const SizedBox(height: 10),
                  Text(
                    isAr ? 'ترتيب حسب' : 'Sort by',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildModalChoiceChip(
                        label: isAr ? 'النشاط الأخير' : 'Recently Accessed',
                        selected: tempSort == CourseSortOption.recentAccess,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.recentAccess),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'أحدث التسجيلات' : 'Recently Enrolled',
                        selected: tempSort == CourseSortOption.recentEnrolled,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.recentEnrolled),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'العنوان (أ-ي)' : 'Title (A-Z)',
                        selected: tempSort == CourseSortOption.titleAZ,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.titleAZ),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'نسبة الإنجاز' : 'Progress %',
                        selected: tempSort == CourseSortOption.progressHigh,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.progressHigh),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isAr ? 'حالة الدورة' : 'Course Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildModalChoiceChip(
                        label: isAr ? 'جميع الدورات' : 'All Courses',
                        selected: tempStatus == CourseStatusFilter.all,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.all),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'قيد التعلم' : 'In Progress',
                        selected: tempStatus == CourseStatusFilter.inProgress,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.inProgress),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'مكتملة' : 'Completed',
                        selected: tempStatus == CourseStatusFilter.completed,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.completed),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: isAr ? 'لم تبدأ بعد' : 'Not Started',
                        selected: tempStatus == CourseStatusFilter.notStarted,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.notStarted),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _statusFilter = tempStatus;
                          _sortOption = tempSort;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isAr ? 'تطبيق التصفية' : 'Apply Filters',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    required bool isDark,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          color: selected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          fontFamily: 'Tajawal',
        ),
      ),
      selected: selected,
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
      side: BorderSide(
        color: selected ? AppColors.primary : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (_) => onSelected(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final allCourses = enrollmentProvider.courses;
    final processedCourses = _processCourses(allCourses);
    final wishlistItems = _processWishlist(wishlistProvider.items);
    final certificates = _processCertificates(_certificates);

    final inProgressCourses = allCourses.where((c) => c.progressPercentage > 0 && c.progressPercentage < 100).toList();
    final heroCourse = inProgressCourses.isNotEmpty ? inProgressCourses.first : enrollmentProvider.mostRecentCourse;

    final hasActiveFilter = _statusFilter != CourseStatusFilter.all || _sortOption != CourseSortOption.recentAccess;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: (!widget.isTab && Navigator.of(context).canPop())
            ? IconButton(
                icon: Icon(
                  isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textColor, fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    hintText: _currentSection == LearningMainSection.myCourses
                        ? (isAr ? 'ابحث في دوراتك...' : 'Search your courses...')
                        : _currentSection == LearningMainSection.myFavourite
                            ? (isAr ? 'ابحث في المفضلة...' : 'Search wishlist...')
                            : (isAr ? 'ابحث في الشهادات...' : 'Search certificates...'),
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: Icon(Icons.search_rounded, size: 18, color: textSubColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              )
            : Text(
                context.loc.navMyLearning,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                  letterSpacing: -0.2,
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
              color: textColor,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: textColor,
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Section Selector: My Courses / My Favourite / My Certificates
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: _buildSectionTabPill(
                    title: isAr ? 'دوراتي' : 'My Courses',
                    count: allCourses.length,
                    isSelected: _currentSection == LearningMainSection.myCourses,
                    icon: Icons.school_rounded,
                    onTap: () => setState(() => _currentSection = LearningMainSection.myCourses),
                    isDark: isDark,
                    borderColor: borderColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSectionTabPill(
                    title: isAr ? 'المفضلة' : 'My Favourite',
                    count: wishlistProvider.items.length,
                    isSelected: _currentSection == LearningMainSection.myFavourite,
                    icon: Icons.favorite_rounded,
                    onTap: () => setState(() => _currentSection = LearningMainSection.myFavourite),
                    isDark: isDark,
                    borderColor: borderColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSectionTabPill(
                    title: isAr ? 'شهاداتي' : 'My Certificates',
                    count: _certificates.length,
                    isSelected: _currentSection == LearningMainSection.myCertificates,
                    icon: Icons.workspace_premium_rounded,
                    onTap: () => setState(() => _currentSection = LearningMainSection.myCertificates),
                    isDark: isDark,
                    borderColor: borderColor,
                  ),
                ),
              ],
            ),
          ),

          // 2. Section Content
          Expanded(
            child: _currentSection == LearningMainSection.myCourses
                ? _buildMyCoursesView(
                    enrollmentProvider: enrollmentProvider,
                    allCourses: allCourses,
                    processedCourses: processedCourses,
                    heroCourse: heroCourse,
                    hasActiveFilter: hasActiveFilter,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isDark: isDark,
                    isAr: isAr,
                  )
                : _currentSection == LearningMainSection.myFavourite
                    ? _buildWishlistView(
                        wishlistProvider: wishlistProvider,
                        items: wishlistItems,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        textSubColor: textSubColor,
                        isDark: isDark,
                        isAr: isAr,
                      )
                    : _buildCertificatesView(
                        certificates: certificates,
                        isLoading: _isLoadingCerts,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        textSubColor: textSubColor,
                        isDark: isDark,
                        isAr: isAr,
                      ),
          ),
        ],
      ),
    );
  }

  // Top Section Pill (Segmented button)
  Widget _buildSectionTabPill({
    required String title,
    required int count,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  fontFamily: 'Tajawal',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : AppColors.primary,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= VIEW 1: MY COURSES =================
  Widget _buildMyCoursesView({
    required EnrollmentProvider enrollmentProvider,
    required List<EnrollmentModel> allCourses,
    required List<EnrollmentModel> processedCourses,
    required EnrollmentModel? heroCourse,
    required bool hasActiveFilter,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
  }) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => enrollmentProvider.fetchEnrollments(forceRefresh: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // Filter Bar
          SliverToBoxAdapter(
            child: Container(
              color: cardBg,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showFilterModal(context, isDark, isAr),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                        decoration: BoxDecoration(
                          color: hasActiveFilter
                              ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.1)
                              : (isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: hasActiveFilter ? AppColors.primary : borderColor,
                            width: hasActiveFilter ? 1.2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 16,
                              color: hasActiveFilter ? AppColors.primary : textColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isAr ? 'تصفية' : 'Filter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: hasActiveFilter ? AppColors.primary : textColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildQuickFilterPill(
                            title: isAr ? 'الكل (${allCourses.length})' : 'All (${allCourses.length})',
                            isSelected: _statusFilter == CourseStatusFilter.all,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.all),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: isAr ? 'قيد التعلم' : 'In Progress',
                            isSelected: _statusFilter == CourseStatusFilter.inProgress,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.inProgress),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: isAr ? 'مكتملة' : 'Completed',
                            isSelected: _statusFilter == CourseStatusFilter.completed,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.completed),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: isAr ? 'لم تبدأ' : 'Not Started',
                            isSelected: _statusFilter == CourseStatusFilter.notStarted,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.notStarted),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Skeleton / Empty / Content
          if (enrollmentProvider.isLoading && allCourses.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildSkeletonLoadingView(cardBg, borderColor, isDark),
            )
          else if (processedCourses.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(
                icon: Icons.school_outlined,
                title: isAr ? 'لا توجد دورات مسجلة' : 'No courses found',
                subtitle: isAr ? 'استكشف آلاف الدورات وابدأ التعلم الآن' : 'Explore thousands of courses and start learning today',
                textColor: textColor,
                textSubColor: textSubColor,
                isDark: isDark,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              sliver: SliverList.separated(
                itemCount: processedCourses.length + (_searchQuery.isEmpty && _statusFilter == CourseStatusFilter.all && heroCourse != null ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (_searchQuery.isEmpty && _statusFilter == CourseStatusFilter.all && heroCourse != null) {
                    if (index == 0) {
                      return _buildContinueWatchingHero(heroCourse, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
                    }
                    final course = processedCourses[index - 1];
                    return _buildUdemyCourseCard(course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
                  } else {
                    final course = processedCourses[index];
                    return _buildUdemyCourseCard(course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  // ================= VIEW 2: MY FAVOURITE (WISHLIST) =================
  Widget _buildWishlistView({
    required WishlistProvider wishlistProvider,
    required List<WishlistItemModel> items,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
  }) {
    if (wishlistProvider.isLoading && wishlistProvider.items.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => wishlistProvider.fetchWishlist(forceRefresh: true),
      child: items.isEmpty
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(
                    icon: Icons.favorite_outline_rounded,
                    title: isAr ? 'قائمة المفضلة فارغة' : 'Your Wishlist is empty',
                    subtitle: isAr ? 'احفظ الدورات التي تعجبك هنا للرجوع إليها لاحقاً' : 'Save courses you love here to easily find them later',
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isDark: isDark,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildWishlistCard(item, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
              },
            ),
    );
  }

  Widget _buildWishlistCard(
    WishlistItemModel item,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/course-details', arguments: item.courseId),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 96,
                height: 64,
                child: item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.primaryDark,
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryDark,
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.courseTitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.instructorName,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                      item.finalPrice == 0
                          ? (isAr ? 'مجاناً' : 'Free')
                          : '${item.finalPrice.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444), size: 20),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            context.read<WishlistProvider>().removeFromWishlist(item.courseId);
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            HapticFeedback.selectionClick();
                            final success = await context.read<CartProvider>().addToCart(item.courseId);
                            if (mounted && success) {
                              AppSnackbar.showSuccess(
                                context,
                                context.loc.addedToCartSnackbar,
                                actionLabel: context.loc.viewCartAction,
                                onAction: () => Navigator.pushNamed(context, '/cart'),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            context.loc.addToCartButton,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                          ),
                        ),
                      ],
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

  // ================= VIEW 3: MY CERTIFICATES =================
  Widget _buildCertificatesView({
    required List<CertificateModel> certificates,
    required bool isLoading,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
  }) {
    if (isLoading && _certificates.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchCertificates,
      child: certificates.isEmpty
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(
                    icon: Icons.workspace_premium_outlined,
                    title: isAr ? 'لا توجد شهادات حتى الآن' : 'No certificates yet',
                    subtitle: isAr ? 'أكمل دوراتك التعليمية واحصل على شهادات معتمدة' : 'Complete your courses to earn verified certificates',
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isDark: isDark,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              itemCount: certificates.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cert = certificates[index];
                return _buildCertificateCard(cert, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
              },
            ),
    );
  }

  Widget _buildCertificateCard(
    CertificateModel cert,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFD97706),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.courseTitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${isAr ? 'تاريخ الإصدار: ' : 'Issued: '}${cert.formattedDate}',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CertificateViewScreen(initialCertificate: cert),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              isAr ? 'عرض' : 'View',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Filter Pill
  Widget _buildQuickFilterPill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  // Hero Continue Watching
  Widget _buildContinueWatchingHero(
    EnrollmentModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_circle_fill_rounded, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      isAr ? 'تابع التعلم' : 'Continue Learning',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${course.progressPercentage}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 48,
                  child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.primaryDark,
                            child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                          ),
                        )
                      : Container(
                          color: AppColors.primaryDark,
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.instructorName,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
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
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: course.progressRatio,
              minHeight: 5,
              backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pushNamed(context, '/lesson-player');
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(
                isAr ? 'متابعة الدرس' : 'Resume Lesson',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Udemy Course Card
  Widget _buildUdemyCourseCard(
    EnrollmentModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final isCompleted = course.isCompleted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, '/lesson-player');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 96,
                      height: 64,
                      child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: course.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.primaryDark,
                                child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                              ),
                            )
                          : Container(
                              color: AppColors.primaryDark,
                              child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                            ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.instructorName,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: course.progressRatio,
                        minHeight: 4,
                        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? const Color(0xFF10B981) : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCompleted
                              ? (isAr ? 'مكتمل بالكامل ✓' : 'Completed ✓')
                              : (isAr ? '${course.progressPercentage}% مكتمل' : '${course.progressPercentage}% complete'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? const Color(0xFF10B981) : AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        if (isCompleted)
                          GestureDetector(
                            onTap: () => setState(() => _currentSection = LearningMainSection.myCertificates),
                            child: Text(
                              isAr ? 'الشهادة' : 'Certificate',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD97706),
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
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 190,
              child: AppButton(
                label: context.loc.learningExploreButton,
                icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/explore'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoadingView(Color cardBg, Color borderColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppSkeleton(
        child: Column(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 86,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const SkeletonBox(width: 96, height: 64, borderRadius: 8),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SkeletonBox(height: 14, width: double.infinity, borderRadius: 4),
                          const SizedBox(height: 6),
                          const SkeletonBox(height: 10, width: 100, borderRadius: 4),
                          const SizedBox(height: 8),
                          const SkeletonBox(height: 4, width: double.infinity, borderRadius: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
