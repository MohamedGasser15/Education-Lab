import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';
import 'package:mobile/features/catalog/presentation/screens/explore_screen.dart';
import 'package:mobile/features/learning/presentation/screens/learning_screen.dart';
import 'package:mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  String _userName = '';
  bool _isNavBarVisible = true;

  late final AnimationController _pageTransition;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _pageTransition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    )..forward();

    _fade = CurvedAnimation(
      parent: _pageTransition,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.012),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageTransition,
      curve: Curves.easeOutCubic,
    ));

    _loadAuthState();
  }

  @override
  void dispose() {
    _pageTransition.dispose();
    super.dispose();
  }

  Future<void> _loadAuthState() async {
    final loggedIn = await AuthStorageService.isLoggedIn();
    final name = loggedIn ? await AuthStorageService.getUserName() : '';
    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _userName = name;
    });
  }

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _isNavBarVisible = true;
    });
    _pageTransition.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(isLoggedIn: _isLoggedIn, userName: _userName),
      const ExploreScreen(),
      if (_isLoggedIn) const LearningScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    final tabs = <_NavTabItem>[
      const _NavTabItem(
        label: 'الرئيسية',
        icon: Icons.star_outline_rounded,
        activeIcon: Icons.star_rounded,
      ),
      const _NavTabItem(
        label: 'استكشف',
        icon: Icons.search_rounded,
        activeIcon: Icons.search_rounded,
      ),
      if (_isLoggedIn)
        const _NavTabItem(
          label: 'دوراتي',
          icon: Icons.play_circle_outline_rounded,
          activeIcon: Icons.play_circle_fill_rounded,
        ),
      const _NavTabItem(
        label: 'السلة',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        badgeCount: 1,
      ),
      const _NavTabItem(
        label: 'حسابي',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
    ];

    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: NotificationListener<UserScrollNotification>(
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
            // User scrolled down in HomeScreen -> Hide nav bar
            if (_isNavBarVisible) {
              setState(() => _isNavBarVisible = false);
            }
          } else if (notification.direction == ScrollDirection.forward) {
            // User scrolled up in HomeScreen -> Show nav bar
            if (!_isNavBarVisible) {
              setState(() => _isNavBarVisible = true);
            }
          }
          return false;
        },
        child: Stack(
          children: [
            // Screen contents with smooth fade & micro-slide
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
              ),
            ),

            // Bottom Navigation Bar (Auto-Hides ONLY on HomeScreen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                offset: (_currentIndex != 0 || _isNavBarVisible) ? Offset.zero : const Offset(0, 1.2),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: (_currentIndex != 0 || _isNavBarVisible) ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(
                        top: BorderSide(
                          color: Color(0xFFF1F5F9),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
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
                ),
              ),
            ),
          ],
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
    final activeColor = AppColors.primary;
    const inactiveColor = Color(0xFF64748B);

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
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5),
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
