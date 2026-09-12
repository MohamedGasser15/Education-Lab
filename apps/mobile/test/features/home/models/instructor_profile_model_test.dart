import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/data/models/instructor_profile_model.dart';

void main() {
  group('InstructorProfileModel', () {
    test('fromJson parses full instructor profile with subjects and links', () {
      final json = {
        'id': 'inst-99',
        'fullName': 'Eng. Kareem',
        'title': 'Senior DevOps Engineer',
        'about': 'Passionate about CI/CD and Flutter.',
        'rating': 4.95,
        'totalStudents': 3400,
        'totalCourses': 8,
        'location': 'Cairo, Egypt',
        'subjects': ['DevOps', 'Docker', 'Kubernetes'],
        'gitHub': 'kareem-dev',
        'linkedIn': 'kareem-linkedin',
      };

      final profile = InstructorProfileModel.fromJson(json);

      expect(profile.id, 'inst-99');
      expect(profile.name, 'Eng. Kareem');
      expect(profile.headline, 'Senior DevOps Engineer');
      expect(profile.about, 'Passionate about CI/CD and Flutter.');
      expect(profile.rating, 4.95);
      expect(profile.totalStudents, 3400);
      expect(profile.coursesCount, 8);
      expect(profile.location, 'Cairo, Egypt');
      expect(profile.subjects.length, 3);
      expect(profile.subjects, contains('Docker'));
    });
  });
}
