import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginTab = true;
  bool obscurePassword = true;
  bool _isPressing = false;
  bool _isRegistering = false;
  bool _isLoggingIn = false;
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
    _codeControllers = List.generate(
      _codeLength,
      (_) => TextEditingController(),
    );
    _codeFocusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
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
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFB),
      body: Stack(
        children: [
          // لمسات دائرية ناعمة في الخلفية
          PositionedDirectional(
            top: -90,
            end: -90,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -110,
            start: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          PositionedDirectional(
            top: 300,
            start: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // الهيدر: أيقونة قبعة التخرج في دائرة متدرجة
                        Container(
                          width: 88,
                          height: 88,
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.graduationCap,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          context.loc.loginAppName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.loc.loginTagline,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // شريط التبديل المنزلق بين الدخول وحساب جديد
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: LayoutBuilder(
                            builder: (context, barConstraints) {
                              final pillWidth =
                                  (barConstraints.maxWidth - 8) / 2;
                              return SizedBox(
                                height: 56,
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      alignment: isLoginTab
                                          ? AlignmentDirectional.centerStart
                                          : AlignmentDirectional.centerEnd,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOutCubic,
                                      child: Container(
                                        width: pillWidth,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.06,
                                              ),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => _switchTab(0),
                                            child: Center(
                                              child: Text(
                                                context.loc.loginTabLogin,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isLoginTab
                                                      ? AppColors.primary
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => _switchTab(1),
                                            child: Center(
                                              child: Text(
                                                context.loc.loginTabRegister,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: !isLoginTab
                                                      ? AppColors.primary
                                                      : AppColors.textSecondary,
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

                        // الفورمات مع انتقال انزلاقي ناعم
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeInOutCubic,
                          transitionBuilder: (child, animation) {
                            final isIncomingLogin =
                                child.key == const Key('login_form');
                            final offset = isIncomingLogin ? -1.0 : 1.0;
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(offset, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: isLoginTab
                              ? _buildLoginForm()
                              : _buildRegisterForm(),
                        ),
                        const SizedBox(height: 12),

                        // فاصل أو الدخول بواسطة
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.border),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Text(
                                'أو الدخول بواسطة',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.9,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.border),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // أزرار السوشيال ميديا Google و Facebook
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/main',
                                ),
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Color(0xFF1877F2),
                                ),
                                label: Text(
                                  'Facebook',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/main',
                                ),
                                icon: const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 28,
                                  color: Color(0xFFEA4335),
                                ),
                                label: Text(
                                  'Google',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData leadingIcon,
    IconButton? trailingIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(leadingIcon, color: AppColors.textSecondary),
      suffixIcon: trailingIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: _fieldBorder(AppColors.border),
      enabledBorder: _fieldBorder(AppColors.border),
      focusedBorder: _fieldBorder(AppColors.primary),
      errorBorder: _fieldBorder(const Color(0xFFEF4444)),
      focusedErrorBorder: _fieldBorder(const Color(0xFFEF4444)),
    );
  }

  Widget _buildPasswordField({FormFieldValidator<String>? validator}) {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      validator: validator,
      decoration: _fieldDecoration(
        hint: context.loc.loginPasswordHint,
        leadingIcon: Icons.lock_outline_rounded,
        trailingIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
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
    return Listener(
      onPointerDown: (_) => setState(() => _isPressing = true),
      onPointerUp: (_) => setState(() => _isPressing = false),
      onPointerCancel: (_) => setState(() => _isPressing = false),
      child: AnimatedScale(
        scale: _isPressing ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: loading ? 0.75 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.loginEmailLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateLoginEmail,
            decoration: _fieldDecoration(
              hint: context.loc.loginEmailHint,
              leadingIcon: Icons.mail_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.loc.loginPasswordLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(validator: _validateLoginPassword),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                context.loc.loginForgotPassword,
                style: TextStyle(
                  fontSize: 13,
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
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                context.loc.loginGuest,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const Key('register_form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
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
                            ? AppColors.primary.withValues(alpha: 0.6)
                            : AppColors.border,
                      ),
                    ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done || active
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.12),
                    ),
                    child: done
                        ? const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          )
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
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
                            ? AppColors.primary.withValues(alpha: 0.6)
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.loginEmailLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _fieldDecoration(
            hint: context.loc.loginEmailHint,
            leadingIcon: Icons.mail_outline_rounded,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.loc.registerSendCodeInfo,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
                height: 54,
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
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
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
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
        TextButton.icon(
          onPressed: _goBackStep,
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
          label: Text(context.loc.registerBack),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            foregroundColor: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 16),

          // 1) الاسم الكامل
          Text(
            context.loc.registerFullNameLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            validator: _validateFullName,
            decoration: _fieldDecoration(
              hint: context.loc.registerFullNameHint,
              leadingIcon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),

          // 2) كلمة المرور
          Text(
            context.loc.loginPasswordLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            validator: _validatePassword,
            decoration: _fieldDecoration(
              hint: context.loc.registerPasswordHint,
              leadingIcon: Icons.lock_outline_rounded,
              trailingIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3) تأكيد كلمة المرور
          Text(
            'تأكيد كلمة المرور',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: obscurePassword,
            validator: _validateConfirmPassword,
            decoration: _fieldDecoration(
              hint: context.loc.registerConfirmHint,
              leadingIcon: Icons.lock_outline_rounded,
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: _goBackStep,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
            label: Text(context.loc.registerBack),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
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
