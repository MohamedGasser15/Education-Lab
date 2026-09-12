import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_network_image.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('AppNetworkImage Widget', () {
    testWidgets('renders fallback error widget when url is empty or null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(const AppNetworkImage(url: '', width: 80, height: 80)),
      );

      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });

    testWidgets('renders custom error widget when url is null', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const AppNetworkImage(
            url: null,
            width: 80,
            height: 80,
            errorWidget: Text('Failed to load image'),
          ),
        ),
      );

      expect(find.text('Failed to load image'), findsOneWidget);
    });

    testWidgets('supports BoxShape.circle', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const AppNetworkImage(
            url: null,
            width: 44,
            height: 44,
            shape: BoxShape.circle,
          ),
        ),
      );
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('handles double.infinity width and height without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          const AppNetworkImage(
            url: 'https://example.com/image.jpg',
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}

