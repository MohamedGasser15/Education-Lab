import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';

void main() {
  group('SocialLinksModel', () {
    test('cleanUrl handles full URLs, usernames, and empty values', () {
      expect(
        SocialLinksModel.cleanUrl('https://github.com/flutter'),
        'https://github.com/flutter',
      );
      expect(
        SocialLinksModel.cleanUrl('mohamed', defaultDomain: 'github.com'),
        'https://github.com/mohamed',
      );
      expect(SocialLinksModel.cleanUrl(''), isNull);
      expect(SocialLinksModel.cleanUrl('   '), isNull);
      expect(SocialLinksModel.cleanUrl('https://'), isNull);
    });

    test('toJson sanitizes urls with standard social network domains', () {
      const links = SocialLinksModel(
        gitHub: 'my-github',
        linkedIn: 'my-linkedin',
        twitter: 'my-twitter',
        facebook: 'my-facebook',
      );

      final json = links.toJson();

      expect(json['gitHub'], 'https://github.com/my-github');
      expect(json['linkedIn'], 'https://linkedin.com/in/my-linkedin');
      expect(json['twitter'], 'https://x.com/my-twitter');
      expect(json['facebook'], 'https://facebook.com/my-facebook');
    });
  });

  group('UserProfileModel', () {
    test('fromJson parses user attributes, roles, and avatar format', () {
      final json = {
        'id': 'u-999',
        'fullName': 'Mohamed Gasser',
        'email': 'user@example.com',
        'title': 'Senior Mobile Engineer',
        'location': 'Cairo, Egypt',
        'roles': ['Student', 'Instructor'],
        'profileImageUrl': '/Images/profiles/avatar.jpg',
      };

      final profile = UserProfileModel.fromJson(json);

      expect(profile.id, 'u-999');
      expect(profile.fullName, 'Mohamed Gasser');
      expect(profile.email, 'user@example.com');
      expect(profile.title, 'Senior Mobile Engineer');
      expect(profile.isInstructor, isTrue);
      expect(profile.isStudent, isTrue);
      expect(profile.profileImageUrl, contains('avatar.jpg'));
      expect(profile.displayName, 'Mohamed Gasser');
      expect(profile.displayInitials, 'MG');
    });

    test('displayInitials handles single name or email fallback', () {
      const singleName = UserProfileModel(
        id: '1',
        fullName: 'Admin',
        email: 'admin@domain.com',
      );
      expect(singleName.displayInitials, 'A');

      const noName = UserProfileModel(
        id: '2',
        fullName: '',
        email: 'developer@edulab.com',
      );
      expect(noName.displayName, 'developer');
      expect(noName.displayInitials, 'D');
    });
  });
}
