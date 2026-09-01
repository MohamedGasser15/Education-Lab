import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomePromoSlider extends StatefulWidget {
  const HomePromoSlider({
    super.key,
    this.onExploreTap,
  });

  final VoidCallback? onExploreTap;

  @override
  State<HomePromoSlider> createState() => _HomePromoSliderState();
}

class _HomePromoSliderState extends State<HomePromoSlider> {
  late final PageController _promoPageController;
  int _currentPromoIndex = 0;
  Timer? _promoTimer;

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController(viewportFraction: 0.92);
    _startPromoTimer();
  }

  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_promoPageController.hasClients) {
        final nextIndex = (_currentPromoIndex + 1) % 3;
        _promoPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoPageController.dispose();
    super.dispose();
  }

  void _handleSlideTap(VoidCallback? customTap) {
    HapticFeedback.mediumImpact();
    if (customTap != null) {
      customTap();
    } else if (widget.onExploreTap != null) {
      widget.onExploreTap!();
    } else {
      Navigator.pushNamed(context, '/explore');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final slides = [
      // Slide 1: Big Season Sale & Discount (Udemy Flash Sale style)
      {
        'cardBgLight': const Color(0xFF0F172A),
        'cardBgDark': const Color(0xFF0F172A),
        'borderLight': const Color(0xFF1E293B),
        'borderDark': const Color(0xFF334155),
        'badgeBg': const Color(0xFF2563EB).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF3B82F6).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFF93C5FD),
        'badgeIcon': Icons.timer_outlined,
        'badgeText': context.loc.homePromo1Badge,
        'title': context.loc.homePromo1Title,
        'subtitle': context.loc.homePromo1Subtitle,
        'btnText': context.loc.homePromo1Button,
        'btnBg': const Color(0xFF2563EB),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF1E293B),
        'iconContainerBorder': const Color(0xFF334155),
        'icon': Icons.local_offer_rounded,
        'iconColor': const Color(0xFF60A5FA),
        'onTap': () => _handleSlideTap(null),
      },
      // Slide 2: Career Roadmap & Certified Skills (Udemy Career Track style)
      {
        'cardBgLight': const Color(0xFF064E3B),
        'cardBgDark': const Color(0xFF064E3B),
        'borderLight': const Color(0xFF065F46),
        'borderDark': const Color(0xFF047857),
        'badgeBg': const Color(0xFF10B981).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF34D399).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFFA7F3D0),
        'badgeIcon': Icons.workspace_premium_rounded,
        'badgeText': context.loc.homePromo2Badge,
        'title': context.loc.homePromo2Title,
        'subtitle': context.loc.homePromo2Subtitle,
        'btnText': context.loc.homePromo2Button,
        'btnBg': const Color(0xFF059669),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF065F46),
        'iconContainerBorder': const Color(0xFF047857),
        'icon': Icons.school_rounded,
        'iconColor': const Color(0xFF6EE7B7),
        'onTap': () => _handleSlideTap(null),
      },
      // Slide 3: Learn from Top Instructors (Udemy Instructors style)
      {
        'cardBgLight': const Color(0xFF1E1B4B),
        'cardBgDark': const Color(0xFF1E1B4B),
        'borderLight': const Color(0xFF312E81),
        'borderDark': const Color(0xFF4338CA),
        'badgeBg': const Color(0xFF6366F1).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF818CF8).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFFC7D2FE),
        'badgeIcon': Icons.stars_rounded,
        'badgeText': context.loc.homePromo3Badge,
        'title': context.loc.homePromo3Title,
        'subtitle': context.loc.homePromo3Subtitle,
        'btnText': context.loc.homePromo3Button,
        'btnBg': const Color(0xFF4F46E5),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF312E81),
        'iconContainerBorder': const Color(0xFF4338CA),
        'icon': Icons.cast_for_education_rounded,
        'iconColor': const Color(0xFFA5B4FC),
        'onTap': () => _handleSlideTap(null),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: AnimatedBuilder(
            animation: _promoPageController,
            builder: (context, _) {
              return PageView.builder(
                controller: _promoPageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _currentPromoIndex = idx);
                  _startPromoTimer();
                },
                itemCount: slides.length,
                itemBuilder: (ctx, index) {
                  final slide = slides[index];

                  // Smooth page transition scale
                  double scale = 1.0;
                  if (_promoPageController.position.haveDimensions) {
                    final page = _promoPageController.page ?? _currentPromoIndex.toDouble();
                    final diff = (index - page).abs();
                    scale = (1.0 - (diff * 0.05)).clamp(0.95, 1.0);
                  }

                  final cardBg = (isDark ? slide['cardBgDark'] : slide['cardBgLight']) as Color;
                  final borderCol = (isDark ? slide['borderDark'] : slide['borderLight']) as Color;

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderCol,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Main Content Layout
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left side: Text & CTA Button
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                          decoration: BoxDecoration(
                                            color: slide['badgeBg'] as Color,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: slide['badgeBorder'] as Color,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                slide['badgeIcon'] as IconData,
                                                size: 12.5,
                                                color: slide['badgeTextColor'] as Color,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                slide['badgeText'] as String,
                                                style: TextStyle(
                                                  color: slide['badgeTextColor'] as Color,
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Tajawal',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Headline
                                        Text(
                                          slide['title'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Tajawal',
                                            height: 1.2,
                                          ),
                                        ),

                                        // Subtitle
                                        Text(
                                          slide['subtitle'] as String,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.82),
                                            fontSize: 11.5,
                                            fontFamily: 'Tajawal',
                                            height: 1.3,
                                          ),
                                        ),

                                        // CTA Button (Udemy Solid Pill Style)
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: slide['onTap'] as VoidCallback,
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                              decoration: BoxDecoration(
                                                color: slide['btnBg'] as Color,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: (slide['btnBg'] as Color).withValues(alpha: 0.35),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    slide['btnText'] as String,
                                                    style: TextStyle(
                                                      color: slide['btnTextColor'] as Color,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w900,
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    Directionality.of(context) == TextDirection.rtl
                                                        ? Icons.arrow_back_ios_new_rounded
                                                        : Icons.arrow_forward_ios_rounded,
                                                    size: 10,
                                                    color: slide['btnTextColor'] as Color,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // Right side: Clean Udemy-style Category / Feature Visual Card
                                  Container(
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      color: slide['iconContainerBg'] as Color,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: slide['iconContainerBorder'] as Color,
                                        width: 1.2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      slide['icon'] as IconData,
                                      size: 34,
                                      color: slide['iconColor'] as Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Dots Indicator (Clean Minimalist Udemy Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (i) {
            final isCurrent = i == _currentPromoIndex;
            return GestureDetector(
              onTap: () {
                _promoPageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: isCurrent ? 20 : 6,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
