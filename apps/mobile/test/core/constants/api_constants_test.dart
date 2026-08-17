import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/api_constants.dart';

void main() {
  group('ApiConstants', () {
    test('baseUrl points to EduLab API', () {
      expect(ApiConstants.baseUrl, 'https://edulabapi.runasp.net/api/');
    });

    test('auth endpoints defined', () {
      expect(ApiConstants.login, 'auth/login');
      expect(ApiConstants.register, 'auth/Register');
      expect(ApiConstants.refresh, 'auth/refresh');
    });

    test('public endpoints defined', () {
      expect(ApiConstants.publicStats, 'public/stats');
    });
  });
}