import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/app_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSessionService Guest Mode Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('isGuestMode defaults to false', () async {
      final isGuest = await AppSessionService.isGuestMode();
      expect(isGuest, isFalse);
    });

    test('setGuestMode updates guest state properly', () async {
      await AppSessionService.setGuestMode(true);
      expect(await AppSessionService.isGuestMode(), isTrue);

      await AppSessionService.setGuestMode(false);
      expect(await AppSessionService.isGuestMode(), isFalse);
    });
  });
}
