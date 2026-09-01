import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTab;
  const ProfileScreen({super.key, this.isTab = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final loggedIn = await AuthStorageService.isLoggedIn();
    final name = await AuthStorageService.getUserName();
    final email = await AuthStorageService.getUserEmail();

    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _userName = name.isNotEmpty ? name : 'محمد النجار';
      _userEmail = email.isNotEmpty ? email : 'mohamed.elnaggar@edulab.edu';
    });
  }

  void _handleLogout() async {
    HapticFeedback.mediumImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            const SizedBox(width: 8),
            Text(
              context.loc.profileLogoutConfirmTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: Text(
          context.loc.profileLogoutConfirmMessage,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.loc.profileCancel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(
              context.loc.profileLogout,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthStorageService.logout();
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // 1. User Profile Header Card (Udemy Style)
          _buildUserProfileHeader(cardBgColor, borderColor, textColor, textSubColor),

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
              icon: Icons.workspace_premium_outlined,
              iconColor: iconColor,
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.certTitle,
              subtitle: context.loc.profileCertificatesSubtitle,
              onTap: () => Navigator.pushNamed(context, '/certificate_view'),
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
              icon: Icons.help_outline_rounded,
              iconColor: iconColor,
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.profileHelpSupport,
              onTap: () => _showFeatureDialog(context.loc.profileHelpSupport),
            ),
            _buildDivider(isDark),
            _buildMenuItem(
              icon: Icons.shield_outlined,
              iconColor: iconColor,
              textColor: textColor,
              textSubColor: textSubColor,
              title: '${context.loc.profileTerms} & ${context.loc.profilePrivacy}',
              onTap: () => _showFeatureDialog(context.loc.profileTerms),
            ),
            _buildDivider(isDark),
            _buildMenuItem(
              icon: Icons.info_outline_rounded,
              iconColor: iconColor,
              textColor: textColor,
              textSubColor: textSubColor,
              title: context.loc.profileAboutEduLab,
              trailingText: 'v1.0.0 (Build 2026)',
              onTap: () => _showFeatureDialog(context.loc.profileAboutEduLab),
            ),
          ]),

          const SizedBox(height: 24),

          // 7. Sign Out Button (If Logged In)
          if (_isLoggedIn)
            _buildLogoutButton(cardBgColor)
          else
            _buildLoginPromptButton(),
        ],
      ),
    );
  }

  // ================= 1. USER PROFILE HEADER =================
  Widget _buildUserProfileHeader(Color cardBgColor, Color borderColor, Color textColor, Color textSubColor) {
    if (!_isLoggedIn) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.profileWelcome,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.loc.profileLoginPrompt,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: textSubColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                elevation: 0,
              ),
              child: Text(
                context.loc.loginSubmit,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      );
    }

    final initial = _userName.isNotEmpty ? _userName.substring(0, 1) : 'م';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D61E7), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _userEmail,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSubColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    context.loc.profileVerifiedStudent,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Profile Action
          IconButton(
            tooltip: context.loc.profileEditProfile,
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            icon: const Icon(
              Icons.mode_edit_outline_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
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
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: InkWell(
        onTap: _handleLogout,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
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
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPromptButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/login'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        elevation: 0,
      ),
      child: Text(
        context.loc.profileLoginOrRegister,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
      ),
    );
  }

  void _showFeatureDialog(String featureTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          featureTitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        content: const Text(
          'هذه الميزة مفعلة وتعمل بكفاءة ضمن منظومة التعليم المعتمدة في منصة EduLab.',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'حسناً',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
