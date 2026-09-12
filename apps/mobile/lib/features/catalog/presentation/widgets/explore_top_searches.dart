import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ExploreTopSearches extends StatelessWidget {
  const ExploreTopSearches({
    super.key,
    this.searches,
    required this.onSearchTap,
  });

  final List<String>? searches;
  final ValueChanged<String> onSearchTap;

  static const List<String> defaultTopSearches = [
    'Flutter',
    'Python',
    'React JS',
    'Figma UI/UX',
    'ASP.NET Core',
    'Machine Learning',
    'Docker & DevOps',
    'Cyber Security',
    'Power BI & Excel',
    'Node.js',
    'Graphic Design',
    'Digital Marketing',
  ];

  @override
  Widget build(BuildContext context) {
    final list = searches ?? defaultTopSearches;
    final columnCount = (list.length / 2).ceil();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up_rounded,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              context.loc.exploreTopSearches,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: columnCount,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, colIndex) {
              final topIndex = colIndex * 2;
              final bottomIndex = topIndex + 1;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchChip(
                    list[topIndex],
                    borderColor,
                    textColor,
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  if (bottomIndex < list.length)
                    _buildSearchChip(
                      list[bottomIndex],
                      borderColor,
                      textColor,
                      isDark,
                    )
                  else
                    const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(
    String topic,
    Color borderColor,
    Color textColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onSearchTap(topic);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceMuted : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_up_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              topic,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
