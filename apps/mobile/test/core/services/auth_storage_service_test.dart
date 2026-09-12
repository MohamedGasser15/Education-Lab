import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthStorageService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('isLoggedIn returns false when not logged in', () async {
      final loggedIn = await AuthStorageService.isLoggedIn();
      expect(loggedIn, isFalse);
      expect(await AuthStorageService.getAccessToken(), isNull);
    });

    test('saveAuth saves tokens and user profile information', () async {
      await AuthStorageService.saveAuth(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        user: {
          'id': 'usr-789',
          'fullName': 'Mohamed Gasser',
          'email': 'mohamed@test.com',
        },
      );

      expect(await AuthStorageService.isLoggedIn(), isTrue);
      expect(await AuthStorageService.getAccessToken(), 'access-123');
      expect(await AuthStorageService.getRefreshToken(), 'refresh-456');
      expect(await AuthStorageService.getUserId(), 'usr-789');
      expect(await AuthStorageService.getUserName(), 'Mohamed Gasser');
      expect(await AuthStorageService.getUserEmail(), 'mohamed@test.com');
    });

    test('logout clears credentials and sets isLoggedIn to false', () async {
      await AuthStorageService.saveAuth(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        user: {'id': 'usr-789'},
      );
      expect(await AuthStorageService.isLoggedIn(), isTrue);

      await AuthStorageService.logout();
      expect(await AuthStorageService.isLoggedIn(), isFalse);
      expect(await AuthStorageService.getAccessToken(), isNull);
      expect(await AuthStorageService.getUser(), isNull);
    });
  });
}
