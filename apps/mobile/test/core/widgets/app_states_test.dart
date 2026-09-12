import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/core/widgets/app_states.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('AppEmptyState Widget', () {
    testWidgets('renders title and default inbox icon', (tester) async {
      await tester.pumpWidget(
        createTestApp(const AppEmptyState(title: 'لا توجد عناصر حالياً')),
      );

      expect(find.text('لا توجد عناصر حالياً'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('renders retry button and triggers callback when provided', (
      tester,
    ) async {
      bool retried = false;

      await tester.pumpWidget(
        createTestApp(
          AppEmptyState(
            title: 'فشل في التحميل',
            onAction: () => retried = true,
            actionLabel: 'حاول مجدداً',
          ),
        ),
      );

      expect(find.text('حاول مجدداً'), findsOneWidget);
      await tester.tap(find.text('حاول مجدداً'));
      await tester.pump();

      expect(retried, isTrue);
    });
  });

  group('AppErrorState Widget', () {
    testWidgets('renders error icon and custom message', (tester) async {
      await tester.pumpWidget(
        createTestApp(const AppErrorState(message: 'خطأ في الاتصال بالخادم')),
      );

      expect(find.text('خطأ في الاتصال بالخادم'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });
  });

  group('AppLoadingState Widget', () {
    testWidgets('renders AppLoadingSpinner and optional message', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(const AppLoadingState(message: 'جاري تحميل البيانات...')),
      );

      expect(find.byType(AppLoadingSpinner), findsOneWidget);
      expect(find.text('جاري تحميل البيانات...'), findsOneWidget);
    });
  });
}
