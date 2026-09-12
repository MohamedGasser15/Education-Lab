import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/data/models/home_models.dart';

void main() {
  group('HomeStatsDTO', () {
    test('fromJson parses stats correctly', () {
      final json = {
        'totalStudents': 5000,
        'totalCourses': 120,
        'totalInstructors': 45,
        'satisfactionPercent': 99.2,
      };

      final stats = HomeStatsDTO.fromJson(json);

      expect(stats.totalStudents, 5000);
      expect(stats.totalCourses, 120);
      expect(stats.totalInstructors, 45);
      expect(stats.satisfactionRate, 99.2);
    });

    test('fromJson uses defaults when empty', () {
      final stats = HomeStatsDTO.fromJson({});

      expect(stats.totalStudents, 0);
      expect(stats.totalCourses, 0);
      expect(stats.totalInstructors, 0);
      expect(stats.satisfactionRate, 98.5);
    });
  });

  group('HomeCategoryDTO', () {
    test('fromJson parses category properties and colors', () {
      final json = {
        'categoryId': 5,
        'categoryName': 'الذكاء الاصطناعي',
        'categoryEnglishName': 'Artificial Intelligence',
        'coursesCount': 18,
      };

      final cat = HomeCategoryDTO.fromJson(json);

      expect(cat.id, 5);
      expect(cat.nameAr, 'الذكاء الاصطناعي');
      expect(cat.nameEn, 'Artificial Intelligence');
      expect(cat.coursesCount, 18);
      expect(cat.name, 'الذكاء الاصطناعي');
    });

    test('copyWith updates specified fields', () {
      const original = HomeCategoryDTO(
        id: 1,
        nameAr: 'تصميم',
        nameEn: 'Design',
        coursesCount: 10,
      );

      final updated = original.copyWith(coursesCount: 15);

      expect(updated.id, 1);
      expect(updated.coursesCount, 15);
      expect(updated.nameAr, 'تصميم');
    });
  });

  group('HomeCourseDTO', () {
    test('fromJson parses course details and calculates bestseller and featured flags', () {
      final json = {
        'id': 101,
        'title': 'Flutter 3.x Masterclass',
        'arabicTitle': 'دورة فلاتر الاحترافية',
        'instructorName': 'Eng. Mohamed Gasser',
        'rating': 4.9,
        'totalRatings': 250,
        'price': 49.99,
        'discount': 20.0,
      };

      final course = HomeCourseDTO.fromJson(json);

      expect(course.id, 101);
      expect(course.title, 'Flutter 3.x Masterclass');
      expect(course.arabicTitle, 'دورة فلاتر الاحترافية');
      expect(course.instructorName, 'Eng. Mohamed Gasser');
      expect(course.rating, 4.9);
      expect(course.reviewsCount, 250);
      expect(course.price, 49.99);
      expect(course.isFeatured, isTrue);
      expect(course.isBestseller, isTrue);
      expect(course.originalPrice, isNotNull);
    });

    test('toUiMap converts model to UI map format', () {
      const course = HomeCourseDTO(
        id: 1,
        title: 'Python for Beginners',
        arabicTitle: 'بايثون للمبتدئين',
        instructorName: 'Tariq',
        price: 0.0,
      );

      final uiMap = course.toUiMap();

      expect(uiMap['id'], '1');
      expect(uiMap['arabicTitle'], 'بايثون للمبتدئين');
      expect(uiMap['price'], 'مجاناً');
      expect(uiMap['instructor'], 'Tariq');
    });
  });

  group('HomeInstructorDTO', () {
    test('fromJson parses instructor info and sets isTopRated', () {
      final json = {
        'id': 'inst-1',
        'fullName': 'Dr. Sara',
        'headline': 'AI Researcher',
        'rating': 4.9,
        'totalStudents': 1200,
        'totalCourses': 4,
      };

      final inst = HomeInstructorDTO.fromJson(json);

      expect(inst.id, 'inst-1');
      expect(inst.name, 'Dr. Sara');
      expect(inst.headline, 'AI Researcher');
      expect(inst.rating, 4.9);
      expect(inst.totalStudents, 1200);
      expect(inst.isTopRated, isTrue);
    });
  });
}
