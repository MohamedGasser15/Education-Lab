import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/constants/app_constants.dart';

class LocaleService extends ChangeNotifier {
  static String cachedLanguageCode = AppConstants.arCode;

  Locale _locale = const Locale(AppConstants.arCode);

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language') ?? AppConstants.arCode;
    cachedLanguageCode = langCode;
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> setLocale(String langCode) async {
    cachedLanguageCode = langCode;
    _locale = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    notifyListeners();
  }
}
