import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';

class ContinueLearningMiniBar extends StatefulWidget {
  const ContinueLearningMiniBar({super.key});

  @override
  State<ContinueLearningMiniBar> createState() =>
      _ContinueLearningMiniBarState();
}

class _ContinueLearningMiniBarState extends State<ContinueLearningMiniBar> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();

    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final courses = enrollmentProvider.courses;
    if (courses.isEmpty) return const SizedBox.shrink();

    final inProgress = courses
        .where((c) => c.progressPercentage > 0 && c.progressPercentage < 100)
        .toList();
    final course = inProgress.isNotEmpty
        ? inProgress.first
        : enrollmentProvider.mostRecentCourse;
    if (course == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Material(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mini Course Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Row(
                    children: [
                      // Thumbnail
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AppNetworkImage(
                            url: course.thumbnailUrl,
                            width: 52,
                            height: 38,
                            borderRadius: BorderRadius.circular(8),
                            fit: BoxFit.cover,
                            memCacheWidth: 150,
                            errorWidget: Container(
                              width: 52,
                              height: 38,
                              color: AppColors.primaryDark,
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: isDark ? 0.25 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    context.loc.homeContinueLearning,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${course.progressPercentage}%',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: textSubColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontFamily: 'Tajawal',
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Play CTA Button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Dismiss Button
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: textSubColor,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _isDismissed = true);
                        },
                      ),
                    ],
                  ),
                ),

                // Sleek bottom progress bar
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(13),
                  ),
                  child: LinearProgressIndicator(
                    value: course.progressRatio,
                    minHeight: 3,
                    backgroundColor: isDark
                        ? AppColors.darkBackground
                        : AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
