import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Theme-aware Shimmer container wrapper.
/// Automatically adapts shimmer base and highlight colors based on Light/Dark theme.
class AppSkeleton extends StatelessWidget {
  final Widget child;
  final ShimmerDirection direction;
  final Duration period;

  const AppSkeleton({
    super.key,
    required this.child,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1400),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1E293B) // Dark surface muted
        : const Color(0xFFE2E8F0); // Light subtle slate

    final highlightColor = isDark
        ? const Color(0xFF334155) // Darker highlight
        : const Color(0xFFF8FAFC); // Light highlight

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      period: period,
      child: child,
    );
  }
}

/// A basic rectangular or rounded placeholder box.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.margin,
  });

  const SkeletonBox.circle({
    super.key,
    required double size,
    this.margin,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A text line placeholder with realistic height and rounded corners.
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 12,
    this.borderRadius = 4,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular avatar/icon placeholder.
class SkeletonCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const SkeletonCircle({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
