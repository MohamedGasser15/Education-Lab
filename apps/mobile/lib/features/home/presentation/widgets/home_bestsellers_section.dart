import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_courses_list.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HomeBestsellersSection extends StatelessWidget {
  const HomeBestsellersSection({
    super.key,
    this.courses,
    this.wishlistedCourseIds,
    this.onToggleWishlist,
    this.onCourseTap,
    this.onSeeAllTap,
  });

  final List<Map<String, dynamic>>? courses;
  final Set<String>? wishlistedCourseIds;
  final ValueChanged<String>? onToggleWishlist;
  final ValueChanged<Map<String, dynamic>>? onCourseTap;
  final VoidCallback? onSeeAllTap;

  static const List<Map<String, dynamic>> defaultBestsellers = [
    {
      'id': 'c1',
      'title': 'The Complete Flutter & Dart Development Guide [2026]',
      'arabicTitle': 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart',
      'instructor': 'م. أحمد محمد',
      'rating': 4.9,
      'reviews': '18,420',
      'price': '49.99 \$',
      'originalPrice': '84.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى تقييماً',
      'badgeColor': AppColors.primaryLight,
      'badgeTextColor': AppColors.primary,
      'gradient': [AppColors.primary, AppColors.roleInstructor],
      'icon': Icons.flutter_dash_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'c2',
      'title': 'Figma UI/UX Design Essentials: From Zero to Pro',
      'arabicTitle':
          'تصميم واجهات وتجربة المستخدم من الصفر حتى الاحتراف بـ Figma',
      'instructor': 'سارة أحمد',
      'rating': 4.9,
      'reviews': '9,850',
      'price': '39.99 \$',
      'originalPrice': '69.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى تقييماً',
      'badgeColor': AppColors.primaryLight,
      'badgeTextColor': AppColors.primary,
      'gradient': [AppColors.textPrimary, AppColors.darkDivider],
      'icon': Icons.brush_rounded,
      'accentColor': AppColors.accent,
    },
    {
      'id': 'c3',
      'title':
          'Building Enterprise Cloud Apps with ASP.NET Core & Microservices',
      'arabicTitle':
          'بناء التطبيقات المؤسسية الحديثة بـ ASP.NET Core و Microservices',
      'instructor': 'د. خالد العلي',
      'rating': 4.8,
      'reviews': '12,300',
      'price': '54.99 \$',
      'originalPrice': '99.99 \$',
      'isBestseller': false,
      'badgeText': 'مميز',
      'badgeColor': AppColors.successLight,
      'badgeTextColor': AppColors.successDark,
      'gradient': [AppColors.primaryDark, AppColors.primary],
      'icon': Icons.cloud_done_rounded,
      'accentColor': AppColors.primaryDark,
    },
    {
      'id': 'c4',
      'title': 'Mastering LLMs, Generative AI & Deep Learning with Python',
      'arabicTitle':
          'احتراف نماذج الذكاء الاصطناعي التوليدي والتعلم العميق بـ Python',
      'instructor': 'م. يوسف محمود',
      'rating': 4.8,
      'reviews': '6,140',
      'price': '59.99 \$',
      'originalPrice': '89.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى تقييماً',
      'badgeColor': AppColors.primaryLight,
      'badgeTextColor': AppColors.primary,
      'gradient': [AppColors.textPrimary, AppColors.darkBorder],
      'icon': Icons.auto_awesome_rounded,
      'accentColor': AppColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final enrollmentProvider = context.watch<EnrollmentProvider>();

    List<Map<String, dynamic>> list;
    if (courses != null) {
      list = courses!;
    } else if (homeProvider.featuredCourses.isNotEmpty) {
      list = homeProvider.featuredCourses
          .map((c) => c.toUiMap(context))
          .toList();
    } else {
      list = defaultBestsellers;
    }

    final Set<String> activeWishlist =
        wishlistedCourseIds ??
        wishlistProvider.items.map((i) => i.courseId.toString()).toSet();

    void handleWishlist(String courseId) {
      if (onToggleWishlist != null) {
        onToggleWishlist!(courseId);
      } else {
        final intId = int.tryParse(courseId);
        if (intId != null) {
          if (wishlistProvider.isInWishlist(intId)) {
            wishlistProvider.removeFromWishlist(intId);
            AppSnackbar.show(
              context,
              context.loc.wishlistRemovedSuccessSnackbar,
            );
          } else {
            if (enrollmentProvider.isEnrolled(intId)) {
              AppSnackbar.show(
                context,
                context.loc.courseDetailsAlreadyEnrolled,
                error: true,
              );
              return;
            }
            wishlistProvider.addToWishlist(intId);
            AppSnackbar.showSuccess(context, context.loc.wishlistAddedSnackbar);
          }
        }
      }
    }

    final bool isSectionLoading =
        courses == null &&
        homeProvider.featuredCourses.isEmpty &&
        homeProvider.isLoadingFeatured;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSectionLoading
          ? Column(
              key: const ValueKey('bestsellers_skeleton'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeBestsellersTitle,
                    subtitle: context.loc.homeBestsellersSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap:
                        onSeeAllTap ??
                        () => MainNavigationScreen.switchToExplore(
                          context,
                          filterIndex: 2,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                const HomeCoursesListSkeleton(),
              ],
            )
          : Column(
              key: const ValueKey('bestsellers_content'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeBestsellersTitle,
                    subtitle: context.loc.homeBestsellersSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap:
                        onSeeAllTap ??
                        () => MainNavigationScreen.switchToExplore(
                          context,
                          filterIndex: 2,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                HomeCoursesList(
                  courses: list,
                  wishlistedCourseIds: activeWishlist,
                  onToggleWishlist: handleWishlist,
                  onCourseTap: onCourseTap,
                ),
              ],
            ),
    );
  }
}
