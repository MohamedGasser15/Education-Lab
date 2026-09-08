import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_courses_list.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HomeNewCoursesSection extends StatelessWidget {
  const HomeNewCoursesSection({
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

  static const List<Map<String, dynamic>> defaultNewCourses = [
    {
      'id': 'n1',
      'title': 'Next.js 15 & Full-Stack Server Actions Bootcamp',
      'arabicTitle': 'احتراف تطوير تطبيقات الويب بـ Next.js 15 و React Server Actions',
      'instructor': 'م. كريم سامي',
      'rating': 4.9,
      'reviews': '1,280',
      'price': '44.99 \$',
      'originalPrice': '74.99 \$',
      'isBestseller': false,
      'badgeText': 'جديد وحصري',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'icon': Icons.rocket_launch_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'n2',
      'title': 'Advanced AI Agentic Systems with LangChain & AutoGen',
      'arabicTitle': 'بناء أنظمة الوكلاء الأذكياء AI Agents بـ LangChain و AutoGen',
      'instructor': 'م. يوسف محمود',
      'rating': 5.0,
      'reviews': '840',
      'price': '54.99 \$',
      'originalPrice': '89.99 \$',
      'isBestseller': false,
      'badgeText': 'أحدث إصدار',
      'badgeColor': Color(0xFFECFDF5),
      'badgeTextColor': Color(0xFF059669),
      'gradient': [Color(0xFF064E3B), Color(0xFF065F46)],
      'icon': Icons.auto_awesome_rounded,
      'accentColor': Color(0xFF10B981),
    },
    {
      'id': 'n3',
      'title': 'Modern Flutter State Management with Riverpod 3.0',
      'arabicTitle': 'إدارة الحالة المتقدمة في Flutter بـ Riverpod 3.0 و Architecture',
      'instructor': 'م. أحمد محمد',
      'rating': 4.9,
      'reviews': '1,920',
      'price': '39.99 \$',
      'originalPrice': '69.99 \$',
      'isBestseller': false,
      'badgeText': 'جديد ومميز',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF1D61E7), Color(0xFF2563EB)],
      'icon': Icons.flutter_dash_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'n4',
      'title': 'Hands-on Cloud DevOps & CI/CD with Kubernetes & GitHub Actions',
      'arabicTitle': 'التطبيق العملي لـ DevOps و CI/CD بـ Kubernetes و GitHub Actions',
      'instructor': 'د. خالد العلي',
      'rating': 4.8,
      'reviews': '950',
      'price': '49.99 \$',
      'originalPrice': '79.99 \$',
      'isBestseller': false,
      'badgeText': 'حديث ومكثف',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF134BB8), Color(0xFF1D61E7)],
      'icon': Icons.cloud_sync_rounded,
      'accentColor': AppColors.primaryDark,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();

    List<Map<String, dynamic>> list;
    if (courses != null) {
      list = courses!;
    } else if (homeProvider.newCourses.isNotEmpty) {
      list = homeProvider.newCourses.map((c) => c.toUiMap(context)).toList();
    } else {
      list = defaultNewCourses;
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
            wishlistProvider.addToWishlist(intId);
            AppSnackbar.showSuccess(
              context,
              context.loc.wishlistAddedSnackbar,
            );
          }
        }
      }
    }

    final bool isSectionLoading = courses == null && homeProvider.newCourses.isEmpty && homeProvider.isLoadingNewCourses;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSectionLoading
          ? Column(
              key: const ValueKey('new_courses_skeleton'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeNewCoursesTitle,
                    subtitle: context.loc.homeNewCoursesSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap: onSeeAllTap ?? () => MainNavigationScreen.switchToExplore(context, filterIndex: 0),
                  ),
                ),
                const SizedBox(height: 12),
                const HomeCoursesListSkeleton(),
              ],
            )
          : Column(
              key: const ValueKey('new_courses_content'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSectionTitle(
                    title: context.loc.homeNewCoursesTitle,
                    subtitle: context.loc.homeNewCoursesSubtitle,
                    actionText: context.loc.homeViewAll,
                    onActionTap: onSeeAllTap ?? () => MainNavigationScreen.switchToExplore(context, filterIndex: 0),
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
