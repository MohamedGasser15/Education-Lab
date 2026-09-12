import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_shimmer.dart';

/// Standard, high-performance Network Image widget for EduLab.
/// Handles caching, dark mode fallbacks, memory optimizations, and shimmer loading.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fallbackBg = isDark
        ? AppColors.darkSurfaceMuted
        : const Color(0xFFF1F5F9);
    final iconColor = isDark ? Colors.grey.shade600 : Colors.grey.shade400;

    Widget buildErrorContainer() {
      return errorWidget ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: fallbackBg,
              shape: shape,
              borderRadius: shape == BoxShape.circle ? null : borderRadius,
            ),
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: iconColor,
                size: (width != null && height != null)
                    ? (width! < 40 ? 16 : 24)
                    : 24,
              ),
            ),
          );
    }

    Widget wrapShape(Widget child) {
      if (shape == BoxShape.circle) {
        return ClipOval(child: child);
      }
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: child);
      }
      return child;
    }

    if (url == null || url!.trim().isEmpty) {
      return wrapShape(buildErrorContainer());
    }

    final imageWidget = CachedNetworkImage(
      imageUrl: url!.trim(),
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, _) =>
          placeholder ??
          AppShimmer(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: fallbackBg,
                shape: shape,
                borderRadius: shape == BoxShape.circle ? null : borderRadius,
              ),
            ),
          ),
      errorWidget: (context, error, stackTrace) => buildErrorContainer(),
    );

    return wrapShape(imageWidget);
  }
}
