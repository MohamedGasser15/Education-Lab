import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppLoadingSpinner extends StatefulWidget {
  const AppLoadingSpinner({
    super.key,
    this.size = 20,
    this.color = Colors.white,
  });

  final double size;
  final Color color;

  @override
  State<AppLoadingSpinner> createState() => _AppLoadingSpinnerState();
}

class _AppLoadingSpinnerState extends State<AppLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * math.pi,
        alignment: Alignment.center,
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _FaSpinnerPainter(
            color: widget.color,
            dotRadius: widget.size * 0.09375,
          ),
        ),
      ),
    );
  }
}

class _FaSpinnerPainter extends CustomPainter {
  const _FaSpinnerPainter({required this.color, required this.dotRadius});

  final Color color;
  final double dotRadius;

  // Relative center of each dot from the FA6 spinner (ratio of icon size 512)
  static const List<Offset> _dots = [
    Offset(0.5, 0.09375), // Top
    Offset(0.90625, 0.5), // Right
    Offset(0.5, 0.90625), // Bottom
    Offset(0.09375, 0.5), // Left
    Offset(0.2128, 0.7872), // Diagonal top-left
    Offset(0.7872, 0.7872), // Diagonal top-right
    Offset(0.2128, 0.2128), // Diagonal bottom-left
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final dot in _dots) {
      canvas.drawCircle(
        Offset(dot.dx * size.width, dot.dy * size.height),
        dotRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FaSpinnerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.dotRadius != dotRadius;
}
