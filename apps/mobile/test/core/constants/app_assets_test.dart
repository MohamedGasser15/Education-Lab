import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_assets.dart';

void main() {
  group('AppAssets', () {
    test('asset paths use correct prefixes', () {
      expect(AppAssets.defaultAvatar, startsWith('assets/images/'));
      expect(AppAssets.appIcon, startsWith('assets/launcher/'));
      expect(AppAssets.soundSuccess, startsWith('assets/sounds/'));
      expect(AppAssets.soundFailed, startsWith('assets/sounds/'));
      expect(AppAssets.fontTajawal, equals('Tajawal'));
      expect(AppAssets.fontInter, equals('Inter'));
    });
  });
}
