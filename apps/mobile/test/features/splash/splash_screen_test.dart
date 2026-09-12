import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

Widget buildSplashTestApp() {
  return const MaterialApp(
    locale: Locale('ar', 'SA'),
    supportedLocales: [Locale('ar', 'SA'), Locale('en', 'US')],
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: SplashScreen(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Widget', () {
    testWidgets('renders splash screen structure, icon, and spinner', (tester) async {
      await tester.pumpWidget(buildSplashTestApp());
      await tester.pump();

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(FaIcon), findsOneWidget);
      expect(find.byType(AppLoadingSpinner), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}
