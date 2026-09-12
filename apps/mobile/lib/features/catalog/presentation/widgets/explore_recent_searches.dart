import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ExploreRecentSearches extends StatelessWidget {
  const ExploreRecentSearches({
    super.key,
    required this.searches,
    required this.onSearchTap,
    required this.onClearAll,
  });

  final List<String> searches;
  final ValueChanged<String> onSearchTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.exploreRecentSearches,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onClearAll();
              },
              child: Text(
                context.loc.exploreClearAll,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: searches.map((item) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSearchTap(item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceMuted
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
