import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';

class ExploreFilterBar extends StatelessWidget {
  const ExploreFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onFilterSelected;

  List<FilterChipItem> _getFilterChips(BuildContext context) => [
    FilterChipItem(label: context.loc.catAll),
    FilterChipItem(
      label: context.loc.exploreFilterTopRated,
      icon: Icons.star_rounded,
      iconColor: const Color(0xFFE59819),
    ),
    FilterChipItem(
      label: context.loc.exploreFilterBestseller,
      icon: Icons.local_fire_department_rounded,
      iconColor: const Color(0xFFF97316),
    ),
    FilterChipItem(
      label: context.loc.exploreFilterUnder50,
      icon: Icons.sell_rounded,
      iconColor: AppColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final chips = _getFilterChips(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final chip = chips[index];

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onFilterSelected(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkSurfaceMuted
                          : AppColors.background),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : borderColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chip.icon != null) ...[
                    Icon(
                      chip.icon,
                      size: 13.5,
                      color: isSelected
                          ? Colors.white
                          : (chip.iconColor ?? textSubColor),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    chip.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : textColor,
                      fontSize: 11.5,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontFamily: 'Tajawal',
                    ),
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
