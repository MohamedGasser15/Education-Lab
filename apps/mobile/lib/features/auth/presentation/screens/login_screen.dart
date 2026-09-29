import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/app_session_service.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/services/google_auth_service.dart';
        import 'package:mobile/core/services/facebook_auth_service.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/auth/presentation/widgets/forgot_password_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;

  bool isLoginTab = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isRegistering = false;
  bool _isLoggingIn = false;
  bool _isSigningInWithGoogle = false;
  bool _isSigningInWithFacebook = false;
  bool _isSendingCode = false;
  bool _isVerifying = false;
  int _registerStep = 0;
  int _resendSeconds = 90;
  String? _verifiedEmail;
  Timer? _resendTimer;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static final TextInputFormatter
  _denyArabicFormatter = FilteringTextInputFormatter.deny(
    RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ),
  );

  static const int _codeLength = 6;
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  static final TextInputFormatter _arabicNumberConverterFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var text = newValue.text;
    for (int i = 0; i < 10; i++) {
      text = text.replaceAll(arabicDigits[i], i.toString());
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  });

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);

    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOutCubic,
    );

    _otpFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _resendTimer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    final wantsLogin = index == 0;
    if (wantsLogin == isLoginTab) return;
    _otpFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    setState(() {
      isLoginTab = wantsLogin;
      if (!wantsLogin && _registerStep == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !isLoginTab && _registerStep == 1) {
            _otpFocusNode.requestFocus();
          }
        });
      }
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.loc.registerNameRequired;
    }
    if (value.trim().length < 6) {
      return context.loc.registerNameMinLength;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.loginPasswordRequired;
    }
    if (value.length < 8) return context.loc.registerPasswordMinLength;
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return context.loc.registerPasswordUppercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return context.loc.registerPasswordNumber;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.registerConfirmRequired;
    }
    if (value != passwordController.text) {
      return context.loc.registerConfirmMismatch;
    }
    return null;
  }

  String? _validateLoginEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.loc.loginEmailRequired;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return context.loc.loginEmailInvalid;
    }
    return null;
  }

  String? _validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.loginPasswordRequired;
    }
    return null;
  }

  Future<void> _submitLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    final email = emailController.text.trim();
    final password = passwordController.text;
    setState(() => _isLoggingIn = true);
    try {
      await locator<AuthRepository>().login(email: email, password: password);
      await AppSessionService.setGuestMode(false);
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/main');
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isSigningInWithGoogle || _isLoggingIn) return;
    setState(() => _isSigningInWithGoogle = true);

    try {
      final idToken = await GoogleAuthService.signInWithGoogle();
      if (idToken == null) {
        // User cancelled
        if (mounted) setState(() => _isSigningInWithGoogle = false);
        return;
      }

      AppLogger.d('got idToken, calling backend...', tag: 'GOOGLE_LOGIN_FLOW');
      await locator<AuthRepository>().externalLogin(idToken);
      await AppSessionService.setGuestMode(false);
      if (!mounted) return;

      AppSnackbar.show(context, context.loc.loginSuccessSnackbar);
      Navigator.pushReplacementNamed(context, '/main');
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isSigningInWithGoogle = false);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    if (_isSigningInWithFacebook || _isSigningInWithGoogle || _isLoggingIn) return;
    setState(() => _isSigningInWithFacebook = true);

    try {
      final accessToken = await FacebookAuthService.signInWithFacebook(context: context);
      if (accessToken == null) {
        // User cancelled or failed
        if (mounted) setState(() => _isSigningInWithFacebook = false);
        return;
      }

      AppLogger.d('got accessToken, calling backend...', tag: 'FACEBOOK_LOGIN_FLOW');
      await locator<AuthRepository>().externalFacebookLogin(accessToken);
      await AppSessionService.setGuestMode(false);
      if (!mounted) return;

      AppSnackbar.show(context, context.loc.loginSuccessSnackbar);
      Navigator.pushReplacementNamed(context, '/main');
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isSigningInWithFacebook = false);
    }
  }

  Future<void> _submitRegister() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isRegistering = true);
    try {
      await locator<AuthRepository>().register(
        fullName: nameController.text.trim(),
        email: _verifiedEmail!,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.registerSuccess);
      try {
        await locator<AuthRepository>().login(
          email: _verifiedEmail!,
          password: passwordController.text,
        );
        await AppSessionService.setGuestMode(false);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/main');
        return;
      } catch (_) {
        if (!mounted) return;
        _switchTab(0);
        emailController.text = _verifiedEmail ?? '';
        passwordController.clear();
        _resetRegisterState();
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  void _resetRegisterState() {
    _registerStep = 0;
    _verifiedEmail = null;
    _otpController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _resendTimer?.cancel();
  }

  Future<void> _sendCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = emailController.text.trim();
    if (email.isEmpty) {
      AppSnackbar.show(context, context.loc.loginEmailRequired, error: true);
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      AppSnackbar.show(context, context.loc.loginEmailInvalid, error: true);
      return;
    }
    setState(() => _isSendingCode = true);
    try {
      await locator<AuthRepository>().sendCode(email: email);
      if (!mounted) return;
      _verifiedEmail = email;
      _resetCodeBoxes();
      setState(() => _registerStep = 1);
      _startCountdown();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _registerStep == 1) {
          _otpFocusNode.requestFocus();
        }
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  Future<void> _verifyCode() async {
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
    setState(() => _isVerifying = true);
    try {
      await locator<AuthRepository>().verifyEmail(
        email: _verifiedEmail!,
        code: code,
      );
      if (!mounted) return;
      _resendTimer?.cancel();
      _otpFocusNode.unfocus();
      setState(() => _registerStep = 2);
    } on AuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(context, context.loc.networkError, error: true);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 90);
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

  void _goBackStep() {
    _otpFocusNode.unfocus();
    if (_registerStep == 1) {
      _resendTimer?.cancel();
      _resetCodeBoxes();
      setState(() => _registerStep = 0);
    } else if (_registerStep == 2) {
      setState(() => _registerStep = 0);
    } else if (_registerStep > 0) {
      setState(() => _registerStep--);
    }
  }

  void _resetCodeBoxes() {
    _otpController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFFFEFB);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final tabBg = isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardOpen = mediaQuery.viewInsets.bottom > 80;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Smooth animated background
            _buildAnimatedBackground(isDark),

            SafeArea(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: isKeyboardOpen
                    ? Alignment.topCenter
                    : Alignment.center,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.screenPadding(context),
                    vertical: isKeyboardOpen ? 10.0 : 20.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppResponsive.value(
                        context,
                        phone: 440.0,
                        tablet: 520.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: isKeyboardOpen ? 4 : 8),

                        // Header: Graduation cap icon inside gradient circle (compacts smoothly when typing)
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            width: isKeyboardOpen ? 46 : 80,
                            height: isKeyboardOpen ? 46 : 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              boxShadow: isKeyboardOpen
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.graduationCap,
                                size: isKeyboardOpen ? 22 : 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isKeyboardOpen ? 8 : 16),
                        Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              fontFamily: isRtl ? 'Tajawal' : null,
                              fontSize: isKeyboardOpen ? 22 : 28,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                            child: Text(context.loc.loginAppName),
                          ),
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: isKeyboardOpen
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: const SizedBox(width: double.infinity),
                          secondChild: Column(
                            children: [
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  context.loc.loginTagline,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textSubColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isKeyboardOpen ? 12 : 24),

                      // Sliding toggle bar between Login and Register
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: tabBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, barConstraints) {
                            final pillWidth = (barConstraints.maxWidth - 8) / 2;
                            return SizedBox(
                              height: 48,
                              child: Stack(
                                children: [
                                  AnimatedAlign(
                                    alignment: isLoginTab
                                        ? AlignmentDirectional.centerStart
                                        : AlignmentDirectional.centerEnd,
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOutCubic,
                                    child: Container(
                                      width: pillWidth,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: cardBg,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.06,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () => _switchTab(0),
                                          child: Center(
                                            child: Text(
                                              context.loc.loginTabLogin,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: isLoginTab
                                                    ? AppColors.primary
                                                    : textSubColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () => _switchTab(1),
                                          child: Center(
                                            child: Text(
                                              context.loc.loginTabRegister,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: !isLoginTab
                                                    ? AppColors.primary
                                                    : textSubColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login or Register Form
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isLoginTab
                            ? _buildLoginForm()
                            : _buildRegisterForm(),
                      ),
                      const SizedBox(height: 20),

                      // Divider: OR
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                            ),
                            child: Text(
                              context.loc.loginOrSocial,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.8,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Social media buttons: Google & Facebook
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Color(0xFF1877F2),
                                size: 20,
                              ),
                              label: 'Facebook',
                              loading: _isSigningInWithFacebook,
                              onPressed: _handleFacebookSignIn,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildSocialButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Color(0xFFEA4335),
                                size: 20,
                              ),
                              label: 'Google',
                              loading: _isSigningInWithGoogle,
                              onPressed: _handleGoogleSignIn,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Guest login button at bottom
                      Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            await AppSessionService.clearSession(context);
                            await AppSessionService.setGuestMode(true);
                            if (!context.mounted) return;
                            Navigator.pushReplacementNamed(context, '/main');
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            foregroundColor: AppColors.textSecondary,
                          ),
                          icon: const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          label: Text(
                            context.loc.loginGuest,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (context, child) {
        final val = _bgAnimation.value;
        return Stack(
          children: [
            // Top circle moves and scales smoothly
            PositionedDirectional(
              top: -90 + (val * 35),
              end: -90 + (val * 25),
              child: Transform.scale(
                scale: 1.0 + (val * 0.08),
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Bottom circle moves in the opposite direction
            PositionedDirectional(
              bottom: -110 - (val * 30),
              start: -80 + (val * 30),
              child: Transform.scale(
                scale: 1.0 + ((1.0 - val) * 0.10),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: isDark ? 0.08 : 0.05,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Side circle floating vertically and horizontally
            PositionedDirectional(
              top: 280 + (val * 50),
              start: -40 + (val * 25),
              child: Transform.scale(
                scale: 0.95 + (val * 0.18),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(
                      alpha: isDark ? 0.12 : 0.08,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: cardBg,
          foregroundColor: textColor,
          elevation: 0,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData leadingIcon,
    IconButton? trailingIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      prefixIcon: Icon(leadingIcon, color: AppColors.textSecondary, size: 20),
      suffixIcon: trailingIcon,
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: _fieldBorder(borderColor),
      enabledBorder: _fieldBorder(borderColor),
      focusedBorder: _fieldBorder(AppColors.primary, width: 1.5),
      errorBorder: _fieldBorder(AppColors.error),
      focusedErrorBorder: _fieldBorder(AppColors.error, width: 1.5),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggle,
    FormFieldValidator<String>? validator,
    String? hint,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      inputFormatters: [_denyArabicFormatter],
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: _fieldDecoration(
        hint: hint ?? context.loc.loginPasswordHint,
        leadingIcon: Icons.lock_outline_rounded,
        trailingIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String label,
    required VoidCallback onPressed,
    bool loading = false,
    String? loadingLabel,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: loading,
      loadingLabel: loadingLabel,
      height: 52,
      borderRadius: 14,
      fontSize: 15,
    );
  }

  Widget _buildLoginForm() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Form(
      key: _loginFormKey,
      child: Column(
        key: const Key('login_form'),
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 7),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateLoginEmail,
            inputFormatters: [_denyArabicFormatter],
            style: TextStyle(fontSize: 14, color: textColor),
            decoration: _fieldDecoration(
              hint: context.loc.loginEmailHint,
              leadingIcon: Icons.mail_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.loc.loginPasswordLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 7),
          _buildPasswordField(
            controller: passwordController,
            isObscured: obscurePassword,
            onToggle: () => setState(() => obscurePassword = !obscurePassword),
            validator: _validateLoginPassword,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ForgotPasswordSheet.show(
                  context,
                  initialEmail: emailController.text.trim(),
                  onPasswordResetSuccess: (email) {
                    emailController.text = email;
                    passwordController.clear();
                  },
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.loc.loginForgotPassword,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSubmitButton(
            label: context.loc.loginSubmit,
            onPressed: _submitLogin,
            loading: _isLoggingIn,
            loadingLabel: context.loc.loginSubmitLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const Key('register_form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: switch (_registerStep) {
            0 => _buildEmailStep(),
            1 => _buildCodeStep(),
            _ => _buildDataStep(),
          },
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final labels = [
      context.loc.registerStepEmail,
      context.loc.registerStepCode,
      context.loc.registerStepData,
    ];

    const double circleSize = 32.0;
    const double lineHeight = 3.5;
    const double lineTop = (circleSize - lineHeight) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Keep a neat side margin so the progress spans widely across the card
        final stepMargin = (totalWidth * 0.10).clamp(28.0, 42.0);
        final itemWidth = stepMargin * 2;

        final c0 = stepMargin;
        final c1 = totalWidth / 2;
        final c2 = totalWidth - stepMargin;

        final segmentWidth = c1 - c0;

        return SizedBox(
          height: circleSize + 8 + 20,
          child: Stack(
            children: [
              // Connecting line between step 0 and step 1
              PositionedDirectional(
                start: c0,
                width: segmentWidth,
                top: lineTop,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: _registerStep >= 1 ? AppColors.primary : borderColor,
                    borderRadius: BorderRadius.circular(lineHeight / 2),
                  ),
                ),
              ),
              // Connecting line between step 1 and step 2
              PositionedDirectional(
                start: c1,
                width: segmentWidth,
                top: lineTop,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: _registerStep >= 2 ? AppColors.primary : borderColor,
                    borderRadius: BorderRadius.circular(lineHeight / 2),
                  ),
                ),
              ),
              // 3 step items positioned exactly at c0, c1, c2
              ...List.generate(3, (index) {
                final done = index < _registerStep;
                final active = index == _registerStep;
                final center = index == 0
                    ? c0
                    : index == 1
                        ? c1
                        : c2;

                return PositionedDirectional(
                  start: center - (itemWidth / 2),
                  width: itemWidth,
                  top: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (index < _registerStep) {
                            _otpFocusNode.unfocus();
                            setState(() => _registerStep = index);
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: done || active
                                ? AppColors.primary
                                : cardBg,
                            border: Border.all(
                              color: done || active
                                  ? AppColors.primary
                                  : borderColor,
                              width: 2,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: done
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : Transform.translate(
                                    offset: const Offset(0, 2),
                                    child: Text(
                                      '${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                        color: active
                                            ? Colors.white
                                            : textSubColor,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w500,
                            color: active
                                ? AppColors.primary
                                : (done ? textColor : textSubColor),
                            fontFamily: isRtl ? 'Tajawal' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Column(
      key: const ValueKey('step_email'),
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 7),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [_denyArabicFormatter],
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: _fieldDecoration(
            hint: context.loc.loginEmailHint,
            leadingIcon: Icons.mail_outline_rounded,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.loc.registerSendCodeInfo,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(
          label: context.loc.registerSendCode,
          onPressed: _sendCode,
          loading: _isSendingCode,
          loadingLabel: context.loc.registerVerifying,
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final emptyFill = isDark ? AppColors.darkSurfaceMuted : Colors.white;
    final activeFill = isDark
        ? AppColors.primary.withValues(alpha: 0.16)
        : AppColors.primaryLight;
    final focusedFill = isDark
        ? AppColors.darkSurface
        : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final otpText = _otpController.text;

    return Column(
      key: const ValueKey('step_code'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.loc.registerCodeSentTo} ',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _verifiedEmail ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: _goBackStep,
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: Text(
                context.loc.generalEdit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                visualDensity: VisualDensity.compact,
                backgroundColor: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Single background input with 6 visual boxes
        Stack(
          alignment: Alignment.center,
          children: [
            // Invisible single TextField in background capturing all keyboard inputs smoothly
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.0,
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: _codeLength,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  enableSuggestions: false,
                  autocorrect: false,
                  showCursor: false,
                  inputFormatters: [
                    _arabicNumberConverterFormatter,
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_codeLength),
                  ],
                  onChanged: (value) {
                    setState(() {});
                    if (value.length == _codeLength) {
                      _verifyCode();
                    }
                  },
                ),
              ),
            ),

            // Visually rendered 6 boxes
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_otpFocusNode.hasFocus) {
                  _otpFocusNode.requestFocus();
                }
              },
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (index) {
                    final hasChar = index < otpText.length;
                    final char = hasChar ? otpText[index] : '';
                    final isCurrent = _otpFocusNode.hasFocus &&
                        (index == otpText.length ||
                            (index == _codeLength - 1 &&
                                otpText.length == _codeLength));

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: 46,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? focusedFill
                            : (hasChar ? activeFill : emptyFill),
                        borderRadius: BorderRadius.circular(14),
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
                            fontSize: 22,
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
              onPressed: _resendSeconds > 0 ? null : _sendCode,
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
                      ? AppColors.textSecondary.withValues(alpha: 0.6)
                      : AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            if (_resendSeconds > 0)
              Text(
                _formatCountdown(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppButton(
                label: context.loc.registerBack,
                outlined: true,
                height: 52,
                borderRadius: 14,
                fontSize: 14,
                onPressed: _goBackStep,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                label: context.loc.registerVerifyCode,
                onPressed: _verifyCode,
                isLoading: _isVerifying,
                loadingLabel: context.loc.registerVerifying,
                height: 52,
                borderRadius: 14,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('step_data'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verified email badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 18,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _verifiedEmail ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 1) Full Name
          Text(
            context.loc.registerFullNameLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: nameController,
            validator: _validateFullName,
            style: TextStyle(fontSize: 14, color: textColor),
            decoration: _fieldDecoration(
              hint: context.loc.registerFullNameHint,
              leadingIcon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),

          // 2) Password
          Text(
            context.loc.loginPasswordLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 7),
          _buildPasswordField(
            controller: passwordController,
            isObscured: obscurePassword,
            onToggle: () => setState(() => obscurePassword = !obscurePassword),
            validator: _validatePassword,
            hint: context.loc.registerPasswordHint,
          ),
          const SizedBox(height: 14),

          // 3) Confirm Password
          Text(
            context.loc.registerConfirmLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 7),
          _buildPasswordField(
            controller: confirmPasswordController,
            isObscured: obscureConfirmPassword,
            onToggle: () => setState(
              () => obscureConfirmPassword = !obscureConfirmPassword,
            ),
            validator: _validateConfirmPassword,
            hint: context.loc.registerConfirmHint,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AppButton(
                  label: context.loc.registerBack,
                  outlined: true,
                  height: 52,
                  borderRadius: 14,
                  fontSize: 14,
                  onPressed: _goBackStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppButton(
                  label: context.loc.registerSubmit,
                  onPressed: _submitRegister,
                  isLoading: _isRegistering,
                  loadingLabel: context.loc.registerSubmitLoading,
                  height: 52,
                  borderRadius: 14,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
