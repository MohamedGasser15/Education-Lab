import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
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
          final int courseId = course.rawId > 0
              ? course.rawId
              : (int.tryParse(course.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1);
          Navigator.pushNamed(context, '/course-details', arguments: courseId);
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
            // 16:9 Thumbnail with CachedNetworkImage & Fallback
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 90,
                height: 66,
                child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: course.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: course.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              course.icon,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 24,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: course.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              course.icon,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 26,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: course.gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            course.icon,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 26,
                          ),
                        ),
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
                    context.isArabic
                        ? (course.arabicTitle.isNotEmpty ? course.arabicTitle : course.title)
                        : (course.title.isNotEmpty ? course.title : course.arabicTitle),
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          course.instructor,
                          style: TextStyle(
                            fontSize: 10,
                            color: textSubColor,
                            fontFamily: isDark ? 'Inter' : 'Tajawal',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '•',
                          style: TextStyle(
                            fontSize: 10,
                            color: textSubColor,
                          ),
                        ),
                      ),
                      Text(
                        course.duration,
                        textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 10,
                          color: textSubColor,
                          fontFamily: isDark ? 'Inter' : 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Rating Row
                  Row(
                    children: [
                      Text(
                        course.rating > 0 ? course.rating.toStringAsFixed(1) : '0.0',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: course.rating > 0 ? const Color(0xFFB4690E) : textSubColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 3),
                      ...List.generate(5, (index) {
                        final starPos = index + 1;
                        if (course.rating >= starPos) {
                          return const Icon(Icons.star_rounded, size: 11.5, color: Color(0xFFF59E0B));
                        } else if (course.rating >= starPos - 0.5) {
                          return const Icon(Icons.star_half_rounded, size: 11.5, color: Color(0xFFF59E0B));
                        } else {
                          return Icon(Icons.star_rounded, size: 11.5, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
                        }
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
                      if (course.badgeText.isNotEmpty) ...[
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
