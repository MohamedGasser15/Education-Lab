import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeService Tests', () {
    late ThemeService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = ThemeService();
    });

    test('default theme mode is light', () {
      expect(service.themeMode, ThemeMode.light);
      expect(service.isDarkMode, isFalse);
    });

    test('toggleDarkMode toggles to dark and persists', () async {
      await service.toggleDarkMode(true);
      expect(service.themeMode, ThemeMode.dark);
      expect(service.isDarkMode, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'dark');

      await service.toggleDarkMode(false);
      expect(service.themeMode, ThemeMode.light);
      expect(service.isDarkMode, isFalse);
    });

    test('setThemeMode updates to system and persists', () async {
      await service.setThemeMode(ThemeMode.system);
      expect(service.themeMode, ThemeMode.system);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'system');
    });

    test('loadTheme retrieves saved theme setting', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      await service.loadTheme();
      expect(service.themeMode, ThemeMode.dark);
      expect(service.isDarkMode, isTrue);
    });
  });
}
