import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/extensions/course_display_ext.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

void main() {
  const c1 = HomeCourseDTO(
    id: 1,
    title: 'Enrolled Course 1',
    arabicTitle: 'دورة مسجل بها 1',
    instructorName: 'Instructor 1',
  );
  const c2 = HomeCourseDTO(
    id: 2,
    title: 'Unenrolled Course 2',
    arabicTitle: 'دورة غير مسجل بها 2',
    instructorName: 'Instructor 2',
  );
  const c3 = HomeCourseDTO(
    id: 3,
    title: 'Unenrolled Course 3',
    arabicTitle: 'دورة غير مسجل بها 3',
    instructorName: 'Instructor 3',
  );

  group('CourseListDisplayExtensions', () {
    test('prioritizeUnenrolled places unenrolled courses first', () {
      final courses = [c1, c2, c3];
      final enrolledIds = {1};

      final prioritized = courses.prioritizeUnenrolled(enrolledIds);

      expect(prioritized.length, 3);
      expect(prioritized[0].id, 2);
      expect(prioritized[1].id, 3);
      expect(prioritized[2].id, 1);
    });

    test('prioritizeUnenrolled returns same order when enrolledIds is empty', () {
      final courses = [c1, c2, c3];
      final prioritized = courses.prioritizeUnenrolled({});

      expect(prioritized[0].id, 1);
      expect(prioritized[1].id, 2);
      expect(prioritized[2].id, 3);
    });

    test('diversifyByInstructor interleaves courses across instructors round-robin', () {
      const a1 = HomeCourseDTO(id: 10, title: 'A1', arabicTitle: 'A1', instructorName: 'Alice');
      const a2 = HomeCourseDTO(id: 11, title: 'A2', arabicTitle: 'A2', instructorName: 'Alice');
      const a3 = HomeCourseDTO(id: 12, title: 'A3', arabicTitle: 'A3', instructorName: 'Alice');
      const b1 = HomeCourseDTO(id: 20, title: 'B1', arabicTitle: 'B1', instructorName: 'Bob');
      const b2 = HomeCourseDTO(id: 21, title: 'B2', arabicTitle: 'B2', instructorName: 'Bob');
      const c1 = HomeCourseDTO(id: 30, title: 'C1', arabicTitle: 'C1', instructorName: 'Charlie');

      final courses = [a1, a2, a3, b1, b2, c1];
      final diversified = courses.diversifyByInstructor();

      // Round 1: A1, B1, C1
      // Round 2: A2, B2
      // Round 3: A3
      expect(diversified.map((c) => c.id).toList(), [10, 20, 30, 11, 21, 12]);
    });
  });

  group('CourseItemListDisplayExtensions', () {
    final item1 = CourseItem.fromHomeCourse(c1);
    final item2 = CourseItem.fromHomeCourse(c2);

    test('prioritizeUnenrolled orders unenrolled CourseItems before enrolled', () {
      final items = [item1, item2];
      final enrolledIds = {1};

      final prioritized = items.prioritizeUnenrolled(enrolledIds);

      expect(prioritized.first.id, '2');
      expect(prioritized.last.id, '1');
    });
  });
}
