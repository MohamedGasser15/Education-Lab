import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/data/models/instructor_profile_model.dart';
import 'package:mobile/features/home/presentation/providers/instructor_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructorProfileScreen extends StatefulWidget {
  final String? instructorId;
  final HomeInstructorDTO? initialDto;
  final Map<String, dynamic>? initialData;

  const InstructorProfileScreen({
    super.key,
    this.instructorId,
    this.initialDto,
    this.initialData,
  });

  @override
  State<InstructorProfileScreen> createState() => _InstructorProfileScreenState();
}

class _InstructorProfileScreenState extends State<InstructorProfileScreen> {
  late final InstructorProfileProvider _provider;
  final ScrollController _scrollController = ScrollController();
  bool _isBioExpanded = false;
  bool _showAppBarTitle = false;
  String _resolvedId = '';

  // Courses single-tap infinite scroll & lazy loading
  static const int _coursesPageSize = 4;
  int _displayedCoursesCount = _coursesPageSize;
  bool _isCoursesInfiniteScrollActive = false;
  bool _isLoadingMoreCourses = false;
  final GlobalKey _coursesBottomKey = GlobalKey();

  // Reviews single-tap infinite scroll & lazy loading
  static const int _reviewsPageSize = 3;
  int _displayedReviewsCount = _reviewsPageSize;
  bool _isReviewsInfiniteScrollActive = false;
  bool _isLoadingMoreReviews = false;
  final GlobalKey _reviewsBottomKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _provider = InstructorProfileProvider();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > 140 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (offset <= 140 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }

    _checkAndTriggerInfiniteScroll();
  }

  void _checkAndTriggerInfiniteScroll() {
    if (!mounted) return;
    final screenHeight = MediaQuery.of(context).size.height;

    // 1. Courses Infinite Scroll (activated upon single tap on courses button)
    if (_isCoursesInfiniteScrollActive && !_isLoadingMoreCourses) {
      final courses = _provider.filteredCourses;
      if (_displayedCoursesCount < courses.length) {
        final keyContext = _coursesBottomKey.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            final position = box.localToGlobal(Offset.zero);
            if (position.dy <= screenHeight + 500) {
              _loadMoreCoursesInfinite();
            }
          }
        }
      }
    }

    // 2. Reviews Infinite Scroll (activated upon single tap on reviews button)
    if (_isReviewsInfiniteScrollActive && !_isLoadingMoreReviews) {
      final reviews = _provider.ratingsOverview?.reviews ?? 
                      _provider.profile?.ratingsOverview?.reviews ?? [];
      if (_displayedReviewsCount < reviews.length) {
        final keyContext = _reviewsBottomKey.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            final position = box.localToGlobal(Offset.zero);
            if (position.dy <= screenHeight + 500) {
              _loadMoreReviewsInfinite(reviews.length);
            }
          }
        } else if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final currentScroll = _scrollController.offset;
          if (maxScroll - currentScroll <= 500) {
            _loadMoreReviewsInfinite(reviews.length);
          }
        }
      }
    }
  }

  void _loadMoreCoursesInfinite() {
    if (_isLoadingMoreCourses) return;
    final courses = _provider.filteredCourses;
    if (_displayedCoursesCount >= courses.length) return;

    setState(() {
      _isLoadingMoreCourses = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _displayedCoursesCount += _coursesPageSize;
        _isLoadingMoreCourses = false;
      });
    });
  }

  void _loadMoreReviewsInfinite(int totalReviews) {
    if (_isLoadingMoreReviews) return;
    if (_displayedReviewsCount >= totalReviews) return;

    setState(() {
      _isLoadingMoreReviews = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _displayedReviewsCount += _reviewsPageSize;
        _isLoadingMoreReviews = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolvedId.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      HomeInstructorDTO? dto = widget.initialDto;
      Map<String, dynamic>? data = widget.initialData;
      String id = widget.instructorId ?? '';

      if (args is String) {
        id = args;
      } else if (args is HomeInstructorDTO) {
        dto = args;
        id = args.id;
      } else if (args is Map<String, dynamic>) {
        data = args;
        id = args['id']?.toString() ?? '';
      }

      _resolvedId = id.isNotEmpty ? id : '1';
      _provider.loadInstructorProfile(_resolvedId, initialDto: dto, rawData: data);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _provider.dispose();
    super.dispose();
  }

  void _shareProfile(InstructorProfileModel? profile) {
    HapticFeedback.mediumImpact();
    final name = (profile != null && profile.name.trim().isNotEmpty)
        ? profile.name
        : context.loc.instructorDefaultName;
    Clipboard.setData(ClipboardData(text: 'https://edulab.app/instructor/$_resolvedId'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              context.loc.instructorProfileLinkCopied(name),
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);

    return ChangeNotifierProvider<InstructorProfileProvider>.value(
      value: _provider,
      child: Consumer<InstructorProfileProvider>(
        builder: (context, provider, _) {
          final profile = provider.profile;
          final isLoading = provider.isLoading;

          return Scaffold(
            backgroundColor: bgColor,
            body: RefreshIndicator(
              onRefresh: () => provider.loadInstructorProfile(_resolvedId),
              color: AppColors.primary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _checkAndTriggerInfiniteScroll();
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // 1. Udemy App Bar
                  _buildSliverAppBar(
                    context: context,
                    profile: profile,
                    isDark: isDark,
                    isAr: isAr,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),

                  // Content
                  if (isLoading)
                    SliverToBoxAdapter(
                      child: _buildSkeletonLoading(cardBg, borderColor, isDark),
                    )
                  else if (profile != null)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Instructor Hero Header (Udemy Style)
                          _buildInstructorHero(
                            context: context,
                            profile: profile,
                            isDark: isDark,
                            isAr: isAr,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            textSubColor: textSubColor,
                          ),

                          // 3. Udemy 3-Box Stats Row
                          _buildUdemyStatsBox(
                            context: context,
                            profile: profile,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            textSubColor: textSubColor,
                          ),

                          // 4. Share Profile Button (Matching MVC)
                          _buildShareButton(
                            context: context,
                            profile: profile,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                          ),

                          // 5. Social Links (Website, LinkedIn, GitHub, X, etc.)
                          if (_hasSocialLinks(profile))
                            _buildSocialLinksRow(
                              profile: profile,
                              isDark: isDark,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),

                          // 6. About Me Section (Expandable)
                          if (profile.about.isNotEmpty)
                            _buildAboutSection(
                              context: context,
                              profile: profile,
                              isDark: isDark,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                              textSubColor: textSubColor,
                            ),

                          // 7. Expertise / Subjects Tags
                          if (profile.subjects.isNotEmpty)
                            _buildSubjectsSection(
                              context: context,
                              profile: profile,
                              isDark: isDark,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),

                          // 8. Instructor's Courses Section Header & Filter
                          _buildCoursesHeader(
                            context: context,
                            provider: provider,
                            isDark: isDark,
                            isAr: isAr,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            textSubColor: textSubColor,
                          ),

                          // 9. Udemy Courses List
                          _buildCoursesList(
                            context: context,
                            provider: provider,
                            isDark: isDark,
                            isAr: isAr,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            textSubColor: textSubColor,
                          ),

                          // 10. Student Feedback Overview (Udemy Style)
                          _buildStudentFeedbackSection(
                            context: context,
                            profile: profile,
                            ratings: provider.ratingsOverview ?? profile.ratingsOverview,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            textSubColor: textSubColor,
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. Sliver App Bar
  // -------------------------------------------------------------
  Widget _buildSliverAppBar({
    required BuildContext context,
    required InstructorProfileModel? profile,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color textColor,
  }) {
    return SliverAppBar(
      pinned: true,
      elevation: _showAppBarTitle ? 1 : 0,
      scrolledUnderElevation: 1,
      backgroundColor: cardBg,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isAr ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
            color: textColor,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: AnimatedOpacity(
        opacity: _showAppBarTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          (profile != null && profile.name.trim().isNotEmpty)
              ? profile.name
              : context.loc.instructorProfileTitle,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share_outlined,
              color: textColor,
              size: 18,
            ),
          ),
          onPressed: () => _shareProfile(profile),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // -------------------------------------------------------------
  // 2. Instructor Hero (Udemy layout)
  // -------------------------------------------------------------
  Widget _buildInstructorHero({
    required BuildContext context,
    required InstructorProfileModel profile,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final displayName = profile.name.trim().isNotEmpty
        ? profile.name.trim()
        : context.loc.instructorDefaultName;
    final displayHeadline = profile.headline.trim().isNotEmpty
        ? profile.headline.trim()
        : context.loc.instructorProfileDefaultHeadline;
    final initial = displayName.isNotEmpty
        ? displayName[0]
        : (isAr ? 'م' : 'I');

    return Container(
      color: cardBg,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Verified badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profile.profileImageUrl != null && profile.profileImageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: profile.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => _buildAvatarFallback(initial),
                            )
                          : _buildAvatarFallback(initial),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: isAr ? null : 0,
                    left: isAr ? 0 : null,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name & Headline
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.instructorProfileBadge,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1.1,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      displayHeadline,
                      style: TextStyle(
                        fontSize: 13,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                        height: 1.35,
                      ),
                    ),
                    if (profile.location != null && profile.location!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: textSubColor),
                          const SizedBox(width: 4),
                          Text(
                            profile.location!,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: textSubColor,
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
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. Udemy Signature 3-Box Stats Row
  // -------------------------------------------------------------
  Widget _buildUdemyStatsBox({
    required BuildContext context,
    required InstructorProfileModel profile,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Stat 1: Total Students
          _buildUdemyStatItem(
            value: _formatNumber(profile.totalStudents),
            label: context.loc.instructorProfileTotalStudents,
            icon: Icons.people_alt_rounded,
            iconColor: const Color(0xFF2563EB),
            textColor: textColor,
            subColor: textSubColor,
          ),
          _buildStatDivider(isDark),

          // Stat 2: Rating
          _buildUdemyStatItem(
            value: '${profile.rating.toStringAsFixed(1)} ★',
            label: context.loc.instructorProfileRating,
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFD97706),
            textColor: textColor,
            subColor: textSubColor,
          ),
          _buildStatDivider(isDark),

          // Stat 3: Courses Count
          _buildUdemyStatItem(
            value: profile.coursesCount.toString(),
            label: context.loc.instructorProfileCourses,
            icon: Icons.play_circle_filled_rounded,
            iconColor: const Color(0xFF059669),
            textColor: textColor,
            subColor: textSubColor,
          ),
        ],
      ),
    );
  }

  Widget _buildUdemyStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color subColor,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subColor,
              fontFamily: 'Tajawal',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 36,
      width: 1,
      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
    );
  }

  // -------------------------------------------------------------
  // 4. Share Profile Button (Matching MVC shareProfileButton)
  // -------------------------------------------------------------
  Widget _buildShareButton({
    required BuildContext context,
    required InstructorProfileModel profile,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _shareProfile(profile),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.share_outlined, size: 17, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                context.loc.instructorProfileShare,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. Social Links Row (Side-by-side 4-item external launchers)
  // -------------------------------------------------------------
  bool _hasSocialLinks(InstructorProfileModel profile) {
    return (profile.linkedInUrl != null && profile.linkedInUrl!.trim().isNotEmpty) ||
        (profile.gitHubUrl != null && profile.gitHubUrl!.trim().isNotEmpty) ||
        (profile.twitterUrl != null && profile.twitterUrl!.trim().isNotEmpty) ||
        (profile.websiteUrl != null && profile.websiteUrl!.trim().isNotEmpty) ||
        (profile.facebookUrl != null && profile.facebookUrl!.trim().isNotEmpty);
  }

  Future<void> _openSocialUrl(String rawUrl) async {
    var url = rawUrl.trim();
    if (url.isEmpty) return;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}

    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }

    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {}
    }

    if (!launched && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      final errorMsg = context.loc.instructorProfileLinkOpenError;
      await Clipboard.setData(ClipboardData(text: url));
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildSocialLinksRow({
    required InstructorProfileModel profile,
    required bool isDark,
    required Color borderColor,
    required Color textColor,
  }) {
    final items = <_InstructorSocialItem>[
      if (profile.linkedInUrl != null && profile.linkedInUrl!.trim().isNotEmpty)
        _InstructorSocialItem(
          icon: const FaIcon(FontAwesomeIcons.linkedin, size: 18, color: Color(0xFF0A66C2)),
          label: 'LinkedIn',
          url: profile.linkedInUrl!,
          brandColor: const Color(0xFF0A66C2),
        ),
      if (profile.gitHubUrl != null && profile.gitHubUrl!.trim().isNotEmpty)
        _InstructorSocialItem(
          icon: FaIcon(FontAwesomeIcons.github, size: 18, color: isDark ? Colors.white : const Color(0xFF24292F)),
          label: 'GitHub',
          url: profile.gitHubUrl!,
          brandColor: isDark ? Colors.white70 : const Color(0xFF24292F),
        ),
      if (profile.twitterUrl != null && profile.twitterUrl!.trim().isNotEmpty)
        _InstructorSocialItem(
          icon: FaIcon(FontAwesomeIcons.xTwitter, size: 17, color: isDark ? Colors.white : const Color(0xFF0F1419)),
          label: 'X (Twitter)',
          url: profile.twitterUrl!,
          brandColor: isDark ? Colors.white70 : const Color(0xFF0F1419),
        ),
      if (profile.websiteUrl != null && profile.websiteUrl!.trim().isNotEmpty)
        _InstructorSocialItem(
          icon: const Icon(Icons.language_rounded, size: 19, color: AppColors.primary),
          label: context.loc.instructorProfileWebsite,
          url: profile.websiteUrl!,
          brandColor: AppColors.primary,
        ),
      if (profile.facebookUrl != null && profile.facebookUrl!.trim().isNotEmpty)
        _InstructorSocialItem(
          icon: const FaIcon(FontAwesomeIcons.facebook, size: 18, color: Color(0xFF1877F2)),
          label: 'Facebook',
          url: profile.facebookUrl!,
          brandColor: const Color(0xFF1877F2),
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    final bool distributeEqually = items.length >= 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        mainAxisAlignment: distributeEqually ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            if (distributeEqually)
              Expanded(
                child: _buildSocialButtonItem(
                  item: items[i],
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              )
            else
              SizedBox(
                width: 96,
                child: _buildSocialButtonItem(
                  item: items[i],
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSocialButtonItem({
    required _InstructorSocialItem item,
    required bool isDark,
    required Color borderColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _openSocialUrl(item.url);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : borderColor,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.brandColor.withValues(alpha: isDark ? 0.16 : 0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: item.icon,
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 6. About Me Section (Udemy Dynamic Expandable Bio)
  // -------------------------------------------------------------
  Widget _buildAboutSection({
    required BuildContext context,
    required InstructorProfileModel profile,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final isAr = context.isArabic;
    final textStyle = TextStyle(
      fontSize: 13,
      height: 1.55,
      color: textSubColor,
      fontFamily: 'Tajawal',
    );

    final aboutText = profile.about.trim().isNotEmpty
        ? profile.about.trim()
        : context.loc.instructorProfileDefaultBio;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.instructorProfileAboutMe,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final span = TextSpan(text: aboutText, style: textStyle);
              final tp = TextPainter(
                text: span,
                maxLines: 4,
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              );
              tp.layout(maxWidth: constraints.maxWidth);
              final bool isLongText = tp.didExceedMaxLines;

              if (!isLongText) {
                return Text(
                  aboutText,
                  style: textStyle,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _isBioExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    firstChild: Text(
                      aboutText,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                    secondChild: Text(
                      aboutText,
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _isBioExpanded = !_isBioExpanded);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isBioExpanded
                                ? context.loc.instructorProfileShowLess
                                : context.loc.instructorProfileShowMore,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isBioExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 7. Expertise & Subjects Tags
  // -------------------------------------------------------------
  Widget _buildSubjectsSection({
    required BuildContext context,
    required InstructorProfileModel profile,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.instructorProfileExpertise,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.subjects.map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 8. My Courses Section Header & Filter
  // -------------------------------------------------------------
  Widget _buildCoursesHeader({
    required BuildContext context,
    required InstructorProfileProvider provider,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final sortOptions = [
      context.loc.instructorProfileSortAll,
      context.loc.instructorProfileSortTopRated,
      context.loc.instructorProfileSortPopular,
      context.loc.instructorProfileSortNewest,
    ];

    final count = provider.filteredCourses.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.loc.instructorProfileCoursesTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(sortOptions.length, (idx) {
                final isSelected = provider.selectedSortIndex == idx;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    showCheckmark: true,
                    checkmarkColor: Colors.white,
                    label: Text(
                      sortOptions[idx],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: cardBg,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _displayedCoursesCount = _coursesPageSize;
                        _isLoadingMoreCourses = false;
                      });
                      provider.setSortIndex(idx);
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 9. Udemy Mobile Course Cards List
  // -------------------------------------------------------------
  Widget _buildCoursesList({
    required BuildContext context,
    required InstructorProfileProvider provider,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final courses = provider.filteredCourses;

    if (courses.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: textSubColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                context.loc.instructorProfileNoCoursesFilter,
                style: TextStyle(
                  fontSize: 14,
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

    final totalAvailable = courses.length;
    final int visibleCount = _displayedCoursesCount.clamp(0, totalAvailable);
    final visibleCourses = courses.take(visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: visibleCourses.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final course = visibleCourses[index];
            return _buildUdemyCourseCard(
              context: context,
              course: course,
              isDark: isDark,
              isAr: isAr,
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
              textSubColor: textSubColor,
            );
          },
        ),

        // Facebook-style Infinite Scroll Feed Loader (when active and fetching more courses)
        if (_isLoadingMoreCourses)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: _buildCoursesInfiniteLoader(cardBg, borderColor, isDark),
          ),

        // Single-tap button to activate infinite scroll OR active infinite scroll loader
        if (totalAvailable > _coursesPageSize && !_isCoursesInfiniteScrollActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _isCoursesInfiniteScrollActive = true;
                  _displayedCoursesCount += _coursesPageSize;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndTriggerInfiniteScroll());
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.all_inclusive_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.instructorProfileLoadMoreCourses((totalAvailable - visibleCount).toString()),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          )
        else if (_isCoursesInfiniteScrollActive) ...[
          if (visibleCount < totalAvailable)
            Container(
              key: _coursesBottomKey,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.loc.instructorProfileLoadingMoreCourses,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    context.loc.instructorProfileAllCoursesLoaded(totalAvailable.toString()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _isCoursesInfiniteScrollActive = false;
                        _displayedCoursesCount = _coursesPageSize;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.loc.instructorProfileShowLess,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.keyboard_arrow_up_rounded, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildCoursesInfiniteLoader(Color cardBg, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 104, height: 80, borderRadius: 8),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: double.infinity, height: 14),
                    SizedBox(height: 6),
                    SkeletonLine(width: 140, height: 12),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SkeletonLine(width: 40, height: 11),
                        SizedBox(width: 12),
                        SkeletonLine(width: 50, height: 11),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.loc.instructorProfileLoadingMoreCourses,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsInfiniteLoader(Color cardBg, Color borderColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonBox.circle(size: 38),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 100, height: 13),
                  SizedBox(height: 6),
                  SkeletonLine(width: 60, height: 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const SkeletonLine(width: double.infinity, height: 11),
          const SizedBox(height: 6),
          const SkeletonLine(width: 180, height: 11),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.loc.instructorProfileLoadingMoreReviews,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUdemyCourseCard({
    required BuildContext context,
    required HomeCourseDTO course,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final title = course.getLocalizedTitle(context);
    final duration = course.getLocalizedDuration(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, '/course-details', arguments: course.id);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16:9 Thumbnail with rounded corners & fallback gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 104,
                height: 78,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: course.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: course.gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.school_rounded, color: Colors.white70, size: 24),
                              ),
                            ),
                            errorWidget: (_, _, _) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: course.gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.school_rounded, color: Colors.white, size: 28),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: course.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.school_rounded, color: Colors.white, size: 28),
                            ),
                          ),
                    // Small play badge overlay
                    Positioned(
                      bottom: 4,
                      right: isAr ? null : 4,
                      left: isAr ? 4 : null,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Course Details Column (Udemy Style)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional Bestseller Badge
                  if (course.isBestseller || course.isFeatured)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: course.badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        course.badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: course.badgeTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),

                  // Course Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rating Row: score + star + (reviews)
                  Row(
                    children: [
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD97706)),
                      const SizedBox(width: 3),
                      Text(
                        '(${course.reviewsCount})',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: textSubColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Metadata: Duration • Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 12, color: textSubColor),
                          const SizedBox(width: 3),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),

                      // Price Display
                      Row(
                        children: [
                          if (course.originalPrice != null && course.originalPrice! > course.price) ...[
                            Text(
                              '\$${course.originalPrice!.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: textSubColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            course.price == 0
                                ? context.loc.generalFree
                                : '\$${course.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
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

  // -------------------------------------------------------------
  // 10. Student Feedback Overview (Udemy Style + Real Reviews & Ratings)
  // -------------------------------------------------------------
  Widget _buildStudentFeedbackSection({
    required BuildContext context,
    required InstructorProfileModel profile,
    InstructorRatingsOverviewModel? ratings,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final isAr = context.isArabic;
    final stats = ratings?.stats;
    final totalReviews = stats != null && stats.totalReviews > 0 ? stats.totalReviews : 0;
    final avgRating = (stats != null && stats.averageRating > 0)
        ? stats.averageRating
        : profile.rating;
    final dist = stats?.distribution ?? const {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    final reviews = ratings?.reviews ?? const [];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Reviews Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 22),
                  const SizedBox(width: 6),
                  Text(
                    context.loc.instructorProfileStudentFeedback,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              if (totalReviews > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706).withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.loc.instructorProfileReviewsCount(totalReviews.toString()),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD97706),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Rating score box + breakdown bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Overall rating column
              Column(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      fontFamily: 'Inter',
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final starNum = index + 1;
                      if (avgRating >= starNum) {
                        return const Icon(Icons.star_rounded, size: 16, color: Color(0xFFD97706));
                      } else if (avgRating >= starNum - 0.5) {
                        return const Icon(Icons.star_half_rounded, size: 16, color: Color(0xFFD97706));
                      }
                      return Icon(Icons.star_outline_rounded, size: 16, color: isDark ? Colors.white24 : const Color(0xFFCBD5E1));
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalReviews > 0
                        ? context.loc.instructorProfileBasedOnReviews(totalReviews.toString())
                        : context.loc.instructorProfileRating,
                    style: TextStyle(
                      fontSize: 11,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),

              // Rating Breakdown Bars (5 down to 1)
              Expanded(
                child: Column(
                  children: [
                    for (int star = 5; star >= 1; star--)
                      _buildRatingBar(
                        stars: star,
                        count: dist[star] ?? 0,
                        totalReviews: totalReviews,
                        isDark: isDark,
                        textSubColor: textSubColor,
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),

          // Reviews Section
          if (reviews.isNotEmpty) ...[
            Text(
              context.loc.instructorProfileRecentReviews,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 12),

            // Review items with lazy loading pagination
            ...(() {
              final totalReviews = reviews.length;
              final visibleCount = _displayedReviewsCount.clamp(0, totalReviews);
              final visibleReviews = reviews.take(visibleCount).toList();
              return visibleReviews.map((r) => _buildReviewCard(
                review: r,
                isDark: isDark,
                borderColor: borderColor,
                textColor: textColor,
                textSubColor: textSubColor,
                isAr: isAr,
              ));
            })(),

            // Facebook-style Infinite Scroll Feed Loader for Reviews
            if (_isLoadingMoreReviews)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildReviewsInfiniteLoader(cardBg, borderColor, isDark),
              ),

            // Single-tap button to activate reviews infinite scroll OR active scroll loader
            if (reviews.length > _reviewsPageSize && !_isReviewsInfiniteScrollActive)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isReviewsInfiniteScrollActive = true;
                      _displayedReviewsCount += _reviewsPageSize;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndTriggerInfiniteScroll());
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.all_inclusive_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.loc.instructorProfileLoadMoreReviews((reviews.length - _displayedReviewsCount.clamp(0, reviews.length)).toString()),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              )
            else if (_isReviewsInfiniteScrollActive) ...[
              if (_displayedReviewsCount < reviews.length)
                Container(
                  key: _reviewsBottomKey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.loc.instructorProfileLoadingMoreReviews,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        context.loc.instructorProfileAllReviewsLoaded(reviews.length.toString()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _isReviewsInfiniteScrollActive = false;
                            _displayedReviewsCount = _reviewsPageSize;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.loc.instructorProfileShowLess,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_up_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ] else ...[
            // Empty Reviews State
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 38,
                      color: textSubColor.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.loc.instructorProfileNoReviewsYet,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.loc.instructorProfileRatingDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required InstructorReviewItemModel review,
    required bool isDark,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isAr,
  }) {
    final studentDisplayName = review.studentName.trim().isNotEmpty
        ? review.studentName.trim()
        : context.loc.instructorProfileDefaultStudentName;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Student Name + TimeAgo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              if (review.studentAvatar != null && review.studentAvatar!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: review.studentAvatar!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _buildInitialAvatar(studentDisplayName, isAr),
                  ),
                )
              else
                _buildInitialAvatar(studentDisplayName, isAr),
              const SizedBox(width: 10),

              // Name + Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: isAr ? 'Tajawal' : 'Inter',
                      ),
                    ),
                    if (review.getLocalizedTimeAgo(context).isNotEmpty)
                      Text(
                        review.getLocalizedTimeAgo(context),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: textSubColor,
                          fontFamily: isAr ? 'Tajawal' : 'Inter',
                        ),
                      ),
                  ],
                ),
              ),

              // Course Badge (if present)
              if (review.courseName.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 130),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primary.withValues(alpha: 0.2) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      review.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Star Rating
          Row(
            children: [
              Row(
                children: List.generate(5, (i) {
                  final filled = i < review.rating;
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: filled ? const Color(0xFFD97706) : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                  );
                }),
              ),
              const SizedBox(width: 6),
              Text(
                review.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),

          // Comment
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF334155),
                height: 1.4,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInitialAvatar(String name, [bool isAr = true]) {
    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF7C3AED),
      const Color(0xFF059669),
      const Color(0xFFD97706),
      const Color(0xFFE11D48),
      const Color(0xFF0891B2),
    ];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = (hash * 31 + name.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    final bg = colors[hash % colors.length];
    final initial = name.isNotEmpty ? name.characters.first : (isAr ? '؟' : '?');

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: bg.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: bg,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildRatingBar({
    required int stars,
    required int count,
    required int totalReviews,
    required bool isDark,
    required Color textSubColor,
  }) {
    final double pct = totalReviews > 0 ? (count / totalReviews) : (stars == 5 ? 0.8 : stars == 4 ? 0.15 : 0.02);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: textSubColor,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star_rounded, size: 11, color: Color(0xFFD97706)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 5.5,
                backgroundColor: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD97706)),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 30,
            child: Text(
              '${(pct * 100).toInt()}%',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 10,
                color: textSubColor,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Shimmer Skeleton Loader (Udemy Layout)
  // -------------------------------------------------------------
  // -------------------------------------------------------------
  // 12. Skeleton Loading (Udemy Style Comprehensive Layout)
  // -------------------------------------------------------------
  Widget _buildSkeletonLoading(Color cardBg, Color borderColor, bool isDark) {
    return AppSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Skeleton (Avatar + Badge + Instructor Label + Name + Headline)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: const Row(
                children: [
                  SkeletonBox.circle(size: 80),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 90, height: 11),
                        SizedBox(height: 8),
                        SkeletonLine(width: 160, height: 18),
                        SizedBox(height: 8),
                        SkeletonLine(width: double.infinity, height: 13),
                        SizedBox(height: 6),
                        SkeletonLine(width: 120, height: 11),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. Stats 3-Box Skeleton
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SkeletonLine(width: 50, height: 18),
                      SizedBox(height: 6),
                      SkeletonLine(width: 70, height: 11),
                    ],
                  ),
                  SkeletonBox(width: 1, height: 36),
                  Column(
                    children: [
                      SkeletonLine(width: 45, height: 18),
                      SizedBox(height: 6),
                      SkeletonLine(width: 65, height: 11),
                    ],
                  ),
                  SkeletonBox(width: 1, height: 36),
                  Column(
                    children: [
                      SkeletonLine(width: 40, height: 18),
                      SizedBox(height: 6),
                      SkeletonLine(width: 55, height: 11),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. Share Button Skeleton
            const SkeletonBox(
              width: double.infinity,
              height: 44,
              borderRadius: 12,
            ),
            const SizedBox(height: 12),

            // 4. Social Links Row Skeleton (4 horizontal boxes)
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: index == 0 ? 0 : 4,
                      end: index == 3 ? 0 : 4,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SkeletonBox.circle(size: 32),
                          SizedBox(height: 6),
                          SkeletonLine(width: 42, height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // 5. About Me Skeleton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 110, height: 16),
                  SizedBox(height: 12),
                  SkeletonLine(width: double.infinity, height: 12),
                  SizedBox(height: 8),
                  SkeletonLine(width: double.infinity, height: 12),
                  SizedBox(height: 8),
                  SkeletonLine(width: 200, height: 12),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6. Expertise Chips Skeleton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 130, height: 16),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SkeletonBox(width: 80, height: 28, borderRadius: 16),
                      SkeletonBox(width: 100, height: 28, borderRadius: 16),
                      SkeletonBox(width: 70, height: 28, borderRadius: 16),
                      SkeletonBox(width: 90, height: 28, borderRadius: 16),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 7. Courses Header & Filter Skeleton
            const Row(
              children: [
                SkeletonLine(width: 110, height: 18),
                SizedBox(width: 8),
                SkeletonBox(width: 26, height: 20, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SkeletonBox(width: 60, height: 32, borderRadius: 16),
                SizedBox(width: 8),
                SkeletonBox(width: 90, height: 32, borderRadius: 16),
                SizedBox(width: 8),
                SkeletonBox(width: 80, height: 32, borderRadius: 16),
              ],
            ),
            const SizedBox(height: 12),

            // 8. Course Cards Skeleton (2 detailed Udemy cards)
            ...List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 104, height: 80, borderRadius: 8),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: double.infinity, height: 14),
                          SizedBox(height: 6),
                          SkeletonLine(width: 140, height: 12),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SkeletonLine(width: 40, height: 11),
                              SizedBox(width: 12),
                              SkeletonLine(width: 50, height: 11),
                            ],
                          ),
                          SizedBox(height: 8),
                          SkeletonLine(width: 60, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),

            // 9. Student Feedback Overview Skeleton
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: 130, height: 16),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Score Box
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SkeletonLine(width: 45, height: 26),
                            SizedBox(height: 6),
                            SkeletonLine(width: 60, height: 11),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Progress lines
                      Expanded(
                        child: Column(
                          children: List.generate(5, (_) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: SkeletonLine(width: double.infinity, height: 8),
                            );
                          }),
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

  Widget _buildAvatarFallback(String initial) {
    return Container(
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      final s = number.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(s[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }
}

class _InstructorSocialItem {
  final Widget icon;
  final String label;
  final String url;
  final Color brandColor;

  const _InstructorSocialItem({
    required this.icon,
    required this.label,
    required this.url,
    required this.brandColor,
  });
}
