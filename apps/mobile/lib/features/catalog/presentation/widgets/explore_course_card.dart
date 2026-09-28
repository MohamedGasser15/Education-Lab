import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/strikethrough_text.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';

class ExploreCourseCard extends StatelessWidget {
  const ExploreCourseCard({super.key, required this.course, this.onTap});

  final CourseItem course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (onTap != null) {
          onTap!();
        } else {
          final int courseId = course.rawId > 0
              ? course.rawId
              : (int.tryParse(course.id.replaceAll(RegExp(r'[^0-9]'), '')) ??
                    1);
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
            // 16:9 Thumbnail with AppNetworkImage & Gradient Fallback
            SizedBox(
              width: 90,
              height: 66,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    url: course.thumbnailUrl,
                    width: 90,
                    height: 66,
                    borderRadius: BorderRadius.circular(8),
                    fit: BoxFit.cover,
                    memCacheWidth: 250,
                    placeholder: Container(
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
                    errorWidget: Container(
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
                  ),
                  if (course.discountPercent != null &&
                      course.discountPercent! > 0)
                    PositionedDirectional(
                      top: 4,
                      start: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6D28D9).withValues(alpha: 0.35),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${course.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ),
                ],
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
                        ? (course.arabicTitle.isNotEmpty
                              ? course.arabicTitle
                              : course.title)
                        : (course.title.isNotEmpty
                              ? course.title
                              : course.arabicTitle),
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
                          style: TextStyle(fontSize: 10, color: textSubColor),
                        ),
                      ),
                      Text(
                        course.duration,
                        textDirection: context.isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
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
                        course.rating > 0
                            ? course.rating.toStringAsFixed(1)
                            : '0.0',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: course.rating > 0
                              ? AppColors.goldDark
                              : textSubColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 3),
                      ...List.generate(5, (index) {
                        final starPos = index + 1;
                        if (course.rating >= starPos) {
                          return const Icon(
                            Icons.star_rounded,
                            size: 11.5,
                            color: AppColors.gold,
                          );
                        } else if (course.rating >= starPos - 0.5) {
                          return const Icon(
                            Icons.star_half_rounded,
                            size: 11.5,
                            color: AppColors.gold,
                          );
                        } else {
                          return Icon(
                            Icons.star_rounded,
                            size: 11.5,
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.border,
                          );
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
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      if (course.originalPrice.isNotEmpty) ...[
                        const SizedBox(width: 5),
                        StrikethroughText(
                          text: course.originalPrice,
                          style: TextStyle(
                            fontSize: 10,
                            color: textSubColor.withValues(alpha: 0.65),
                            fontFamily: 'Tajawal',
                          ),
                          lineColor: textSubColor.withValues(alpha: 0.65),
                          strokeWidth: 1.0,
                          yOffset: -1.3,
                        ),
                        if (course.discountPercent != null &&
                            course.discountPercent! > 0) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(
                                alpha: isDark ? 0.2 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${course.discountPercent}%',
                              style: const TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFEF4444),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ],
                      if (course.badgeText.isNotEmpty) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? course.badgeColor.withValues(alpha: 0.2)
                                : course.badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            course.badgeText,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : course.badgeTextColor,
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
