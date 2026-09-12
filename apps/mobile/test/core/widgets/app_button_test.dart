import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('AppButton Widget', () {
    testWidgets('renders standard label and responds to tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestApp(
          AppButton(label: 'Submit', onPressed: () => tapped = true),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets(
      'shows loading spinner and loading label when isLoading is true',
      (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createTestApp(
            AppButton(
              label: 'Submit',
              loadingLabel: 'Saving',
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        );

        expect(find.byType(AppLoadingSpinner), findsOneWidget);
        expect(find.text('Saving...'), findsOneWidget);

        await tester.tap(find.byType(AppButton));
        await tester.pump();

        expect(tapped, isFalse); // Should not trigger tap while loading
      },
    );

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          AppButton(
            label: 'Continue with Google',
            icon: const Icon(Icons.g_mobiledata),
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('renders outlined style correctly', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          AppButton(label: 'Cancel', outlined: true, onPressed: () {}),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
