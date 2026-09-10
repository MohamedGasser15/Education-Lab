import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/google_auth_service.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/support_provider.dart';

class AppSessionService {
  AppSessionService._();

  /// Completely clears cached auth credentials, Google OAuth tokens, and resets
  /// all in-memory providers so the app enters a completely clean state (e.g. on logout or guest login).
  static Future<void> clearSession(BuildContext context) async {
    final profileProvider = context.read<ProfileProvider>();
    final cartProvider = context.read<CartProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final enrollmentProvider = context.read<EnrollmentProvider>();
    final supportProvider = context.read<SupportProvider>();

    try {
      await locator<AuthRepository>().logout();
    } catch (_) {}

    try {
      await GoogleAuthService.signOut();
    } catch (_) {}

    try {
      await profileProvider.logout();
    } catch (_) {}

    try {
      cartProvider.reset();
    } catch (_) {}

    try {
      wishlistProvider.reset();
    } catch (_) {}

    try {
      notificationProvider.reset();
    } catch (_) {}

    try {
      enrollmentProvider.reset();
    } catch (_) {}

    try {
      await supportProvider.reset();
    } catch (_) {}
  }
}
