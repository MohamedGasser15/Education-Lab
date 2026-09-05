import 'package:flutter/material.dart';
import 'package:mobile/features/home/presentation/widgets/home_course_card.dart';

class HomeCoursesList extends StatelessWidget {
  const HomeCoursesList({
    super.key,
    required this.courses,
    this.wishlistedCourseIds = const {},
    this.onToggleWishlist,
    this.onCourseTap,
    this.height = 196,
  });

  final List<Map<String, dynamic>> courses;
  final Set<String> wishlistedCourseIds;
  final ValueChanged<String>? onToggleWishlist;
  final ValueChanged<Map<String, dynamic>>? onCourseTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          final courseId = (course['id'] ?? '') as String;
          final isWishlisted = wishlistedCourseIds.contains(courseId);

          return HomeCourseCard(
            course: course,
            isWishlisted: isWishlisted,
            onWishlistTap: () => onToggleWishlist?.call(courseId),
            onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
          );
        },
      ),
    );
  }
}
