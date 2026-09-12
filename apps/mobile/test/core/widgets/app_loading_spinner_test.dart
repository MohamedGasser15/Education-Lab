import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

void main() {
  group('AppLoadingSpinner Widget', () {
    testWidgets('renders spinner and animates rotation without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppLoadingSpinner(size: 32, color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(AppLoadingSpinner), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(AppLoadingSpinner), findsOneWidget);
    });
  });
}
