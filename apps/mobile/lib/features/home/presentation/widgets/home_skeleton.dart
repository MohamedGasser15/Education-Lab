import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';

/// Full-page skeleton for the Home Screen.
/// Accurately matches the sliver layout, padding, and dimensions of HomeScreen.
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key, this.topPadding = 0});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        // Status bar spacer
        SliverToBoxAdapter(child: SizedBox(height: topPadding)),

        // 1. Header Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: HomeHeaderSkeleton(),
          ),
        ),

        // 2. Search Bar Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: HomeSearchBarSkeleton(),
          ),
        ),

        // 3. Promo Slider Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: HomePromoSliderSkeleton(),
          ),
        ),

        // 4. Category Chips Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: HomeCategoryChipsSkeleton(),
          ),
        ),

        // 5. Section 1: Bestsellers Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(),
                SizedBox(height: 12),
                HomeCoursesListSkeleton(),
              ],
            ),
          ),
        ),

        // 6. Section 2: Popular Topics Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(),
                SizedBox(height: 12),
                HomePopularTopicsSkeleton(),
              ],
            ),
          ),
        ),

        // 7. Section 3: Recommended Section Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(),
                SizedBox(height: 12),
                HomeCoursesListSkeleton(),
              ],
            ),
          ),
        ),

        // 8. Section 4: Top Instructors Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(),
                SizedBox(height: 12),
                HomeTopInstructorsSkeleton(),
              ],
            ),
          ),
        ),

        // 9. Section 5: New Courses Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(),
                SizedBox(height: 12),
                HomeCoursesListSkeleton(),
              ],
            ),
          ),
        ),

        // 10. Section 6: Explore Categories Skeleton
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionTitleSkeleton(hasAction: true),
                SizedBox(height: 12),
                HomeExploreCategoriesSkeleton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Header Skeleton: Avatar + Welcome Text + Notification Icon
class HomeHeaderSkeleton extends StatelessWidget {
  const HomeHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      child: Row(
        children: [
          SkeletonCircle(size: 42),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonLine(width: 75, height: 11),
                SizedBox(height: 6),
                SkeletonLine(width: 130, height: 15),
              ],
            ),
          ),
          SizedBox(width: 10),
          SkeletonCircle(size: 38),
        ],
      ),
    );
  }
}

/// Search Bar Skeleton
class HomeSearchBarSkeleton extends StatelessWidget {
  const HomeSearchBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: const AppSkeleton(
        child: Row(
          children: [
            SkeletonBox(width: 18, height: 18, borderRadius: 4),
            SizedBox(width: 10),
            SkeletonLine(width: 140, height: 12),
            Spacer(),
            SkeletonBox(width: 20, height: 20, borderRadius: 5),
          ],
        ),
      ),
    );
  }
}

/// Promo Slider Skeleton
class HomePromoSliderSkeleton extends StatelessWidget {
  const HomePromoSliderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Column(
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: const AppSkeleton(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonBox(width: 85, height: 22, borderRadius: 6),
                      SizedBox(height: 6),
                      SkeletonLine(width: 180, height: 16),
                      SizedBox(height: 4),
                      SkeletonLine(width: double.infinity, height: 11),
                      SkeletonLine(width: 130, height: 11),
                      SizedBox(height: 8),
                      SkeletonBox(width: 100, height: 32, borderRadius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 14),
                SkeletonBox(width: 68, height: 68, borderRadius: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const AppSkeleton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonBox(width: 20, height: 5, borderRadius: 3),
              SizedBox(width: 6),
              SkeletonBox(width: 6, height: 5, borderRadius: 3),
              SizedBox(width: 6),
              SkeletonBox(width: 6, height: 5, borderRadius: 3),
            ],
          ),
        ),
      ],
    );
  }
}

/// Category Chips Carousel Skeleton
class HomeCategoryChipsSkeleton extends StatelessWidget {
  const HomeCategoryChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const [
            SkeletonBox(width: 65, height: 34, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 95, height: 34, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 85, height: 34, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 110, height: 34, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 80, height: 34, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 90, height: 34, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}

/// Section Title Skeleton
class HomeSectionTitleSkeleton extends StatelessWidget {
  const HomeSectionTitleSkeleton({super.key, this.hasAction = true});

  final bool hasAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppSkeleton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 140, height: 16),
                SizedBox(height: 5),
                SkeletonLine(width: 180, height: 11),
              ],
            ),
            if (hasAction) const SkeletonLine(width: 50, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Single Course Card Skeleton matching HomeCourseCard (width: 195, height: ~196)
class HomeCourseCardSkeleton extends StatelessWidget {
  const HomeCourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: 195,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const AppSkeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail Box
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
              child: SkeletonBox(width: 195, height: 94, borderRadius: 0),
            ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonLine(width: 170, height: 11),
                  SizedBox(height: 3),
                  SkeletonLine(width: 115, height: 11),
                  SizedBox(height: 4),
                  SkeletonLine(width: 80, height: 9.5),
                  SizedBox(height: 5),

                  // Rating Row
                  Row(
                    children: [
                      SkeletonLine(width: 18, height: 9),
                      SizedBox(width: 4),
                      SkeletonBox(width: 10, height: 10, borderRadius: 2),
                      SizedBox(width: 2),
                      SkeletonBox(width: 10, height: 10, borderRadius: 2),
                      SizedBox(width: 2),
                      SkeletonBox(width: 10, height: 10, borderRadius: 2),
                      SizedBox(width: 2),
                      SkeletonBox(width: 10, height: 10, borderRadius: 2),
                      SizedBox(width: 2),
                      SkeletonBox(width: 10, height: 10, borderRadius: 2),
                      SizedBox(width: 4),
                      SkeletonLine(width: 32, height: 8.5),
                    ],
                  ),
                  SizedBox(height: 6),

                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 48, height: 12),
                      SkeletonBox(width: 40, height: 14, borderRadius: 4),
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
}

/// Horizontal Courses List Skeleton
class HomeCoursesListSkeleton extends StatelessWidget {
  const HomeCoursesListSkeleton({
    super.key,
    this.height = 196,
    this.itemCount = 3,
  });

  final double height;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => const HomeCourseCardSkeleton(),
      ),
    );
  }
}

/// Popular Topics 2-Row Skeleton
class HomePopularTopicsSkeleton extends StatelessWidget {
  const HomePopularTopicsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 80, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 110, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 90, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 120, height: 34, borderRadius: 8),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 100, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 75, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 125, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 85, height: 34, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Top Instructors Horizontal List Skeleton (width 220, height 106)
class HomeTopInstructorsSkeleton extends StatelessWidget {
  const HomeTopInstructorsSkeleton({
    super.key,
    this.height = 106,
    this.itemCount = 3,
  });

  final double height;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, _) {
          return Container(
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: const AppSkeleton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SkeletonCircle(size: 42),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 95, height: 12),
                            SizedBox(height: 4),
                            SkeletonLine(width: 125, height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SkeletonBox(
                    width: double.infinity,
                    height: 1,
                    borderRadius: 0,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      SkeletonBox(width: 38, height: 16, borderRadius: 4),
                      SizedBox(width: 6),
                      Expanded(child: SkeletonLine(width: 60, height: 9.5)),
                      SkeletonLine(width: 42, height: 9),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Explore Categories 2-Column Grid Skeleton
class HomeExploreCategoriesSkeleton extends StatelessWidget {
  const HomeExploreCategoriesSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.15,
      ),
      itemCount: itemCount,
      itemBuilder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: const AppSkeleton(
            child: Row(
              children: [
                SkeletonBox(width: 38, height: 38, borderRadius: 10),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 80, height: 11.5),
                      SizedBox(height: 5),
                      SkeletonLine(width: 50, height: 9),
                    ],
                  ),
                ),
                SkeletonBox(width: 10, height: 14, borderRadius: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
