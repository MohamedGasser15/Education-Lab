import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthStorageService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
      AuthStorageService.setMockStorage(resetPrefs: true);
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

    test('legacy token migration from SharedPreferences to SecureStorage', () async {
      SharedPreferences.setMockInitialValues({
        'access_token': 'legacy-access-token',
        'refresh_token': 'legacy-refresh-token',
      });
      FlutterSecureStorage.setMockInitialValues({});
      AuthStorageService.setMockStorage(resetPrefs: true);


      final accessToken = await AuthStorageService.getAccessToken();
      final refreshToken = await AuthStorageService.getRefreshToken();

      expect(accessToken, 'legacy-access-token');
      expect(refreshToken, 'legacy-refresh-token');

      // Check that secure storage received the migrated values
      const secureStorage = FlutterSecureStorage();
      expect(await secureStorage.read(key: 'access_token'), 'legacy-access-token');
      expect(await secureStorage.read(key: 'refresh_token'), 'legacy-refresh-token');

      // Check that plain SharedPreferences was cleaned up
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('access_token'), isNull);
      expect(prefs.getString('refresh_token'), isNull);
    });

    test('saveTokens updates tokens securely', () async {
      await AuthStorageService.saveTokens(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
      );

      expect(await AuthStorageService.getAccessToken(), 'new-access-token');
      expect(await AuthStorageService.getRefreshToken(), 'new-refresh-token');
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
      expect(await AuthStorageService.getRefreshToken(), isNull);
      expect(await AuthStorageService.getUser(), isNull);
    });
  });
}

