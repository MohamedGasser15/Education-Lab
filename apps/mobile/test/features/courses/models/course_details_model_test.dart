import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';

void main() {
  group('CourseLectureModel', () {
    test('fromJson parses lecture details, duration, and type flags', () {
      final json = {
        'id': 10,
        'title': 'Setting Up Development Environment',
        'videoUrl': 'https://example.com/video.mp4',
        'contentType': 'Video',
        'duration': 360, // 6 minutes (360 seconds)
        'sectionId': 1,
        'isFreePreview': true,
      };

      final lecture = CourseLectureModel.fromJson(json);

      expect(lecture.id, 10);
      expect(lecture.title, 'Setting Up Development Environment');
      expect(lecture.isVideo, isTrue);
      expect(lecture.isArticle, isFalse);
      expect(lecture.isQuiz, isFalse);
      expect(lecture.isFreePreview, isTrue);
      expect(lecture.formattedDuration, '06:00');
    });

    test('isArticle returns true when contentType is article', () {
      final json = {
        'id': 11,
        'title': 'Documentation and Cheatsheet',
        'articleContent': '# Markdown content here',
        'contentType': 'Article',
        'sectionId': 1,
      };

      final lecture = CourseLectureModel.fromJson(json);

      expect(lecture.isArticle, isTrue);
      expect(lecture.isVideo, isFalse);
    });
  });

  group('CourseSectionModel', () {
    test('fromJson parses section with lectures', () {
      final json = {
        'id': 1,
        'title': 'Chapter 1: Basics',
        'order': 1,
        'lectures': [
          {'id': 101, 'title': 'Lecture 1.1', 'sectionId': 1, 'duration': 120},
          {'id': 102, 'title': 'Lecture 1.2', 'sectionId': 1, 'duration': 180},
        ],
      };

      final section = CourseSectionModel.fromJson(json);

      expect(section.id, 1);
      expect(section.title, 'Chapter 1: Basics');
      expect(section.lectures.length, 2);
    });
  });

  group('CourseDetailsModel', () {
    test('fromJson parses course details, pricing, and nested sections', () {
      final json = {
        'id': 500,
        'title': 'Advanced Flutter Architecture',
        'price': 100.0,
        'discount': 25.0,
        'totalLectures': 1,
        'averageRating': 4.9,
        'totalRatings': 80,
        'instructorName': 'Eng. Mohamed',
        'sections': [
          {
            'id': 1,
            'title': 'Intro',
            'lectures': [
              {'id': 1, 'title': 'Overview', 'sectionId': 1, 'duration': 300},
            ],
          },
        ],
        'requirements': ['Basic Dart Knowledge', 'Flutter Installed'],
        'learnings': ['Clean Architecture', 'State Management'],
      };

      final course = CourseDetailsModel.fromJson(json);

      expect(course.id, 500);
      expect(course.title, 'Advanced Flutter Architecture');
      expect(course.price, 100.0);
      expect(course.finalPrice, 75.0);
      expect(course.hasDiscount, isTrue);
      expect(course.sections.length, 1);
      expect(course.requirements.length, 2);
      expect(course.learnings.length, 2);
      expect(course.totalLectures, 1);
      expect(course.calculatedTotalLectures, 1);
    });
  });
}
