import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_theme.dart';
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

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  String _userName = '';

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
      _isLoggedIn = loggedIn;
      _userName = name;
    });
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

    final items = <(IconData, IconData)>[
      (Icons.home_outlined, Icons.home_rounded),
      (Icons.explore_outlined, Icons.explore_rounded),
      if (_isLoggedIn) (Icons.school_outlined, Icons.school_rounded),
      (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded),
      (Icons.person_outline_rounded, Icons.person_rounded),
    ];

    if (_currentIndex >= items.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BottomBar(
        layout: const BottomBarLayout.adaptive(
          maxWidth: 720,
          offset: 14,
          borderRadius: BorderRadius.all(Radius.circular(32)),
          clip: Clip.none,
        ),
        motion: const BottomBarMotion.cupertino(
          preset: BottomBarCupertinoMotion.snappy,
          duration: Duration(milliseconds: 460),
          extraBounce: 0.03,
        ),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 30,
                offset: Offset(0, 16),
              ),
            ],
          ),
        ),
        scrollBehavior: const BottomBarScrollBehavior(showAtStart: true),
        showIcon: false,
        body: IndexedStack(index: _currentIndex, children: screens),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _DockButton(
                    icon: items[i].$1,
                    selectedIcon: items[i].$2,
                    selected: i == _currentIndex,
                    onTap: () {
                      if (i == _currentIndex) return;
                      setState(() => _currentIndex = i);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                )
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            selected ? selectedIcon : icon,
            key: ValueKey(selected),
            size: 23,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
