import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/profile/data/models/security_models.dart';
import 'package:mobile/features/profile/presentation/providers/security_provider.dart';

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
  bool _isToggling2FA = false;
  bool _showAllDevices = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSecurityData();
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSecurityData() async {
    await context.read<SecurityProvider>().loadSecurityData();
  }

  // ================= CHANGE PASSWORD =================
  void _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    setState(() => _isChangingPassword = true);

    final currentPass = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    final result = await context.read<SecurityProvider>().changePassword(
      currentPassword: currentPass,
      newPassword: newPass,
      confirmPassword: confirmPass,
    );

    if (!mounted) return;
    setState(() => _isChangingPassword = false);

    if (result is Success<bool>) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      AppSnackbar.showSuccess(
        context,
        context.loc.securityPasswordUpdatedSuccess,
      );
    } else if (result is Failure<bool>) {
      AppSnackbar.showError(context, result.message);
    }
  }

  // ================= TOGGLE 2FA =================
  void _toggle2FA(bool value) async {
    if (_isToggling2FA) return;
    HapticFeedback.selectionClick();

    if (value) {
      // Fetch 2FA setup details (QR & Secret)
      setState(() => _isToggling2FA = true);
      final setupResult = await context
          .read<SecurityProvider>()
          .getTwoFactorSetup();
      if (!mounted) return;
      setState(() => _isToggling2FA = false);

      TwoFactorSetupModel? setupModel;
      if (setupResult is Success<TwoFactorSetupModel>) {
        setupModel = setupResult.data;
      } else if (setupResult is Failure<TwoFactorSetupModel>) {
        AppSnackbar.showError(context, setupResult.message);
        return;
      }

      final code = await _show2FAEnableModal(setupModel);
      if (code == null || code.trim().isEmpty || !mounted) return;

      setState(() => _isToggling2FA = true);
      final enableResult = await context
          .read<SecurityProvider>()
          .enableTwoFactor(code.trim());

      if (!mounted) return;
      setState(() => _isToggling2FA = false);

      if (enableResult is Success<bool>) {
        AppSnackbar.showSuccess(context, context.loc.security2FAEnabledSuccess);
      } else if (enableResult is Failure<bool>) {
        AppSnackbar.showError(context, enableResult.message);
      }
    } else {
      // Disable 2FA flow
      final confirm = await _showDisable2FAModal();
      if (confirm != true || !mounted) return;

      setState(() => _isToggling2FA = true);
      final disableResult = await context
          .read<SecurityProvider>()
          .disableTwoFactor();

      if (!mounted) return;
      setState(() => _isToggling2FA = false);

      if (disableResult is Success<bool>) {
        AppSnackbar.showSuccess(
          context,
          context.loc.security2FADisabledSuccess,
        );
      } else if (disableResult is Failure<bool>) {
        AppSnackbar.showError(context, disableResult.message);
      }
    }
  }

  // ================= 2FA ENABLE MODAL (WITH QR CODE & SECRET) =================
  Future<String?> _show2FAEnableModal(TwoFactorSetupModel? setup) {
    final codeController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final qrUrl = setup?.qrCodeUrl.isNotEmpty == true
        ? 'https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=${Uri.encodeComponent(setup!.qrCodeUrl)}'
        : '';

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 12,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.securitySetup2FATitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.loc.securityScanQRCode,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: textSubColor),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 1. QR Code Display Card
                    if (qrUrl.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppNetworkImage(
                          url: qrUrl,
                          width: 170,
                          height: 170,
                          fit: BoxFit.contain,
                          placeholder: const SizedBox(
                            width: 170,
                            height: 170,
                            child: Center(
                              child: AppLoadingSpinner(
                                size: 28,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          errorWidget: const SizedBox(
                            width: 170,
                            height: 170,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // 2. Secret Key manual entry
                    if (setup?.secret.isNotEmpty == true) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceMuted
                              : AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.key_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.loc.securitySecretKeyManual,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: textSubColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    setup!.secret,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy',
                              icon: const Icon(
                                Icons.copy_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: setup.secret),
                                );
                                HapticFeedback.selectionClick();
                                AppSnackbar.showSuccess(
                                  context,
                                  context.loc.securitySecretKeyCopied,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // 3. Verification Code Input
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        context.loc.securityEnter6DigitCode,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceMuted
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: '000000',
                          hintStyle: TextStyle(
                            fontSize: 22,
                            letterSpacing: 8,
                            color: isDark ? Colors.white24 : Colors.black26,
                            fontFamily: 'Inter',
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. Submit button
                    AppButton(
                      label: context.loc.securityConfirmEnable2FABtn,
                      icon: const Icon(
                        Icons.shield_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final code = codeController.text.trim();
                        if (code.length < 6) {
                          AppSnackbar.showError(
                            context,
                            context.loc.securityEnter6DigitsError,
                          );
                          return;
                        }
                        Navigator.pop(ctx, code);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= MODERN LOGOUT CONFIRM MODAL =================
  Future<bool?> _showLogoutAllConfirmModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Warning Icon Badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.roleAdmin,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              context.loc.securityLogoutAllDevicesTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),

            Text(
              context.loc.securityLogoutAllDevicesMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Red Button
            AppButton(
              label: context.loc.securityLogoutAllDevicesConfirmBtn,
              backgroundColor: AppColors.roleAdmin,
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
              label: context.loc.generalCancel,
              outlined: true,
              onPressed: () => Navigator.pop(ctx, false),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DISABLE 2FA CONFIRM MODAL =================
  Future<bool?> _showDisable2FAModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.gpp_maybe_rounded,
                color: AppColors.roleStudent,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              context.loc.securityDisable2FAModalTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),

            Text(
              context.loc.securityDisable2FAModalMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: context.loc.securityDisable2FAConfirmBtn,
              backgroundColor: AppColors.roleAdmin,
              icon: const Icon(
                Icons.shield_outlined,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
            ),
            const SizedBox(height: 10),

            AppButton(
              label: context.loc.generalCancel,
              outlined: true,
              onPressed: () => Navigator.pop(ctx, false),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REVOKE SESSIONS =================
  void _revokeSession(String id) async {
    HapticFeedback.lightImpact();

    final result = await context.read<SecurityProvider>().revokeSession(id);

    if (!mounted) return;

    if (result is Success<bool>) {
      AppSnackbar.showSuccess(
        context,
        context.loc.securitySessionRevokedSuccess,
      );
    } else if (result is Failure<bool>) {
      AppSnackbar.showError(context, result.message);
    }
  }

  void _revokeAllOtherSessions() async {
    final confirm = await _showLogoutAllConfirmModal();
    if (confirm != true || !mounted) return;

    HapticFeedback.mediumImpact();

    final result = await context.read<SecurityProvider>().revokeAllSessions();

    if (!mounted) return;

    if (result is Success<bool>) {
      AppSnackbar.showSuccess(
        context,
        context.loc.securityAllSessionsRevokedSuccess,
      );
    } else if (result is Failure<bool>) {
      AppSnackbar.showError(context, result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityProvider = context.watch<SecurityProvider>();
    final isLoadingData = securityProvider.isLoading;
    final is2FaEnabled = securityProvider.is2FaEnabled;
    final activeSessions = securityProvider.activeSessions;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.background;
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final displayedSessions = _showAllDevices
        ? activeSessions
        : activeSessions.take(5).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
      body: RefreshIndicator(
        onRefresh: _loadSecurityData,
        color: AppColors.primary,
        child: isLoadingData && activeSessions.isEmpty
            ? _buildSkeletonSecurityView(cardBg, borderColor, isDark)
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.screenPadding(context),
                  16,
                  AppResponsive.screenPadding(context),
                  120,
                ),
                children: [
                  // 1. Change Password Section (POST /api/Settings/change-password)
                  _buildSectionHeader(
                    context.loc.securitySectionChangePassword,
                  ),
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
                            onToggle: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? context.loc.securityCurrentPasswordError
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            label: context.loc.securityNewPasswordLabel,
                            obscure: _obscureNew,
                            inputFill: inputFill,
                            borderColor: borderColor,
                            textColor: textColor,
                            onToggle: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            validator: (v) => (v == null || v.length < 8)
                                ? context.loc.securityNewPasswordError
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            label: context.loc.securityConfirmPasswordLabel,
                            obscure: _obscureConfirm,
                            inputFill: inputFill,
                            borderColor: borderColor,
                            textColor: textColor,
                            onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            validator: (v) => (v != _newPasswordController.text)
                                ? context.loc.securityConfirmPasswordError
                                : null,
                          ),
                          const SizedBox(height: 18),
                          AppButton(
                            label: context.loc.securityUpdatePasswordBtn,
                            isLoading: _isChangingPassword,
                            icon: const Icon(
                              Icons.lock_reset_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: _changePassword,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Two-Factor Authentication (2FA) (GET/POST /api/Settings/two-factor)
                  _buildSectionHeader(context.loc.securitySection2FA),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                            color: is2FaEnabled
                                ? AppColors.emeraldLight
                                : (isDark
                                      ? AppColors.darkSurfaceMuted
                                      : AppColors.surfaceMuted),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shield_rounded,
                            color: is2FaEnabled
                                ? AppColors.emerald
                                : AppColors.textSecondary,
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
                                is2FaEnabled
                                    ? context.loc.security2FAEnabledDesc
                                    : context.loc.security2FADisabledDesc,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: is2FaEnabled
                                      ? AppColors.emerald
                                      : textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isToggling2FA)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: AppLoadingSpinner(
                              size: 20,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          Switch(
                            value: is2FaEnabled,
                            activeThumbColor: AppColors.primary,
                            onChanged: _toggle2FA,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Active Sessions & Logged-in Devices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader(context.loc.securitySectionSessions),
                      if (activeSessions.where((s) => !s.isCurrent).isNotEmpty)
                        GestureDetector(
                          onTap: _revokeAllOtherSessions,
                          child: Text(
                            context.loc.securityLogoutAllDevices,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.roleAdmin,
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
                    child: isLoadingData && activeSessions.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: AppLoadingSpinner(
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : activeSessions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 26.0,
                              horizontal: 16.0,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurfaceMuted
                                          : AppColors.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.devices_rounded,
                                      size: 24,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    context.loc.securityNoOtherSessions,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.loc.securityCurrentDeviceOnly,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: textSubColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              for (
                                int i = 0;
                                i < displayedSessions.length;
                                i++
                              ) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    color: isDark
                                        ? AppColors.darkDivider
                                        : AppColors.divider,
                                  ),
                                _buildSessionItem(
                                  displayedSessions[i],
                                  textColor,
                                  textSubColor,
                                  isDark,
                                ),
                              ],

                              // Show All / Show Less Button if more than 5 devices
                              if (activeSessions.length > 5) ...[
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? AppColors.darkDivider
                                      : AppColors.divider,
                                ),
                                InkWell(
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                  onTap: () => setState(
                                    () => _showAllDevices = !_showAllDevices,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _showAllDevices
                                              ? context
                                                    .loc
                                                    .securityShowLessDevices
                                              : context.loc
                                                    .securityShowAllDevicesCount(
                                                      activeSessions.length
                                                          .toString(),
                                                    ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          _showAllDevices
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                    .keyboard_arrow_down_rounded,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
          color: AppColors.textSecondary,
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
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
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
            style: TextStyle(
              fontSize: 12.5,
              fontFamily: 'Inter',
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              errorStyle: const TextStyle(
                fontSize: 11,
                fontFamily: 'Tajawal',
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: onToggle,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(
    ActiveSessionModel session,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
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

    final dateFormatted = session.isCurrent
        ? context.loc.securityThisDevice
        : (session.lastActive != null
              ? '${session.lastActive!.day}/${session.lastActive!.month}/${session.lastActive!.year}'
              : 'نشط سابقاً');

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: session.isCurrent
                  ? AppColors.primaryLight
                  : (isDark
                        ? AppColors.darkSurfaceMuted
                        : AppColors.surfaceMuted),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              deviceIcon,
              color: session.isCurrent
                  ? AppColors.primary
                  : AppColors.textSecondary,
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
                    Expanded(
                      child: Text(
                        session.deviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    if (session.isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.loc.securityThisDevice,
                          style: const TextStyle(
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
                  '${session.location} • $dateFormatted',
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
              tooltip: 'إنهاء الجلسة',
              onPressed: () => _revokeSession(session.id),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 19,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonSecurityView(
    Color cardBg,
    Color borderColor,
    bool isDark,
  ) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        // 1. Password Section Skeleton
        const AppSkeleton(child: SkeletonLine(width: 140, height: 16)),
        const SizedBox(height: 10),
        AppSkeleton(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              children: [
                SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 12,
                ),
                SizedBox(height: 12),
                SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 12,
                ),
                SizedBox(height: 12),
                SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 12,
                ),
                SizedBox(height: 16),
                SkeletonBox(
                  width: double.infinity,
                  height: 46,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 2. 2FA Section Skeleton
        const AppSkeleton(child: SkeletonLine(width: 160, height: 16)),
        const SizedBox(height: 10),
        const SkeletonListTile(showSubtitle: true),
        const SizedBox(height: 24),

        // 3. Active Sessions Section Skeleton
        const AppSkeleton(child: SkeletonLine(width: 130, height: 16)),
        const SizedBox(height: 10),
        const SkeletonListTile(showSubtitle: true),
        const SkeletonListTile(showSubtitle: true),
      ],
    );
  }
}
