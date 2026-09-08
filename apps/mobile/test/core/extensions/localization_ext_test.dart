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

    testWidgets('instructor profile localization keys are present and accurate in Arabic', (tester) async {
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
              expect(context.isArabic, isTrue);
              expect(context.loc.instructorProfileTitle, 'الملف التعريفي للمدرب');
              expect(context.loc.instructorDefaultName, 'المدرب');
              expect(context.loc.instructorProfileBadge, 'المحاضر المعتمد');
              expect(context.loc.instructorProfileTotalStudents, 'إجمالي الطلاب');
              expect(context.loc.instructorProfileRating, 'تقييم المدرب');
              expect(context.loc.instructorProfileCourses, 'الدورات');
              expect(context.loc.instructorProfileShare, 'مشاركة الملف التعريفي');
              expect(context.loc.instructorProfileAboutMe, 'عن المدرب');
              expect(context.loc.instructorProfileCoursesTitle, 'دورات المدرب');
              expect(context.loc.instructorProfileStudentFeedback, 'آراء وتقييمات الطلاب');
              expect(context.loc.instructorProfileLinkCopied('محمد'), 'تم نسخ رابط ملف محمد');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('instructor profile localization keys are present and accurate in English', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) {
              expect(context.isArabic, isFalse);
              expect(context.loc.instructorProfileTitle, 'Instructor Profile');
              expect(context.loc.instructorDefaultName, 'Instructor');
              expect(context.loc.instructorProfileBadge, 'INSTRUCTOR');
              expect(context.loc.instructorProfileTotalStudents, 'Total Students');
              expect(context.loc.instructorProfileRating, 'Instructor Rating');
              expect(context.loc.instructorProfileCourses, 'Courses');
              expect(context.loc.instructorProfileShare, 'Share Profile');
              expect(context.loc.instructorProfileAboutMe, 'About Me');
              expect(context.loc.instructorProfileCoursesTitle, 'Instructor Courses');
              expect(context.loc.instructorProfileStudentFeedback, 'Student Feedback');
              expect(context.loc.instructorProfileLinkCopied('John'), 'Link for John copied to clipboard');
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}