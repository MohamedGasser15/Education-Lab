import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProfileRepository extends ProfileRepository {
  UserProfileModel? user;
  FakeProfileRepository({this.user});

  @override
  Future<UserProfileModel?> getCachedProfile() async {
    return user;
  }

  @override
  Future<Result<UserProfileModel>> fetchRemoteProfile() async {
    if (user != null) {
      return Success(user!);
    }
    return const Failure('User not found');
  }

  @override
  Future<Result<bool>> updateProfile(UserProfileModel profile) async {
    user = profile;
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileProvider Tests', () {
    late ProfileProvider provider;
    late FakeProfileRepository fakeRepo;
    const testUser = UserProfileModel(
      id: 'usr-1',
      fullName: 'Ahmed Ali',
      email: 'ahmed@test.com',
      roles: ['Instructor'],
    );

    setUp(() {
      SharedPreferences.setMockInitialValues({'is_logged_in': true});
      fakeRepo = FakeProfileRepository(user: testUser);
      provider = ProfileProvider(repository: fakeRepo);
    });

    test('init and fetchProfile sets user profile and role getters', () async {
      await provider.fetchProfile(forceRefresh: true);

      expect(provider.profile, isNotNull);
      expect(provider.profile?.fullName, 'Ahmed Ali');
      expect(provider.isInstructor, isTrue);
      expect(provider.isStudent, isFalse);
      expect(provider.hasProfile, isTrue);
      expect(provider.isLoggedIn, isTrue);
    });

    test('saveProfile updates local state on success', () async {
      await provider.fetchProfile();
      final updated = provider.profile!.copyWith(fullName: 'Ahmed Mohamed');

      final result = await provider.saveProfile(updated);
      expect(result is Success, isTrue);
      expect(provider.profile?.fullName, 'Ahmed Mohamed');
    });

    test('logout clears profile state', () async {
      await provider.fetchProfile();
      expect(provider.profile, isNotNull);

      await provider.logout();
      expect(provider.profile, isNull);
      expect(provider.hasProfile, isFalse);
      expect(provider.isLoggedIn, isFalse);
    });
  });
}
