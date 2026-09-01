import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/services/google_auth_service.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

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

  static const int _codeLength = 6;
  late final List<TextEditingController> _codeControllers;
  late final List<FocusNode> _codeFocusNodes;

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

    _codeControllers = List.generate(
      _codeLength,
      (_) => TextEditingController(),
    );
    _codeFocusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _resendTimer?.cancel();
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _codeFocusNodes) {
      node.dispose();
    }
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    final wantsLogin = index == 0;
    if (wantsLogin == isLoginTab) return;
    setState(() => isLoginTab = wantsLogin);
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
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    final email = emailController.text.trim();
    final password = passwordController.text;
    setState(() => _isLoggingIn = true);
    try {
      await locator<AuthRepository>().login(email: email, password: password);
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

      debugPrint('GOOGLE_LOGIN_FLOW: got idToken, calling backend...');
      await locator<AuthRepository>().externalLogin(idToken);
      if (!mounted) return;

      AppSnackbar.show(context, 'تم تسجيل الدخول بنجاح');
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

  Future<void> _submitRegister() async {
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
      Navigator.pushReplacementNamed(context, '/login');
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

  Future<void> _sendCode() async {
    final email = emailController.text.trim();
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
    final code = _codeControllers.map((c) => c.text).join();
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
    if (_registerStep > 0) {
      setState(() => _registerStep--);
    }
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _codeFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
    }
  }

  void _resetCodeBoxes() {
    for (final controller in _codeControllers) {
      controller.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFFFFEFB);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final tabBg = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // الخلفية المتحركة بانسيابية ونعومة
          _buildAnimatedBackground(isDark),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      // الهيدر: أيقونة قبعة التخرج في دائرة متدرجة
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
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
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.graduationCap,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          context.loc.loginAppName,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
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
                      const SizedBox(height: 24),

                      // شريط التبديل المنزلق بين الدخول وحساب جديد
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
                                          borderRadius: BorderRadius.circular(12),
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
                                          borderRadius: BorderRadius.circular(12),
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

                      // نموذج الدخول أو إنشاء الحساب
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

                      // فاصل: أو
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border, height: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              'أو الدخول بواسطة',
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

                      // أزرار السوشيال ميديا Google و Facebook
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
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/main',
                              ),
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

                      // زر الدخول كزائر في الأسفل بشكل أنيق
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/main',
                          ),
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
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (context, child) {
        final val = _bgAnimation.value;
        return Stack(
          children: [
            // الدائرة العلوية (AppColors.primaryLight) تتحرك وتتنفس بنعومة
            PositionedDirectional(
              top: -90 + (val * 35),
              end: -90 + (val * 25),
              child: Transform.scale(
                scale: 1.0 + (val * 0.08),
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // الدائرة السفلية تتحرك في الاتجاه المعاكس
            PositionedDirectional(
              bottom: -110 - (val * 30),
              start: -80 + (val * 30),
              child: Transform.scale(
                scale: 1.0 + ((1.0 - val) * 0.10),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // الدائرة الجانبية تطفو رأسياً وأفقياً
            PositionedDirectional(
              top: 280 + (val * 50),
              start: -40 + (val * 25),
              child: Transform.scale(
                scale: 0.95 + (val * 0.18),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: isDark ? 0.12 : 0.08),
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
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

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
      hintStyle: const TextStyle(
        fontSize: 14,
        color: AppColors.textMuted,
      ),
      prefixIcon: Icon(leadingIcon, color: AppColors.textSecondary, size: 20),
      suffixIcon: trailingIcon,
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: _fieldBorder(borderColor),
      enabledBorder: _fieldBorder(borderColor),
      focusedBorder: _fieldBorder(AppColors.primary, width: 1.5),
      errorBorder: _fieldBorder(const Color(0xFFEF4444)),
      focusedErrorBorder: _fieldBorder(const Color(0xFFEF4444), width: 1.5),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggle,
    FormFieldValidator<String>? validator,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
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
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLoadingSpinner(size: 20, color: Colors.white),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '${loadingLabel ?? label}...',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const Key('login_form'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.loc.loginEmailLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateLoginEmail,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: _fieldDecoration(
              hint: context.loc.loginEmailHint,
              leadingIcon: Icons.mail_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.loc.loginPasswordLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
              onPressed: () {},
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
            return FadeTransition(
              opacity: animation,
              child: child,
            );
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
    final labels = [
      context.loc.registerStepEmail,
      context.loc.registerStepCode,
      context.loc.registerStepData,
    ];
    return Row(
      children: List.generate(3, (index) {
        final done = index < _registerStep;
        final active = index == _registerStep;
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index <= _registerStep
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done || active
                          ? AppColors.primary
                          : const Color(0xFFF1F5F9),
                      border: Border.all(
                        color: done || active
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: done
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                  ),
                  if (index < 2)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < _registerStep
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                labels[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('step_email'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.loc.loginEmailLabel,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
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
    return Column(
      key: const ValueKey('step_code'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${context.loc.registerCodeSentTo} ',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.start,
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
        const SizedBox(height: 16),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_codeLength, (index) {
              final isEmpty = _codeControllers[index].text.isEmpty;
              return SizedBox(
                width: 44,
                height: 52,
                child: TextField(
                  controller: _codeControllers[index],
                  focusNode: _codeFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  maxLength: 1,
                  autofocus: index == 0 && _registerStep == 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {});
                    _onCodeChanged(index, value);
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: isEmpty ? Colors.white : AppColors.primaryLight,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
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
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: _goBackStep,
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_rounded,
              size: 14,
            ),
            label: Text(context.loc.registerBack),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildSubmitButton(
          label: context.loc.registerVerifyCode,
          onPressed: _verifyCode,
          loading: _isVerifying,
          loadingLabel: context.loc.registerVerifying,
        ),
      ],
    );
  }

  Widget _buildDataStep() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('step_data'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // البريد الموثق
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

          // 1) الاسم الكامل
          Text(
            context.loc.registerFullNameLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: nameController,
            validator: _validateFullName,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: _fieldDecoration(
              hint: context.loc.registerFullNameHint,
              leadingIcon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),

          // 2) كلمة المرور
          Text(
            context.loc.loginPasswordLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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

          // 3) تأكيد كلمة المرور
          const Text(
            'تأكيد كلمة المرور',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: _goBackStep,
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.arrow_back_ios_rounded,
                size: 14,
              ),
              label: Text(context.loc.registerBack),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildSubmitButton(
            label: context.loc.registerSubmit,
            onPressed: _submitRegister,
            loading: _isRegistering,
            loadingLabel: context.loc.registerSubmitLoading,
          ),
        ],
      ),
    );
  }
}

