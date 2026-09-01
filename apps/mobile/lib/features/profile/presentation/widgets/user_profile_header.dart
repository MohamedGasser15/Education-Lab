import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_shimmer.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.profile == null) {
          return _buildSkeleton(cardBgColor, borderColor, isDark);
        }

        if (!provider.isLoggedIn && provider.profile == null) {
          return _buildGuestCard(context, cardBgColor, borderColor, textColor, textSubColor);
        }

        final profile = provider.profile ??
            const UserProfileModel(
              id: '',
              fullName: 'مستخدم EduLab',
              email: 'user@edulab.edu',
            );

        return _buildProfileCard(
          context,
          profile,
          cardBgColor,
          borderColor,
          textColor,
          textSubColor,
          isDark,
        );
      },
    );
  }

  // ================= 1. LOGGED IN PROFILE CARD =================
  Widget _buildProfileCard(
    BuildContext context,
    UserProfileModel profile,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar Hero
          _buildAvatar(profile),
          const SizedBox(width: 14),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (profile.title != null && profile.title!.trim().isNotEmpty) ...[
                  Text(
                    profile.title!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSubColor,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Edit Profile Button
          IconButton(
            tooltip: context.loc.profileEditProfile,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/edit-profile');
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mode_edit_outline_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= AVATAR BUILDER =================
  Widget _buildAvatar(UserProfileModel profile) {
    if (profile.hasAvatar) {
      return Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: profile.profileImageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => const AppShimmer(
              child: ShimmerBox(
                width: 58,
                height: 58,
                borderRadius: BorderRadius.all(Radius.circular(29)),
              ),
            ),
            errorWidget: (context, url, error) => _buildDefaultAvatar(),
          ),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/default_avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= 2. GUEST CARD =================
  Widget _buildGuestCard(
    BuildContext context,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك في EduLab',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'سجّل دخولك لمتابعة دوراتك وشهاداتك',
                  style: TextStyle(
                    fontSize: 11,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 3. SKELETON LOADING =================
  Widget _buildSkeleton(Color cardBgColor, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: const AppShimmer(
        child: Row(
          children: [
            ShimmerBox(
              width: 58,
              height: 58,
              borderRadius: BorderRadius.all(Radius.circular(29)),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 130, height: 16, borderRadius: BorderRadius.all(Radius.circular(4))),
                  SizedBox(height: 6),
                  ShimmerBox(width: 170, height: 12, borderRadius: BorderRadius.all(Radius.circular(4))),
                  SizedBox(height: 6),
                  ShimmerBox(width: 80, height: 16, borderRadius: BorderRadius.all(Radius.circular(4))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
