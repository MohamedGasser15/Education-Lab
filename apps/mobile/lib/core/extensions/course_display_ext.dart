import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

/// Extension methods for prioritizing un-enrolled courses and diversifying instructors.
/// Prevents courses from the same instructor from monopolizing the top of a category,
/// and ensures un-enrolled courses appear before enrolled courses when logged in.
extension HomeCourseListDisplayExtensions on List<HomeCourseDTO> {
  /// Returns a new list where un-enrolled courses appear first, and within each
  /// segment (unenrolled vs enrolled), courses are interleaved across instructors
  /// (round-robin) so learners experience variety and diversity.
  List<HomeCourseDTO> prioritizeUnenrolled(Set<int> enrolledIds) {
    return diversifyByInstructor(enrolledIds);
  }

  /// Reorders courses to ensure instructor diversity across the list using round-robin interleaving,
  /// while keeping un-enrolled courses prioritized if [enrolledIds] is provided.
  List<HomeCourseDTO> diversifyByInstructor([Set<int>? enrolledIds]) {
    if (length <= 2) {
      if (enrolledIds != null && enrolledIds.isNotEmpty) {
        final copy = List<HomeCourseDTO>.from(this);
        copy.sort((a, b) {
          final aEnrolled = enrolledIds.contains(a.id) ? 1 : 0;
          final bEnrolled = enrolledIds.contains(b.id) ? 1 : 0;
          return aEnrolled.compareTo(bEnrolled);
        });
        return copy;
      }
      return this;
    }

    if (enrolledIds != null && enrolledIds.isNotEmpty) {
      final unenrolled = where((c) => !enrolledIds.contains(c.id)).toList();
      final enrolled = where((c) => enrolledIds.contains(c.id)).toList();

      return [
        ..._interleaveHomeCourses(unenrolled),
        ..._interleaveHomeCourses(enrolled),
      ];
    }

    return _interleaveHomeCourses(this);
  }

  static List<HomeCourseDTO> _interleaveHomeCourses(List<HomeCourseDTO> list) {
    if (list.length <= 2) return list;

    final Map<String, List<HomeCourseDTO>> groups = {};
    for (final course in list) {
      final key = course.instructorName.trim().isNotEmpty
          ? course.instructorName.trim().toLowerCase()
          : course.id.toString();
      groups.putIfAbsent(key, () => []).add(course);
    }

    if (groups.length <= 1) return list;

    final groupLists = groups.values.toList();
    int maxCount = 0;
    for (final g in groupLists) {
      if (g.length > maxCount) maxCount = g.length;
    }

    final List<HomeCourseDTO> result = [];
    for (int round = 0; round < maxCount; round++) {
      for (final group in groupLists) {
        if (round < group.length) {
          result.add(group[round]);
        }
      }
    }

    return result;
  }
}

extension CourseItemListDisplayExtensions on List<CourseItem> {
  /// Returns a new list where un-enrolled CourseItems appear before enrolled ones,
  /// and courses are interleaved across instructors for diversity.
  List<CourseItem> prioritizeUnenrolled(Set<int> enrolledIds) {
    return diversifyByInstructor(enrolledIds);
  }

  /// Reorders courses to ensure instructor diversity across the list using round-robin interleaving,
  /// while keeping un-enrolled courses prioritized if [enrolledIds] is provided.
  List<CourseItem> diversifyByInstructor([Set<int>? enrolledIds]) {
    if (length <= 2) {
      if (enrolledIds != null && enrolledIds.isNotEmpty) {
        final copy = List<CourseItem>.from(this);
        copy.sort((a, b) {
          final aId = int.tryParse(a.id) ?? 0;
          final bId = int.tryParse(b.id) ?? 0;
          final aEnrolled = enrolledIds.contains(aId) ? 1 : 0;
          final bEnrolled = enrolledIds.contains(bId) ? 1 : 0;
          return aEnrolled.compareTo(bEnrolled);
        });
        return copy;
      }
      return this;
    }

    if (enrolledIds != null && enrolledIds.isNotEmpty) {
      final unenrolled = where((c) {
        final id = int.tryParse(c.id) ?? 0;
        return !enrolledIds.contains(id);
      }).toList();
      final enrolled = where((c) {
        final id = int.tryParse(c.id) ?? 0;
        return enrolledIds.contains(id);
      }).toList();

      return [
        ..._interleaveCourseItems(unenrolled),
        ..._interleaveCourseItems(enrolled),
      ];
    }

    return _interleaveCourseItems(this);
  }

  static List<CourseItem> _interleaveCourseItems(List<CourseItem> list) {
    if (list.length <= 2) return list;

    final Map<String, List<CourseItem>> groups = {};
    for (final course in list) {
      final key = course.instructor.trim().isNotEmpty
          ? course.instructor.trim().toLowerCase()
          : course.id;
      groups.putIfAbsent(key, () => []).add(course);
    }

    if (groups.length <= 1) return list;

    final groupLists = groups.values.toList();
    int maxCount = 0;
    for (final g in groupLists) {
      if (g.length > maxCount) maxCount = g.length;
    }

    final List<CourseItem> result = [];
    for (int round = 0; round < maxCount; round++) {
      for (final group in groupLists) {
        if (round < group.length) {
          result.add(group[round]);
        }
      }
    }

    return result;
  }
}
