import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/services/app_session_service.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildSplashTestApp({
  Widget? targetHome,
  Widget? targetMain,
}) {
  return MaterialApp(
    locale: const Locale('ar', 'SA'),
    supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/': (context) => targetHome ?? const Scaffold(body: Text('Onboarding Screen')),
      '/main': (context) => targetMain ?? const Scaffold(body: Text('Main Screen')),
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    AuthStorageService.setMockStorage(resetPrefs: true);
  });

  group('SplashScreen Widget & Navigation', () {
    testWidgets('renders splash screen structure, icon, and spinner', (
      tester,
    ) async {
      await tester.pumpWidget(buildSplashTestApp());
      await tester.pump();

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(FaIcon), findsOneWidget);
      expect(find.byType(AppLoadingSpinner), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('navigates to Onboarding ("/") when user is not logged in and not guest', (
      tester,
    ) async {
      await AppSessionService.setGuestMode(false);

      await tester.pumpWidget(buildSplashTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Onboarding Screen'), findsOneWidget);
      expect(find.text('Main Screen'), findsNothing);
    });

    testWidgets('navigates to Main ("/main") when user is guest', (
      tester,
    ) async {
      await AppSessionService.setGuestMode(true);

      await tester.pumpWidget(buildSplashTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Main Screen'), findsOneWidget);
      expect(find.text('Onboarding Screen'), findsNothing);
    });

    testWidgets('navigates to Main ("/main") when user is logged in', (
      tester,
    ) async {
      await AuthStorageService.saveAuth(
        accessToken: 'valid-token',
        refreshToken: 'valid-refresh',
        user: {'id': 'user-123', 'fullName': 'Test User', 'email': 'test@test.com'},
      );

      await tester.pumpWidget(buildSplashTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Main Screen'), findsOneWidget);
      expect(find.text('Onboarding Screen'), findsNothing);
    });
  });
}
