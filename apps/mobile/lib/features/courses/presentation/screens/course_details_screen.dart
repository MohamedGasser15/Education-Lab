import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/presentation/providers/course_details_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_course_card.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int? courseId;
  final Map<String, dynamic>? initialCourseData;

  const CourseDetailsScreen({
    super.key,
    this.courseId,
    this.initialCourseData,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> with SingleTickerProviderStateMixin {
  int _activeCourseId = 0;
  bool _isDescriptionExpanded = false;
  late final CourseDetailsProvider _provider;
  int _selectedTabIndex = 0; // 0: Overview, 1: Curriculum, 2: Instructor, 3: Reviews
  bool _isAddingToCart = false;
  bool _isBuyingNow = false;

  @override
  void initState() {
    super.initState();
    _provider = CourseDetailsProvider();
    if (widget.courseId != null && widget.courseId! > 0) {
      _activeCourseId = widget.courseId!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.fetchCourseDetails(_activeCourseId);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activeCourseId == 0) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        _activeCourseId = args;
      } else if (args is String) {
        _activeCourseId = int.tryParse(args) ?? 0;
      } else if (args is Map) {
        _activeCourseId = int.tryParse(args['id']?.toString() ?? args['courseId']?.toString() ?? '0') ?? 0;
      }

      if (_activeCourseId > 0) {
        _provider.fetchCourseDetails(_activeCourseId);
      }
    }
  }

  void _shareCourse(CourseDetailsModel? course) {
    if (course == null) return;
    HapticFeedback.lightImpact();
    final url = '${ApiConstants.baseUrl.replaceAll('/api/', '')}/course/${course.id}';
    Clipboard.setData(
      ClipboardData(
        text: context.loc.courseShareMessage(course.title, url),
      ),
    );
    AppSnackbar.showSuccess(
      context,
      context.loc.courseShareCopied,
    );
  }

  void _openCoursePreviewModal(CourseDetailsModel course, {CourseLectureModel? initialLecture}) {
    final course = _provider.course;
    if (course == null) return;
    HapticFeedback.selectionClick();

    final cartProvider = context.read<CartProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _CoursePreviewPlayerModal(
          course: course,
          initialLecture: initialLecture,
          onEnrollNow: () async {
            Navigator.pop(ctx);
            if (!context.read<ProfileProvider>().isLoggedIn) {
              _showGuestLoginRequiredModal(context, course: course);
              return;
            }
            if (!cartProvider.isInCart(course.id)) {
              await cartProvider.addToCart(course.id);
            }
            if (mounted) {
              Navigator.pushNamed(context, '/checkout');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoggedIn = profileProvider.isLoggedIn;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final cartProvider = context.watch<CartProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final enrollmentProvider = context.watch<EnrollmentProvider>();

    final isEnrolled = enrollmentProvider.isEnrolled(_activeCourseId);
    final isWishlisted = wishlistProvider.isInWishlist(_activeCourseId);
    final isInCart = cartProvider.isInCart(_activeCourseId);

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<CourseDetailsProvider>(
        builder: (context, provider, _) {
          final course = provider.course;
          final isLoading = provider.isLoading && course == null;
          final error = provider.errorMessage;

          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: cardBg,
              elevation: 0,
              centerTitle: true,
              scrolledUnderElevation: 1,
              leading: IconButton(
                icon: Icon(
                  isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed('/main');
                  }
                },
              ),
              title: Text(
                course?.title ?? context.loc.courseDetailsDefaultTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                if (course != null)
                  IconButton(
                    tooltip: context.loc.courseDetailsTooltipShare,
                    icon: Icon(Icons.share_outlined, color: textColor, size: 21),
                    onPressed: () => _shareCourse(course),
                  ),
                if (course != null && isLoggedIn && !isEnrolled)
                  IconButton(
                    tooltip: context.loc.courseDetailsTooltipWishlist,
                    icon: Icon(
                      isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isWishlisted ? const Color(0xFFEF4444) : textColor,
                      size: 22,
                    ),
                    onPressed: () {
                      if (isEnrolled) return;
                      HapticFeedback.selectionClick();
                      wishlistProvider.toggleWishlist(course.id);
                    },
                  ),
                if (isLoggedIn)
                  IconButton(
                    tooltip: context.loc.courseDetailsTooltipCart,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: textColor, size: 22),
                        if (cartProvider.count > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                '${cartProvider.count}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
              ],
            ),
            body: isLoading
                ? _buildSkeletonLoading(cardBg, borderColor, isDark)
                : error != null && course == null
                    ? _buildErrorView(error, textColor, textSubColor)
                    : course == null
                        ? _buildErrorView(context.loc.courseDetailsNotFound, textColor, textSubColor)
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => provider.fetchCourseDetails(_activeCourseId, forceRefresh: true),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              padding: const EdgeInsets.only(bottom: 120),
                              children: [
                                // 1. Hero Preview Thumbnail & Play Button
                                _buildHeroMedia(course, cardBg, isDark, isAr),

                                const SizedBox(height: 12),

                                // 2. Header Title & Stats Card
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: _buildCourseHeaderInfo(course, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                                ),

                                const SizedBox(height: 16),

                                // 3. Segmented Navigation Tabs
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: _buildSegmentedTabs(cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                                ),

                                const SizedBox(height: 16),

                                // 4. Tab Content Area
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: _buildActiveTabContent(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                                ),

                                const SizedBox(height: 20),

                                // 5. Related Courses
                                if (provider.relatedCourses.isNotEmpty)
                                  _buildRelatedCourses(provider.relatedCourses, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                              ],
                            ),
                          ),
            bottomNavigationBar: (course != null && !isLoading)
                ? _buildStickyBottomBar(
                    course: course,
                    isEnrolled: isEnrolled,
                    isInCart: isInCart,
                    isLoggedIn: isLoggedIn,
                    cartProvider: cartProvider,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isDark: isDark,
                    isAr: isAr,
                  )
                : null,
          );
        },
      ),
    );
  }

  // ================= 1. HERO PREVIEW =================
  Widget _buildHeroMedia(CourseDetailsModel course, Color cardBg, bool isDark, bool isAr) {
    final hasPreview = course.hasFreePreview;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GestureDetector(
        onTap: hasPreview ? () => _openCoursePreviewModal(course) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: course.thumbnailUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: course.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            color: const Color(0xFF0F172A),
                            child: const Icon(Icons.school_rounded, color: Colors.white38, size: 48),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.school_rounded, color: Colors.white38, size: 48),
                        ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Center Play Button with Glow (Only shown if course has a preview)
                if (hasPreview)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 18,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                // Category / Level Badge Top
                Positioned(
                  top: 10,
                  right: isAr ? 10 : null,
                  left: isAr ? null : 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      course.getLocalizedCategory(context).isNotEmpty
                          ? course.getLocalizedCategory(context)
                          : context.loc.courseDetailsDefaultCategory,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                // Preview Tag Badge Bottom (Only shown if course has a preview)
                if (hasPreview)
                  Positioned(
                    bottom: 10,
                    left: isAr ? null : 10,
                    right: isAr ? 10 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            context.loc.previewCourseVideo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  // ================= 2. HEADER INFO & STATS =================
  Widget _buildCourseHeaderInfo(
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            course.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textColor,
              fontFamily: 'Tajawal',
              height: 1.35,
            ),
          ),
          if (course.shortDescription.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              course.shortDescription,
              style: TextStyle(
                fontSize: 12.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Rating and Student Counts
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 15, color: Color(0xFFD97706)),
                    const SizedBox(width: 3),
                    Text(
                      course.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.loc.courseDetailsTotalRatingsCount(course.totalRatings.toString()),
                style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'),
              ),
              const SizedBox(width: 8),
              Text('•', style: TextStyle(color: textSubColor)),
              const SizedBox(width: 8),
              Text(
                context.loc.courseDetailsStudents(course.enrollmentCount.toString()),
                style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Compact Instructor Pill
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: course.instructorAvatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: course.instructorAvatarUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            color: AppColors.primary,
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                        )
                      : Container(
                          color: AppColors.primary,
                          child: const Icon(Icons.person, color: Colors.white, size: 16),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                course.instructorName,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 14),

          // Meta Specs Row (Duration, Lectures, Language, Certificate)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetaSpecItem(Icons.timer_outlined, course.getFormattedDuration(context), textColor, textSubColor),
                _buildMetaSpecItem(Icons.play_lesson_outlined, context.loc.courseDetailsLecturesCount(course.calculatedTotalLectures.toString()), textColor, textSubColor),
                _buildMetaSpecItem(Icons.language_rounded, course.language, textColor, textSubColor),
                _buildMetaSpecItem(Icons.workspace_premium_outlined, context.loc.courseDetailsCertificateBadge, textColor, textSubColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaSpecItem(IconData icon, String text, Color textColor, Color textSubColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  // ================= 3. SEGMENTED TABS =================
  Widget _buildSegmentedTabs(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final tabs = [
      {'title': context.loc.courseDetailsTabOverview, 'icon': Icons.info_outline_rounded},
      {'title': context.loc.courseDetailsTabCurriculum, 'icon': Icons.menu_book_rounded},
      {'title': context.loc.courseDetailsTabInstructor, 'icon': Icons.person_outline_rounded},
      {'title': context.loc.courseDetailsTabReviews, 'icon': Icons.star_outline_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTabIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    tabs[index]['title'] as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= 4. ACTIVE TAB CONTENT =================
  Widget _buildActiveTabContent(
    CourseDetailsProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab(course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
      case 1:
        return _buildCurriculumTab(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
      case 2:
        return _buildInstructorTab(course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
      case 3:
        return _buildReviewsTab(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
      default:
        return const SizedBox.shrink();
    }
  }

  // TAB 1: OVERVIEW (Description first, then Learnings, then Requirements)
  Widget _buildOverviewTab(
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Description
        if (course.description.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.courseDetailsFullDescriptionTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  maxLines: _isDescriptionExpanded ? null : 4,
                  overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: textSubColor, fontFamily: 'Tajawal', height: 1.45),
                ),
                if (course.description.length > 180)
                  GestureDetector(
                    onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _isDescriptionExpanded ? context.loc.courseDetailsShowLess : context.loc.courseDetailsShowMore,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 2. What you'll learn
        if (course.learnings.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.courseDetailsWhatLearn,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: course.learnings.map((point) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_rounded, size: 15, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              point,
                              style: TextStyle(fontSize: 12, color: textColor, fontFamily: 'Tajawal', height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 3. Requirements
        if (course.requirements.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.checklist_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.courseDetailsRequirements,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: course.requirements.map((req) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(color: textSubColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req,
                              style: TextStyle(fontSize: 12, color: textColor, fontFamily: 'Tajawal', height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // TAB 2: CURRICULUM
  Widget _buildCurriculumTab(
    CourseDetailsProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final sections = course.sections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.courseDetailsCurriculumSectionsLectures(
                sections.length.toString(),
                course.calculatedTotalLectures.toString(),
              ),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSubColor, fontFamily: 'Tajawal'),
            ),
            if (sections.isNotEmpty)
              GestureDetector(
                onTap: () {
                  final anyExpanded = sections.any((s) => s.isExpanded);
                  if (anyExpanded) {
                    provider.collapseAllSections();
                  } else {
                    provider.expandAllSections();
                  }
                },
                child: Text(
                  sections.any((s) => s.isExpanded)
                      ? context.loc.courseDetailsCollapseAll
                      : context.loc.courseDetailsExpandAll,
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (sections.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Text(
                context.loc.courseDetailsCurriculumComingSoon,
                style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
              ),
            ),
          )
        else
          Column(
            children: List.generate(sections.length, (sIndex) {
              final section = sections[sIndex];
              final isExpanded = section.isExpanded;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => provider.toggleSection(sIndex),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: textColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                section.title,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.loc.courseDetailsSectionLecturesCount(section.lectures.length.toString()),
                              style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      Divider(height: 1, color: borderColor),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: section.lectures.length,
                        separatorBuilder: (_, _) => Divider(height: 1, color: borderColor.withValues(alpha: 0.5)),
                        itemBuilder: (ctx, lIndex) {
                          final lecture = section.lectures[lIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                            child: Row(
                              children: [
                                Icon(
                                  lecture.isArticle
                                      ? Icons.menu_book_rounded
                                      : Icons.play_circle_outline_rounded,
                                  size: 16,
                                  color: lecture.isFreePreview
                                      ? (lecture.isArticle ? const Color(0xFF3B82F6) : AppColors.primary)
                                      : textSubColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    lecture.title,
                                    style: TextStyle(fontSize: 11.5, color: textColor, fontFamily: 'Tajawal'),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: (lecture.isArticle ? const Color(0xFF3B82F6) : AppColors.primary).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    lecture.isArticle ? context.loc.articleWord : context.loc.videoWord,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: lecture.isArticle ? const Color(0xFF3B82F6) : AppColors.primary,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                                if (lecture.isFreePreview) ...[
                                  GestureDetector(
                                    onTap: () => _openCoursePreviewModal(course, initialLecture: lecture),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        context.loc.courseDetailsLecturePreviewBtn,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  lecture.formattedDuration,
                                  style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Inter'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }

  // TAB 3: INSTRUCTOR (Compact & Proportioned)
  Widget _buildInstructorTab(
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(
                context,
                '/instructor-profile',
                arguments: {
                  'id': course.instructorId,
                  'name': course.instructorName,
                  'role': course.instructorTitle ?? '',
                  'avatarUrl': course.instructorAvatarUrl,
                  'rating': course.averageRating,
                  'students': course.enrollmentCount.toString(),
                  'about': course.instructorAbout,
                },
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: course.instructorAvatarUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: course.instructorAvatarUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: AppColors.primary,
                              child: const Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                          )
                        : Container(
                            color: AppColors.primary,
                            child: const Icon(Icons.person, color: Colors.white, size: 24),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            course.instructorName,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                          const Spacer(),
                          Icon(
                            isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                            size: 18,
                            color: textSubColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        course.instructorTitle ?? context.loc.courseDetailsDefaultInstructorTitle,
                        style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3 Compact Stats Columns
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInstructorStat('${course.averageRating.toStringAsFixed(1)} ★', context.loc.courseDetailsInstructorRatingLabel, textColor, textSubColor),
                _buildInstructorStat('${course.enrollmentCount}', context.loc.courseDetailsInstructorStudentsLabel, textColor, textSubColor),
                _buildInstructorStat('${course.sections.length}', context.loc.courseDetailsInstructorSectionsLabel, textColor, textSubColor),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // About text
          Text(
            context.loc.courseDetailsAboutInstructorTitle,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 6),
          Text(
            (course.instructorAbout != null && course.instructorAbout!.isNotEmpty)
                ? course.instructorAbout!
                : context.loc.courseDetailsDefaultInstructorAbout,
            style: TextStyle(fontSize: 12, color: textSubColor, fontFamily: 'Tajawal', height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorStat(String value, String label, Color textColor, Color textSubColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Inter')),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Tajawal')),
      ],
    );
  }

  // TAB 4: REVIEWS
  Widget _buildReviewsTab(
    CourseDetailsProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final ratings = provider.ratings;
    final summary = provider.ratingSummary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                course.averageRating.toStringAsFixed(1),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Inter'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (_) => const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.loc.courseDetailsStudentRatingsCount(
                      (course.totalRatings > 0 ? course.totalRatings : 120).toString(),
                    ),
                    style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating Bars
          _buildRatingBarRow(5, summary.fiveStarRatio, textColor, textSubColor),
          _buildRatingBarRow(4, summary.fourStarRatio, textColor, textSubColor),
          _buildRatingBarRow(3, summary.threeStarRatio, textColor, textSubColor),
          _buildRatingBarRow(2, summary.twoStarRatio, textColor, textSubColor),
          _buildRatingBarRow(1, summary.oneStarRatio, textColor, textSubColor),

          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),

          if (ratings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  context.loc.courseDetailsNoWrittenReviews,
                  style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ratings.length > 3 ? 3 : ratings.length,
              separatorBuilder: (_, _) => Divider(height: 16, color: borderColor),
              itemBuilder: (ctx, index) {
                final r = ratings[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          child: Text(
                            r.userName.isNotEmpty ? r.userName[0].toUpperCase() : 'U',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            r.userName,
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                          ),
                        ),
                        Text(r.formattedDate, style: TextStyle(fontSize: 9.5, color: textSubColor, fontFamily: 'Inter')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (r.comment != null && r.comment!.isNotEmpty)
                      Text(
                        r.comment!,
                        style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal', height: 1.35),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRatingBarRow(int stars, double ratio, Color textColor, Color textSubColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text('$stars ★', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 28,
            child: Text(
              '${(ratio * 100).round()}%',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 9.5, color: textSubColor, fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 5. RELATED COURSES =================
  Widget _buildRelatedCourses(
    List<dynamic> relatedCourses,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.loc.courseDetailsRelatedCourses,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 196,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: relatedCourses.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (ctx, idx) {
              final c = relatedCourses[idx];
              final courseMap = {
                'id': c.id.toString(),
                'title': c.title,
                'arabicTitle': c.arabicTitle,
                'instructor': c.instructorName,
                'rating': c.rating,
                'reviews': c.reviewsCount.toString(),
                'price': '${c.price} EGP',
                'thumbnailUrl': c.thumbnailUrl,
                'gradient': c.gradient,
              };
              return HomeCourseCard(
                course: courseMap,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/course-details',
                    arguments: c.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= 6. STICKY BOTTOM BAR =================
  Widget _buildStickyBottomBar({
    required CourseDetailsModel course,
    required bool isEnrolled,
    required bool isInCart,
    required bool isLoggedIn,
    required CartProvider cartProvider,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
  }) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isFree = course.finalPrice == 0;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: borderColor.withValues(alpha: isDark ? 0.6 : 0.8),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        bottomInset > 0 ? bottomInset : 10,
      ),
      child: isEnrolled
            // Already Enrolled Button
            ? SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.pushNamed(
                      context,
                      '/lesson-player',
                      arguments: course.id > 0 ? course.id : widget.courseId,
                    );
                  },
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 24),
                  label: Text(
                    context.loc.courseDetailsResumeCourse,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              )
            // Purchase / Cart Bar
            : Row(
                children: [
                  // --- 1. Price Box ---
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFree)
                        Text(
                          context.loc.courseDetailsFree,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF10B981),
                            fontFamily: 'Tajawal',
                          ),
                        )
                      else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              course.finalPrice.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                fontFamily: 'Tajawal',
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'ج.م',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textSubColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        if (course.hasDiscount) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '${course.price.toStringAsFixed(0)} ج.م',
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '%${course.discountPercent}-',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF4444),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),

                  const SizedBox(width: 16),

                  // --- 2. Add to Cart Icon Button (Clean Square Pill) - Logged in only ---
                  if (isLoggedIn) ...[
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: OutlinedButton(
                        onPressed: _isAddingToCart
                            ? null
                            : () async {
                                HapticFeedback.selectionClick();
                                if (isInCart) {
                                  Navigator.pushNamed(context, '/cart');
                                } else {
                                  setState(() => _isAddingToCart = true);
                                  final success = await cartProvider.addToCart(course.id);
                                  if (mounted) {
                                    setState(() => _isAddingToCart = false);
                                    if (success) {
                                      AppSnackbar.showSuccess(
                                        context,
                                        context.loc.addedToCartSnackbar,
                                        actionLabel: context.loc.viewCartAction,
                                        onAction: () => Navigator.pushNamed(context, '/cart'),
                                      );
                                    }
                                  }
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: isInCart
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                          side: BorderSide(
                            color: isInCart ? AppColors.primary : borderColor,
                            width: isInCart ? 1.5 : 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isAddingToCart
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                ),
                              )
                            : Icon(
                                isInCart
                                    ? Icons.shopping_cart_checkout_rounded
                                    : Icons.add_shopping_cart_rounded,
                                color: isInCart ? AppColors.primary : textColor,
                                size: 22,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],

                  // --- 3. Buy Now Main Button (Prominent & Spacious) ---
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isBuyingNow
                            ? null
                            : () async {
                                HapticFeedback.selectionClick();
                                if (!isLoggedIn) {
                                  _showGuestLoginRequiredModal(context, course: course);
                                  return;
                                }
                                setState(() => _isBuyingNow = true);
                                if (!isInCart) {
                                  await cartProvider.addToCart(course.id);
                                }
                                if (mounted) {
                                  setState(() => _isBuyingNow = false);
                                  Navigator.pushNamed(context, '/checkout');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: _isBuyingNow
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.bolt_rounded, size: 20, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    context.loc.courseDetailsBuyNow,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  // ================= GUEST LOGIN REQUIRED MODAL =================
  void _showGuestLoginRequiredModal(BuildContext context, {required CourseDetailsModel course}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(ctx).padding.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),

              // Icon Circle with soft glow
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_person_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                context.loc.courseDetailsLoginRequiredTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 10),

              // Message
              Text(
                context.loc.courseDetailsLoginRequiredDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.login_rounded, size: 20, color: Colors.white),
                  label: Text(
                    context.loc.courseDetailsProceedToLogin,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    context.loc.commonCancel,
                    style: TextStyle(
                      color: textSubColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
  }

  // Skeleton Loading
  Widget _buildSkeletonLoading(Color cardBg, Color borderColor, bool isDark) {
    return AppSkeleton(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SkeletonBox(width: double.infinity, height: 190, borderRadius: 16),
          const SizedBox(height: 16),
          const SkeletonBox(width: 120, height: 16, borderRadius: 4),
          const SizedBox(height: 10),
          const SkeletonBox(width: double.infinity, height: 22, borderRadius: 4),
          const SizedBox(height: 8),
          const SkeletonBox(width: 180, height: 14, borderRadius: 4),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 40, borderRadius: 10),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 140, borderRadius: 14),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorView(String msg, Color textColor, Color textSubColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 54, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 150,
              child: AppButton(
                label: context.loc.courseDetailsTryAgain,
                icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                onPressed: () => _provider.fetchCourseDetails(_activeCourseId, forceRefresh: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= COURSE PREVIEW MODAL PLAYER (VIDEO & ARTICLE AWARE) =================
class _CoursePreviewPlayerModal extends StatefulWidget {
  final CourseDetailsModel course;
  final CourseLectureModel? initialLecture;
  final VoidCallback onEnrollNow;

  const _CoursePreviewPlayerModal({
    required this.course,
    this.initialLecture,
    required this.onEnrollNow,
  });

  @override
  State<_CoursePreviewPlayerModal> createState() => _CoursePreviewPlayerModalState();
}

class _CoursePreviewPlayerModalState extends State<_CoursePreviewPlayerModal> with SingleTickerProviderStateMixin {
  late CourseLectureModel _currentLecture;
  late List<CourseSectionModel> _freeSections;
  late List<CourseLectureModel> _previewLectures;

  // Real Video Player Controller
  VideoPlayerController? _videoController;
  bool _isNativeVideo = false;
  bool _isBuffering = false;
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _showControls = true;
  double _playbackSpeed = 1.0;
  double _articleFontSize = 14.0;

  // Fallback Simulation State
  double _simulatedSeconds = 0.0;
  double _simulatedTotalSeconds = 320.0;
  Timer? _simulatedTimer;
  Timer? _controlsTimer;

  // Waveform animation
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Collect ONLY the Free Sections from backend
    final sections = widget.course.sections;
    _freeSections = sections
        .where((s) => s.isFreePreview || s.lectures.any((l) => l.isFreePreview))
        .map((s) {
          final freeLectures = s.isFreePreview
              ? s.lectures
              : s.lectures.where((l) => l.isFreePreview).toList();
          return CourseSectionModel(
            id: s.id,
            title: s.title,
            order: s.order,
            courseId: s.courseId,
            isFreePreview: true,
            lectures: freeLectures,
            isExpanded: true,
          );
        })
        .where((s) => s.lectures.isNotEmpty)
        .toList();

    _previewLectures = _freeSections.expand((s) => s.lectures).toList();

    if (_previewLectures.isEmpty && widget.initialLecture != null) {
      _previewLectures = [widget.initialLecture!];
    }

    if (_previewLectures.isNotEmpty) {
      _currentLecture = widget.initialLecture ?? _previewLectures.first;
      _initLecture(_currentLecture);
    }
    _resetControlsTimer();
  }

  String _getVideoUrl(CourseLectureModel lecture) {
    if (lecture.videoUrl != null && lecture.videoUrl!.trim().isNotEmpty) {
      return ApiConstants.formatImageUrl(lecture.videoUrl);
    }
    return '';
  }

  Future<void> _initLecture(CourseLectureModel lecture) async {
    _simulatedTimer?.cancel();
    final oldController = _videoController;

    if (lecture.isArticle) {
      // It's an Article
      if (oldController != null) {
        try {
          oldController.removeListener(_videoListener);
          await oldController.dispose();
        } catch (_) {}
      }
      _videoController = null;
      setState(() {
        _isBuffering = false;
        _isNativeVideo = false;
        _isPlaying = false;
      });
      return;
    }

    // It's a Video
    setState(() {
      _isBuffering = true;
      _isNativeVideo = false;
      _simulatedSeconds = 0.0;
      _simulatedTotalSeconds = (lecture.duration > 0 ? lecture.duration : 320).toDouble();
      _isPlaying = true;
    });

    if (oldController != null) {
      try {
        oldController.removeListener(_videoListener);
        await oldController.dispose();
      } catch (_) {}
    }

    final url = _getVideoUrl(lecture);
    if (url.isEmpty) {
      setState(() {
        _isBuffering = false;
        _isNativeVideo = false;
        _isPlaying = false;
      });
      return;
    }

    bool nativeSuccess = false;

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _videoController = controller;
      await controller.initialize();

      if (mounted) {
        controller.addListener(_videoListener);
        await controller.setPlaybackSpeed(_playbackSpeed);
        await controller.setVolume(_isMuted ? 0.0 : 1.0);
        await controller.play();

        setState(() {
          _isNativeVideo = true;
          _isBuffering = false;
          _isPlaying = true;
        });
        nativeSuccess = true;
      }
    } catch (_) {
      nativeSuccess = false;
    }

    if (!nativeSuccess && mounted) {
      setState(() {
        _isNativeVideo = false;
        _isBuffering = false;
        _isPlaying = true;
      });
      _startSimulatedEngine();
    }

    _resetControlsTimer();
  }

  void _startSimulatedEngine() {
    _simulatedTimer?.cancel();
    _simulatedTimer = Timer.periodic(const Duration(milliseconds: 250), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_isPlaying && !_isBuffering) {
        setState(() {
          _simulatedSeconds += 0.25 * _playbackSpeed;
          if (_simulatedSeconds >= _simulatedTotalSeconds) {
            _simulatedSeconds = _simulatedTotalSeconds;
            _isPlaying = false;
            // Auto advance
            final currentIndex = _previewLectures.indexWhere((l) => l.id == _currentLecture.id);
            if (currentIndex != -1 && currentIndex + 1 < _previewLectures.length) {
              _switchLecture(_previewLectures[currentIndex + 1]);
            }
          }
        });
      }
    });
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;
    final isPlaying = _videoController!.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    } else {
      setState(() {});
    }

    if (_videoController!.value.isInitialized &&
        _videoController!.value.position >= _videoController!.value.duration &&
        _videoController!.value.duration > Duration.zero) {
      final currentIndex = _previewLectures.indexWhere((l) => l.id == _currentLecture.id);
      if (currentIndex != -1 && currentIndex + 1 < _previewLectures.length) {
        _switchLecture(_previewLectures[currentIndex + 1]);
      }
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _simulatedTimer?.cancel();
    _waveController.dispose();
    if (_videoController != null) {
      try {
        _videoController!.removeListener(_videoListener);
        _videoController!.dispose();
      } catch (_) {}
    }
    super.dispose();
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (_isPlaying) {
      _controlsTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetControlsTimer();
    }
  }

  void _togglePlayPause() {
    HapticFeedback.selectionClick();
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        setState(() {
          _isPlaying = false;
          _showControls = true;
        });
      } else {
        _videoController!.play();
        setState(() {
          _isPlaying = true;
        });
        _resetControlsTimer();
      }
    } else {
      // Simulated Engine
      setState(() {
        _isPlaying = !_isPlaying;
        if (_isPlaying && _simulatedSeconds >= _simulatedTotalSeconds) {
          _simulatedSeconds = 0.0;
        }
      });
      if (_isPlaying) {
        _resetControlsTimer();
      } else {
        setState(() => _showControls = true);
      }
    }
  }

  void _seekRelative(int secondsDelta) {
    HapticFeedback.selectionClick();
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      final current = _videoController!.value.position;
      final target = current + Duration(seconds: secondsDelta);
      final duration = _videoController!.value.duration;
      if (target < Duration.zero) {
        _videoController!.seekTo(Duration.zero);
      } else if (target > duration) {
        _videoController!.seekTo(duration);
      } else {
        _videoController!.seekTo(target);
      }
    } else {
      setState(() {
        _simulatedSeconds = (_simulatedSeconds + secondsDelta).clamp(0.0, _simulatedTotalSeconds);
      });
    }
    _resetControlsTimer();
  }

  void _toggleSpeed() {
    HapticFeedback.selectionClick();
    double nextSpeed = 1.0;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 2.0;
    } else {
      nextSpeed = 1.0;
    }

    setState(() => _playbackSpeed = nextSpeed);
    if (_isNativeVideo && _videoController != null) {
      _videoController!.setPlaybackSpeed(nextSpeed);
    }
    _resetControlsTimer();
  }

  void _toggleMute() {
    HapticFeedback.selectionClick();
    setState(() => _isMuted = !_isMuted);
    if (_isNativeVideo && _videoController != null) {
      _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
    }
    _resetControlsTimer();
  }

  void _switchLecture(CourseLectureModel lecture) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentLecture = lecture;
      _showControls = true;
    });
    _initLecture(lecture);
  }

  String _formatDuration(Duration duration) {
    final mins = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;

    // Adaptive Theme Colors for Light & Dark Mode
    final sheetBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final currentIndex = _previewLectures.indexWhere((l) => l.id == _currentLecture.id);
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex != -1 && currentIndex + 1 < _previewLectures.length;

    // Position & Duration (Native or Simulated)
    final Duration position = _isNativeVideo && _videoController != null
        ? _videoController!.value.position
        : Duration(milliseconds: (_simulatedSeconds * 1000).toInt());

    final Duration duration = _isNativeVideo && _videoController != null && _videoController!.value.duration > Duration.zero
        ? _videoController!.value.duration
        : Duration(seconds: _simulatedTotalSeconds.toInt());

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Drag Handle & Title Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: sheetBg,
              border: Border(bottom: BorderSide(color: borderColor)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _currentLecture.isArticle
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _currentLecture.isArticle
                              ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _currentLecture.isArticle ? Icons.menu_book_rounded : Icons.play_circle_filled_rounded,
                            size: 13,
                            color: _currentLecture.isArticle ? const Color(0xFF3B82F6) : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _currentLecture.isArticle
                                ? context.loc.articleLecture
                                : context.loc.freeDemoVideo,
                            style: TextStyle(
                              color: _currentLecture.isArticle ? const Color(0xFF3B82F6) : AppColors.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _currentLecture.isArticle
                          ? context.loc.articleViewer
                          : context.loc.courseVideoPlayer,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: textSecondary, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // MEDIA CANVAS (VIDEO OR ARTICLE READER)
          if (_currentLecture.isArticle)
            // ================= 1. RICH ARTICLE READER =================
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Article Header Info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.article_outlined, color: Color(0xFF3B82F6), size: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentLecture.title,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  Text(
                                    context.loc.courseDetailsEstimatedReading,
                                    style: TextStyle(color: textSecondary, fontSize: 10.5, fontFamily: 'Tajawal'),
                                  ),
                                ],
                              ),
                            ),
                            // Font Size Adjuster
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.text_decrease_rounded, size: 18, color: textSecondary),
                                  onPressed: () {
                                    if (_articleFontSize > 12) {
                                      setState(() => _articleFontSize -= 1);
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.text_increase_rounded, size: 18, color: textSecondary),
                                  onPressed: () {
                                    if (_articleFontSize < 20) {
                                      setState(() => _articleFontSize += 1);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: borderColor),
                        const SizedBox(height: 12),

                        // Article Body Text
                        SelectableText(
                          (_currentLecture.articleContent != null && _currentLecture.articleContent!.trim().isNotEmpty)
                              ? _currentLecture.articleContent!
                              : context.loc.courseDetailsSampleArticleContent,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: _articleFontSize,
                            fontFamily: 'Tajawal',
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // ================= 2. 16:9 PRO VIDEO CANVAS & CONTROLLER =================
            AspectRatio(
              aspectRatio: 16 / 9,
              child: GestureDetector(
                onTap: _toggleControlsVisibility,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Native Video Surface OR Dynamic High-Quality Video Visualizer
                      if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized)
                        Center(
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio > 0
                                ? _videoController!.value.aspectRatio
                                : (16 / 9),
                            child: VideoPlayer(_videoController!),
                          ),
                        )
                      else ...[
                        // Dynamic Video Visualizer Backdrop
                        if (widget.course.thumbnailUrl.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: widget.course.thumbnailUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorWidget: (_, _, _) => Container(
                              color: const Color(0xFF0F172A),
                              child: const Icon(Icons.school_rounded, color: Colors.white24, size: 48),
                            ),
                          )
                        else
                          Container(color: const Color(0xFF0F172A)),

                        // Subtle Dark Video Overlay
                        Container(color: Colors.black.withValues(alpha: 0.45)),

                        // Dynamic Audio/Video Equalizer Pulse
                        if (_isPlaying && !_isBuffering)
                          Positioned(
                            bottom: 48,
                            right: isAr ? 14 : null,
                            left: isAr ? null : 14,
                            child: AnimatedBuilder(
                              animation: _waveController,
                              builder: (context, _) {
                                return Row(
                                  children: List.generate(5, (index) {
                                    final height = 6.0 + 14.0 * ((index % 2 == 0 ? _waveController.value : 1.0 - _waveController.value));
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                      width: 3.5,
                                      height: height,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                      ],

                      // 2. Buffering Spinner
                      if (_isBuffering)
                        const Center(
                          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
                        ),

                      // 3. Dark Overlay Tint for Controls
                      if (_showControls && !_isBuffering)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          color: Colors.black.withValues(alpha: 0.52),
                        ),

                      // 4. CONTROLS OVERLAY (Auto-fading)
                      if (_showControls && !_isBuffering) ...[
                        // Top Bar info (Badge + Quality + Sound + Speed)
                        Positioned(
                          top: 10,
                          left: 12,
                          right: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: const Text(
                                  '1080p Full HD',
                                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: _toggleMute,
                                  ),
                                  GestureDetector(
                                    onTap: _toggleSpeed,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '${_playbackSpeed}x',
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Center Playback Buttons (-10s | Play/Pause | +10s)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 30),
                              onPressed: () => _seekRelative(-10),
                            ),
                            const SizedBox(width: 18),
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            IconButton(
                              icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 30),
                              onPressed: () => _seekRelative(10),
                            ),
                          ],
                        ),

                        // Bottom Scrubber Bar & Timestamps
                        Positioned(
                          bottom: 4,
                          left: 10,
                          right: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3.5,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.white,
                                ),
                                child: Slider(
                                  value: position.inMilliseconds.toDouble().clamp(
                                    0.0,
                                    duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                                  ),
                                  max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                                  onChanged: (val) {
                                    if (_isNativeVideo && _videoController != null) {
                                      _videoController!.seekTo(Duration(milliseconds: val.toInt()));
                                    } else {
                                      setState(() {
                                        _simulatedSeconds = val / 1000.0;
                                      });
                                    }
                                    _resetControlsTimer();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                                    ),
                                    Row(
                                      children: [
                                        if (hasPrevious)
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(Icons.skip_previous_rounded, color: Colors.white70, size: 20),
                                            onPressed: () => _switchLecture(_previewLectures[currentIndex - 1]),
                                          ),
                                        if (hasNext) ...[
                                          const SizedBox(width: 12),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(Icons.skip_next_rounded, color: Colors.white70, size: 20),
                                            onPressed: () => _switchLecture(_previewLectures[currentIndex + 1]),
                                          ),
                                        ],
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                              context,
                                              '/lesson-player',
                                              arguments: widget.course.id,
                                            );
                                          },
                                          child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 22),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // Current Lecture Info Tile (Themed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentLecture.title,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.course.title,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 11,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (_currentLecture.isArticle ? const Color(0xFF3B82F6) : const Color(0xFF10B981)).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: (_currentLecture.isArticle ? const Color(0xFF3B82F6) : const Color(0xFF10B981)).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _currentLecture.isArticle
                        ? context.loc.readingNow
                        : context.loc.playingNow,
                    style: TextStyle(
                      color: _currentLecture.isArticle ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FREE SECTIONS & LECTURES LIST ONLY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_freeSections.isEmpty && _previewLectures.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        context.loc.noLecturesInFreeSection,
                        style: TextStyle(color: textSecondary, fontSize: 13, fontFamily: 'Tajawal'),
                      ),
                    ),
                  )
                else
                  ..._freeSections.map((section) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Free Section Header
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.folder_open_rounded, color: AppColors.primary, size: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        section.title,
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      Text(
                                        context.loc.freeLecturesCount(section.lectures.length.toString()),
                                        style: TextStyle(color: textSecondary, fontSize: 10.5, fontFamily: 'Tajawal'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    context.loc.freeSection,
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: borderColor),

                          // Lectures in this Free Section (Video or Article Aware)
                          ...section.lectures.map((lec) {
                            final isSelected = lec.id == _currentLecture.id;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (lec.isArticle
                                        ? const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.08)
                                        : AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08))
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary,
                                        width: 1.2,
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                onTap: () => _switchLecture(lec),
                                leading: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary)
                                        : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    lec.isArticle
                                        ? Icons.menu_book_rounded
                                        : (isSelected && _isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded),
                                    color: isSelected ? Colors.white : (lec.isArticle ? const Color(0xFF3B82F6) : textSecondary),
                                    size: 15,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lec.title,
                                        style: TextStyle(
                                          color: isSelected
                                              ? (lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary)
                                              : textPrimary,
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          fontFamily: 'Tajawal',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: (lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        lec.isArticle ? context.loc.articleWord : context.loc.videoWord,
                                        style: TextStyle(
                                          color: lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  lec.formattedDuration,
                                  style: TextStyle(
                                    color: isSelected ? (lec.isArticle ? const Color(0xFF3B82F6) : AppColors.primary) : textSecondary,
                                    fontSize: 10.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 6),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          // BOTTOM ENROLLMENT CTA BAR (Themed)
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 12),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.finalPrice == 0 ? context.loc.courseDetailsFree : '${widget.course.finalPrice.toStringAsFixed(0)} EGP',
                      style: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w900, fontFamily: 'Tajawal'),
                    ),
                    if (widget.course.hasDiscount)
                      Text(
                        '${widget.course.price.toStringAsFixed(0)} EGP',
                        style: TextStyle(color: textSecondary, fontSize: 11, decoration: TextDecoration.lineThrough, fontFamily: 'Inter'),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: widget.onEnrollNow,
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: Text(
                        context.loc.enrollInFullCourse,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
