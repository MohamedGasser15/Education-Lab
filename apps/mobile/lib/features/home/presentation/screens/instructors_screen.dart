import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedSortIndex = 0; // 0: All, 1: Top Rated, 2: Most Students, 3: Most Courses

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().fetchAllInstructors();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final homeProvider = context.watch<HomeProvider>();
    final List<HomeInstructorDTO> rawList = homeProvider.instructors;

    // Filter by query
    List<HomeInstructorDTO> filtered = rawList.where((ins) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      final nameMatches = ins.name.toLowerCase().contains(q);
      final roleMatches = ins.headline.toLowerCase().contains(q);
      return nameMatches || roleMatches;
    }).toList();

    // Sort
    switch (_selectedSortIndex) {
      case 1: // Top Rated
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 2: // Most Students
        filtered.sort((a, b) => b.totalStudents.compareTo(a.totalStudents));
        break;
      case 3: // Most Courses
        filtered.sort((a, b) => b.coursesCount.compareTo(a.coursesCount));
        break;
      default:
        break;
    }

    final sortOptions = [
      context.loc.instructorsSortAll,
      context.loc.instructorsSortTopRated,
      context.loc.instructorsSortMostStudents,
      context.loc.instructorsSortMostCourses,
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          context.loc.homeTopInstructorsTitle,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => homeProvider.fetchAllInstructors(forceRefresh: true),
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // Search Bar & Filter Chips Header
            SliverToBoxAdapter(
              child: Container(
                color: cardBg,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Column(
                  children: [
                    // Search Input
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.5,
                          fontFamily: 'Tajawal',
                        ),
                        decoration: InputDecoration(
                          hintText: context.loc.instructorsSearchHint,
                          hintStyle: TextStyle(
                            color: textSubColor,
                            fontSize: 13,
                            fontFamily: 'Tajawal',
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: textSubColor,
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sort Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(sortOptions.length, (idx) {
                          final isSelected = _selectedSortIndex == idx;
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
                                  color: isSelected
                                      ? Colors.white
                                      : textColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              backgroundColor: isDark
                                  ? AppColors.darkBackground
                                  : const Color(0xFFF8FAFC),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : borderColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelected: (_) {
                                HapticFeedback.selectionClick();
                                setState(() => _selectedSortIndex = idx);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Row(
                  children: [
                    if (homeProvider.isLoadingAllInstructors && rawList.isEmpty)
                      const AppSkeleton(child: SkeletonLine(width: 90, height: 12))
                    else
                      Text(
                        context.loc.instructorsAvailableCount(filtered.length.toString()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Instructors List
            if (homeProvider.isLoadingAllInstructors && rawList.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SliverList.separated(
                  itemCount: 6,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _buildInstructorSkeletonCard(cardBg, borderColor, isDark),
                ),
              )
            else if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 64,
                          color: textSubColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.loc.instructorsNotFound,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.loc.instructorsNotFoundSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final instructor = filtered[index];
                    return _buildInstructorCard(
                      context: context,
                      instructor: instructor,
                      isDark: isDark,
                      isAr: isAr,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      textSubColor: textSubColor,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorSkeletonCard(Color cardBg, Color borderColor, bool isDark) {
    return AppSkeleton(
      child: Container(
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
                const SkeletonBox(width: 50, height: 50, borderRadius: 25),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLine(width: 140, height: 14),
                      SizedBox(height: 6),
                      SkeletonLine(width: 200, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                SkeletonBox(width: 55, height: 20, borderRadius: 6),
                SizedBox(width: 10),
                SkeletonLine(width: 80, height: 12),
                Spacer(),
                SkeletonBox(width: 80, height: 28, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorCard({
    required BuildContext context,
    required HomeInstructorDTO instructor,
    required bool isDark,
    required bool isAr,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    final initial = instructor.name.trim().isNotEmpty
        ? instructor.name.trim()[0]
        : (isAr ? 'م' : 'I');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
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
          // Top Row: Avatar + Name + Specialization
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: instructor.profileImageUrl != null &&
                              instructor.profileImageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: instructor.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => _buildAvatarFallback(initial),
                            )
                          : _buildAvatarFallback(initial),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    right: isAr ? null : -1,
                    left: isAr ? -1 : null,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: AppColors.primary,
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
                    Text(
                      instructor.name,
                      style: TextStyle(
                        fontSize: 14.5,
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
                      instructor.getLocalizedHeadline(context),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                        height: 1.2,
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

          // Divider
          Container(
            height: 1,
            color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 10),

          // Bottom Row: Rating + Students + Courses Button
          Row(
            children: [
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF78350F).withValues(alpha: 0.3)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD97706)),
                    const SizedBox(width: 3),
                    Text(
                      instructor.rating.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Students Count
              Expanded(
                child: Text(
                  context.loc.studentsCountText(instructor.totalStudents.toString()),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Explore Courses Button
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, '/explore');
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.loc.instructorsCoursesCount(instructor.coursesCount.toString()),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
          fontSize: 18,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
