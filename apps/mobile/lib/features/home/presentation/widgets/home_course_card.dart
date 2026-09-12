import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';

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
    final thumbnailUrl = course['thumbnailUrl'] as String?;

    final double rating = (course['rating'] is num)
        ? (course['rating'] as num).toDouble()
        : (double.tryParse(course['rating']?.toString() ?? '') ?? 0.0);

    final String reviewsStr = course['reviews']?.toString() ?? '0';
    final int reviewsCount = (course['reviews'] is num)
        ? (course['reviews'] as num).toInt()
        : (int.tryParse(reviewsStr.replaceAll(',', '')) ?? 0);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (onTap != null) {
          onTap!();
        } else {
          final rawId = course['id'] ?? course['courseId'] ?? 1;
          final int parsedId = int.tryParse(rawId.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
          Navigator.pushNamed(context, '/course-details', arguments: parsedId);
        }
      },
      child: Container(
        width: 195,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail
            Container(
              height: 94,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                    AppNetworkImage(
                      url: thumbnailUrl,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                      fit: BoxFit.cover,
                      memCacheWidth: 350,
                      errorWidget: Center(
                        child: Icon(
                          (course['icon'] as IconData?) ?? Icons.school_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 32,
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        (course['icon'] as IconData?) ?? Icons.school_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    (course['title'] ?? course['arabicTitle'] ?? '') as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Instructor
                  Text(
                    (course['instructor'] ?? '') as String,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Dynamic Accurate Star Rating Row
                  _buildRatingStars(
                    rating: rating,
                    reviewsCount: reviewsCount,
                    reviewsText: reviewsStr,
                    textSubColor: textSubColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 4),

                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (course['price'] ?? '') as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (course['originalPrice'] != null && (course['originalPrice'] as String).isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          course['originalPrice'] as String,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Badge
                      if (course['badgeText'] != null && (course['badgeText'] as String).isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ((course['badgeColor'] as Color?) ?? AppColors.primary).withValues(alpha: 0.2)
                                  : ((course['badgeColor'] as Color?) ?? const Color(0xFFEFF4FF)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course['badgeText'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : ((course['badgeTextColor'] as Color?) ?? AppColors.primary),
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
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

  Widget _buildRatingStars({
    required double rating,
    required int reviewsCount,
    required String reviewsText,
    required Color textSubColor,
    required bool isDark,
  }) {
    final bool hasRating = rating > 0;
    const Color activeStarColor = Color(0xFFF59E0B);
    final Color emptyStarColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Row(
      children: [
        Text(
          hasRating ? rating.toStringAsFixed(1) : '0.0',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: hasRating ? const Color(0xFFB4690E) : textSubColor,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 3),
        ...List.generate(5, (index) {
          final int starPosition = index + 1;
          IconData icon;
          Color color;

          if (rating >= starPosition) {
            icon = Icons.star_rounded;
            color = activeStarColor;
          } else if (rating >= starPosition - 0.5) {
            icon = Icons.star_half_rounded;
            color = activeStarColor;
          } else {
            icon = Icons.star_rounded;
            color = emptyStarColor;
          }

          return Icon(
            icon,
            size: 11.5,
            color: color,
          );
        }),
        const SizedBox(width: 3),
        Text(
          '($reviewsText)',
          style: TextStyle(
            fontSize: 9,
            color: textSubColor,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
