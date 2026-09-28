import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/strikethrough_text.dart';

void main() {
  testWidgets('StrikethroughText renders CustomPaint with child Text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StrikethroughText(
            text: '\$100.00',
            yOffset: -1.5,
            strokeWidth: 1.1,
          ),
        ),
      ),
    );

    expect(find.byType(StrikethroughText), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
