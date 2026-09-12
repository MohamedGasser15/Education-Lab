import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';
import 'package:mobile/features/catalog/presentation/screens/explore_screen.dart';
import 'package:mobile/features/learning/presentation/screens/learning_screen.dart';
import 'package:mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/learning/presentation/widgets/continue_learning_mini_bar.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static MainNavigationScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainNavigationScreenState>();
  }

  /// Pushes the ExploreScreen with smooth native page transition and a Back button,
  /// pre-selecting a category, filter chip, or search query.
  static void switchToExplore(
    BuildContext context, {
    CategoryItem? category,
    String? searchQuery,
    int? filterIndex,
    bool autoFocusSearch = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExploreScreen(
          isTab: false,
          initialCategory: category,
          initialSearchQuery: searchQuery,
          initialFilterIndex: filterIndex,
          autoFocusSearch: autoFocusSearch,
        ),
      ),
    );
  }

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _userName = '';
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final loggedIn = await AuthStorageService.isLoggedIn();
    final name = loggedIn ? await AuthStorageService.getUserName() : '';
    if (!mounted) return;
    setState(() {
      _userName = name;
    });
  }

  void switchTab(int index) => _switchTab(index);

  void _switchTab(int index) {
    if (index == _currentIndex) {
      if (index == 1) {
        // Tapping Explore tab icon while already on Explore tab:
        // Returns to root Explore page (clears search, active category, and filters)
        final exploreProvider = context.read<ExploreProvider>();
        if (exploreProvider.isViewingResults) {
          HapticFeedback.selectionClick();
          FocusManager.instance.primaryFocus?.unfocus();
          exploreProvider.clearFilters();
        }
      }
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = index;
      _isNavBarVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = AppColors.getBackground(context);

    final profileProvider = context.watch<ProfileProvider>();
    final isLoggedIn = profileProvider.isLoggedIn;
    final userName = profileProvider.profile?.displayName ?? _userName;

    final screens = <Widget>[
      HomeScreen(isLoggedIn: isLoggedIn, userName: userName),
      const ExploreScreen(isTab: true),
      if (isLoggedIn) const LearningScreen(isTab: true),
      const CartScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    final cartCount = context.watch<CartProvider>().count;

    final tabs = <_NavTabItem>[
      _NavTabItem(
        label: context.loc.navHome,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
      ),
      _NavTabItem(
        label: context.loc.navExplore,
        icon: Icons.search_rounded,
        activeIcon: Icons.search_rounded,
      ),
      if (isLoggedIn)
        _NavTabItem(
          label: context.loc.navMyLearning,
          icon: Icons.play_circle_outline_rounded,
          activeIcon: Icons.play_circle_fill_rounded,
        ),
      _NavTabItem(
        label: context.loc.navCart,
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        badgeCount: cartCount,
      ),
      _NavTabItem(
        label: context.loc.navAccount,
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
    ];

    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: scaffoldBg,
      body: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentIndex != 0) {
            _switchTab(0);
          }
        },
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis != Axis.vertical) return false;

            // Auto-hide on scroll is active ONLY on HomeScreen (Tab 0)
            if (_currentIndex != 0) {
              if (!_isNavBarVisible) {
                setState(() => _isNavBarVisible = true);
              }
              return false;
            }

            if (notification.direction == ScrollDirection.reverse) {
              if (_isNavBarVisible) {
                setState(() => _isNavBarVisible = false);
              }
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isNavBarVisible) {
                setState(() => _isNavBarVisible = true);
              }
            }
            return false;
          },
          child: Stack(
            children: [
              // Screen contents with smooth animated transitions
              FadeIndexedStack(index: _currentIndex, children: screens),

              // Bottom Navigation Bar (Auto-Hides ONLY on HomeScreen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  offset: (_currentIndex != 0 || _isNavBarVisible)
                      ? Offset.zero
                      : const Offset(0, 1.2),
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    opacity: (_currentIndex != 0 || _isNavBarVisible)
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Floating Mini Bar: Continue Learning (Udemy Style)
                        if (isLoggedIn) const ContinueLearningMiniBar(),

                        // Bottom Navigation Bar
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.surfaceMuted,
                                width: 1,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.35 : 0.05,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            top: false,
                            child: SizedBox(
                              height: 56,
                              child: Row(
                                children: [
                                  for (int i = 0; i < tabs.length; i++)
                                    Expanded(
                                      child: _NavBarButton(
                                        item: tabs[i],
                                        isSelected: i == _currentIndex,
                                        onTap: () => _switchTab(i),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int badgeCount;

  const _NavTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badgeCount = 0,
  });
}

class _NavBarButton extends StatelessWidget {
  final _NavTabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = AppColors.getTextSecondary(context);

    return InkWell(
      onTap: onTap,
      splashColor: activeColor.withValues(alpha: 0.06),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with optional badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 23,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              if (item.badgeCount > 0)
                Positioned(
                  top: -3,
                  right: -7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 1.5,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${item.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),

          // Label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: isSelected ? 11 : 10.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
              fontFamily: 'Tajawal',
              height: 1.1,
            ),
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps state alive while providing a smooth slide & fade transition between tabs
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _prevIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _prevIndex = widget.index.clamp(
      0,
      widget.children.isEmpty ? 0 : widget.children.length - 1,
    );
    _currentIndex = _prevIndex;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _currentIndex && widget.children.isNotEmpty) {
      _prevIndex = _currentIndex.clamp(0, widget.children.length - 1);
      _currentIndex = widget.index.clamp(0, widget.children.length - 1);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final isAnimating = _controller.isAnimating;
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final direction = (_currentIndex >= _prevIndex) ? 1.0 : -1.0;
        final rtlMultiplier = isRtl ? -1.0 : 1.0;
        final effectiveDir = direction * rtlMultiplier;

        return Stack(
          fit: StackFit.expand,
          children: List.generate(widget.children.length, (i) {
            final isCurrent = i == _currentIndex;
            final isPrev = i == _prevIndex && isAnimating;

            if (!isCurrent && !isPrev) {
              return Visibility(
                visible: false,
                maintainState: true,
                maintainAnimation: false,
                maintainSize: false,
                child: widget.children[i],
              );
            }

            if (!isAnimating && isCurrent) {
              return Visibility(
                visible: true,
                maintainState: true,
                child: widget.children[i],
              );
            }

            final double opacity;
            final Offset offset;

            if (isCurrent) {
              opacity = _animation.value;
              offset = Offset(
                14.0 * (1.0 - _animation.value) * effectiveDir,
                0,
              );
            } else {
              opacity = (1.0 - _animation.value);
              offset = Offset(-14.0 * _animation.value * effectiveDir, 0);
            }

            return Visibility(
              visible: true,
              maintainState: true,
              child: IgnorePointer(
                ignoring: !isCurrent,
                child: Transform.translate(
                  offset: offset,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: widget.children[i],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
