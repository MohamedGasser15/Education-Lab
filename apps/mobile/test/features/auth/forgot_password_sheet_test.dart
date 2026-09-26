import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/widgets/forgot_password_sheet.dart';
import 'package:mobile/l10n/app_localizations.dart';

class MockAuthRepo extends Fake implements AuthRepository {
  bool forgotPasswordCalled = false;
  String? sentEmail;

  @override
  Future<void> forgotPassword({required String email}) async {
    forgotPasswordCalled = true;
    sentEmail = email;
  }
}

Widget buildTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('ar', 'SA'),
    supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthRepo mockRepo;

  setUp(() {
    mockRepo = MockAuthRepo();
    final locator = GetIt.instance;
    if (locator.isRegistered<AuthRepository>()) {
      locator.unregister<AuthRepository>();
    }
    locator.registerSingleton<AuthRepository>(mockRepo);
  });

  tearDown(() {
    final locator = GetIt.instance;
    if (locator.isRegistered<AuthRepository>()) {
      locator.unregister<AuthRepository>();
    }
  });

  group('ForgotPasswordSheet Widget Tests', () {
    testWidgets('renders email step initially with pre-filled email', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const ForgotPasswordSheet(initialEmail: 'student@edulab.com'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordSheet), findsOneWidget);
      expect(find.byKey(const ValueKey('forgot_step_email')), findsOneWidget);
      expect(find.text('student@edulab.com'), findsOneWidget);
      expect(find.text('استعادة كلمة المرور'), findsOneWidget);
    });

    testWidgets('shows validation error when email is empty', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const ForgotPasswordSheet(initialEmail: ''),
        ),
      );
      await tester.pumpAndSettle();

      final sendBtn = find.text('إرسال كود التفعيل');
      expect(sendBtn, findsOneWidget);

      await tester.tap(sendBtn);
      await tester.pump();

      expect(mockRepo.forgotPasswordCalled, isFalse);
    });

    testWidgets('triggers forgotPassword and transitions to code step on success', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const ForgotPasswordSheet(initialEmail: 'user@example.com'),
        ),
      );
      await tester.pumpAndSettle();

      final sendBtn = find.text('إرسال كود التفعيل');
      await tester.tap(sendBtn);
      await tester.pumpAndSettle();

      expect(mockRepo.forgotPasswordCalled, isTrue);
      expect(mockRepo.sentEmail, 'user@example.com');
      expect(find.byKey(const ValueKey('forgot_step_code')), findsOneWidget);
    });

    testWidgets('adapts smoothly when keyboard appears without leaving gaps', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ForgotPasswordSheet.show(
                  context,
                  initialEmail: 'user@example.com',
                ),
                child: const Text('OpenSheet'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('OpenSheet'));
      await tester.pumpAndSettle();

      final sendBtnBefore = tester.getRect(find.text('إرسال كود التفعيل'));

      // Simulate keyboard open (300 logical px)
      tester.view.viewInsets = const FakeViewPadding(bottom: 600);
      await tester.pumpAndSettle();

      final sendBtnAfter = tester.getRect(find.text('إرسال كود التفعيل'));

      // Content has shifted up above keyboard
      expect(sendBtnAfter.bottom, lessThan(sendBtnBefore.bottom));
      // And sits above the keyboard (800 - 300 = 500)
      expect(sendBtnAfter.bottom, lessThanOrEqualTo(500.0));
    });
  });
}
