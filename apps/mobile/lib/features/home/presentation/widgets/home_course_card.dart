import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomeCourseCard extends StatelessWidget {
  const HomeCourseCard({
    super.key,
    required this.course,
    this.isWishlisted = false,
    this.onWishlistTap,
    this.onTap,
  });

  final Map<String, dynamic> course;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final gradient = (course['gradient'] as List<Color>?) ?? [AppColors.primaryDark, AppColors.primary];

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
        width: 220,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 16:9 Thumbnail
            Container(
              height: 105,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      (course['icon'] as IconData?) ?? Icons.school_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 38,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onWishlistTap?.call();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? const Color(0xFFEF4444) : textColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title (2 Lines max)
                  Text(
                    (course['arabicTitle'] ?? course['title'] ?? '') as String,
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
                  const SizedBox(height: 3),

                  // Instructor
                  Text(
                    (course['instructor'] ?? '') as String,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rating Row
                  Row(
                    children: [
                      Text(
                        (course['rating'] ?? 0.0).toString(),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB4690E),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(5, (starIdx) {
                        return const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFE59819),
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${course['reviews'] ?? '0'})',
                        style: TextStyle(
                          fontSize: 10,
                          color: textSubColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        (course['price'] ?? '') as String,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (course['originalPrice'] != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          course['originalPrice'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Badge
                      if (course['badgeText'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ((course['badgeColor'] as Color?) ?? AppColors.primary).withValues(alpha: 0.2)
                                : ((course['badgeColor'] as Color?) ?? const Color(0xFFEFF4FF)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            course['badgeText'] as String,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : ((course['badgeTextColor'] as Color?) ?? AppColors.primary),
                              fontSize: 9.5,
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
