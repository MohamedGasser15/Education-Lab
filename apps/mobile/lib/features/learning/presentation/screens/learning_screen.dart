import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';
import 'package:mobile/features/courses/presentation/screens/certificate_view_screen.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';

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

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search State
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Certificates Tab State
  final _certRepo = CertificatesRepository();
  bool _isLoadingCerts = false;
  List<CertificateModel> _certificates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 2),
    );

    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

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
    _tabController.dispose();
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

  void _openCertificate(CertificateModel cert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CertificateViewScreen(initialCertificate: cert),
      ),
    );
  }

  List<EnrollmentModel> _getFilteredCourses(List<EnrollmentModel> allCourses) {
    if (_searchQuery.trim().isEmpty) return allCourses;

    final q = _searchQuery.toLowerCase().trim();
    return allCourses.where((c) {
      final title = c.title.toLowerCase();
      final instructor = c.instructorName.toLowerCase();
      final category = c.categoryName.toLowerCase();
      return title.contains(q) || instructor.contains(q) || category.contains(q);
    }).toList();
  }

  void _handleRemoveFromWishlist(WishlistItemModel item) async {
    HapticFeedback.mediumImpact();
    final provider = context.read<WishlistProvider>();
    final success = await provider.removeFromWishlist(item.courseId);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.wishlistRemovedSnackbar),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: context.loc.cartUndo,
            textColor: Colors.white,
            onPressed: () => provider.addToWishlist(item.courseId),
          ),
        ),
      );
    }
  }

  void _handleAddToCart(WishlistItemModel item) async {
    HapticFeedback.mediumImpact();
    final cartProvider = context.read<CartProvider>();
    final success = await cartProvider.addToCart(item.courseId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.cartAddedSnackbar),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: context.loc.cartTitle,
            textColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cartProvider.errorMessage ?? 'فشل إضافة الدورة إلى السلة'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: (!widget.isTab && Navigator.of(context).canPop())
            ? IconButton(
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed('/main');
                  }
                },
              )
            : null,
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textColor, fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    hintText: context.loc.learningSearchHint,
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              )
            : Text(
                widget.showTabs ? context.loc.navMyLearning : context.loc.profileMyCourses,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
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
        bottom: widget.showTabs
            ? TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: textSubColor,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal, fontFamily: 'Tajawal'),
                tabs: [
                  Tab(text: context.loc.profileMyCourses),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.loc.profileWishlist),
                        if (wishlistProvider.items.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: _tabController.index == 1 ? AppColors.primary : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${wishlistProvider.items.length}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _tabController.index == 1 ? Colors.white : AppColors.primary,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(text: context.loc.certTitle),
                ],
              )
            : null,
      ),
      body: widget.showTabs
          ? TabBarView(
              controller: _tabController,
              physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
              children: [
                // TAB 0: My Courses
                _buildMyCoursesTab(enrollmentProvider, cardBg, borderColor, dividerColor, textColor, textSubColor, isDark),

                // TAB 1: Wishlist
                _buildWishlistTab(wishlistProvider, cardBg, borderColor, textColor, textSubColor, isDark),

                // TAB 2: Certificates
                _buildCertificatesTab(cardBg, borderColor, textColor, textSubColor, isDark),
              ],
            )
          : _buildMyCoursesTab(enrollmentProvider, cardBg, borderColor, dividerColor, textColor, textSubColor, isDark),
    );
  }

  // ================= TAB 0: MY COURSES =================
  Widget _buildMyCoursesTab(
    EnrollmentProvider provider,
    Color cardBg,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    final allCourses = provider.courses;
    final filteredCourses = _getFilteredCourses(allCourses);
    final inProgress = allCourses.where((c) => !c.isCompleted).toList();
    final heroCourse = inProgress.isNotEmpty ? inProgress.first : provider.mostRecentCourse;

    if (provider.isLoading && allCourses.isEmpty) {
      return _buildSkeletonLoadingView(cardBg, borderColor, isDark);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.fetchEnrollments(forceRefresh: true),
      child: filteredCourses.isEmpty
          ? _buildEmptyCoursesState(cardBg, textColor, textSubColor, isDark)
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: filteredCourses.length + (_searchQuery.isEmpty && heroCourse != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (_searchQuery.isEmpty && heroCourse != null) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildContinueWatchingHeroCard(heroCourse, cardBg, borderColor, textColor, textSubColor, isDark),
                    );
                  }
                  final course = filteredCourses[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCourseCard(course, cardBg, borderColor, textColor, textSubColor, isDark),
                  );
                } else {
                  final course = filteredCourses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCourseCard(course, cardBg, borderColor, textColor, textSubColor, isDark),
                  );
                }
              },
            ),
    );
  }

  // ================= TAB 1: WISHLIST =================
  Widget _buildWishlistTab(
    WishlistProvider provider,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    final items = provider.items;

    if (provider.isLoading && items.isEmpty) {
      return _buildSkeletonWishlistView();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.fetchWishlist(forceRefresh: true),
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              children: [
                Center(
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
                        child: const Icon(Icons.favorite_outline_rounded, size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.loc.wishlistEmptyTitle,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.loc.wishlistEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        child: AppButton(
                          label: context.loc.learningExploreButton,
                          icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.white),
                          onPressed: () => Navigator.pushNamed(context, '/explore'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildWishlistCard(item, cardBg, borderColor, textColor, textSubColor, isDark);
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
  ) {
    final hasDiscount = item.courseDiscount != null && item.courseDiscount! > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/course-details', arguments: item.courseId),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 92,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1D61E7), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                        ),
                        child: (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
                            ? Image.network(
                                item.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
                              ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '-${item.courseDiscount!.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.getLocalizedBadge(context),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.courseTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.instructorName,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 2),
                              Text(
                                item.averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              if (item.totalRatings > 0) ...[
                                const SizedBox(width: 2),
                                Text(
                                  '(${item.totalRatings})',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: textSubColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text('•', style: TextStyle(fontSize: 10, color: textSubColor)),
                          Text(
                            item.formattedDuration,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          if (item.totalLectures > 0) ...[
                            Text('•', style: TextStyle(fontSize: 10, color: textSubColor)),
                            Text(
                              item.formattedLectures,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: textSubColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$${item.finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(width: 6),
                    Text(
                      '\$${item.coursePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: textSubColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _handleRemoveFromWishlist(item),
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                    tooltip: context.loc.cartRemove,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _handleAddToCart(item),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 15),
                    label: Text(
                      context.loc.courseDetailsAddToCart,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
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

  // ================= TAB 2: CERTIFICATES =================
  Widget _buildCertificatesTab(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    if (_isLoadingCerts) {
      return _buildSkeletonCertificatesView();
    }

    if (_certificates.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
        children: [
          Center(
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
                  child: const Icon(Icons.workspace_premium_outlined, size: 40, color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                Text(
                  context.loc.certEmptyTitle,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 8),
                Text(
                  context.loc.certEmptyDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: AppButton(
                    label: context.loc.learningExploreButton,
                    icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/explore'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        for (final cert in _certificates) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openCertificate(cert),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert.courseTitle,
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${context.loc.certIssueDateLabel}: ${cert.formattedDate}',
                                  style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _openCertificate(cert),
                            icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                            label: Text(context.loc.certViewAndDownload, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _buildContinueWatchingHeroCard(
    EnrollmentModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      context.loc.learningHeroTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                Text(
                  context.loc.learningProgress(course.progressPercentage),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      course.thumbnailUrl!,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  course.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      course.instructorName,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    () {
                      final category = course.getLocalizedCategory(context);
                      if (category.isEmpty) return const SizedBox.shrink();
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      );
                    }(),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progressRatio,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/lesson-player', arguments: course.courseId),
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(
                          context.loc.learningContinue,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
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
    );
  }

  Widget _buildCourseCard(
    EnrollmentModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(context, '/course-details', arguments: course.courseId),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 80,
                        height: 68,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1D61E7), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                        ),
                        child: (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty)
                            ? Image.network(
                                course.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.school_rounded, color: Colors.white, size: 28),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.school_rounded, color: Colors.white, size: 28),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                course.instructorName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              () {
                                final category = course.getLocalizedCategory(context);
                                if (category.isEmpty) return const SizedBox.shrink();
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 2),
                              Text(
                                course.averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              if (course.totalRatings > 0) ...[
                                const SizedBox(width: 3),
                                Text(
                                  '(${course.totalRatings})',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textSubColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                              const SizedBox(width: 8),
                              Text(
                                course.formattedDuration,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: textSubColor,
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
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progressRatio,
                    minHeight: 5,
                    backgroundColor: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      course.isCompleted ? const Color(0xFF059669) : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${context.loc.learningProgress(course.progressPercentage)} • ${course.completedLectures}/${course.totalLectures} ${context.loc.learningLessons}',
                      style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                    ),
                    Text(
                      course.isCompleted
                          ? context.loc.learningCompletedFull
                          : context.loc.learningRemainingHours(course.remainingHours.toStringAsFixed(1)),
                      style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
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

  Widget _buildEmptyCoursesState(
    Color cardBg,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_outlined, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                context.loc.learningEmptyTitle,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.learningEmptySubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppButton(
                  label: context.loc.learningExploreButton,
                  icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/explore'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonLoadingView(Color cardBg, Color borderColor, bool isDark) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: SkeletonCourseCard(),
      ),
    );
  }

  Widget _buildSkeletonWishlistView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: SkeletonWishlistCard(),
      ),
    );
  }

  Widget _buildSkeletonCertificatesView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: 4,
      itemBuilder: (context, index) => const SkeletonCertificateCard(),
    );
  }
}
