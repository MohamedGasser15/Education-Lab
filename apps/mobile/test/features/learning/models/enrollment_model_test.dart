import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/learning/data/models/enrollment_model.dart';

void main() {
  group('EnrollmentModel', () {
    test('fromJson parses enrollment properties and calculates status correctly', () {
      final json = {
        'id': 1,
        'courseId': 105,
        'title': 'Mastering Clean Architecture',
        'price': 100.0,
        'discount': 20.0,
        'finalPrice': 80.0,
        'progressPercentage': 75,
        'totalLectures': 20,
        'duration': 7200, // 2 hours
        'instructorName': 'Lead Eng',
        'categoryName': 'هندسة البرمجيات',
        'categoryEnglishName': 'Software Engineering',
      };

      final enrollment = EnrollmentModel.fromJson(json);

      expect(enrollment.id, 1);
      expect(enrollment.courseId, 105);
      expect(enrollment.title, 'Mastering Clean Architecture');
      expect(enrollment.price, 100.0);
      expect(enrollment.discount, 20.0);
      expect(enrollment.finalPrice, 80.0);
      expect(enrollment.progressPercentage, 75);
      expect(enrollment.progressRatio, 0.75);
      expect(enrollment.isCompleted, isFalse);
      expect(enrollment.completedLectures, 15); // 20 * 0.75 = 15
    });

    test('isCompleted returns true when progress reaches 100%', () {
      const completed = EnrollmentModel(
        id: 2,
        courseId: 200,
        title: 'Completed Course',
        progressPercentage: 100,
      );

      expect(completed.isCompleted, isTrue);
      expect(completed.progressRatio, 1.0);
      expect(completed.remainingHours, 0.0);
    });

    test('toJson produces expected data map', () {
      const enrollment = EnrollmentModel(
        id: 10,
        courseId: 55,
        title: 'Dart Testing',
        price: 50.0,
        progressPercentage: 50,
      );

      final json = enrollment.toJson();

      expect(json['id'], 10);
      expect(json['courseId'], 55);
      expect(json['title'], 'Dart Testing');
      expect(json['progressPercentage'], 50);
    });
  });
}
