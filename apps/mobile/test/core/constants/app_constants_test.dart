import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('has app name', () {
      expect(AppConstants.appName, 'EduLab');
    });

    test('has locale codes', () {
      expect(AppConstants.arCode, 'ar');
      expect(AppConstants.enCode, 'en');
    });
  });
}
