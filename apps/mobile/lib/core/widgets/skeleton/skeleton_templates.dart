import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';

/// Skeleton for horizontal course card in My Courses
class SkeletonCourseCard extends StatelessWidget {
  const SkeletonCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 80, height: 68, borderRadius: 10),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: double.infinity, height: 13),
                      SizedBox(height: 6),
                      SkeletonLine(width: 140, height: 11),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          SkeletonBox(width: 48, height: 14, borderRadius: 4),
                          SizedBox(width: 8),
                          SkeletonLine(width: 50, height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SkeletonBox(width: double.infinity, height: 5, borderRadius: 4),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 100, height: 10),
                SkeletonLine(width: 60, height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the Wishlist card
class SkeletonWishlistCard extends StatelessWidget {
  const SkeletonWishlistCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 92, height: 80, borderRadius: 12),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 60, height: 14, borderRadius: 4),
                      SizedBox(height: 6),
                      SkeletonLine(width: double.infinity, height: 13),
                      SizedBox(height: 4),
                      SkeletonLine(width: 100, height: 11),
                      SizedBox(height: 6),
                      SkeletonLine(width: 130, height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 70, height: 18),
                Row(
                  children: [
                    SkeletonCircle(size: 28),
                    SizedBox(width: 8),
                    SkeletonBox(width: 110, height: 32, borderRadius: 8),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for Profile Header (Avatar, Name, Email, Edit Button)
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: const Row(
          children: [
            SkeletonCircle(size: 64),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 130, height: 16),
                  SizedBox(height: 6),
                  SkeletonLine(width: 170, height: 12),
                  SizedBox(height: 6),
                  SkeletonBox(width: 75, height: 16, borderRadius: 6),
                ],
              ),
            ),
            SkeletonCircle(size: 36),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for list tile item (e.g. Account Security, Settings, Purchase History)
class SkeletonListTile extends StatelessWidget {
  final bool showSubtitle;

  const SkeletonListTile({
    super.key,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const SkeletonBox(width: 38, height: 38, borderRadius: 10),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: 120, height: 13),
                  if (showSubtitle) ...[
                    const SizedBox(height: 5),
                    const SkeletonLine(width: 180, height: 10),
                  ],
                ],
              ),
            ),
            const SkeletonBox(width: 16, height: 16, borderRadius: 4),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for Purchase History card
class SkeletonPurchaseCard extends StatelessWidget {
  const SkeletonPurchaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 110, height: 13),
                SkeletonBox(width: 65, height: 18, borderRadius: 6),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SkeletonBox(width: 50, height: 50, borderRadius: 8),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: double.infinity, height: 13),
                      SizedBox(height: 6),
                      SkeletonLine(width: 100, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 90, height: 11),
                SkeletonLine(width: 60, height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for Certificate card
class SkeletonCertificateCard extends StatelessWidget {
  const SkeletonCertificateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AppSkeleton(
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonBox(width: 44, height: 44, borderRadius: 10),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 180, height: 14),
                      SizedBox(height: 6),
                      SkeletonLine(width: 120, height: 11),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkeletonBox(width: 130, height: 32, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
