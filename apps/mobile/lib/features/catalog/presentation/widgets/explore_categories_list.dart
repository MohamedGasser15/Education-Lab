import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';

class ExploreCategoriesList extends StatelessWidget {
  const ExploreCategoriesList({
    super.key,
    this.categories,
    required this.onCategoryTap,
  });

  final List<CategoryItem>? categories;
  final ValueChanged<CategoryItem> onCategoryTap;

  static const List<CategoryItem> defaultCategories = [
    CategoryItem(
      id: 'dev',
      title: 'تطوير البرمجيات والويب',
      subtitle: 'Web & Mobile Development',
      icon: Icons.code_rounded,
      color: Color(0xFF1D61E7),
      coursesCount: '140+ دورة',
    ),
    CategoryItem(
      id: 'ai',
      title: 'الذكاء الاصطناعي وعلوم البيانات',
      subtitle: 'AI, Machine Learning & Data',
      icon: Icons.psychology_rounded,
      color: Color(0xFF7C3AED),
      coursesCount: '85+ دورة',
    ),
    CategoryItem(
      id: 'design',
      title: 'التصميم وتجربة المستخدم',
      subtitle: 'UI/UX & Product Design',
      icon: Icons.palette_rounded,
      color: Color(0xFFDB2777),
      coursesCount: '60+ دورة',
    ),
    CategoryItem(
      id: 'business',
      title: 'إدارة الأعمال والريادة',
      subtitle: 'Business & Entrepreneurship',
      icon: Icons.business_center_rounded,
      color: Color(0xFFD97706),
      coursesCount: '50+ دورة',
    ),
    CategoryItem(
      id: 'security',
      title: 'الأمن السيبراني والشبكات',
      subtitle: 'Cybersecurity & Ethical Hacking',
      icon: Icons.shield_rounded,
      color: Color(0xFF059669),
      coursesCount: '40+ دورة',
    ),
    CategoryItem(
      id: 'marketing',
      title: 'التسويق الرقمي والتجارة',
      subtitle: 'Digital Marketing & Growth',
      icon: Icons.campaign_rounded,
      color: Color(0xFF0284C7),
      coursesCount: '35+ دورة',
    ),
    CategoryItem(
      id: 'cloud',
      title: 'السحابة والـ DevOps',
      subtitle: 'Cloud Computing & CI/CD',
      icon: Icons.cloud_done_rounded,
      color: Color(0xFF4F46E5),
      coursesCount: '30+ دورة',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = categories ?? defaultCategories;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 17),
            const SizedBox(width: 6),
            Text(
              context.loc.exploreBrowseCategories,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          context.loc.exploreBrowseCategoriesSubtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: textSubColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 12),
        ...list.map((cat) => _buildCategoryItem(
              context: context,
              cat: cat,
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
              textSubColor: textSubColor,
              isRtl: isRtl,
            )),
      ],
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required CategoryItem cat,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isRtl,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onCategoryTap(cat);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            // Colored Icon Box
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(cat.icon, color: cat.color, size: 22),
            ),
            const SizedBox(width: 12),

            // Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    '${cat.subtitle} • ${cat.coursesCount}',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              color: textSubColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
