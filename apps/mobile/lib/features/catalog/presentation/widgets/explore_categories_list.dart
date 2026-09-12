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
      arabicTitle: 'تطوير البرمجيات والويب',
      englishTitle: 'Software & Web Development',
      arabicSubtitle: 'تطوير الويب وتطبيقات الهاتف والأنظمة',
      englishSubtitle: 'Web, Mobile & Systems Development',
      icon: Icons.code_rounded,
      color: AppColors.primary,
      coursesCount: '140+ دورة',
      englishTag: '140+ courses',
    ),
    CategoryItem(
      id: 'ai',
      title: 'الذكاء الاصطناعي وعلوم البيانات',
      subtitle: 'AI, Machine Learning & Data',
      arabicTitle: 'الذكاء الاصطناعي وعلوم البيانات',
      englishTitle: 'AI & Data Science',
      arabicSubtitle: 'تعلم الآلة والذكاء الاصطناعي وعلوم البيانات',
      englishSubtitle: 'AI, Machine Learning & Data Science',
      icon: Icons.psychology_rounded,
      color: AppColors.purple,
      coursesCount: '85+ دورة',
      englishTag: '85+ courses',
    ),
    CategoryItem(
      id: 'design',
      title: 'التصميم وتجربة المستخدم',
      subtitle: 'UI/UX & Product Design',
      arabicTitle: 'التصميم وتجربة المستخدم',
      englishTitle: 'UI/UX Design',
      arabicSubtitle: 'تصميم واجهات وتجربة المستخدم والمنتجات',
      englishSubtitle: 'UI/UX, Graphic & Product Design',
      icon: Icons.palette_rounded,
      color: AppColors.rose,
      coursesCount: '60+ دورة',
      englishTag: '60+ courses',
    ),
    CategoryItem(
      id: 'business',
      title: 'إدارة الأعمال والريادة',
      subtitle: 'Business & Entrepreneurship',
      arabicTitle: 'إدارة الأعمال والريادة',
      englishTitle: 'Business & Entrepreneurship',
      arabicSubtitle: 'ريادة الأعمال وإدارة المشاريع والقيادة',
      englishSubtitle: 'Business Management & Entrepreneurship',
      icon: Icons.business_center_rounded,
      color: AppColors.roleStudent,
      coursesCount: '50+ دورة',
      englishTag: '50+ courses',
    ),
    CategoryItem(
      id: 'security',
      title: 'الأمن السيبراني والشبكات',
      subtitle: 'Cybersecurity & Ethical Hacking',
      arabicTitle: 'الأمن السيبراني والشبكات',
      englishTitle: 'Cybersecurity & Networking',
      arabicSubtitle: 'الأمن السيبراني، حماية الأنظمة والشبكات',
      englishSubtitle: 'Cybersecurity, Ethical Hacking & Networks',
      icon: Icons.shield_rounded,
      color: AppColors.emerald,
      coursesCount: '40+ دورة',
      englishTag: '40+ courses',
    ),
    CategoryItem(
      id: 'marketing',
      title: 'التسويق الرقمي والتجارة',
      subtitle: 'Digital Marketing & Growth',
      arabicTitle: 'التسويق الرقمي والتجارة',
      englishTitle: 'Digital Marketing',
      arabicSubtitle: 'التسويق الرقمي واستراتيجيات نمو المبيعات',
      englishSubtitle: 'Digital Marketing & Growth Strategies',
      icon: Icons.campaign_rounded,
      color: AppColors.sky,
      coursesCount: '35+ دورة',
      englishTag: '35+ courses',
    ),
    CategoryItem(
      id: 'cloud',
      title: 'السحابة والـ DevOps',
      subtitle: 'Cloud Computing & CI/CD',
      arabicTitle: 'السحابة والـ DevOps',
      englishTitle: 'Cloud & DevOps',
      arabicSubtitle: 'البنية السحابية وإدارة النظم و DevOps',
      englishSubtitle: 'Cloud Infrastructure, DevOps & CI/CD',
      icon: Icons.cloud_done_rounded,
      color: AppColors.indigo,
      coursesCount: '30+ دورة',
      englishTag: '30+ courses',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = categories ?? defaultCategories;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.grid_view_rounded,
              color: AppColors.primary,
              size: 17,
            ),
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
        ...list.map(
          (cat) => _buildCategoryItem(
            context: context,
            cat: cat,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
            isRtl: isRtl,
          ),
        ),
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
                    cat.getLocalizedTitle(context),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: isRtl ? 'Tajawal' : 'Inter',
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          cat.getLocalizedSubtitle(context),
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSubColor,
                            fontFamily: isRtl ? 'Tajawal' : 'Inter',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '•',
                          style: TextStyle(fontSize: 10, color: textSubColor),
                        ),
                      ),
                      Text(
                        cat.getLocalizedTag(context),
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: textSubColor,
                          fontFamily: isRtl ? 'Tajawal' : 'Inter',
                        ),
                      ),
                    ],
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
