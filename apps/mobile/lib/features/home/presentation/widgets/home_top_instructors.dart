import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomeTopInstructors extends StatelessWidget {
  const HomeTopInstructors({
    super.key,
    this.instructors,
    this.onInstructorTap,
    this.height = 135,
  });

  final List<Map<String, dynamic>>? instructors;
  final ValueChanged<Map<String, dynamic>>? onInstructorTap;
  final double height;

  static const List<Map<String, dynamic>> _defaultInstructors = [
    {
      'name': 'م. أحمد محمد',
      'role': 'Senior Flutter & Mobile Architect',
      'rating': 4.9,
      'students': '48,200',
      'coursesCount': 12,
      'initial': 'أ',
      'color': AppColors.primary,
    },
    {
      'name': 'سارة أحمد',
      'role': 'Lead Product & UI/UX Designer',
      'rating': 4.9,
      'students': '32,100',
      'coursesCount': 8,
      'initial': 'س',
      'color': Color(0xFF0F172A),
    },
    {
      'name': 'م. يوسف محمود',
      'role': 'AI & Machine Learning Specialist',
      'rating': 4.8,
      'students': '24,500',
      'coursesCount': 6,
      'initial': 'ي',
      'color': Color(0xFF059669),
    },
    {
      'name': 'د. خالد العلي',
      'role': 'Principal Enterprise Cloud Architect',
      'rating': 4.8,
      'students': '19,800',
      'coursesCount': 9,
      'initial': 'خ',
      'color': Color(0xFF134BB8),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final list = instructors ?? _defaultInstructors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final instructor = list[index];
          final color = (instructor['color'] as Color?) ?? AppColors.primary;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onInstructorTap?.call(instructor);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: color,
                      child: Text(
                        (instructor['initial'] ?? '') as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (instructor['name'] ?? '') as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      (instructor['role'] ?? '') as String,
                      style: TextStyle(
                        fontSize: 9.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFE59819)),
                        const SizedBox(width: 3),
                        Text(
                          (instructor['rating'] ?? 0.0).toString(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB4690E),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${instructor['students'] ?? '0'} طالب',
                          style: TextStyle(
                            fontSize: 10,
                            color: textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
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
