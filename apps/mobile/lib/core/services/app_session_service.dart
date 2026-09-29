import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/facebook_auth_service.dart';
import 'package:mobile/core/services/google_auth_service.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/support_provider.dart';

class AppSessionService {
  AppSessionService._();

  static const String _guestModeKey = 'is_guest_mode';

  /// Returns true if the user explicitly chose guest exploration mode.
  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestModeKey) ?? false;
  }

  /// Sets whether the app is running in guest mode.
  static Future<void> setGuestMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, value);
  }

  /// Completely clears cached auth credentials, OAuth tokens, HTTP cache, and resets
  /// all in-memory providers so the app enters a completely clean state (e.g. on logout or guest login).
  static Future<void> clearSession(BuildContext context) async {
    // 1. Immediately clear HTTP response cache
    ApiClient.clearCache();

    // 2. Safely capture provider references
    ProfileProvider? profileProvider;
    CartProvider? cartProvider;
    WishlistProvider? wishlistProvider;
    NotificationProvider? notificationProvider;
    EnrollmentProvider? enrollmentProvider;
    SupportProvider? supportProvider;

    try {
      profileProvider = context.read<ProfileProvider>();
    } catch (_) {}
    try {
      cartProvider = context.read<CartProvider>();
    } catch (_) {}
    try {
      wishlistProvider = context.read<WishlistProvider>();
    } catch (_) {}
    try {
      notificationProvider = context.read<NotificationProvider>();
    } catch (_) {}
    try {
      enrollmentProvider = context.read<EnrollmentProvider>();
    } catch (_) {}
    try {
      supportProvider = context.read<SupportProvider>();
    } catch (_) {}

    // 3. Immediately reset synchronous in-memory state
    try {
      cartProvider?.reset();
    } catch (_) {}
    try {
      wishlistProvider?.reset();
    } catch (_) {}
    try {
      notificationProvider?.reset();
    } catch (_) {}
    try {
      enrollmentProvider?.reset();
    } catch (_) {}

    // 4. Concurrently clear local auth storage, guest mode, and remaining providers
    await Future.wait([
      setGuestMode(false).catchError((_) {}),
      locator<AuthRepository>().logout().catchError((_) {}),
      GoogleAuthService.signOut().catchError((_) {}),
      FacebookAuthService.signOut().catchError((_) {}),
      if (profileProvider != null) profileProvider.logout().catchError((_) {}),
      if (supportProvider != null) supportProvider.reset().catchError((_) {}),
    ]);
  }
}
