import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mobile/features/auth/presentation/widgets/facebook_oauth_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles Facebook Login and returns the Access Token for the backend.
class FacebookAuthService {
  FacebookAuthService._();

  static const String _keyAccessToken = 'facebook_access_token';
  static const String _keyDisplayName = 'facebook_display_name';
  static const String _keyEmail = 'facebook_email';

  /// Performs Facebook Sign-In and returns the access token string, or null when cancelled/failed.
  static Future<String?> signInWithFacebook({BuildContext? context}) async {
    const debugTag = 'FACEBOOK_SIGN_IN';
    debugPrint('[$debugTag] Starting Facebook login...');

    // On iOS, native SDK enforces Limited Login (JWT) which the backend rejects,
    // and causes a double-login popup if tried first.
    // So on iOS/Web we directly open the seamless in-app OAuth dialog for a single, direct login.
    final bool isIOS = !kIsWeb && Platform.isIOS;

    if (!isIOS) {
      try {
        try {
          await FacebookAuth.instance.autoLogAppEventsEnabled(true);
        } catch (_) {}

        final LoginResult result = await FacebookAuth.instance.login(
          permissions: const ['email', 'public_profile'],
          loginTracking: LoginTracking.enabled,
          loginBehavior: LoginBehavior.nativeWithFallback,
        );

        debugPrint('[$debugTag] Login status: ${result.status}');

        if (result.status == LoginStatus.success) {
          final AccessToken? accessToken = result.accessToken;
          if (accessToken != null && accessToken.tokenString.isNotEmpty) {
            final tokenString = accessToken.tokenString;
            // If token is a classic Graph API token (does NOT start with eyJ), use it directly
            if (!tokenString.startsWith('eyJ')) {
              debugPrint('[$debugTag] Successfully retrieved Graph API accessToken (length: ${tokenString.length})');
              return tokenString;
            }
          }
        }
      } catch (e, st) {
        debugPrint('[$debugTag] Native Facebook login exception: $e\n$st');
      }
    }

    // Direct in-app OAuth Dialog (single prompt, real Graph API token)
    if (context != null && context.mounted) {
      debugPrint('[$debugTag] Launching direct FacebookOAuthDialog...');
      return await FacebookOAuthDialog.show(context);
    }

    return null;
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
