import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccentColorOption {
  final String key;
  final String nameAr;
  final String nameEn;
  final Color color;

  const AccentColorOption({
    required this.key,
    required this.nameAr,
    required this.nameEn,
    required this.color,
  });
}

class TextScalePreset {
  final double scale;
  final String labelAr;
  final String labelEn;

  const TextScalePreset({
    required this.scale,
    required this.labelAr,
    required this.labelEn,
  });
}

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  static const String _textScaleKey = 'app_text_scale';
  static const String _amoledKey = 'app_amoled_dark';
  static const String _accentKey = 'app_accent_color';

  static const List<AccentColorOption> accentOptions = [
    AccentColorOption(
      key: 'blue',
      nameAr: 'أزرق إديولاب',
      nameEn: 'EduLab Blue',
      color: Color(0xFF1D61E7),
    ),
    AccentColorOption(
      key: 'emerald',
      nameAr: 'أخضر زمردي',
      nameEn: 'Emerald Green',
      color: Color(0xFF059669),
    ),
    AccentColorOption(
      key: 'violet',
      nameAr: 'بنفسجي إبداعي',
      nameEn: 'Creative Violet',
      color: Color(0xFF7C3AED),
    ),
    AccentColorOption(
      key: 'amber',
      nameAr: 'كهرماني دافئ',
      nameEn: 'Warm Amber',
      color: Color(0xFFEA580C),
    ),
    AccentColorOption(
      key: 'rose',
      nameAr: 'وردي عصري',
      nameEn: 'Modern Rose',
      color: Color(0xFFE11D48),
    ),
  ];

  static const List<TextScalePreset> textScalePresets = [
    TextScalePreset(scale: 0.85, labelAr: 'صغير', labelEn: 'Small'),
    TextScalePreset(scale: 1.00, labelAr: 'افتراضي', labelEn: 'Default'),
    TextScalePreset(scale: 1.15, labelAr: 'كبير', labelEn: 'Large'),
    TextScalePreset(scale: 1.30, labelAr: 'كبير جداً', labelEn: 'Extra Large'),
  ];

  ThemeMode _themeMode = ThemeMode.light;
  double _textScale = 1.0;
  bool _isAmoled = false;
  Color _accentColor = const Color(0xFF1D61E7);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get textScale => _textScale;
  bool get isAmoled => _isAmoled;
  Color get accentColor => _accentColor;

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }

      _textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
      _isAmoled = prefs.getBool(_amoledKey) ?? false;

      final savedAccent = prefs.getInt(_accentKey);
      if (savedAccent != null) {
        _accentColor = Color(savedAccent);
      }

      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleDarkMode(bool enableDark) async {
    _themeMode = enableDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, enableDark ? 'dark' : 'light');
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      String modeStr = 'light';
      if (mode == ThemeMode.dark) {
        modeStr = 'dark';
      } else if (mode == ThemeMode.system) {
        modeStr = 'system';
      }
      await prefs.setString(_themeKey, modeStr);
    } catch (_) {}
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey, scale);
    } catch (_) {}
  }

  Future<void> toggleAmoled(bool enable) async {
    _isAmoled = enable;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_amoledKey, enable);
    } catch (_) {}
  }

  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_accentKey, color.toARGB32());
    } catch (_) {}
  }
}
