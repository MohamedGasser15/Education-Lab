import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Single particle model for the celebration confetti burst animation.
class ConfettiParticle {
  final double x;
  final double y;
  final double speed;
  final double angle;
  final double rotationSpeed;
  final Color color;
  final double size;
  final bool isCircle;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
    required this.color,
    required this.size,
    required this.isCircle,
  });
}

/// Custom painter that renders dynamic falling confetti particles upon checkout success.
class CheckoutConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  CheckoutConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final currentY = (p.y + (p.speed * progress * 1.6)) * size.height;
      final currentX =
          (p.x * size.width) + math.sin(progress * math.pi * 4 + p.angle) * 35;
      final opacity = (1.0 - progress * 0.85).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(progress * p.rotationSpeed * math.pi * 2);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.55,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CheckoutConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
