import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/app_shimmer.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppShimmer and Skeleton Widgets', () {
    testWidgets('AppShimmer and ShimmerBox render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppShimmer(child: ShimmerBox(width: 100, height: 20)),
          ),
        ),
      );

      expect(find.byType(AppShimmer), findsOneWidget);
      expect(find.byType(ShimmerBox), findsOneWidget);
    });

    testWidgets('AppSkeleton and SkeletonBox render in light and dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: AppSkeleton(
              child: Column(
                children: [
                  SkeletonBox(width: 80, height: 16),
                  SkeletonBox.circle(size: 40),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AppSkeleton), findsOneWidget);
      expect(find.byType(SkeletonBox), findsNWidgets(2));
    });
  });
}
