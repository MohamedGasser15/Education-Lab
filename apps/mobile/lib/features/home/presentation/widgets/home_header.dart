import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/constants/app_assets.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.isLoggedIn = false,
    this.userName = '',
    this.hasWishlistItems,
    this.onProfileTap,
    this.onWishlistTap,
    this.onNotificationsTap,
    this.onCartTap,
  });

  final bool isLoggedIn;
  final String userName;
  final bool? hasWishlistItems;
  final VoidCallback? onProfileTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final isUserLoggedIn = profileProvider.isLoggedIn || isLoggedIn;
    final displayName = (profile != null && profile.displayName.isNotEmpty)
        ? profile.displayName
        : (userName.trim().isNotEmpty
              ? userName.trim()
              : (isUserLoggedIn
                    ? context.loc.homeDefaultUser
                    : context.loc.homeVisitor));

    final hasAvatar = profile != null && profile.hasAvatar;

    final wishlistCount = context.watch<WishlistProvider>().count;
    final isWishlistActive = hasWishlistItems ?? (wishlistCount > 0);

    final cartCount = context.watch<CartProvider>().count;
    final isCartActive = cartCount > 0;

    final unreadNotificationCount = context
        .watch<NotificationProvider>()
        .unreadCount;

    return Row(
      children: [
        // 1. User Avatar / Brand Icon
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            if (onProfileTap != null) {
              onProfileTap!();
            } else {
              Navigator.pushNamed(context, '/profile');
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isUserLoggedIn
                        ? [AppColors.primary, AppColors.accent]
                        : [AppColors.darkDivider, AppColors.textMuted],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isUserLoggedIn ? AppColors.primary : Colors.black)
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: hasAvatar
                    ? AppNetworkImage(
                        url: profile.profileImageUrl,
                        fit: BoxFit.cover,
                        shape: BoxShape.circle,
                        errorWidget: Image.asset(
                          AppAssets.defaultAvatar,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(AppAssets.defaultAvatar, fit: BoxFit.cover),
              ),
              if (isUserLoggedIn)
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // 2. Greeting Headline & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isUserLoggedIn
                          ? context.loc.homeGreeting(displayName)
                          : 'EduLab',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (isUserLoggedIn)
                    const Icon(
                      Icons.waving_hand_rounded,
                      size: 16,
                      color: Color(0xFFF59E0B),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 11,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Edu',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 1.5),
              Text(
                isUserLoggedIn
                    ? context.loc.homeSubGreeting
                    : context.loc.homeGuestTagline,
                style: TextStyle(
                  fontSize: 11.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // 3. Action Buttons (Only for authenticated users; guest gets a Sign-In button)
        if (isUserLoggedIn) ...[
          _HomeHeaderActionButton(
            tooltip: context.loc.profileWishlist,
            icon: Icons.favorite_border_rounded,
            badgeColor: isWishlistActive ? const Color(0xFFEF4444) : null,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            onTap: () {
              if (onWishlistTap != null) {
                onWishlistTap!();
              } else {
                Navigator.pushNamed(context, '/wishlist');
              }
            },
          ),
          const SizedBox(width: 6),
          _HomeHeaderActionButton(
            tooltip: context.loc.notificationsTitle,
            icon: Icons.notifications_none_rounded,
            badgeColor: unreadNotificationCount > 0
                ? const Color(0xFFEF4444)
                : null,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            onTap: () {
              if (onNotificationsTap != null) {
                onNotificationsTap!();
              } else {
                Navigator.pushNamed(context, '/notifications');
              }
            },
          ),
          const SizedBox(width: 6),
          _HomeHeaderActionButton(
            tooltip: context.loc.cartTitle,
            icon: Icons.shopping_cart_outlined,
            badgeColor: isCartActive ? AppColors.primary : null,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            onTap: () {
              if (onCartTap != null) {
                onCartTap!();
              } else {
                Navigator.pushNamed(context, '/cart');
              }
            },
          ),
        ] else ...[
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/login');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.login_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    context.loc.loginTabLogin,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HomeHeaderActionButton extends StatelessWidget {
  const _HomeHeaderActionButton({
    required this.tooltip,
    required this.icon,
    required this.badgeColor,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final Color? badgeColor;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: textColor, size: 20),
                if (badgeColor != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6.5,
                      height: 6.5,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
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
