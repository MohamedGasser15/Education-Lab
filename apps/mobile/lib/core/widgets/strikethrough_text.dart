import 'package:flutter/material.dart';

/// A custom strikethrough text widget that allows precise vertical positioning
/// of the strikethrough line ("طلع الخط فوق سيكا"), especially useful for
/// Arabic fonts like Tajawal where default [TextDecoration.lineThrough] is
/// rendered too low below the optical center of numbers and latin glyphs.
class StrikethroughText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? lineColor;
  final double strokeWidth;

  /// Vertical offset in logical pixels. Negative value shifts the line upwards.
  final double yOffset;
  final int? maxLines;
  final TextOverflow? overflow;

  const StrikethroughText({
    super.key,
    required this.text,
    this.style,
    this.lineColor,
    this.strokeWidth = 1.1,
    this.yOffset = -1.5,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final color =
        lineColor ??
        effectiveStyle.decorationColor ??
        effectiveStyle.color?.withValues(alpha: 0.7) ??
        Colors.grey;

    return CustomPaint(
      foregroundPainter: _StrikethroughPainter(
        color: color,
        strokeWidth: strokeWidth,
        yOffset: yOffset,
      ),
      child: Text(
        text,
        style: effectiveStyle.copyWith(decoration: TextDecoration.none),
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

class _StrikethroughPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double yOffset;

  const _StrikethroughPainter({
    required this.color,
    required this.strokeWidth,
    required this.yOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final y = (size.height / 2) + yOffset;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant _StrikethroughPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.yOffset != yOffset;
  }
}
