import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:provider/provider.dart';

class HomeTopInstructors extends StatelessWidget {
  const HomeTopInstructors({
    super.key,
    this.instructors,
    this.onInstructorTap,
    this.height = 106,
  });

  final List<Map<String, dynamic>>? instructors;
  final ValueChanged<Map<String, dynamic>>? onInstructorTap;
  final double height;

  static const List<Map<String, dynamic>> defaultInstructors = [
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
    final isAr = context.isArabic;
    final homeProvider = context.watch<HomeProvider>();

    List<Map<String, dynamic>> list;
    if (instructors != null) {
      list = instructors!;
    } else if (homeProvider.instructors.isNotEmpty) {
      list = homeProvider.instructors.map((ins) {
        final initial = ins.name.trim().isNotEmpty ? ins.name.trim()[0] : 'م';
        return {
          'id': ins.id,
          'name': ins.name,
          'role': ins.getLocalizedHeadline(context),
          'rating': ins.rating,
          'students': ins.totalStudents.toString(),
          'coursesCount': ins.coursesCount,
          'avatarUrl': ins.profileImageUrl,
          'initial': initial,
          'color': AppColors.primary,
        };
      }).toList();
    } else {
      list = defaultInstructors;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final bool isSectionLoading = instructors == null && homeProvider.instructors.isEmpty && homeProvider.isLoadingInstructors;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSectionLoading
          ? HomeTopInstructorsSkeleton(
              key: const ValueKey('instructors_skeleton'),
              height: height,
            )
          : SizedBox(
              key: const ValueKey('instructors_content'),
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
          final avatarUrl = instructor['avatarUrl'] as String?;
          final coursesCount = instructor['coursesCount'];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onInstructorTap?.call(instructor);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 220,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Avatar + Name & Specialty
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: avatarUrl != null && avatarUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: avatarUrl,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => _buildAvatarFallback(instructor, color),
                                      )
                                    : _buildAvatarFallback(instructor, color),
                              ),
                            ),
                            Positioned(
                              bottom: -1,
                              right: isAr ? null : -1,
                              left: isAr ? -1 : null,
                              child: Container(
                                padding: const EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  size: 13,
                                  color: AppColors.primary,
                                ),
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
                                (instructor['name'] ?? '') as String,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontFamily: 'Tajawal',
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                (instructor['role'] ?? '') as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Divider
                    Container(
                      height: 1,
                      color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
                    ),
                    const SizedBox(height: 6),

                    // Bottom Row: Rating Pill + Students Count + Courses
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 11.5, color: Color(0xFFD97706)),
                              const SizedBox(width: 2),
                              Text(
                                (instructor['rating'] ?? 0.0).toString(),
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            context.loc.studentsCountText(instructor['students']?.toString() ?? '0'),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (coursesCount != null)
                          Text(
                            context.loc.instructorsCoursesCount(coursesCount.toString()),
                            style: TextStyle(
                              fontSize: 9,
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
      ),
    );
  }

  Widget _buildAvatarFallback(Map<String, dynamic> instructor, Color color) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Text(
        (instructor['initial'] ?? '') as String,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
