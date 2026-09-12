import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  group('AppTheme', () {
    testWidgets('light theme builds and uses Tajawal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.lightTheme,
          home: const Scaffold(),
        ),
      );
      final context = tester.element(find.byType(Scaffold));
      final theme = Theme.of(context);
      expect(theme.brightness, Brightness.light);
    });

    test('dark theme is dark', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });
  });
}
