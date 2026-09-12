import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/app_session_service.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/profile/presentation/widgets/user_profile_header.dart';
import 'package:mobile/features/legal/presentation/screens/legal_content_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
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
                color: isDark
                    ? const Color(0xFF3B1717)
                    : const Color(0xFFFEE2E2),
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
                color: isDark
                    ? AppColors.darkSurfaceMuted
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
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
              icon: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: Colors.white,
              ),
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
      await AppSessionService.clearSession(context);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _openAuthenticatedWebUrl({String? returnUrl}) async {
    HapticFeedback.lightImpact();
    try {
      final token = await AuthStorageService.getAccessToken();
      final email = await AuthStorageService.getUserEmail();

      String targetUrl = 'https://edulab.runasp.net/';

      if (token != null && token.isNotEmpty && email.isNotEmpty) {
        final queryParams = <String, String>{
          'email': email,
          'isNewUser': 'false',
          'token': token,
        };
        if (returnUrl != null && returnUrl.isNotEmpty) {
          queryParams['returnUrl'] = returnUrl;
        }

        final uri = Uri.https(
          'edulab.runasp.net',
          '/Learner/Auth/ExternalLoginCallbackFromApi',
          queryParams,
        );
        targetUrl = uri.toString();
      }

      final uri = Uri.parse(targetUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      try {
        await launchUrl(Uri.parse('https://edulab.runasp.net/'));
      } catch (_) {
        if (mounted) {
          AppSnackbar.showError(
            context,
            context.isArabic
                ? 'تعذر فتح لوحة التحكم'
                : 'Could not open dashboard',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBgColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : const Color(0xFF475569);
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final isLoggedIn = profileProvider.isLoggedIn;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        centerTitle: true,
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
        onRefresh: () =>
            context.read<ProfileProvider>().fetchProfile(forceRefresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            AppResponsive.screenPadding(context),
            16,
            AppResponsive.screenPadding(context),
            120,
          ),
          children: [
            // 1. User Profile Header Card (Modular Widget with Skeleton & Guest states)
            const UserProfileHeader(),

            const SizedBox(height: 20),

            if (isLoggedIn) ...[
              // 2. Admin Management Group (If user has Admin role or Admin claims)
              if (profile?.isAdmin == true ||
                  profile?.hasAdminClaim == true) ...[
                _buildSectionHeader(
                  context.isArabic ? 'لوحة تحكم المسؤول' : 'Admin Panel',
                ),
                _buildGroupContainer(cardBgColor, borderColor, [
                  _buildMenuItem(
                    icon: Icons.admin_panel_settings_rounded,
                    iconColor: const Color(0xFFDC2626),
                    textColor: textColor,
                    textSubColor: textSubColor,
                    title: context.isArabic
                        ? 'لوحة تحكم الإدارة (الويب)'
                        : 'Admin Dashboard (Web)',
                    subtitle: context.isArabic
                        ? 'إدارة المستخدمين، الدورات، والصلاحيات عبر المتصفح'
                        : 'Manage users, courses, and platform via web',
                    trailingIcon: Icons.open_in_new_rounded,
                    onTap: () => _openAuthenticatedWebUrl(
                      returnUrl: '/Admin/Dashboard/Index',
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
              ],

              // 3. Instructor Management Group (If user is an instructor)
              if (profile?.isInstructor == true) ...[
                _buildSectionHeader(
                  context.isArabic
                      ? 'لوحة تحكم المدرب'
                      : 'Instructor Dashboard',
                ),
                _buildGroupContainer(cardBgColor, borderColor, [
                  _buildMenuItem(
                    icon: Icons.cast_for_education_rounded,
                    iconColor: const Color(0xFF2563EB),
                    textColor: textColor,
                    textSubColor: textSubColor,
                    title: context.isArabic
                        ? 'لوحة تحكم المدرب (الويب)'
                        : 'Instructor Dashboard (Web)',
                    subtitle: context.isArabic
                        ? 'إدارة دوراتك، الطلاب، والتقارير عبر المتصفح'
                        : 'Manage your courses, students, and reports via web',
                    trailingIcon: Icons.open_in_new_rounded,
                    onTap: () => _openAuthenticatedWebUrl(
                      returnUrl: '/Instructor/Dashboard/index',
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
              ],

              // 4. Account Settings Group (Only for authenticated users)
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
                  onTap: () =>
                      Navigator.pushNamed(context, '/account-security'),
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.receipt_long_rounded,
                  iconColor: iconColor,
                  textColor: textColor,
                  textSubColor: textSubColor,
                  title: context.loc.profilePurchaseHistory,
                  subtitle: context.loc.profilePurchaseHistorySubtitle,
                  onTap: () =>
                      Navigator.pushNamed(context, '/purchase-history'),
                ),
              ]),

              const SizedBox(height: 20),

              // 5. Learning & Achievements Group (Only for authenticated users)
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

              // 6. Teaching on EduLab (For Students & Pending Instructors)
              if (profile?.isInstructor != true &&
                  (profile?.isStudent == true ||
                      profile?.isInstructorPending == true)) ...[
                _buildSectionHeader(context.loc.profileTeach),
                _buildGroupContainer(cardBgColor, borderColor, [
                  _buildMenuItem(
                    icon: Icons.school_outlined,
                    iconColor: profile?.isInstructorPending == true
                        ? const Color(0xFFF59E0B)
                        : iconColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    title: context.loc.profileTeach,
                    subtitle: profile?.isInstructorPending == true
                        ? 'طلبك قيد المراجعة حالياً'
                        : context.loc.profileTeachSubtitle,
                    onTap: () => Navigator.pushNamed(context, '/teach-apply'),
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ],

            // 5. App Preferences & Video Settings (Available to both logged-in and guests)
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
              if (isLoggedIn) ...[
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
              ],
            ]),

            if (isLoggedIn) ...[
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
            ],

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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LegalContentScreen(
                        initialTab: LegalTab.privacy,
                      ),
                    ),
                  );
                },
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.gavel_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileTerms,
                subtitle: null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const LegalContentScreen(initialTab: LegalTab.terms),
                    ),
                  );
                },
              ),
              _buildDivider(isDark),
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                iconColor: iconColor,
                textColor: textColor,
                textSubColor: textSubColor,
                title: context.loc.profileAboutEduLab,
                trailingText: 'v1.0.0+1',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const LegalContentScreen(initialTab: LegalTab.about),
                    ),
                  );
                },
              ),
            ]),

            if (isLoggedIn) ...[
              const SizedBox(height: 24),
              _buildLogoutButton(cardBgColor),
              const SizedBox(height: 50),
            ] else
              const SizedBox(height: 40),
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
  Widget _buildGroupContainer(
    Color cardBgColor,
    Color borderColor,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
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
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 21, color: iconColor),
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
              trailingIcon ??
                  (Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded),
              size: trailingIcon != null ? 18 : 20,
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
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
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
