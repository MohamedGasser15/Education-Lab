import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_states.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  group('AppEmptyState Widget', () {
    testWidgets('renders message and default inbox icon', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const AppEmptyState(message: 'لا توجد عناصر حالياً'),
        ),
      );

      expect(find.text('لا توجد عناصر حالياً'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('renders retry button and triggers callback when provided', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        createTestApp(
          AppEmptyState(
            message: 'فشل في التحميل',
            onRetry: () => retried = true,
            retryLabel: 'حاول مجدداً',
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
        createTestApp(
          const AppErrorState(message: 'خطأ في الاتصال بالخادم'),
        ),
      );

      expect(find.text('خطأ في الاتصال بالخادم'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    });
  });

  group('AppLoadingState Widget', () {
    testWidgets('renders CircularProgressIndicator and optional message', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const AppLoadingState(message: 'جاري تحميل البيانات...'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('جاري تحميل البيانات...'), findsOneWidget);
    });
  });
}
