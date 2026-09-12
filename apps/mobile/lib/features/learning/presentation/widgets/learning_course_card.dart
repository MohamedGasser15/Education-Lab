import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';

/// Card widget that displays an enrolled course with its thumbnail, title, instructor, and progress bar.
class LearningCourseCard extends StatelessWidget {
  final EnrollmentModel course;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color textSubColor;
  final bool isDark;
  final bool isAr;

  const LearningCourseCard({
    super.key,
    required this.course,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.textSubColor,
    required this.isDark,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = course.isCompleted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(
            context,
            '/lesson-player',
            arguments: course.courseId > 0 ? course.courseId : course.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
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
              Stack(
                alignment: Alignment.center,
                children: [
                  AppNetworkImage(
                    url: course.thumbnailUrl,
                    width: 96,
                    height: 64,
                    borderRadius: BorderRadius.circular(8),
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      width: 96,
                      height: 64,
                      color: AppColors.primaryDark,
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.instructorName,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: course.progressRatio,
                        minHeight: 4,
                        backgroundColor: isDark
                            ? AppColors.darkBackground
                            : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? const Color(0xFF10B981)
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isCompleted
                              ? context.loc.learningCompletedBadge
                              : context.loc.learningProgressPercentComplete(
                                  course.progressPercentage.toString(),
                                ),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? const Color(0xFF10B981)
                                : AppColors.primary,
                            fontFamily: 'Tajawal',
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
      ),
    );
  }
}
