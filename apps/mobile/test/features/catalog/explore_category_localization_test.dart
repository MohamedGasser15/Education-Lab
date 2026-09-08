import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/catalog/data/repositories/explore_repository.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_categories_list.dart';
import 'package:mobile/l10n/app_localizations.dart';

Widget buildTestApp({
  required Locale locale,
  required Widget Function(BuildContext) builder,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [
      Locale('ar'),
      Locale('en'),
      Locale('fr'),
      Locale('de'),
    ],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Builder(builder: builder),
  );
}

void main() {
  group('CategoryItem Localization', () {
    testWidgets('Arabic locale returns Arabic title, subtitle, and tag', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          locale: const Locale('ar'),
          builder: (context) {
            for (final cat in ExploreCategoriesList.defaultCategories) {
              final title = cat.getLocalizedTitle(context);
              final subtitle = cat.getLocalizedSubtitle(context);
              final tag = cat.getLocalizedTag(context);

              expect(title, isNotEmpty);
              expect(subtitle, isNotEmpty);
              expect(tag, isNotEmpty);

              // Arabic characters present
              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(title), isTrue,
                  reason: 'Title should contain Arabic in Arabic mode: $title');
              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(subtitle), isTrue,
                  reason: 'Subtitle should contain Arabic in Arabic mode: $subtitle');
            }
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('English locale returns English title, subtitle, and tag', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          locale: const Locale('en'),
          builder: (context) {
            for (final cat in ExploreCategoriesList.defaultCategories) {
              final title = cat.getLocalizedTitle(context);
              final subtitle = cat.getLocalizedSubtitle(context);
              final tag = cat.getLocalizedTag(context);

              expect(title, isNotEmpty);
              expect(subtitle, isNotEmpty);
              expect(tag, isNotEmpty);

              // Arabic characters should NOT be present in English
              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(title), isFalse,
                  reason: 'Title should not contain Arabic in English mode: $title');
              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(subtitle), isFalse,
                  reason: 'Subtitle should not contain Arabic in English mode: $subtitle');
            }
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Non-Arabic (e.g. French / German) returns respective localized title and subtitle', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          locale: const Locale('fr'),
          builder: (context) {
            for (final cat in ExploreCategoriesListDefaults.topCategories) {
              final title = cat.getLocalizedTitle(context);
              final subtitle = cat.getLocalizedSubtitle(context);
              final tag = cat.getLocalizedTag(context);

              expect(title, isNotEmpty);
              expect(subtitle, isNotEmpty);
              expect(tag, isNotEmpty);

              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(title), isFalse,
                  reason: 'Title should be non-Arabic in French mode: $title');
              expect(RegExp(r'[\u0600-\u06FF]').hasMatch(subtitle), isFalse,
                  reason: 'Subtitle should be non-Arabic in French mode: $subtitle');
            }
            return const SizedBox();
          },
        ),
      );
    });

    test('All topCategories have both Arabic and English subtitles', () {
      for (final cat in ExploreCategoriesListDefaults.topCategories) {
        expect(cat.arabicSubtitle, isNotNull);
        expect(cat.arabicSubtitle!.isNotEmpty, isTrue);
        expect(cat.englishSubtitle, isNotNull);
        expect(cat.englishSubtitle!.isNotEmpty, isTrue);
      }
    });

    test('All defaultCategories have both Arabic and English subtitles', () {
      for (final cat in ExploreCategoriesList.defaultCategories) {
        expect(cat.arabicSubtitle, isNotNull);
        expect(cat.arabicSubtitle!.isNotEmpty, isTrue);
        expect(cat.englishSubtitle, isNotNull);
        expect(cat.englishSubtitle!.isNotEmpty, isTrue);
      }
    });
  });
}
