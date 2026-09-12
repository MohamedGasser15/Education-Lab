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
  static List<CertificateModel>? _cachedCertificates;
  final _certRepo = CertificatesRepository();
  bool _isLoadingCerts = false;
  late List<CertificateModel> _certificates;

  @override
  void initState() {
    super.initState();
    _certificates = _cachedCertificates ?? [];
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

  Future<void> _fetchCertificates({bool forceRefresh = false}) async {
    if (_certificates.isEmpty || forceRefresh) {
      if (mounted) setState(() => _isLoadingCerts = true);
    }
    final result = await _certRepo.getMyCertificates();
    if (!mounted) return;
    if (result is Success<List<CertificateModel>>) {
      _cachedCertificates = result.data;
      if (mounted) {
        setState(() {
          _certificates = result.data;
          _isLoadingCerts = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingCerts = false);
      }
    }
  }

  Future<void> _showClearWishlistModal(int count) async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3B1717) : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: isDark ? 0.35 : 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color(0xFFDC2626),
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.loc.wishlistClearAllTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.wishlistClearAllMessage(count.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.loc.wishlistClearAllHint,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx, true);
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.white),
                  label: Text(
                    context.loc.wishlistClearAllConfirm(count.toString()),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.loc.commonCancel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && mounted) {
      final success = await context.read<WishlistProvider>().clearWishlist();
      if (!mounted) return;
      if (success) {
        AppSnackbar.showSuccess(
          context,
          context.loc.wishlistClearedSuccess,
        );
      } else {
        AppSnackbar.showError(
          context,
          context.loc.wishlistClearFailed,
        );
      }
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
                        context.loc.learningFilterAndSortTitle,
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
                          context.loc.learningFilterReset,
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
                    context.loc.learningSortByTitle,
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
                        label: context.loc.learningSortRecentActivity,
                        selected: tempSort == CourseSortOption.recentAccess,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.recentAccess),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningSortRecentEnrolled,
                        selected: tempSort == CourseSortOption.recentEnrolled,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.recentEnrolled),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningSortTitleAZ,
                        selected: tempSort == CourseSortOption.titleAZ,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.titleAZ),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningSortProgress,
                        selected: tempSort == CourseSortOption.progressHigh,
                        onSelected: () => setModalState(() => tempSort = CourseSortOption.progressHigh),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    context.loc.learningStatusTitle,
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
                        label: context.loc.learningStatusAll,
                        selected: tempStatus == CourseStatusFilter.all,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.all),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningStatusInProgress,
                        selected: tempStatus == CourseStatusFilter.inProgress,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.inProgress),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningStatusCompleted,
                        selected: tempStatus == CourseStatusFilter.completed,
                        onSelected: () => setModalState(() => tempStatus = CourseStatusFilter.completed),
                        isDark: isDark,
                      ),
                      _buildModalChoiceChip(
                        label: context.loc.learningStatusNotStarted,
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
                        context.loc.learningFilterApply,
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final cartCount = context.watch<CartProvider>().count;
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
                        ? context.loc.learningSearchCoursesHint
                        : _currentSection == LearningMainSection.myFavourite
                            ? context.loc.learningSearchWishlistHint
                            : context.loc.learningSearchCertificatesHint,
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
                    title: context.loc.learningTabMyCourses,
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
                    title: context.loc.learningTabFavourite,
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
                    title: context.loc.learningTabCertificates,
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
                    isRtl: isRtl,
                    cartCount: cartCount,
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
                        isRtl: isRtl,
                        cartCount: cartCount,
                      )
                    : _buildCertificatesView(
                        certificates: certificates,
                        allCourses: allCourses,
                        isLoading: _isLoadingCerts,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        textSubColor: textSubColor,
                        isDark: isDark,
                        isAr: isAr,
                        isRtl: isRtl,
                        cartCount: cartCount,
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
      child: Container(
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
    required bool isRtl,
    required int cartCount,
  }) {
    if (enrollmentProvider.isLoading && allCourses.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    // When the user has 0 enrolled courses across the entire account:
    // Show full-page, bottom-anchored empty state directly
    if (allCourses.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => enrollmentProvider.fetchEnrollments(forceRefresh: true),
        child: _buildEmptyState(
          icon: Icons.school_rounded,
          iconColor: AppColors.primary,
          glowColor: AppColors.primary,
          floatingBadgeTop: const Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
          floatingBadgeBottom: const Icon(Icons.play_arrow_rounded, size: 14, color: AppColors.primary),
          title: context.loc.learningNoCoursesTitle,
          subtitle: context.loc.learningNoCoursesSubtitle,
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          textSubColor: textSubColor,
          isDark: isDark,
          isRtl: isRtl,
          isAr: isAr,
          primaryButtonLabel: context.loc.learningExploreButton,
          primaryButtonIcon: Icons.explore_rounded,
          onPrimaryPressed: () => Navigator.pushNamed(context, '/explore'),
          secondaryAction: cartCount > 0
              ? _buildSecondaryCartButton(
                  cartCount: cartCount,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  isAr: isAr,
                )
              : _buildSubtleCartLink(
                  textSubColor: textSubColor,
                  isAr: isAr,
                ),
        ),
      );
    }

    // When the user has courses, show the filter bar and courses/filter-empty state
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
                              context.loc.learningFilterButton,
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
                            title: context.loc.learningFilterAllCount(allCourses.length.toString()),
                            isSelected: _statusFilter == CourseStatusFilter.all,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.all),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: context.loc.learningStatusInProgress,
                            isSelected: _statusFilter == CourseStatusFilter.inProgress,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.inProgress),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: context.loc.learningStatusCompleted,
                            isSelected: _statusFilter == CourseStatusFilter.completed,
                            onTap: () => setState(() => _statusFilter = CourseStatusFilter.completed),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 6),
                          _buildQuickFilterPill(
                            title: context.loc.learningStatusNotStartedShort,
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

          // Filter Empty View OR Course List
          if (processedCourses.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildFilterEmptyView(
                allCourses: allCourses,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                textSubColor: textSubColor,
                isDark: isDark,
                isAr: isAr,
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

  // Dedicated empty view for filter / search results
  Widget _buildFilterEmptyView({
    required List<EnrollmentModel> allCourses,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
  }) {
    final isSearching = _searchQuery.trim().isNotEmpty;
    final String title;
    final String subtitle;
    final IconData icon;
    final Color accentColor;

    if (isSearching) {
      title = context.loc.learningNoMatchTitle;
      subtitle = context.loc.learningNoMatchSubtitle(_searchQuery);
      icon = Icons.search_off_rounded;
      accentColor = AppColors.primary;
    } else {
      switch (_statusFilter) {
        case CourseStatusFilter.inProgress:
          title = context.loc.learningNoInProgressTitle;
          subtitle = context.loc.learningNoInProgressSubtitle;
          icon = Icons.timelapse_rounded;
          accentColor = const Color(0xFF0284C7);
          break;
        case CourseStatusFilter.completed:
          title = context.loc.learningNoCompletedTitle;
          subtitle = context.loc.learningNoCompletedSubtitle;
          icon = Icons.emoji_events_outlined;
          accentColor = const Color(0xFFD97706);
          break;
        case CourseStatusFilter.notStarted:
          title = context.loc.learningNoUnstartedTitle;
          subtitle = context.loc.learningNoUnstartedSubtitle;
          icon = Icons.auto_awesome_rounded;
          accentColor = const Color(0xFF10B981);
          break;
        case CourseStatusFilter.all:
          title = context.loc.learningNoFilterMatchTitle;
          subtitle = context.loc.learningNoFilterMatchSubtitle;
          icon = Icons.filter_list_off_rounded;
          accentColor = AppColors.primary;
          break;
      }
    }

    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final double bottomPadding = widget.isTab ? (110.0 + bottomInset) : (32.0 + bottomInset);

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, bottomPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: isDark ? 0.15 : 0.09),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 38,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _statusFilter = CourseStatusFilter.all;
                  _sortOption = CourseSortOption.recentAccess;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 17, color: Colors.white),
              label: Text(
                context.loc.learningViewAllCoursesCount(allCourses.length.toString()),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
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
    required bool isRtl,
    required int cartCount,
  }) {
    if (wishlistProvider.isLoading && wishlistProvider.items.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => wishlistProvider.fetchWishlist(forceRefresh: true),
      child: items.isEmpty
          ? _buildEmptyState(
              icon: Icons.favorite_border_rounded,
              iconColor: const Color(0xFFEF4444),
              glowColor: const Color(0xFFEF4444),
              floatingBadgeTop: const Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
              floatingBadgeBottom: const Icon(Icons.school_rounded, size: 14, color: AppColors.primary),
              title: context.loc.wishlistEmptyTitle,
              subtitle: context.loc.wishlistEmptySubtitle,
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
              textSubColor: textSubColor,
              isDark: isDark,
              isRtl: isRtl,
              isAr: isAr,
              primaryButtonLabel: context.loc.learningExploreButton,
              primaryButtonIcon: Icons.explore_rounded,
              onPrimaryPressed: () => Navigator.pushNamed(context, '/explore'),
              secondaryAction: cartCount > 0
                  ? _buildSecondaryCartButton(
                      cartCount: cartCount,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      isAr: isAr,
                    )
                  : _buildSubtleCartLink(
                      textSubColor: textSubColor,
                      isAr: isAr,
                    ),
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.loc.learningSavedCoursesCount(items.length.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _showClearWishlistModal(items.length),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_sweep_outlined,
                                size: 17,
                                color: Color(0xFFDC2626),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.loc.learningClearAllSaved,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFDC2626),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < items.length; i++) ...[
                  _buildWishlistCard(items[i], cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                  if (i < items.length - 1) const SizedBox(height: 12),
                ],
              ],
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
    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isEnrolled = enrollmentProvider.isEnrolled(item.courseId);
    final isInCart = cartProvider.isInCart(item.courseId);

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
                        errorWidget: (_, _, _) => Container(
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
                          ? context.loc.checkoutFreePrice
                          : '${item.finalPrice.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<WishlistProvider>().removeFromWishlist(item.courseId);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(5.5),
                              child: Icon(Icons.favorite_rounded, color: Color(0xFFEF4444), size: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isEnrolled)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                Navigator.pushNamed(context, '/lesson-player', arguments: {'courseId': item.courseId});
                              },
                              child: Ink(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.22),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1.5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_circle_fill_rounded, size: 13, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.loc.courseDetailsGoToCourse,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else if (isInCart)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                Navigator.pushNamed(context, '/cart');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: isDark ? 0.45 : 0.3),
                                    width: 1.1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.loc.courseDetailsAddedToCart,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
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
                              child: Ink(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1.5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.shopping_cart_outlined, size: 13, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.loc.addToCartButton,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal'),
                                    ),
                                  ],
                                ),
                              ),
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
    required List<EnrollmentModel> allCourses,
    required bool isLoading,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
    required bool isRtl,
    required int cartCount,
  }) {
    if (isLoading && _certificates.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchCertificates,
      child: certificates.isEmpty
          ? _buildEmptyState(
              icon: Icons.workspace_premium_rounded,
              iconColor: const Color(0xFFD97706),
              glowColor: const Color(0xFFF59E0B),
              floatingBadgeTop: const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF10B981)),
              floatingBadgeBottom: const Icon(Icons.school_rounded, size: 14, color: AppColors.primary),
              title: context.loc.learningNoCertificatesTitle,
              subtitle: context.loc.learningNoCertificatesSubtitle,
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
              textSubColor: textSubColor,
              isDark: isDark,
              isRtl: isRtl,
              isAr: isAr,
              primaryButtonLabel: allCourses.isNotEmpty
                  ? context.loc.learningGoToCourses
                  : context.loc.learningExploreButton,
              primaryButtonIcon: allCourses.isNotEmpty ? Icons.play_lesson_rounded : Icons.explore_rounded,
              onPrimaryPressed: () {
                if (allCourses.isNotEmpty) {
                  setState(() => _currentSection = LearningMainSection.myCourses);
                } else {
                  Navigator.pushNamed(context, '/explore');
                }
              },
              secondaryAction: allCourses.isNotEmpty
                  ? TextButton.icon(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(context, '/explore');
                      },
                      icon: const Icon(Icons.explore_outlined, size: 16, color: AppColors.primary),
                      label: Text(
                        context.loc.learningExploreButton,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    )
                  : (cartCount > 0
                      ? _buildSecondaryCartButton(
                          cartCount: cartCount,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          isAr: isAr,
                        )
                      : _buildSubtleCartLink(
                          textSubColor: textSubColor,
                          isAr: isAr,
                        )),
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
                  context.loc.learningCertIssuedDate(cert.formattedDate),
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
              context.loc.learningCertView,
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
                      context.loc.homeContinueLearning,
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
                          errorWidget: (_, _, _) => Container(
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
          const SizedBox(height: 12),
          AppButton(
            height: 44,
            borderRadius: 10,
            fontSize: 13,
            label: context.loc.learningResumeLesson,
            icon: const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(
                context,
                '/lesson-player',
                arguments: course.courseId > 0 ? course.courseId : course.id,
              );
            },
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
          Navigator.pushNamed(
            context,
            '/lesson-player',
            arguments: course.courseId > 0 ? course.courseId : course.id,
          );
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
                              errorWidget: (_, _, _) => Container(
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
                              ? context.loc.learningCompletedBadge
                              : context.loc.learningProgressPercentComplete(course.progressPercentage.toString()),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? const Color(0xFF10B981) : AppColors.primary,
                            fontFamily: 'Tajawal',
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
    Color? iconColor,
    Color? glowColor,
    Widget? floatingBadgeTop,
    Widget? floatingBadgeBottom,
    required String title,
    required String subtitle,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isRtl,
    required bool isAr,
    required String primaryButtonLabel,
    required VoidCallback onPrimaryPressed,
    IconData? primaryButtonIcon,
    Widget? secondaryAction,
  }) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    // In tab mode, the bottom overlay includes the bottom nav bar (56 + bottomInset)
    // plus the ContinueLearningMiniBar (~72px) and breathing space (~20px).
    final double bottomPadding = widget.isTab ? (175.0 + bottomInset) : (28.0 + bottomInset);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Layered Decorative Icon
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Outer soft glow
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (glowColor ?? AppColors.primary).withValues(alpha: isDark ? 0.14 : 0.08),
                            boxShadow: [
                              BoxShadow(
                                color: (glowColor ?? AppColors.primary).withValues(alpha: isDark ? 0.2 : 0.08),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        // Inner Circle
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            border: Border.all(
                              color: (iconColor ?? AppColors.primary).withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              icon,
                              size: 42,
                              color: iconColor ?? AppColors.primary,
                            ),
                          ),
                        ),
                        // Floating Badge 1 (Top)
                        if (floatingBadgeTop != null)
                          Positioned(
                            top: -2,
                            right: isRtl ? null : 2,
                            left: isRtl ? 2 : null,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: floatingBadgeTop,
                            ),
                          ),
                        // Floating Badge 2 (Bottom)
                        if (floatingBadgeBottom != null)
                          Positioned(
                            bottom: 0,
                            left: isRtl ? null : 2,
                            right: isRtl ? 2 : null,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: floatingBadgeBottom,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Bottom Action Area
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.32),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                onPrimaryPressed();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    primaryButtonIcon ?? Icons.explore_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    primaryButtonLabel,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                                    size: 17,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Secondary Action
                        if (secondaryAction != null) ...[
                          const SizedBox(height: 10),
                          secondaryAction,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecondaryCartButton({
    required int cartCount,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required bool isAr,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, '/cart');
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: cardBg,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              context.loc.learningViewCartCount(cartCount.toString()),
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtleCartLink({
    required Color textSubColor,
    required bool isAr,
  }) {
    return TextButton.icon(
      onPressed: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, '/cart');
      },
      icon: Icon(
        Icons.shopping_cart_outlined,
        size: 16,
        color: textSubColor,
      ),
      label: Text(
        context.loc.learningGoToCart,
        style: TextStyle(
          fontSize: 13,
          color: textSubColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tajawal',
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
