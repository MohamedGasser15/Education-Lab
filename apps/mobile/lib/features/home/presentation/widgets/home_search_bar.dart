import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/screens/explore_screen.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key, this.onTap, this.trendingHints});

  final VoidCallback? onTap;
  final List<String>? trendingHints;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  int _searchHintIndex = 0;
  Timer? _searchHintTimer;

  static const List<String> _defaultTrendingHints = [
    'Flutter & Dart...',
    'Python & AI...',
    'UI/UX Design & Figma...',
    'Full-Stack Web...',
    'Cyber Security...',
    'Data Science & SQL...',
  ];

  List<String> get _hints => widget.trendingHints ?? _defaultTrendingHints;

  @override
  void initState() {
    super.initState();
    _startHintTimer();
  }

  void _startHintTimer() {
    _searchHintTimer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (mounted && _hints.isNotEmpty) {
        setState(() {
          _searchHintIndex = (_searchHintIndex + 1) % _hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchHintTimer?.cancel();
    super.dispose();
  }

  void _openSearchScreen(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ExploreScreen(autoFocusSearch: true, isTab: false),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Hero(
      tag: 'app_search_bar',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSearchScreen(context),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.0),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),

                // Animated Rotating Trending Search Hint
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.4),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      key: ValueKey<int>(_searchHintIndex),
                      children: [
                        Flexible(
                          child: Text(
                            '${context.loc.homeSearchHint.split('...').first.trim()}: ',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.6),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _hints[_searchHintIndex % _hints.length],
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter Action Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5.5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceMuted
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.loc.homeSearchFilter,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
