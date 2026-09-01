import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';

class ExploreCourseCard extends StatelessWidget {
  const ExploreCourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  final CourseItem course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.pushNamed(context, '/course-details');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16:9 Thumbnail
            Container(
              width: 90,
              height: 66,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: course.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  course.icon,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.arabicTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${course.instructor} • ${course.duration}',
                    style: TextStyle(
                      fontSize: 10,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Rating Row
                  Row(
                    children: [
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB4690E),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 3),
                      ...List.generate(5, (_) {
                        return const Icon(
                          Icons.star_rounded,
                          size: 11.5,
                          color: Color(0xFFE59819),
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${course.reviews})',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: textSubColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Price & Badge
                  Row(
                    children: [
                      Text(
                        course.price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        course.originalPrice,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? course.badgeColor.withValues(alpha: 0.2)
                              : course.badgeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.badgeText,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : course.badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
