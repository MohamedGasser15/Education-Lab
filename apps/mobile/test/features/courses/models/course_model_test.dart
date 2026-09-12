import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/courses/models/course_model.dart';

void main() {
  group('Instructor Model', () {
    test('fromJson parses instructor info correctly', () {
      final json = {
        'name': 'Dr. Angela',
        'title': 'Senior Software Engineer',
        'avatar': 'https://example.com/avatar.png',
      };

      final inst = Instructor.fromJson(json);

      expect(inst.name, 'Dr. Angela');
      expect(inst.title, 'Senior Software Engineer');
      expect(inst.avatar, 'https://example.com/avatar.png');
    });

    test('fromJson provides empty string defaults when fields are missing', () {
      final inst = Instructor.fromJson({});

      expect(inst.name, '');
      expect(inst.title, '');
      expect(inst.avatar, '');
    });
  });

  group('Course Model & CourseLesson', () {
    test('CourseLesson defaults are applied properly', () {
      final lesson = CourseLesson(
        id: 'l-1',
        title: 'Introduction',
        duration: '10 min',
      );

      expect(lesson.id, 'l-1');
      expect(lesson.title, 'Introduction');
      expect(lesson.duration, '10 min');
      expect(lesson.type, 'video');
      expect(lesson.isFree, isFalse);
      expect(lesson.isCompleted, isFalse);
      expect(lesson.isLocked, isFalse);
      expect(lesson.videoUrl, isNull);
    });

    test('CourseSection holds lessons collection', () {
      final section = CourseSection(
        id: 's-1',
        number: 1,
        title: 'Getting Started',
        lecturesCount: 2,
        duration: '25 min',
        lessons: [
          CourseLesson(id: 'l-1', title: 'Intro', duration: '10 min'),
          CourseLesson(id: 'l-2', title: 'Setup', duration: '15 min'),
        ],
      );

      expect(section.lessons.length, 2);
      expect(section.lecturesCount, 2);
      expect(section.lessons.first.title, 'Intro');
    });

    test('Course properties and computed getters', () {
      final instructor = Instructor(
        name: 'John Doe',
        title: 'Lead Architect',
        avatar: 'https://example.com/john.png',
      );

      final course = Course(
        id: 'c-100',
        title: 'Fullstack Flutter & Dart',
        category: 'Development',
        level: 'متوسط',
        rating: 4.8,
        reviewsCount: 150,
        studentsCount: 1200,
        duration: '12 hours',
        price: 99.0,
        originalPrice: 149.0,
        currency: 'USD',
        image: 'https://example.com/course.png',
        instructor: instructor,
      );

      expect(course.id, 'c-100');
      expect(course.title, 'Fullstack Flutter & Dart');
      expect(course.rating, 4.8);
      expect(course.studentsCount, 1200);
      expect(course.instructor.name, 'John Doe');
      expect(course.isWishlisted, isFalse);
    });
  });
}
