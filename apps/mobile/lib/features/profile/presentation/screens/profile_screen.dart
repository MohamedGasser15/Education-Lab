import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/profile/presentation/widgets/user_profile_header.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTab;
  const ProfileScreen({super.key, this.isTab = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileProvider>().fetchProfile();
      }
    });
  }

  void _handleLogout() async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Red Warning Badge
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3B1717) : const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 34,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              context.loc.profileLogoutConfirmTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              context.loc.profileLogoutConfirmMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 18),

            // Safe reassurance note box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.loc.profileLogoutSafeNote,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Red Button
            AppButton(
              label: context.loc.profileLogout,
              backgroundColor: const Color(0xFFDC2626),
              icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white),
              onPressed: () => Navigator.pop(ctx, true),
            ),
            const SizedBox(height: 10),

            // Cancel Button
            AppButton(
              label: context.loc.profileCancel,
              outlined: true,
              onPressed: () => Navigator.pop(ctx, false),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      await context.read<ProfileProvider>().logout();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final iconColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: (!widget.isTab && Navigator.of(context).canPop())
            ? IconButton(
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed('/main');
                  }
                },
              )
            : null,
        title: Text(
          context.loc.profileTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<ProfileProvider>().fetchProfile(forceRefresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // 1. User Profile Header Card (Modular Widget with Skeleton & Guest states)
            const UserProfileHeader(),

            const SizedBox(height: 20),

            // 2. Account Settings Group
            _buildSectionHeader(context.loc.profileAccountSettings),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileEditProfile,
                subtitle: context.loc.profileEditProfileSubtitle,
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.security_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileSecurity,
                subtitle: context.loc.profileSecuritySubtitle,
                onTap: () => Navigator.pushNamed(context, '/account-security'),
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.receipt_long_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profilePurchaseHistory,
                subtitle: context.loc.profilePurchaseHistorySubtitle,
                onTap: () => Navigator.pushNamed(context, '/purchase-history'),
              ),
            ]),

            const SizedBox(height: 20),

            // 3. Learning & Achievements Group
            _buildSectionHeader(context.loc.learningTitle),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.play_circle_outline_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileMyCourses,
                subtitle: context.loc.profileMyCoursesSubtitle,
                onTap: () => Navigator.pushNamed(context, '/my-courses'),
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.favorite_outline_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileWishlist,
                subtitle: context.loc.profileWishlistSubtitle,
                onTap: () => Navigator.pushNamed(context, '/wishlist'),
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.workspace_premium_outlined,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.certTitle,
                subtitle: context.loc.profileCertificatesSubtitle,
                onTap: () => Navigator.pushNamed(context, '/certificates'),
              ),
            ]),

            const SizedBox(height: 20),

            // 4. Teaching on EduLab (MVC Instructor Application)
            _buildSectionHeader(context.loc.profileTeach),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.school_outlined,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileTeach,
                subtitle: context.loc.profileTeachSubtitle,
                onTap: () => Navigator.pushNamed(context, '/teach-apply'),
              ),
            ]),

            const SizedBox(height: 20),

            // 5. App Preferences & Video Settings
            _buildSectionHeader(context.loc.settingsTitle),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.tune_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profilePreferences,
                subtitle: context.loc.profilePreferencesSubtitle,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.notifications_none_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileNotifications,
                subtitle: context.loc.profileNotificationsSubtitle,
                onTap: () => Navigator.pushNamed(context, '/notifications'),
              ),
            ]),

            const SizedBox(height: 20),

            // 6. Help & Support Group
            _buildSectionHeader(context.loc.profileHelpSupport),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.messagesTitle,
                subtitle: null,
                onTap: () => Navigator.pushNamed(context, '/messages'),
              ),
            ]),

            const SizedBox(height: 20),

            // 7. About Group
            _buildSectionHeader(context.loc.profileAboutEduLab),
            _buildGroupContainer(cardBgColor, borderColor, [
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profilePrivacy,
                subtitle: null,
                onTap: () {},
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.gavel_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileTerms,
                subtitle: null,
                onTap: () {},
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.code_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileAboutEduLab,
                trailingText: 'v1.0.0+1',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 24),

            // 8. Logout Button (Only if logged in)
            Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                if (!provider.isLoggedIn && provider.profile == null) {
                  return const SizedBox.shrink();
                }
                return _buildLogoutButton(cardBgColor);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  // Group Box Container (Udemy Card Style)
  Widget _buildGroupContainer(Color cardBgColor, Color borderColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Menu List Item
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color textSubColor,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: iconColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 11,
                  color: textSubColor,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              size: 20,
              color: textSubColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 48,
      color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9),
    );
  }

  // Logout Button
  Widget _buildLogoutButton(Color cardBgColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleLogout,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.loc.profileLogout,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
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
