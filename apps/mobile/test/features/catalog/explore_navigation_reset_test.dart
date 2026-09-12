import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';

void main() {
  testWidgets(
    'Tapping Explore navigation bar icon while in search results resets to root Explore screen',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final exploreProvider = ExploreProvider();
      final cartProvider = CartProvider();
      final enrollmentProvider = EnrollmentProvider();
      final homeProvider = HomeProvider();
      final profileProvider = ProfileProvider();
      final notificationProvider = NotificationProvider();
      final wishlistProvider = WishlistProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExploreProvider>.value(
              value: exploreProvider,
            ),
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
            ChangeNotifierProvider<EnrollmentProvider>.value(
              value: enrollmentProvider,
            ),
            ChangeNotifierProvider<HomeProvider>.value(value: homeProvider),
            ChangeNotifierProvider<ProfileProvider>.value(
              value: profileProvider,
            ),
            ChangeNotifierProvider<NotificationProvider>.value(
              value: notificationProvider,
            ),
            ChangeNotifierProvider<WishlistProvider>.value(
              value: wishlistProvider,
            ),
          ],
          child: const MaterialApp(
            locale: Locale('en'),
            supportedLocales: [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MainNavigationScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));

      // 1. Switch to Explore Tab (Tab Index 1)
      final exploreTabFinder = find.text('Explore');
      expect(exploreTabFinder, findsOneWidget);

      await tester.tap(exploreTabFinder);
      await tester.pump(const Duration(milliseconds: 300));

      // 2. Perform search in ExploreProvider
      exploreProvider.onSearchSubmitted('Flutter');
      await tester.pump(const Duration(milliseconds: 300));

      expect(exploreProvider.isViewingResults, isTrue);
      expect(exploreProvider.searchQuery, equals('Flutter'));

      // 3. Tap Explore tab icon in navigation bar again
      await tester.tap(exploreTabFinder);
      await tester.pump(const Duration(milliseconds: 300));

      // 4. Verify search is reset and user is back at root Explore
      expect(exploreProvider.isViewingResults, isFalse);
      expect(exploreProvider.searchQuery, isEmpty);
      expect(exploreProvider.activeCategory, isNull);
    },
  );
}
