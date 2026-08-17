import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  group('LocalizationExt', () {
    testWidgets('supportedLocales fallback ships ar + en', (tester) async {
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
          home: Builder(
            builder: (context) {
              expect(context.loc, isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}