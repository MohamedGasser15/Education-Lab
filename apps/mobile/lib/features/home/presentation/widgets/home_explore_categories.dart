import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:provider/provider.dart';

class HomeExploreCategories extends StatelessWidget {
  const HomeExploreCategories({super.key, this.categories, this.onCategoryTap});

  final List<Map<String, dynamic>>? categories;
  final ValueChanged<Map<String, dynamic>>? onCategoryTap;

  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'title': 'تطوير البرمجيات والويب',
      'subtitle': 'Web & Mobile',
      'icon': Icons.code_rounded,
      'courses': '140+ دورة',
      'color': AppColors.primary,
    },
    {
      'title': 'الذكاء الاصطناعي والبيانات',
      'subtitle': 'AI & Data Science',
      'icon': Icons.psychology_rounded,
      'courses': '85+ دورة',
      'color': AppColors.purple,
    },
    {
      'title': 'التصميم وتجربة المستخدم',
      'subtitle': 'UI/UX Design',
      'icon': Icons.palette_rounded,
      'courses': '65+ دورة',
      'color': AppColors.rose,
    },
    {
      'title': 'إدارة الأعمال والريادة',
      'subtitle': 'Business & Finance',
      'icon': Icons.business_center_rounded,
      'courses': '50+ دورة',
      'color': AppColors.roleStudent,
    },
    {
      'title': 'الأمن السيبراني والشبكات',
      'subtitle': 'Cyber Security',
      'icon': Icons.shield_rounded,
      'courses': '42+ دورة',
      'color': AppColors.emerald,
    },
    {
      'title': 'التسويق الرقمي والنمو',
      'subtitle': 'Digital Marketing',
      'icon': Icons.campaign_rounded,
      'courses': '38+ دورة',
      'color': AppColors.sky,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    List<Map<String, dynamic>> list;
    if (categories != null) {
      list = categories!;
    } else if (homeProvider.categories.isNotEmpty) {
      final sorted = List<HomeCategoryDTO>.from(homeProvider.categories)
        ..sort((a, b) => b.coursesCount.compareTo(a.coursesCount));
      list = sorted.take(10).map((c) {
        final localizedTitle = c.getLocalizedName(context);
        return {
          'id': c.id,
          'title': localizedTitle,
          'subtitle': c.description ?? '',
          'icon': c.icon,
          'courses': context.loc.coursesCountText(c.coursesCount.toString()),
          'coursesCount': c.coursesCount,
          'color': c.color,
        };
      }).toList();
    } else {
      list = defaultCategories;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final bool isSectionLoading =
        categories == null &&
        homeProvider.categories.isEmpty &&
        homeProvider.isLoadingCategories;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSectionLoading
          ? const HomeExploreCategoriesSkeleton(
              key: ValueKey('explore_categories_skeleton'),
            )
          : GridView.builder(
              key: const ValueKey('explore_categories_content'),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppResponsive.value(
                  context,
                  phone: 2,
                  tablet: 3,
                  smallPhone: 1,
                ),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: AppResponsive.value(
                  context,
                  phone: 2.15,
                  tablet: 2.5,
                  smallPhone: 2.3,
                ),
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final cat = list[index];
                final catColor = (cat['color'] as Color?) ?? AppColors.primary;

                return Material(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      if (onCategoryTap != null) {
                        onCategoryTap!(cat);
                      } else {
                        final exploreProvider = context.read<ExploreProvider>();
                        final catId = cat['id']?.toString() ?? '1';
                        final catTitle = (cat['title'] ?? '') as String;
                        final catItem = exploreProvider.findOrCreateCategory(
                          id: catId,
                          title: catTitle,
                          subtitle: (cat['subtitle'] ?? '') as String,
                          icon:
                              (cat['icon'] as IconData?) ??
                              Icons.category_rounded,
                          color: (cat['color'] as Color?) ?? AppColors.primary,
                          coursesCount: (cat['courses'] ?? '') as String,
                        );
                        MainNavigationScreen.switchToExplore(
                          context,
                          category: catItem,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.15 : 0.03,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Categorized Icon Container with custom accent tint
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: catColor.withValues(
                                alpha: isDark ? 0.22 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: catColor.withValues(
                                  alpha: isDark ? 0.35 : 0.2,
                                ),
                                width: 1.0,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              (cat['icon'] as IconData?) ??
                                  Icons.category_rounded,
                              color: catColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Category Info
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (cat['title'] ?? '') as String,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                    fontFamily: 'Tajawal',
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: catColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        (cat['courses'] ?? '') as String,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w600,
                                          color: textSubColor,
                                          fontFamily: 'Tajawal',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Micro Chevron
                          Icon(
                            isRtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            size: 16,
                            color: textSubColor.withValues(alpha: 0.5),
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
}
