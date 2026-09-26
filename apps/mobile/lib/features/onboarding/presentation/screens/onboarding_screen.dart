import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const int _pagesCount = 3;
  static const int _initialVirtualPage = 3000;

  late final PageController _pageController;
  int _virtualPage = _initialVirtualPage;
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  late final AnimationController _pageIntroController;
  late final AnimationController _pulseController;
  late final AnimationController _orbitController;

  List<Map<String, dynamic>> _buildPages() {
    final l = context.loc;
    return [
      {
        'icon': Icons.rocket_launch_rounded,
        'title': l.onboardingTitle1,
        'subtitle': l.onboardingSubtitle1,
      },
      {
        'icon': Icons.groups_rounded,
        'title': l.onboardingTitle2,
        'subtitle': l.onboardingSubtitle2,
      },
      {
        'icon': Icons.workspace_premium_rounded,
        'title': l.onboardingTitle3,
        'subtitle': l.onboardingSubtitle3,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialVirtualPage);
    _pageIntroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: 1,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients) return;
      final currentVirtual = _pageController.page?.round() ?? _virtualPage;
      _pageController.animateToPage(
        currentVirtual + 1,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _goToSlide(int targetSlideIndex) {
    if (!_pageController.hasClients) return;
    final currentVirtual = _pageController.page?.round() ?? _virtualPage;
    final currentSlide = ((currentVirtual % _pagesCount) + _pagesCount) % _pagesCount;
    int diff = targetSlideIndex - currentSlide;
    if (diff > _pagesCount / 2) {
      diff -= _pagesCount;
    } else if (diff < -_pagesCount / 2) {
      diff += _pagesCount;
    }
    _pageController.animateToPage(
      currentVirtual + diff,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int virtualIndex) {
    final normalized = ((virtualIndex % _pagesCount) + _pagesCount) % _pagesCount;
    setState(() {
      _virtualPage = virtualIndex;
      _currentPage = normalized;
    });
    _pageIntroController.forward(from: 0);
    _startAutoAdvance();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }

  void _next() async {
    if (_currentPage == _pagesCount - 1) {
      await _completeOnboarding();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      if (!_pageController.hasClients) return;
      final currentVirtual = _pageController.page?.round() ?? _virtualPage;
      _pageController.animateToPage(
        currentVirtual + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skip() async {
    await _completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    _pageIntroController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pagesCount - 1;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final pages = _buildPages();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at the top
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    context.loc.onboardingSkip,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      fontFamily: isRtl ? 'Tajawal' : null,
                    ),
                  ),
                ),
              ),
            ),

            // Onboarding pages with continuous parallax transitions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final pageIndex =
                      ((index % _pagesCount) + _pagesCount) % _pagesCount;
                  final page = pages[pageIndex];

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double pageOffset = 0.0;
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions &&
                          _pageController.page != null) {
                        pageOffset = _pageController.page! - index;
                      } else {
                        pageOffset = (_virtualPage - index).toDouble();
                      }

                      final clampedOffset = pageOffset.clamp(-1.0, 1.0);
                      final absOffset = clampedOffset.abs();
                      final dir = isRtl ? -1.0 : 1.0;

                      // Layered parallax transforms
                      final artworkScale =
                          (1.0 - absOffset * 0.12).clamp(0.85, 1.0);
                      final artworkFade =
                          (1.0 - absOffset * 0.6).clamp(0.0, 1.0);
                      final artworkTranslateX = clampedOffset * 36.0 * dir;

                      final titleTranslateX = clampedOffset * 62.0 * dir;
                      final titleFade =
                          (1.0 - absOffset * 0.85).clamp(0.0, 1.0);

                      final subtitleTranslateX = clampedOffset * 86.0 * dir;
                      final subtitleFade =
                          (1.0 - absOffset * 0.85).clamp(0.0, 1.0);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.value(
                            context,
                            phone: 24.0,
                            tablet: 48.0,
                            smallPhone: 16.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(artworkTranslateX, 0),
                              child: Transform.scale(
                                scale: artworkScale,
                                child: Opacity(
                                  opacity: artworkFade,
                                  child: _buildArtwork(
                                    page['icon'] as IconData,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),
                            Transform.translate(
                              offset: Offset(titleTranslateX, 0),
                              child: Opacity(
                                opacity: titleFade,
                                child: AnimatedBuilder(
                                  animation: _pageIntroController,
                                  builder: (context, titleChild) {
                                    final t = CurvedAnimation(
                                      parent: _pageIntroController,
                                      curve: const Interval(
                                        0.15,
                                        0.55,
                                        curve: Curves.easeOut,
                                      ),
                                    ).value;
                                    return Opacity(
                                      opacity: t,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - t)),
                                        child: titleChild,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    page['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: isRtl ? 0 : -0.5,
                                      fontFamily: isRtl ? 'Tajawal' : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Transform.translate(
                              offset: Offset(subtitleTranslateX, 0),
                              child: Opacity(
                                opacity: subtitleFade,
                                child: AnimatedBuilder(
                                  animation: _pageIntroController,
                                  builder: (context, subtitleChild) {
                                    final t = CurvedAnimation(
                                      parent: _pageIntroController,
                                      curve: const Interval(
                                        0.3,
                                        0.75,
                                        curve: Curves.easeOut,
                                      ),
                                    ).value;
                                    return Opacity(
                                      opacity: t,
                                      child: Transform.translate(
                                        offset: Offset(0, 16 * (1 - t)),
                                        child: subtitleChild,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    page['subtitle'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                      fontFamily: isRtl ? 'Tajawal' : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pagesCount, (index) {
                final isActive = index == _currentPage;
                return GestureDetector(
                  onTap: () => _goToSlide(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      final breathe = isActive
                          ? 1 + 0.12 * _pulseController.value
                          : 1.0;
                      return Transform.scale(
                        scale: breathe,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 30 : 9,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isActive
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.18),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Main continue / get started button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(
                  context,
                  phone: 24.0,
                  tablet: 48.0,
                  smallPhone: 16.0,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1.0)
                        .animate(animation),
                    child: child,
                  ),
                ),
                child: AppButton(
                  key: ValueKey(isLastPage),
                  height: 56,
                  borderRadius: 18,
                  fontSize: 16.5,
                  label: isLastPage
                      ? context.loc.onboardingStart
                      : context.loc.onboardingNext,
                  trailingIcon: Icon(
                    isLastPage
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: _next,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Circular artwork + icon + continuous animation (pulse + orbit)
  Widget _buildArtwork(IconData icon) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pageIntroController,
        _pulseController,
        _orbitController,
      ]),
      builder: (context, _) {
        final pulse = _pulseController.value;

        // Outer circles pulse
        final lightScale = 1 + 0.035 * pulse;
        final ringScale = 1 + 0.06 * pulse;

        // Icon bounce-in animation
        final iconScale = CurvedAnimation(
          parent: _pageIntroController,
          curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
        ).value;

        // Icon fade-in animation
        final iconOpacity = CurvedAnimation(
          parent: _pageIntroController,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
        ).value;

        final orbitAngle = 2 * math.pi * _orbitController.value;

        return SizedBox(
          width: 340,
          height: 340,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing circle
              Transform.scale(
                scale: lightScale,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Pulsing ring border
              Transform.scale(
                scale: ringScale,
                child: Container(
                  width: 252,
                  height: 252,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: 0.15 + 0.1 * pulse,
                      ),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Icon container with bounce entrance
              Transform.scale(
                scale: iconScale,
                child: Opacity(
                  opacity: iconOpacity,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 96, color: Colors.white),
                  ),
                ),
              ),
              // Primary orbiting dot
              Transform.rotate(
                angle: orbitAngle,
                child: Transform.translate(
                  offset: const Offset(0, -125),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              // Faster counter-orbiting dot (two revolutions per cycle)
              Transform.rotate(
                angle: -2 * orbitAngle,
                child: Transform.translate(
                  offset: const Offset(0, 130),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
