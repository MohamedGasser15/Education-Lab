import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/home_courses_list.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';

class HomeNewCoursesSection extends StatefulWidget {
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
  State<HomeNewCoursesSection> createState() => _HomeNewCoursesSectionState();
}

class _HomeNewCoursesSectionState extends State<HomeNewCoursesSection> {
  final Set<String> _internalWishlist = {'c1', 'c3'};

  Set<String> get _currentWishlist => widget.wishlistedCourseIds ?? _internalWishlist;

  void _handleWishlist(String courseId) {
    if (widget.onToggleWishlist != null) {
      widget.onToggleWishlist!(courseId);
    } else {
      setState(() {
        if (_internalWishlist.contains(courseId)) {
          _internalWishlist.remove(courseId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت إزالة الدورة من قائمة الرغبات'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1400),
            ),
          );
        } else {
          _internalWishlist.add(courseId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت إضافة الدورة إلى قائمة الرغبات بنجاح'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 1400),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.courses ?? HomeNewCoursesSection.defaultNewCourses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionTitle(
            title: context.loc.homeNewCoursesTitle,
            subtitle: context.loc.homeNewCoursesSubtitle,
            actionText: widget.onSeeAllTap != null ? context.loc.homeViewAll : null,
            onActionTap: widget.onSeeAllTap,
          ),
        ),
        const SizedBox(height: 12),
        HomeCoursesList(
          courses: list,
          wishlistedCourseIds: _currentWishlist,
          onToggleWishlist: _handleWishlist,
          onCourseTap: widget.onCourseTap,
        ),
      ],
    );
  }
}
