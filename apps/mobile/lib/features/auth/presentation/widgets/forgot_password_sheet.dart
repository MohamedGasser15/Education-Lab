import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';

/// Interactive 3-step modal bottom sheet for Forgot Password flow
class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({
    super.key,
    this.initialEmail,
    this.onPasswordResetSuccess,
  });

  final String? initialEmail;
  final ValueChanged<String>? onPasswordResetSuccess;

  static Future<void> show(
    BuildContext context, {
    String? initialEmail,
    ValueChanged<String>? onPasswordResetSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => ForgotPasswordSheet(
        initialEmail: initialEmail,
        onPasswordResetSuccess: onPasswordResetSuccess,
      ),
    );
  }

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  int _step = 0; // 0: email, 1: code, 2: new password

  // Controllers
  late final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Focus nodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _otpFocus = FocusNode();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  // State flags
  bool _isLoading = false;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  String? _verifiedEmail;

  // Countdown timer for resend
  Timer? _resendTimer;
  int _resendSeconds = 0;

  static const int _codeLength = 6;

  final _denyArabicFormatter =
      FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]'));

  final _arabicDigitsFormatter = TextInputFormatter.withFunction(
    (oldValue, newValue) {
      const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      var text = newValue.text;
      for (int i = 0; i < eastern.length; i++) {
        text = text.replaceAll(eastern[i], western[i]);
      }
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    },
  );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _otpFocus.dispose();
    _newPassFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _resendSeconds--);
      if (_resendSeconds <= 0) timer.cancel();
    });
  }

  String _formatCountdown() {
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // --- Actions ---

  Future<void> _handleSendResetCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      AppSnackbar.show(context, context.loc.loginEmailRequired, error: true);
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      AppSnackbar.show(context, context.loc.loginEmailInvalid, error: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await locator<AuthRepository>().forgotPassword(email: email);
      if (!mounted) return;
      _verifiedEmail = email;
      _otpController.clear();
      _startCountdown();
      setState(() => _step = 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _step == 1) _otpFocus.requestFocus();
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVerifyResetCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = _otpController.text.trim();
    if (code.length != _codeLength) {
      AppSnackbar.show(
        context,
        context.loc.registerCodeIncomplete,
        error: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await locator<AuthRepository>().verifyResetCode(
        email: _verifiedEmail!,
        code: code,
      );
      if (!mounted) return;
      _resendTimer?.cancel();
      setState(() => _step = 2);
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.isEmpty) {
      AppSnackbar.show(context, context.loc.loginPasswordRequired, error: true);
      return;
    }
    if (newPass.length < 6) {
      AppSnackbar.show(
        context,
        context.loc.forgotPasswordMinLengthError,
        error: true,
      );
      return;
    }
    if (newPass != confirmPass) {
      AppSnackbar.show(
        context,
        context.loc.registerConfirmMismatch,
        error: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await locator<AuthRepository>().resetPassword(
        email: _verifiedEmail!,
        code: _otpController.text.trim(),
        newPassword: newPass,
        confirmPassword: confirmPass,
      );
      if (!mounted) return;
      final savedEmail = _verifiedEmail!;
      Navigator.of(context).pop();
      widget.onPasswordResetSuccess?.call(savedEmail);
      AppSnackbar.showSuccess(
        context,
        context.loc.securityPasswordUpdatedSuccess,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    final screenHeight = mediaQuery.size.height;
    final safeTop = mediaQuery.padding.top;
    final safeBottom = mediaQuery.padding.bottom;

    // Keep max sheet height within screen bounds leaving comfortable status bar gap
    final maxSheetHeight = screenHeight - safeTop - 24;

    return PopScope(
      canPop: !isKeyboardOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && isKeyboardOpen) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxSheetHeight.clamp(300.0, screenHeight * 0.90),
        ),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              isKeyboardOpen
                  ? keyboardHeight + 16
                  : (safeBottom > 0 ? safeBottom + 8 : 20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  // Drag Handle Bar
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4, bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header with Icon, Title, Subtitle, and Close Button
                  _buildHeader(
                    isDark,
                    textColor,
                    textSubColor,
                    isRtl,
                    isKeyboardOpen,
                  ),
                  SizedBox(height: isKeyboardOpen ? 14 : 20),

                  // Step Content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        ...previousChildren,
                        ?currentChild,
                      ],
                    ),
                    child: switch (_step) {
                      0 => _buildEmailStep(
                          textColor,
                          textSubColor,
                          borderColor,
                          isDark,
                          isKeyboardOpen,
                        ),
                      1 => _buildCodeStep(
                          textColor,
                          textSubColor,
                          borderColor,
                          isDark,
                          isRtl,
                          isKeyboardOpen,
                        ),
                      _ => _buildNewPasswordStep(
                          textColor,
                          textSubColor,
                          borderColor,
                          isDark,
                          isRtl,
                          isKeyboardOpen,
                        ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildHeader(
    bool isDark,
    Color textColor,
    Color textSubColor,
    bool isRtl,
    bool isKeyboardOpen,
  ) {
    final title = switch (_step) {
      0 => context.loc.forgotPasswordTitle,
      1 => context.loc.forgotPasswordEnterCodeTitle,
      _ => context.loc.forgotPasswordSetNewPasswordTitle,
    };

    final subtitle = switch (_step) {
      0 => context.loc.forgotPasswordSubtitle,
      1 => '${context.loc.registerCodeSentTo} ${_verifiedEmail ?? ''}',
      _ => context.loc.forgotPasswordSetNewPasswordSubtitle,
    };

    final iconData = switch (_step) {
      0 => Icons.lock_reset_rounded,
      1 => Icons.mark_email_read_rounded,
      _ => Icons.verified_user_rounded,
    };

    return Row(
      children: [
        Container(
          width: isKeyboardOpen ? 38 : 44,
          height: isKeyboardOpen ? 38 : 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
          ),
          child: Icon(
            iconData,
            color: AppColors.primary,
            size: isKeyboardOpen ? 20 : 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isKeyboardOpen ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isKeyboardOpen ? 11 : 12,
                  color: textSubColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: textSubColor,
            size: 20,
          ),
          splashRadius: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ],
    );
  }

  // --- Step 0: Email Input ---
  Widget _buildEmailStep(
    Color textColor,
    Color textSubColor,
    Color borderColor,
    bool isDark,
    bool isKeyboardOpen,
  ) {
    return Column(
      key: const ValueKey('forgot_step_email'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.loc.loginEmailLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: isKeyboardOpen ? 6 : 8),
        TextField(
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          scrollPadding: const EdgeInsets.all(24),
          inputFormatters: [_denyArabicFormatter],
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: _inputDecoration(
            hint: context.loc.loginEmailHint,
            leadingIcon: Icons.mail_outline_rounded,
            borderColor: borderColor,
            isDark: isDark,
            isKeyboardOpen: isKeyboardOpen,
          ),
          onSubmitted: (_) => _handleSendResetCode(),
        ),
        SizedBox(height: isKeyboardOpen ? 16 : 20),
        AppButton(
          label: context.loc.registerSendCode,
          isLoading: _isLoading,
          height: isKeyboardOpen ? 48 : 52,
          borderRadius: 14,
          onPressed: _handleSendResetCode,
        ),
      ],
    );
  }

  // --- Step 1: Code Input ---
  Widget _buildCodeStep(
    Color textColor,
    Color textSubColor,
    Color borderColor,
    bool isDark,
    bool isRtl,
    bool isKeyboardOpen,
  ) {
    final otpText = _otpController.text;
    final emptyFill = isDark ? AppColors.darkSurfaceMuted : Colors.white;
    final activeFill = isDark
        ? AppColors.primary.withValues(alpha: 0.16)
        : AppColors.primaryLight;
    final focusedFill = isDark ? AppColors.darkSurface : Colors.white;

    return Column(
      key: const ValueKey('forgot_step_code'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.0,
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: _codeLength,
                  buildCounter: (
                    _, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) =>
                      null,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  enableSuggestions: false,
                  autocorrect: false,
                  showCursor: false,
                  scrollPadding: const EdgeInsets.all(24),
                  inputFormatters: [
                    _arabicDigitsFormatter,
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_codeLength),
                  ],
                  onChanged: (value) {
                    setState(() {});
                    if (value.length == _codeLength) {
                      _handleVerifyResetCode();
                    }
                  },
                  onSubmitted: (_) {
                    if (_otpController.text.trim().length == _codeLength) {
                      _handleVerifyResetCode();
                    }
                  },
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_otpFocus.hasFocus) _otpFocus.requestFocus();
              },
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (index) {
                    final hasChar = index < otpText.length;
                    final char = hasChar ? otpText[index] : '';
                    final isCurrent = _otpFocus.hasFocus &&
                        (index == otpText.length ||
                            (index == _codeLength - 1 &&
                                otpText.length == _codeLength));

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: isKeyboardOpen ? 43 : 46,
                      height: isKeyboardOpen ? 48 : 54,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? focusedFill
                            : (hasChar ? activeFill : emptyFill),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (hasChar
                                  ? AppColors.primary.withValues(alpha: 0.6)
                                  : borderColor),
                          width: isCurrent ? 2.0 : 1.2,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.22),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          char,
                          style: TextStyle(
                            fontSize: isKeyboardOpen ? 19 : 22,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TextButton(
              onPressed: _resendSeconds > 0 ? null : _handleSendResetCode,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.loc.registerResendCode,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _resendSeconds > 0
                      ? textSubColor.withValues(alpha: 0.6)
                      : AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            if (_resendSeconds > 0)
              Text(
                _formatCountdown(),
                style: TextStyle(
                  fontSize: 12,
                  color: textSubColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
        SizedBox(height: isKeyboardOpen ? 16 : 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppButton(
                label: context.loc.registerBack,
                outlined: true,
                height: isKeyboardOpen ? 48 : 52,
                borderRadius: 14,
                fontSize: 14,
                onPressed: () {
                  _resendTimer?.cancel();
                  setState(() => _step = 0);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                label: context.loc.registerVerifyCode,
                isLoading: _isLoading,
                height: isKeyboardOpen ? 48 : 52,
                borderRadius: 14,
                fontSize: 14,
                onPressed: _handleVerifyResetCode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Step 2: New Password Input ---
  Widget _buildNewPasswordStep(
    Color textColor,
    Color textSubColor,
    Color borderColor,
    bool isDark,
    bool isRtl,
    bool isKeyboardOpen,
  ) {
    return Column(
      key: const ValueKey('forgot_step_password'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.loc.forgotPasswordNewPasswordLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: isKeyboardOpen ? 5 : 7),
        TextField(
          controller: _newPasswordController,
          focusNode: _newPassFocus,
          obscureText: _obscureNewPass,
          textInputAction: TextInputAction.next,
          scrollPadding: const EdgeInsets.all(24),
          inputFormatters: [_denyArabicFormatter],
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: _inputDecoration(
            hint: context.loc.loginPasswordHint,
            leadingIcon: Icons.lock_outline_rounded,
            borderColor: borderColor,
            isDark: isDark,
            isKeyboardOpen: isKeyboardOpen,
            trailingIcon: IconButton(
              icon: Icon(
                _obscureNewPass
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: textSubColor,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureNewPass = !_obscureNewPass),
            ),
          ),
          onSubmitted: (_) => _confirmPassFocus.requestFocus(),
        ),
        SizedBox(height: isKeyboardOpen ? 10 : 14),
        Text(
          context.loc.registerConfirmLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: isKeyboardOpen ? 5 : 7),
        TextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPassFocus,
          obscureText: _obscureConfirmPass,
          textInputAction: TextInputAction.done,
          scrollPadding: const EdgeInsets.all(24),
          inputFormatters: [_denyArabicFormatter],
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: _inputDecoration(
            hint: context.loc.registerConfirmHint,
            leadingIcon: Icons.lock_outline_rounded,
            borderColor: borderColor,
            isDark: isDark,
            isKeyboardOpen: isKeyboardOpen,
            trailingIcon: IconButton(
              icon: Icon(
                _obscureConfirmPass
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: textSubColor,
                size: 20,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPass = !_obscureConfirmPass,
              ),
            ),
          ),
          onSubmitted: (_) => _handleResetPassword(),
        ),
        SizedBox(height: isKeyboardOpen ? 16 : 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppButton(
                label: context.loc.registerBack,
                outlined: true,
                height: isKeyboardOpen ? 48 : 52,
                borderRadius: 14,
                fontSize: 14,
                onPressed: () => setState(() => _step = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                label: context.loc.forgotPasswordSaveBtn,
                isLoading: _isLoading,
                height: isKeyboardOpen ? 48 : 52,
                borderRadius: 14,
                fontSize: 14,
                onPressed: _handleResetPassword,
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData leadingIcon,
    required Color borderColor,
    required bool isDark,
    required bool isKeyboardOpen,
    IconButton? trailingIcon,
  }) {
    final inputFill = isDark ? AppColors.darkSurfaceMuted : Colors.white;
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      filled: true,
      fillColor: inputFill,
      prefixIcon: Icon(leadingIcon, color: AppColors.textSecondary, size: 20),
      suffixIcon: trailingIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isKeyboardOpen ? 13 : 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

