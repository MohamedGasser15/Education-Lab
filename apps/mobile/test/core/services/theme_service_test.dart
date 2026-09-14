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

    test('setTextScale updates scale and persists', () async {
      await service.setTextScale(1.15);
      expect(service.textScale, 1.15);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('app_text_scale'), 1.15);
    });

    test('toggleAmoled updates isAmoled and persists', () async {
      await service.toggleAmoled(true);
      expect(service.isAmoled, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('app_amoled_dark'), isTrue);
    });

    test('setAccentColor updates accentColor and persists', () async {
      const newColor = Color(0xFF059669);
      await service.setAccentColor(newColor);
      expect(service.accentColor, newColor);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('app_accent_color'), newColor.toARGB32());
    });

    test('loadTheme retrieves all saved settings', () async {
      const testColor = Color(0xFF7C3AED);
      SharedPreferences.setMockInitialValues({
        'app_theme_mode': 'dark',
        'app_text_scale': 1.30,
        'app_amoled_dark': true,
        'app_accent_color': testColor.toARGB32(),
      });
      await service.loadTheme();
      expect(service.themeMode, ThemeMode.dark);
      expect(service.isDarkMode, isTrue);
      expect(service.textScale, 1.30);
      expect(service.isAmoled, isTrue);
      expect(service.accentColor, testColor);
    });
  });
}
