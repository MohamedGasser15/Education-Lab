import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final ShimmerDirection direction;

  const AppShimmer({
    super.key,
    required this.child,
    this.direction = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        direction: direction,
        child: child,
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: borderRadius,
      ),
    );
  }
}
