import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_assets.dart';

void main() {
  group('AppAssets', () {
    test('asset paths use assets prefix', () {
      expect(AppAssets.appLogo, startsWith('assets/'));
      expect(AppAssets.navBarLogo, startsWith('assets/'));
      expect(AppAssets.authLoginBackground, startsWith('assets/'));
    });
  });
}