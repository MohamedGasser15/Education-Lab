import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/app_responsive.dart';

Widget wrap(double width, double height) {
  return MediaQuery(
    data: MediaQueryData(size: Size(width, height)),
    child: const SizedBox(),
  );
}

void main() {
  group('AppResponsive', () {
    testWidgets('tablet detection - shortestSide >= 600', (tester) async {
      await tester.pumpWidget(wrap(800, 1000));
      final context = tester.element(find.byType(SizedBox));
      expect(AppResponsive.isTablet(context), true);
    });

    testWidgets('phone detection', (tester) async {
      await tester.pumpWidget(wrap(390, 844));
      final context = tester.element(find.byType(SizedBox));
      expect(AppResponsive.isTablet(context), false);
    });

    testWidgets('value() picks device tier', (tester) async {
      await tester.pumpWidget(wrap(350, 780));
      final context = tester.element(find.byType(SizedBox));
      final v = AppResponsive.value<int>(
        context,
        tablet: 3,
        phone: 1,
        largePhone: 2,
        extraSmallPhone: 0,
      );
      expect(v, 0);
    });

    testWidgets('screenPadding differs tablet vs phone', (tester) async {
      await tester.pumpWidget(wrap(800, 1000));
      final tabletCtx = tester.element(find.byType(SizedBox));
      expect(AppResponsive.screenPadding(tabletCtx).horizontal, 120);

      await tester.pumpWidget(wrap(390, 844));
      final phoneCtx = tester.element(find.byType(SizedBox));
      expect(AppResponsive.screenPadding(phoneCtx).horizontal, 40);
    });
  });
}