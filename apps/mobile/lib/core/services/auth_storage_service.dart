import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _userKey = 'user_info';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberedEmailKey = 'remembered_email';
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
  }) async {
    final prefs = await _instance;
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_userKey, json.encode(user));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await _instance;
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await _instance;
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _instance;
    return prefs.getString(_refreshTokenKey);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _instance;
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      try {
        return json.decode(userStr) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await _instance;
    await prefs.remove(_userKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?['id']?.toString();
  }

  static Future<String> getUserName() async {
    final user = await getUser();
    return user?['fullName']?.toString() ?? '';
  }

  static Future<void> saveRememberedEmail(String email) async {
    final prefs = await _instance;
    await prefs.setString(_rememberedEmailKey, email);
  }

  static Future<String?> getRememberedEmail() async {
    final prefs = await _instance;
    return prefs.getString(_rememberedEmailKey);
  }

  static Future<void> clearRememberedEmail() async {
    final prefs = await _instance;
    await prefs.remove(_rememberedEmailKey);
  }
}