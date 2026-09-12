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

class HomeRecommendedSection extends StatelessWidget {
  const HomeRecommendedSection({
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

  static const List<Map<String, dynamic>> defaultRecommended = [
    {
      'id': 'r1',
      'title': 'Clean Architecture & Unit Testing in Modern Mobile Apps',
      'arabicTitle': 'المعمارية النظيفة Clean Architecture واختبار الكود للتطبيقات',
      'instructor': 'م. أحمد محمد',
      'rating': 4.9,
      'reviews': '4,520',
      'price': '34.99 \$',
      'originalPrice': '59.99 \$',
      'isBestseller': false,
      'badgeText': 'موصى به لك',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF1D61E7), Color(0xFF3B82F6)],
      'icon': Icons.verified_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'r2',
      'title': 'Complete Ethical Hacking & Cyber Security Bootcamp',
      'arabicTitle': 'المعسكر الشامل لاختبار الاختراق والأمن السيبراني الأخلاقي',
      'instructor': 'م. عمر طارق',
      'rating': 4.8,
      'reviews': '8,900',
      'price': '44.99 \$',
      'originalPrice': '79.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى مبيعاً',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'icon': Icons.security_rounded,
      'accentColor': Color(0xFF10B981),
    },
    {
      'id': 'r3',
      'title': 'Data Science & Machine Learning Real-World Projects',
      'arabicTitle': 'مشاريع عملية متقدمة في علوم البيانات وتحليل الأعمال بـ Python',
      'instructor': 'د. سارة عثمان',
      'rating': 4.7,
      'reviews': '3,780',
      'price': '49.99 \$',
      'originalPrice': '84.99 \$',
      'isBestseller': false,
      'badgeText': 'تطبيقي وعملي',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF134BB8), Color(0xFF1E40AF)],
      'icon': Icons.insights_rounded,
      'accentColor': AppColors.primaryDark,
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
    } else if (homeProvider.recommended.isNotEmpty) {
      list = homeProvider.recommended.map((c) => c.toUiMap(context)).toList();
    } else {
      list = defaultRecommended;
    }

    final Set<String> activeWishlist = wishlistedCourseIds ??
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
            AppSnackbar.showSuccess(
              context,
              context.loc.wishlistAddedSnackbar,
            );
          }
        }
      }
    }

    final bool isSectionLoading = courses == null && homeProvider.recommended.isEmpty && homeProvider.isLoadingRecommended;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSectionLoading
          ? Column(
              key: const ValueKey('recommended_skeleton'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeRecommendedTitle,
                    subtitle: context.loc.homeRecommendedSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap: onSeeAllTap ?? () => MainNavigationScreen.switchToExplore(context, filterIndex: 1),
                  ),
                ),
                const SizedBox(height: 12),
                const HomeCoursesListSkeleton(),
              ],
            )
          : Column(
              key: const ValueKey('recommended_content'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeRecommendedTitle,
                    subtitle: context.loc.homeRecommendedSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap: onSeeAllTap ?? () => MainNavigationScreen.switchToExplore(context, filterIndex: 1),
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
