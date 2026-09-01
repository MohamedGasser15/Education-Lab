import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _ActiveSessionModel {
  final String id;
  final String deviceName;
  final String deviceType; // 'phone' | 'desktop' | 'tablet'
  final String location;
  final String lastActive;
  final String ipAddress;
  final bool isCurrent;

  const _ActiveSessionModel({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.location,
    required this.lastActive,
    required this.ipAddress,
    this.isCurrent = false,
  });
}

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final _passwordFormKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isChangingPassword = false;
  bool _is2FaEnabled = false;

  final List<_ActiveSessionModel> _activeSessions = [
    const _ActiveSessionModel(
      id: 'sess_1',
      deviceName: 'iPhone 15 Pro Max',
      deviceType: 'phone',
      location: 'الرياض، المملكة العربية السعودية',
      lastActive: 'نشط الآن',
      ipAddress: '156.204.12.89',
      isCurrent: true,
    ),
    const _ActiveSessionModel(
      id: 'sess_2',
      deviceName: 'MacBook Pro 16" (Chrome)',
      deviceType: 'desktop',
      location: 'الرياض، المملكة العربية السعودية',
      lastActive: 'منذ 3 ساعات',
      ipAddress: '156.204.12.92',
      isCurrent: false,
    ),
    const _ActiveSessionModel(
      id: 'sess_3',
      deviceName: 'iPad Air 5th Gen (EduLab App)',
      deviceType: 'tablet',
      location: 'جدة، المملكة العربية السعودية',
      lastActive: 'منذ يومين',
      ipAddress: '188.130.45.11',
      isCurrent: false,
    ),
  ];

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    setState(() => _isChangingPassword = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() {
      _isChangingPassword = false;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.securityPasswordUpdatedSuccess),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggle2FA(bool value) async {
    HapticFeedback.selectionClick();
    if (value) {
      final confirm = await _show2FASetupDialog();
      if (confirm == true) {
        setState(() => _is2FaEnabled = true);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc.security2FAEnabledSuccess),
            backgroundColor: Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      setState(() => _is2FaEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.security2FADisabledSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<bool?> _show2FASetupDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.security_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              context.loc.security2FASetupTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: Text(
          context.loc.security2FASetupContent,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.loc.commonCancel,
              style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(context.loc.security2FAEnableNow, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _revokeSession(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _activeSessions.removeWhere((s) => s.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.securitySessionRevokedSuccess),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _revokeAllOtherSessions() {
    HapticFeedback.mediumImpact();
    setState(() {
      _activeSessions.removeWhere((s) => !s.isCurrent);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.securityAllSessionsRevokedSuccess),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/main');
            }
          },
        ),
        title: Text(
          context.loc.securityTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // 1. Change Password Section (ChangePasswordDTO)
          _buildSectionHeader(context.loc.securitySectionChangePassword),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Form(
              key: _passwordFormKey,
              child: Column(
                children: [
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: context.loc.securityCurrentPasswordLabel,
                    obscure: _obscureCurrent,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    validator: (v) => (v == null || v.length < 6) ? context.loc.securityCurrentPasswordError : null,
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: context.loc.securityNewPasswordLabel,
                    obscure: _obscureNew,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    validator: (v) => (v == null || v.length < 8) ? context.loc.securityNewPasswordError : null,
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: context.loc.securityConfirmPasswordLabel,
                    obscure: _obscureConfirm,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) => (v != _newPasswordController.text) ? context.loc.securityConfirmPasswordError : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isChangingPassword ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: _isChangingPassword
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              context.loc.securityUpdatePasswordBtn,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Two-Factor Authentication (2FA) (TwoFactorDTO)
          _buildSectionHeader(context.loc.securitySection2FA),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _is2FaEnabled ? const Color(0xFFECFDF5) : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    color: _is2FaEnabled ? const Color(0xFF059669) : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.security2FATitle,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _is2FaEnabled ? context.loc.security2FAEnabledDesc : context.loc.security2FADisabledDesc,
                        style: TextStyle(
                          fontSize: 11,
                          color: _is2FaEnabled ? const Color(0xFF059669) : textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _is2FaEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: _toggle2FA,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Active Sessions & Logged-in Devices (ActiveSessionsDTO)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(context.loc.securitySectionSessions),
              if (_activeSessions.length > 1)
                GestureDetector(
                  onTap: _revokeAllOtherSessions,
                  child: Text(
                    context.loc.securityLogoutAllDevices,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _activeSessions.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
                  _buildSessionItem(_activeSessions[i], textColor, textSubColor, isDark),
                ],
              ],
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required Color inputFill,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12.5, fontFamily: 'Inter', color: textColor),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.textSecondary),
                onPressed: onToggle,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(_ActiveSessionModel session, Color textColor, Color textSubColor, bool isDark) {
    IconData deviceIcon;
    switch (session.deviceType) {
      case 'desktop':
        deviceIcon = Icons.laptop_mac_rounded;
        break;
      case 'tablet':
        deviceIcon = Icons.tablet_mac_rounded;
        break;
      default:
        deviceIcon = Icons.phone_iphone_rounded;
    }

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: session.isCurrent
                  ? const Color(0xFFEFF4FF)
                  : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              deviceIcon,
              color: session.isCurrent ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      session.deviceName,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (session.isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.loc.securityThisDevice,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.location} • ${session.lastActive}',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          if (!session.isCurrent)
            IconButton(
              tooltip: context.loc.securityLogoutAllDevices,
              onPressed: () => _revokeSession(session.id),
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 19),
            ),
        ],
      ),
    );
  }
}
