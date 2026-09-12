import 'package:flutter/material.dart';

/// Configuration tokens for the visual credit card preview themes (Gradients, orbs, stripes).
class CardThemeConfig {
  final List<Color> gradientColors;
  final List<double> stops;
  final Color shadowColor;
  final Color accentOrb1;
  final Color accentOrb2;
  final Color backStripeColor1;
  final Color backStripeColor2;

  const CardThemeConfig({
    required this.gradientColors,
    required this.stops,
    required this.shadowColor,
    required this.accentOrb1,
    required this.accentOrb2,
    required this.backStripeColor1,
    required this.backStripeColor2,
  });
}
