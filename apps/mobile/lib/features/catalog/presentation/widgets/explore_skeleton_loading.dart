import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ExploreSkeletonLoading extends StatelessWidget {
  const ExploreSkeletonLoading({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return ListView.separated(
      key: const ValueKey('skeleton_loading'),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
          highlightColor: isDark ? AppColors.darkSurfaceMuted : Colors.white,
          period: const Duration(milliseconds: 900),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton Thumbnail Box
                Container(
                  width: 90,
                  height: 66,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),

                // Skeleton Lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 140,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 65,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 10,
                            width: 45,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 14,
                            width: 55,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 14,
                            width: 60,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
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
}
