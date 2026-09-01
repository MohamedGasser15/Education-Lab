import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomeCategoryChips extends StatefulWidget {
  const HomeCategoryChips({
    super.key,
    this.selectedIndex,
    this.onCategorySelected,
    this.categories,
  });

  final int? selectedIndex;
  final ValueChanged<int>? onCategorySelected;
  final List<String>? categories;

  @override
  State<HomeCategoryChips> createState() => _HomeCategoryChipsState();
}

class _HomeCategoryChipsState extends State<HomeCategoryChips> {
  int _internalIndex = 0;

  int get _currentIndex => widget.selectedIndex ?? _internalIndex;

  List<String> _getCategories(BuildContext context) => [
    context.loc.catAll,
    context.loc.catWebDev,
    context.loc.catMobileApps,
    context.loc.catAI,
    context.loc.catUIUX,
    context.loc.catBusiness,
    context.loc.catCyberSecurity,
    context.loc.catDataScience,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final categories = widget.categories ?? _getCategories(context);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _currentIndex == index;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              if (widget.selectedIndex == null) {
                setState(() => _internalIndex = index);
              }
              widget.onCategorySelected?.call(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : borderColor,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
