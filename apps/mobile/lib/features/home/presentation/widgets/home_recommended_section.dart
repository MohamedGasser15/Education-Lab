import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/home_courses_list.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';

class HomeRecommendedSection extends StatefulWidget {
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
  State<HomeRecommendedSection> createState() => _HomeRecommendedSectionState();
}

class _HomeRecommendedSectionState extends State<HomeRecommendedSection> {
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
    final list = widget.courses ?? HomeRecommendedSection.defaultRecommended;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionTitle(
            title: context.loc.homeRecommendedTitle,
            subtitle: context.loc.homeRecommendedSubtitle,
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
