import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/stripe_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/profile/data/models/payment_intent_models.dart';
import 'package:mobile/features/profile/data/repositories/payment_repository.dart';

// ================= CUSTOM CARD FORMATTERS =================
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) text = text.substring(0, 16);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && (i + 1) != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '').replaceAll(' ', '');
    if (text.length > 4) text = text.substring(0, 4);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write(' / ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  // Stepper State (1: Customer Info, 2: Payment Method, 3: Confirmation, 4: Success)
  int _currentStep = 1;
  int _previousStep = 1;

  // Repositories & Services
  final PaymentRepository _paymentRepo = PaymentRepository();
  final StripeService _stripeService = StripeService();

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  bool _saveInfoForNextTime = true;
  bool _isLoadingUserData = false;

  // Payment Form Controllers (Stripe Integration)
  final TextEditingController _cardNumberController =
      TextEditingController(text: '4242 4242 4242 4242');
  final TextEditingController _expiryController =
      TextEditingController(text: '12 / 28');
  final TextEditingController _cvcController =
      TextEditingController(text: '888');
  final TextEditingController _cardHolderController =
      TextEditingController();

  bool _isProcessing = false;
  String _orderNumber = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Rebuild live preview on card changes
    _cardNumberController.addListener(_onCardFieldChanged);
    _expiryController.addListener(_onCardFieldChanged);
    _cardHolderController.addListener(_onCardFieldChanged);
  }

  void _onCardFieldChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoadingUserData = true);
    final result = await _paymentRepo.getUserData();
    if (result is Success<PaymentUserDataModel> && mounted) {
      final user = result.data;
      if (_nameController.text.isEmpty && user.fullName.isNotEmpty) {
        _nameController.text = user.fullName;
      }
      if (_cardHolderController.text.isEmpty && user.fullName.isNotEmpty) {
        _cardHolderController.text = user.fullName.toUpperCase();
      }
      if (_phoneController.text.isEmpty && (user.phoneNumber ?? '').isNotEmpty) {
        _phoneController.text = user.phoneNumber!;
      }
      if (_postalCodeController.text.isEmpty && (user.postalCode ?? '').isNotEmpty) {
        _postalCodeController.text = user.postalCode!;
      }
    }
    if (mounted) {
      setState(() => _isLoadingUserData = false);
    }
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_onCardFieldChanged);
    _expiryController.removeListener(_onCardFieldChanged);
    _cardHolderController.removeListener(_onCardFieldChanged);

    _nameController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step > _currentStep && _currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _previousStep = _currentStep;
      _currentStep = step;
      _errorMessage = null;
    });
  }

  bool _validateCardDetails() {
    final cleanNumber = _cardNumberController.text.replaceAll(' ', '');
    if (cleanNumber.length < 15 || cleanNumber.length > 19) {
      AppSnackbar.showError(context, context.loc.checkoutCardNumberInvalid);
      return false;
    }
    final expiryParts = _expiryController.text.split('/');
    if (expiryParts.length != 2) {
      AppSnackbar.showError(context, context.loc.checkoutCardExpiryInvalidFormat);
      return false;
    }
    final month = int.tryParse(expiryParts.first.trim()) ?? 0;
    final year = int.tryParse(expiryParts.last.trim()) ?? 0;
    if (month < 1 || month > 12 || year < 24) {
      AppSnackbar.showError(context, context.loc.checkoutCardExpiredDate);
      return false;
    }
    final cleanCvc = _cvcController.text.trim();
    if (cleanCvc.length < 3) {
      AppSnackbar.showError(context, context.loc.checkoutCardCvcInvalid);
      return false;
    }
    if (_cardHolderController.text.trim().isEmpty) {
      AppSnackbar.showError(context, context.loc.checkoutCardHolderNameRequired);
      return false;
    }
    return true;
  }

  void _processPayment() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final cartProvider = context.read<CartProvider>();
    final isFree = cartProvider.finalPrice <= 0;
    final courseIds = cartProvider.items.map((i) => i.courseId).toList();

    if (courseIds.isEmpty) {
      setState(() => _isProcessing = false);
      AppSnackbar.showError(context, context.loc.checkoutCartEmptySnackbar);
      return;
    }

    // 1. Create Payment Intent on Backend API
    final request = PaymentRequestModel(
      amount: cartProvider.finalPrice,
      currency: 'usd',
      description: 'Payment for ${cartProvider.items.length} courses',
      courseIds: courseIds,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );

    final intentResult = await _paymentRepo.createPaymentIntent(request);
    if (intentResult is! Success<PaymentResponseModel>) {
      if (!mounted) return;
      final msg = (intentResult as Failure).message;
      setState(() {
        _isProcessing = false;
        _errorMessage = msg;
      });
      AppSnackbar.showError(context, msg.isNotEmpty ? msg : context.loc.checkoutPaymentStartFailed);
      return;
    }

    final paymentResponse = intentResult.data;
    final paymentIntentId = paymentResponse.paymentIntentId ?? '';
    final clientSecret = paymentResponse.clientSecret ?? '';

    // 2. If Paid Order (Amount > 0), confirm with Stripe REST API
    if (!isFree) {
      if (clientSecret.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isProcessing = false;
          _errorMessage = context.loc.checkoutClientSecretMissing;
        });
        AppSnackbar.showError(context, _errorMessage!);
        return;
      }

      // Parse Expiry MM / YY
      final expiryParts = _expiryController.text.split('/');
      final expMonth = int.tryParse(expiryParts.first.trim()) ?? 12;
      var expYear = int.tryParse(expiryParts.last.trim()) ?? 2028;
      if (expYear < 100) expYear += 2000;

      // Create PaymentMethod in Stripe
      final stripePmResult = await _stripeService.createPaymentMethod(
        cardNumber: _cardNumberController.text,
        expMonth: expMonth,
        expYear: expYear,
        cvc: _cvcController.text,
        name: _cardHolderController.text.isNotEmpty
            ? _cardHolderController.text.trim()
            : _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
      );

      if (!stripePmResult.success || stripePmResult.paymentMethodId == null) {
        if (!mounted) return;
        final msg = stripePmResult.errorMessage ?? context.loc.checkoutCardVerificationFailed;
        setState(() {
          _isProcessing = false;
          _errorMessage = msg;
        });
        AppSnackbar.showError(context, msg);
        return;
      }

      // Confirm PaymentIntent in Stripe
      final stripeConfirmResult = await _stripeService.confirmPaymentIntent(
        paymentIntentId: paymentIntentId,
        clientSecret: clientSecret,
        paymentMethodId: stripePmResult.paymentMethodId!,
      );

      if (!stripeConfirmResult.success) {
        if (!mounted) return;
        final msg = stripeConfirmResult.errorMessage ?? context.loc.checkoutStripeProcessingFailed;
        setState(() {
          _isProcessing = false;
          _errorMessage = msg;
        });
        AppSnackbar.showError(context, msg);
        return;
      }
    }

    // 3. Confirm on Backend API (creates enrollments, clears cart, writes DB records, sends emails/notifications)
    final confirmResult = await _paymentRepo.confirmPayment(paymentIntentId);
    if (confirmResult is! Success<PaymentResponseModel>) {
      if (!mounted) return;
      final msg = (confirmResult as Failure).message;
      setState(() {
        _isProcessing = false;
        _errorMessage = msg;
      });
      AppSnackbar.showError(context, msg.isNotEmpty ? msg : context.loc.checkoutServerConfirmationFailed);
      return;
    }

    // 4. Synchronize with other Providers
    if (!mounted) return;
    context.read<CartProvider>().fetchCart(forceRefresh: true);
    context.read<EnrollmentProvider>().fetchEnrollments(forceRefresh: true);
    context.read<NotificationProvider>().fetchNotifications(forceRefresh: true);

    HapticFeedback.heavyImpact();
    setState(() {
      _isProcessing = false;
      _currentStep = 4; // Step 4: Success View
      _orderNumber = paymentIntentId.startsWith('free_')
          ? 'FREE-${paymentIntentId.substring(5, 13).toUpperCase()}'
          : 'EDU-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isForward = _currentStep >= _previousStep;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isAr = context.isArabic;

    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;
    final isFree = cartProvider.finalPrice <= 0;

    // Empty Cart Check (only before completing purchase)
    final isCartEmpty = cartItems.isEmpty && _currentStep != 4 && !_isProcessing;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: _currentStep == 4
            ? null
            : IconButton(
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  if (_currentStep > 1) {
                    _goToStep(_currentStep - 1);
                  } else if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed('/main');
                  }
                },
              ),
        title: Text(
          _currentStep == 4 ? context.loc.checkoutSuccessTitle : context.loc.checkoutTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: _currentStep == 4
          ? _buildSuccessView(cardBg, borderColor, textColor, textSubColor)
          : isCartEmpty
              ? _buildEmptyCartView(cardBg, borderColor, textColor, textSubColor, isAr)
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
                  children: [
                    // 1. Stepper Header
                    _buildStepperHeader(cardBg, borderColor, isDark),

                    const SizedBox(height: 16),

                    // 2. Animated Step Switcher
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      transitionBuilder: (child, animation) {
                        final offsetBegin = isForward
                            ? const Offset(-0.15, 0.0)
                            : const Offset(0.15, 0.0);
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: offsetBegin,
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey('step_$_currentStep'),
                        child: _buildCurrentStepWidget(
                          cardBg,
                          inputFill,
                          borderColor,
                          textColor,
                          textSubColor,
                          isDark,
                          isFree,
                          isAr,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Order Summary & Guarantee Card
                    _buildOrderSummaryCard(
                      cartProvider,
                      cardBg,
                      borderColor,
                      textColor,
                      textSubColor,
                      isDark,
                      isFree,
                      isAr,
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyCartView(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isAr,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.loc.checkoutEmptyCartTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.loc.checkoutEmptyCartDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: textSubColor,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacementNamed('/catalog');
                }
              },
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: Text(
                context.loc.exploreTitle,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isFree,
    bool isAr,
  ) {
    switch (_currentStep) {
      case 1:
        return _buildCustomerInfoStep(cardBg, inputFill, borderColor, textColor, isFree, isAr);
      case 2:
        return _buildPaymentMethodStep(cardBg, inputFill, borderColor, textColor, isFree, isAr);
      case 3:
        return _buildOrderConfirmationStep(cardBg, inputFill, borderColor, textColor, textSubColor, isDark, isFree, isAr);
      default:
        return const SizedBox.shrink();
    }
  }

  // ================= 1. SMOOTH ANIMATED STEPPER HEADER =================
  Widget _buildStepperHeader(Color cardBg, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepNode(1, context.loc.checkoutBuyerInfo, Icons.person_rounded, isDark),
          _buildStepLine(_currentStep >= 2, isDark),
          _buildStepNode(2, context.loc.checkoutPaymentMethod, Icons.credit_card_rounded, isDark),
          _buildStepLine(_currentStep >= 3, isDark),
          _buildStepNode(3, context.loc.checkoutReviewConfirm, Icons.check_circle_rounded, isDark),
        ],
      ),
    );
  }

  Widget _buildStepNode(int stepNum, String title, IconData icon, bool isDark) {
    final isActive = _currentStep == stepNum;
    final isDone = _currentStep > stepNum;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? const Color(0xFF059669)
                : (isActive ? AppColors.primary : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9))),
            border: Border.all(
              color: isDone
                  ? const Color(0xFF059669)
                  : (isActive ? AppColors.primary : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0))),
              width: 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              isDone ? Icons.check_rounded : icon,
              size: 16,
              color: isDone || isActive ? Colors.white : (isDark ? Colors.white60 : const Color(0xFF64748B)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? AppColors.primary
                : (isDone ? const Color(0xFF059669) : (isDark ? Colors.white60 : const Color(0xFF64748B))),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isPassed, bool isDark) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 6, right: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          height: 2,
          decoration: BoxDecoration(
            color: isPassed
                ? const Color(0xFF059669)
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // ================= 2. STEP 1: CUSTOMER INFO =================
  Widget _buildCustomerInfoStep(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    bool isFree,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 6),
                Text(
                  context.loc.checkoutPersonalInfoTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                if (_isLoadingUserData) ...[
                  const Spacer(),
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            // Full Name Input
            _buildInputField(
              controller: _nameController,
              label: context.loc.checkoutFullNameLabel,
              hint: context.loc.checkoutFullNameHint,
              icon: Icons.person_rounded,
              inputFill: inputFill,
              borderColor: borderColor,
              textColor: textColor,
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? context.loc.checkoutFullNameRequired : null,
            ),
            const SizedBox(height: 12),

            // Phone Number Input
            _buildInputField(
              controller: _phoneController,
              label: context.loc.checkoutPhoneLabel,
              hint: '+966 50 123 4567',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              inputFill: inputFill,
              borderColor: borderColor,
              textColor: textColor,
              validator: (v) =>
                  (v == null || v.trim().length < 8) ? context.loc.checkoutPhoneRequired : null,
            ),
            const SizedBox(height: 12),

            // Postal Code Input
            _buildInputField(
              controller: _postalCodeController,
              label: context.loc.checkoutPostalLabel,
              hint: '11564',
              icon: Icons.location_on_rounded,
              keyboardType: TextInputType.number,
              inputFill: inputFill,
              borderColor: borderColor,
              textColor: textColor,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? context.loc.checkoutPostalRequired : null,
            ),
            const SizedBox(height: 14),

            // Save info checkbox
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _saveInfoForNextTime = !_saveInfoForNextTime);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _saveInfoForNextTime ? const Color(0xFFEFF4FF) : inputFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _saveInfoForNextTime ? const Color(0xFFDBEAFE) : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _saveInfoForNextTime ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: _saveInfoForNextTime ? AppColors.primary : AppColors.textMuted,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.loc.checkoutSaveInfo,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _saveInfoForNextTime ? const Color(0xFF1E40AF) : textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Continue Button (If Free -> jumps to confirmation directly like MVC)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  if (isFree) {
                    _goToStep(3);
                  } else {
                    _goToStep(2);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isFree
                          ? context.loc.checkoutContinueFreeReview
                          : context.loc.checkoutContinueToPayment,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 3. STEP 2: PAYMENT METHOD & LIVE CARD PREVIEW =================
  Widget _buildPaymentMethodStep(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    bool isFree,
    bool isAr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_card_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                context.loc.checkoutSelectPayment,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Free Order Note
          if (isFree) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard_rounded, color: Color(0xFF059669), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.checkoutFreeOrderBadge,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF065F46), fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.loc.checkoutFreeOrderNotice,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF047857), fontFamily: 'Tajawal', height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Stripe Payment Gateway Header & Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF635BFF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF635BFF).withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.lock_rounded, color: Color(0xFF635BFF), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.loc.checkoutSecureSSL,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4338CA),
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'stripe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Inter',
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Live Card Mockup
            _buildLiveCreditCardPreview(),

            const SizedBox(height: 14),

            // Stripe Card Input Fields
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: inputFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Number
                  _buildInputField(
                    controller: _cardNumberController,
                    label: context.loc.checkoutCardNumberLabel,
                    hint: '4242 4242 4242 4242',
                    icon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_CardNumberFormatter()],
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // Expiry Date
                      Expanded(
                        child: _buildInputField(
                          controller: _expiryController,
                          label: context.loc.checkoutExpiryLabel,
                          hint: 'MM / YY',
                          icon: Icons.date_range_rounded,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [_CardExpiryFormatter()],
                          inputFill: inputFill,
                          borderColor: borderColor,
                          textColor: textColor,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // CVC
                      Expanded(
                        child: _buildInputField(
                          controller: _cvcController,
                          label: context.loc.checkoutCVVLabel,
                          hint: '•••',
                          icon: Icons.lock_outline_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(4)],
                          inputFill: inputFill,
                          borderColor: borderColor,
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Cardholder Name
                  _buildInputField(
                    controller: _cardHolderController,
                    label: context.loc.checkoutCardHolderLabel,
                    hint: 'Full Name as shown on card',
                    icon: Icons.badge_outlined,
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToStep(1),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text(
                    context.loc.registerBack,
                    style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: textColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!isFree && !_validateCardDetails()) return;
                    _goToStep(3);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                  ),
                  child: Text(
                    context.loc.checkoutContinueToReview,
                    style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Live Credit Card Widget
  Widget _buildLiveCreditCardPreview() {
    final rawNumber = _cardNumberController.text.trim();
    final displayNumber = rawNumber.isEmpty ? '•••• •••• •••• 4242' : rawNumber;
    final cardHolder = _cardHolderController.text.trim().isEmpty
        ? (_nameController.text.trim().isNotEmpty ? _nameController.text.toUpperCase() : 'CARDHOLDER NAME')
        : _cardHolderController.text.toUpperCase();
    final expiry = _expiryController.text.trim().isEmpty ? 'MM/YY' : _expiryController.text;

    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row (Chip & Card Brand)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gold Chip
              Container(
                width: 36,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.contactless_rounded, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    displayNumber.startsWith('4') ? 'VISA' : 'Mastercard',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Card Number
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              displayNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                letterSpacing: 2.2,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),

          // Bottom Row (Holder & Expiry)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CARD HOLDER',
                      style: TextStyle(color: Colors.white54, fontSize: 8.5, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cardHolder,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white54, fontSize: 8.5, fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 4. STEP 3: ORDER CONFIRMATION =================
  Widget _buildOrderConfirmationStep(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isFree,
    bool isAr,
  ) {
    final cartProvider = context.watch<CartProvider>();
    final finalPrice = cartProvider.finalPrice;

    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final lastFour = cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : '4242';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                context.loc.checkoutReviewConfirm,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // User Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.checkoutBuyerInfo,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                    ),
                    GestureDetector(
                      onTap: () => _goToStep(1),
                      child: Text(
                        context.loc.profileEditProfile,
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${context.loc.registerFullNameLabel}: ${_nameController.text}', style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal')),
                Text('${context.loc.checkoutPhoneLabel}: ${_phoneController.text}', style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal')),
                Text('${context.loc.checkoutPostalLabel}: ${_postalCodeController.text}', style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal')),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Payment Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.checkoutPaymentMethod,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFree
                            ? context.loc.checkoutFreeCheckoutTitle
                            : '${context.loc.checkoutCreditCard} (•••• $lastFour)',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isFree ? const Color(0xFF059669) : textSubColor,
                          fontWeight: isFree ? FontWeight.bold : FontWeight.normal,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isFree)
                  GestureDetector(
                    onTap: () => _goToStep(2),
                    child: Text(
                      context.loc.profileEditProfile,
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                  ),
              ],
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 11.5, fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Pay Button with Loading state
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFree ? const Color(0xFF059669) : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isFree ? Icons.card_giftcard_rounded : Icons.lock_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          isFree
                              ? context.loc.checkoutConfirmFreeEnrollment
                              : '${context.loc.checkoutPayNow} (\$${finalPrice.toStringAsFixed(2)})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 5. SUCCESS VIEW =================
  Widget _buildSuccessView(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF059669),
                  size: 52,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              context.loc.checkoutSuccessTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              context.loc.checkoutSuccessSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: textSubColor,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                'Ref: #$_orderNumber',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Start Learning Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/learning'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                child: Text(
                  context.loc.checkoutStartLearning,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Explore more courses button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  context.loc.checkoutBackHome,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 6. LIVE ORDER SUMMARY CARD =================
  Widget _buildOrderSummaryCard(
    CartProvider cartProvider,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isFree,
    bool isAr,
  ) {
    final cartItems = cartProvider.items;
    final subtotal = cartProvider.subtotal;
    final discount = cartProvider.discountAmount;
    final finalPrice = cartProvider.finalPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.cartOrderSummary,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                context.loc.checkoutCoursesCount(cartItems.length.toString()),
                style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Real Course items from CartProvider
          for (final item in cartItems) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: item.thumbnailUrl!,
                            width: 48,
                            height: 38,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 48,
                              height: 38,
                              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                              child: const Icon(Icons.school_rounded, size: 18, color: AppColors.textMuted),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 48,
                              height: 38,
                              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                              child: const Icon(Icons.school_rounded, size: 18, color: AppColors.textMuted),
                            ),
                          )
                        : Container(
                            width: 48,
                            height: 38,
                            color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                            child: const Icon(Icons.school_rounded, size: 18, color: AppColors.textMuted),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.courseTitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Tajawal',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.instructorName.isNotEmpty)
                          Text(
                            item.instructorName,
                            style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Tajawal'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.totalPrice <= 0
                        ? context.loc.checkoutFreePrice
                        : '${item.totalPrice.toStringAsFixed(2)} \$',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: item.totalPrice <= 0 ? const Color(0xFF059669) : textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],

          Divider(height: 1, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Price Calculation Rows
          _buildPriceRow(context.loc.cartSubtotal, '${subtotal.toStringAsFixed(2)} \$', textColor: textColor, textSubColor: textSubColor),
          if (discount > 0)
            _buildPriceRow(context.loc.cartCouponDiscount, '-${discount.toStringAsFixed(2)} \$', isDiscount: true, textColor: textColor, textSubColor: textSubColor),

          const SizedBox(height: 6),
          Divider(height: 1, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          _buildPriceRow(
            context.loc.cartFinalTotal,
            isFree ? context.loc.checkoutFreeZero : '${finalPrice.toStringAsFixed(2)} \$',
            isTotal: true,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isTotal = false, required Color textColor, required Color textSubColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 13.5 : 11.5,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? textColor : textSubColor,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 12,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              color: isTotal
                  ? (value.contains('Free') || value.contains(context.loc.checkoutFreePrice) ? const Color(0xFF059669) : AppColors.primary)
                  : (isDiscount ? const Color(0xFF059669) : textColor),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color inputFill,
    required Color borderColor,
    required Color textColor,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
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
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            style: TextStyle(fontSize: 12.5, fontFamily: 'Tajawal', color: textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
              prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
