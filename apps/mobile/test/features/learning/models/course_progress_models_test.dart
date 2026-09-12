import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/learning/data/models/course_progress_models.dart';

void main() {
  group('CourseProgressSummaryModel', () {
    test(
      'fromJson parses summary and calculates completion state correctly',
      () {
        final json = {
          'enrollmentId': 99,
          'courseId': 105,
          'courseTitle': 'Complete Flutter Bootcamp',
          'totalLectures': 40,
          'completedLectures': 40,
          'progressPercentage': 100.0,
          'totalDuration': 36000,
          'watchedDuration': 36000,
        };

        final summary = CourseProgressSummaryModel.fromJson(json);

        expect(summary.enrollmentId, 99);
        expect(summary.courseId, 105);
        expect(summary.isCompleted, isTrue);
        expect(summary.progressRatio, 1.0);
      },
    );

    test('isCompleted returns false when lectures are partially completed', () {
      final json = {
        'courseId': 105,
        'totalLectures': 20,
        'completedLectures': 10,
        'progressPercentage': 50.0,
      };

      final summary = CourseProgressSummaryModel.fromJson(json);

      expect(summary.isCompleted, isFalse);
      expect(summary.progressRatio, 0.5);
    });
  });

  group('LectureResourceModel', () {
    test('fromJson parses downloadable resource metadata', () {
      final json = {
        'id': 1,
        'lectureId': 10,
        'title': 'Source Code ZIP',
        'fileUrl': '/downloads/source.zip',
        'fileType': 'zip',
        'fileSize': '1.0 MB',
      };

      final resource = LectureResourceModel.fromJson(json);

      expect(resource.id, 1);
      expect(resource.lectureId, 10);
      expect(resource.title, 'Source Code ZIP');
      expect(resource.fileType, 'zip');
      expect(resource.fileSize, '1.0 MB');
      expect(resource.formattedUrl, contains('source.zip'));
    });
  });
}
