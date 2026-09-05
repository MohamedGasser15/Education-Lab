import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeExploreCategories extends StatelessWidget {
  const HomeExploreCategories({
    super.key,
    this.categories,
    this.onCategoryTap,
  });

  final List<Map<String, dynamic>>? categories;
  final ValueChanged<Map<String, dynamic>>? onCategoryTap;

  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'title': 'تطوير البرمجيات والويب',
      'subtitle': 'Web & Mobile',
      'icon': Icons.code_rounded,
      'courses': '140+ دورة',
      'color': Color(0xFF1D61E7),
    },
    {
      'title': 'الذكاء الاصطناعي والبيانات',
      'subtitle': 'AI & Data Science',
      'icon': Icons.psychology_rounded,
      'courses': '85+ دورة',
      'color': Color(0xFF7C3AED),
    },
    {
      'title': 'التصميم وتجربة المستخدم',
      'subtitle': 'UI/UX Design',
      'icon': Icons.palette_rounded,
      'courses': '65+ دورة',
      'color': Color(0xFFDB2777),
    },
    {
      'title': 'إدارة الأعمال والريادة',
      'subtitle': 'Business & Finance',
      'icon': Icons.business_center_rounded,
      'courses': '50+ دورة',
      'color': Color(0xFFD97706),
    },
    {
      'title': 'الأمن السيبراني والشبكات',
      'subtitle': 'Cyber Security',
      'icon': Icons.shield_rounded,
      'courses': '42+ دورة',
      'color': Color(0xFF059669),
    },
    {
      'title': 'التسويق الرقمي والنمو',
      'subtitle': 'Digital Marketing',
      'icon': Icons.campaign_rounded,
      'courses': '38+ دورة',
      'color': Color(0xFF0284C7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    List<Map<String, dynamic>> list;
    if (categories != null) {
      list = categories!;
    } else if (homeProvider.categories.isNotEmpty) {
      list = homeProvider.categories.map((c) {
        final localizedTitle = c.getLocalizedName(context);
        return {
          'id': c.id,
          'title': localizedTitle,
          'subtitle': c.description ?? '',
          'icon': c.icon,
          'courses': context.loc.coursesCountText(c.coursesCount.toString()),
          'color': c.color,
        };
      }).toList();
    } else {
      list = defaultCategories;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
                Navigator.pushNamed(context, '/explore');
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
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
                      color: catColor.withValues(alpha: isDark ? 0.22 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: catColor.withValues(alpha: isDark ? 0.35 : 0.2),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      (cat['icon'] as IconData?) ?? Icons.category_rounded,
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
                    isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                    size: 16,
                    color: textSubColor.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
