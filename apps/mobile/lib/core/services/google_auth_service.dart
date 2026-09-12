import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Google OAuth client ID for Android / Web / Backend.
const String kAndroidClientId =
    '114806076172-tqtrrqupp076ilo8j3hgpb8jhggju8fv.apps.googleusercontent.com';
const String kIosClientId =
    '114806076172-be913jqrvsnprd7ei3nk61lpfc41aia3.apps.googleusercontent.com';

/// Handles Google Sign-In and returns the ID token for the backend.
class GoogleAuthService {
  GoogleAuthService._();

  static const String _keyIdToken = 'google_id_token';
  static const String _keyDisplayName = 'google_display_name';
  static const String _keyEmail = 'google_email';

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    clientId: _isApple ? kIosClientId : null,
    serverClientId: kAndroidClientId,
  );

  /// Performs Google Sign-In and returns the ID token, or null when cancelled/failed.
  static Future<String?> signInWithGoogle() async {
    const debugTag = 'GOOGLE_SIGN_IN';
    debugPrint('[$debugTag] starting sign-in (apple=$_isApple)');
    try {
      // Clear any previously signed-in session to always show the account picker
      final account = await _googleSignIn
          .signIn()
          .timeout(const Duration(seconds: 45));
      if (account == null) {
        debugPrint('[$debugTag] account returned null -> user cancelled');
        return null;
      }
      debugPrint('[$debugTag] account = ${account.email} '
          '(${account.displayName ?? 'no-name'})');

      var auth = await account.authentication;
      var idToken = auth.idToken;
      debugPrint('[$debugTag] got idToken? ${idToken != null}'
          ' length=${idToken?.length ?? 0}');

      // If idToken is null on the first attempt (known Android Google Play Services caching issue for new accounts):
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[$debugTag] idToken was null on initial read. Clearing auth cache & re-fetching token...');
        try {
          await account.clearAuthCache();
        } catch (_) {}
        auth = await account.authentication;
        idToken = auth.idToken;
        debugPrint('[$debugTag] retry after clearAuthCache: got idToken? ${idToken != null}');
      }

      // If still null, try signInSilently with reAuthenticate
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[$debugTag] idToken still null. Attempting signInSilently fallback...');
        try {
          final silentAccount = await _googleSignIn.signInSilently(reAuthenticate: true);
          if (silentAccount != null) {
            auth = await silentAccount.authentication;
            idToken = auth.idToken;
            debugPrint('[$debugTag] retry after signInSilently: got idToken? ${idToken != null}');
          }
        } catch (_) {}
      }

      if (idToken == null || idToken.isEmpty) {
        debugPrint('[$debugTag] FAILED: idToken is null even after retries '
            '(likely clientId/serverClientId misconfigured or Google Play Services delay)');
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyIdToken, idToken);
      await prefs.setString(_keyDisplayName, account.displayName ?? '');
      await prefs.setString(_keyEmail, account.email);

      return idToken;
    } catch (e, st) {
      debugPrint('[$debugTag] ERROR: $e\n$st');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIdToken);
      await prefs.remove(_keyDisplayName);
      await prefs.remove(_keyEmail);
      await _googleSignIn.disconnect();
    } catch (_) {}
  }

  static Future<bool> isGoogleSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyIdToken) != null;
  }

  static Future<String> getSavedDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName) ?? '';
  }

  static Future<String> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }
}
