import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles Facebook Login and returns the Access Token for the backend.
class FacebookAuthService {
  FacebookAuthService._();

  static const String _keyAccessToken = 'facebook_access_token';
  static const String _keyDisplayName = 'facebook_display_name';
  static const String _keyEmail = 'facebook_email';

  /// Performs Facebook Sign-In and returns the access token string, or null when cancelled/failed.
  static Future<String?> signInWithFacebook() async {
    const debugTag = 'FACEBOOK_SIGN_IN';
    debugPrint('[$debugTag] Starting Facebook login...');

    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
      );

      debugPrint('[$debugTag] Login status: ${result.status}');

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null || accessToken.tokenString.isEmpty) {
          debugPrint('[$debugTag] FAILED: AccessToken is null or empty');
          return null;
        }

        final tokenString = accessToken.tokenString;
        debugPrint('[$debugTag] Successfully retrieved accessToken (length: ${tokenString.length})');

        // Optional: retrieve user profile from Facebook SDK for local cache
        try {
          final userData = await FacebookAuth.instance.getUserData(
            fields: 'name,email,picture.width(400)',
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_keyAccessToken, tokenString);
          if (userData['name'] != null) {
            await prefs.setString(_keyDisplayName, userData['name'].toString());
          }
          if (userData['email'] != null) {
            await prefs.setString(_keyEmail, userData['email'].toString());
          }
        } catch (e) {
          debugPrint('[$debugTag] Failed to fetch local user data cache: $e');
        }

        return tokenString;
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint('[$debugTag] User cancelled Facebook login');
        return null;
      } else {
        debugPrint('[$debugTag] Login failed: ${result.message}');
        return null;
      }
    } catch (e, st) {
      debugPrint('[$debugTag] ERROR during Facebook login: $e\n$st');
      return null;
    }
  }

  /// Logs out the user from Facebook session.
  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAccessToken);
      await prefs.remove(_keyDisplayName);
      await prefs.remove(_keyEmail);
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('[FACEBOOK_SIGN_IN] Error during signOut: $e');
    }
  }

  /// Checks if current session was initiated via Facebook.
  static Future<bool> isFacebookSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken) != null;
  }
}
