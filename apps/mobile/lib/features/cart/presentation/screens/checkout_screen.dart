import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/sound_service.dart';
import 'package:mobile/core/services/stripe_service.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/cart/presentation/widgets/checkout_card_formatters.dart';
import 'package:mobile/features/cart/presentation/widgets/checkout_card_theme.dart';
import 'package:mobile/features/cart/presentation/widgets/checkout_confetti_painter.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/profile/data/models/payment_intent_models.dart';
import 'package:mobile/features/profile/data/repositories/payment_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  // Stepper State (1: Customer Info, 2: Payment Method, 3: Confirmation, 4: Success)
  int _currentStep = 1;
  int _previousStep = 1;

  // Repositories & Services
  final PaymentRepository _paymentRepo = PaymentRepository();
  final StripeService _stripeService = StripeService();

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _cardFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  bool _saveInfoForNextTime = true;
  bool _isLoadingUserData = false;

  // Payment Form Controllers (Stripe Integration)
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  bool _isProcessing = false;
  String _orderNumber = '';
  String? _errorMessage;

  // 3D Card Flip Animation & Focus Nodes
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  // Success Celebration & Confetti
  late final AnimationController _successAnimController;
  late final Animation<double> _badgeScaleAnimation;
  late final Animation<double> _contentSlideAnimation;
  late final Animation<double> _confettiAnimation;
  late final List<ConfettiParticle> _confettiParticles;

  double _paidAmount = 0.0;
  int _purchasedItemsCount = 0;
  String _paidCardBrand = 'VISA';
  String _paidLastFour = '4242';
  DateTime _purchaseTime = DateTime.now();
  bool _copiedRef = false;

  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expiryFocusNode = FocusNode();
  final FocusNode _cvcFocusNode = FocusNode();
  final FocusNode _cardHolderFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.4, end: 2.2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );

    _confettiParticles = _generateConfettiParticles();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _contentSlideAnimation = Tween<double>(begin: 35.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _successAnimController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutQuad),
      ),
    );

    _cardNumberFocusNode.addListener(_onFocusChanged);
    _expiryFocusNode.addListener(_onFocusChanged);
    _cardHolderFocusNode.addListener(_onFocusChanged);
    _cvcFocusNode.addListener(() {
      if (_cvcFocusNode.hasFocus) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
      _onFocusChanged();
    });

    // Rebuild live preview on card changes
    _cardNumberController.addListener(_onCardFieldChanged);
    _expiryController.addListener(_onCardFieldChanged);
    _cardHolderController.addListener(_onCardFieldChanged);
    _cvcController.addListener(_onCardFieldChanged);
  }

  List<ConfettiParticle> _generateConfettiParticles() {
    final rand = math.Random(42);
    final colors = [
      AppColors.emerald,
      AppColors.accent,
      AppColors.gold,
      AppColors.rose,
      AppColors.purple,
      AppColors.sky,
      AppColors.error,
    ];

    return List.generate(55, (i) {
      return ConfettiParticle(
        x: rand.nextDouble(),
        y: -0.2 - rand.nextDouble() * 0.3,
        speed: 0.6 + rand.nextDouble() * 0.8,
        angle: rand.nextDouble() * math.pi * 2,
        rotationSpeed: 2.0 + rand.nextDouble() * 5.0,
        color: colors[rand.nextInt(colors.length)],
        size: 7.0 + rand.nextDouble() * 7.0,
        isCircle: rand.nextBool(),
      );
    });
  }

  void _playSuccessCelebration() async {
    _successAnimController.forward(from: 0.0);
    SoundService().playSuccess();
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 160));
    HapticFeedback.mediumImpact();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  void _onCardFieldChanged() {
    if (mounted) {
      final brand = _getCardBrand(_cardNumberController.text);
      final maxLen = brand == 'AMEX' ? 4 : 3;
      if (_cvcController.text.length > maxLen) {
        _cvcController.text = _cvcController.text.substring(0, maxLen);
        _cvcController.selection = TextSelection.collapsed(
          offset: _cvcController.text.length,
        );
      }
      setState(() {});
    }
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoadingUserData = true);
    final result = await _paymentRepo.getUserData();
    if (result is Success<PaymentUserDataModel> && mounted) {
      final user = result.data;
      if (_nameController.text.isEmpty && user.fullName.isNotEmpty) {
        _nameController.text = user.fullName;
      }
      if (_phoneController.text.isEmpty &&
          (user.phoneNumber ?? '').isNotEmpty) {
        _phoneController.text = user.phoneNumber!;
      }
      if (_postalCodeController.text.isEmpty &&
          (user.postalCode ?? '').isNotEmpty) {
        _postalCodeController.text = user.postalCode!;
      }
    }
    if (mounted) {
      setState(() => _isLoadingUserData = false);
    }
  }

  @override
  void dispose() {
    _cardNumberFocusNode.removeListener(_onFocusChanged);
    _expiryFocusNode.removeListener(_onFocusChanged);
    _cardHolderFocusNode.removeListener(_onFocusChanged);
    _cardNumberFocusNode.dispose();
    _expiryFocusNode.dispose();
    _cardHolderFocusNode.dispose();
    _cvcFocusNode.dispose();
    _flipController.dispose();
    _shimmerController.dispose();
    _successAnimController.dispose();

    _cardNumberController.removeListener(_onCardFieldChanged);
    _expiryController.removeListener(_onCardFieldChanged);
    _cardHolderController.removeListener(_onCardFieldChanged);
    _cvcController.removeListener(_onCardFieldChanged);

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
      if (!(_formKey.currentState?.validate() ?? true)) {
        HapticFeedback.mediumImpact();
        return;
      }
    }
    if (step > _currentStep && _currentStep == 2) {
      final isFree = context.read<CartProvider>().finalPrice <= 0;
      if (!isFree && !_validateCardDetails()) return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _previousStep = _currentStep;
      _currentStep = step;
      _errorMessage = null;
    });
  }

  bool _validateCardDetails() {
    final isValid = _cardFormKey.currentState?.validate() ?? false;
    if (!isValid) {
      HapticFeedback.mediumImpact();
      return false;
    }
    return true;
  }

  void _processPayment() async {
    HapticFeedback.mediumImpact();
    final loc = context.loc;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final cartProvider = context.read<CartProvider>();
    final isFree = cartProvider.finalPrice <= 0;
    final courseIds = cartProvider.items.map((i) => i.courseId).toList();

    if (courseIds.isEmpty) {
      setState(() => _isProcessing = false);
      AppSnackbar.showError(context, loc.checkoutCartEmptySnackbar);
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

    void handlePaymentFailure(String msg) {
      SoundService().playFailed();
      HapticFeedback.heavyImpact();
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = msg;
      });
      AppSnackbar.showError(context, msg);
    }

    final intentResult = await _paymentRepo.createPaymentIntent(request);
    if (intentResult is! Success<PaymentResponseModel>) {
      final msg = (intentResult as Failure).message;
      handlePaymentFailure(
        msg.isNotEmpty ? msg : loc.checkoutPaymentStartFailed,
      );
      return;
    }

    final paymentResponse = intentResult.data;
    final paymentIntentId = paymentResponse.paymentIntentId ?? '';
    final clientSecret = paymentResponse.clientSecret ?? '';

    // 2. If Paid Order (Amount > 0), confirm with Stripe REST API
    if (!isFree) {
      if (clientSecret.isEmpty) {
        handlePaymentFailure(loc.checkoutClientSecretMissing);
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
        final msg =
            stripePmResult.errorMessage ?? loc.checkoutCardVerificationFailed;
        handlePaymentFailure(msg);
        return;
      }

      // Confirm PaymentIntent in Stripe
      final stripeConfirmResult = await _stripeService.confirmPaymentIntent(
        paymentIntentId: paymentIntentId,
        clientSecret: clientSecret,
        paymentMethodId: stripePmResult.paymentMethodId!,
      );

      if (!stripeConfirmResult.success) {
        final msg =
            stripeConfirmResult.errorMessage ??
            loc.checkoutStripeProcessingFailed;
        handlePaymentFailure(msg);
        return;
      }
    }

    // 3. Confirm on Backend API (creates enrollments, clears cart, writes DB records, sends emails/notifications)
    final confirmResult = await _paymentRepo.confirmPayment(paymentIntentId);
    if (confirmResult is! Success<PaymentResponseModel>) {
      final msg = (confirmResult as Failure).message;
      handlePaymentFailure(
        msg.isNotEmpty ? msg : loc.checkoutServerConfirmationFailed,
      );
      return;
    }

    final paidAmount = cartProvider.finalPrice;
    final purchasedItemsCount = cartProvider.items.length;
    final cleanNum = _cardNumberController.text.replaceAll(' ', '');
    final paidCardBrand = isFree ? 'Free' : _getCardBrand(cleanNum);
    final paidLastFour = cleanNum.length >= 4
        ? cleanNum.substring(cleanNum.length - 4)
        : '4242';
    final purchaseTime = DateTime.now();

    // 4. Synchronize with other Providers
    if (!mounted) return;
    context.read<CartProvider>().fetchCart(forceRefresh: true);
    context.read<EnrollmentProvider>().fetchEnrollments(forceRefresh: true);
    context.read<NotificationProvider>().fetchNotifications(forceRefresh: true);

    setState(() {
      _isProcessing = false;
      _currentStep = 4; // Step 4: Success View
      _paidAmount = paidAmount;
      _purchasedItemsCount = purchasedItemsCount;
      _paidCardBrand = paidCardBrand;
      _paidLastFour = paidLastFour;
      _purchaseTime = purchaseTime;
      _copiedRef = false;
      _orderNumber = paymentIntentId.startsWith('free_')
          ? 'FREE-${paymentIntentId.substring(5, 13).toUpperCase()}'
          : 'EDU-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';
    });

    _playSuccessCelebration();
  }

  @override
  Widget build(BuildContext context) {
    final isForward = _currentStep >= _previousStep;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.background;
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isAr = context.isArabic;

    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;
    final isFree = cartProvider.finalPrice <= 0;

    // Empty Cart Check (only before completing purchase)
    final isCartEmpty =
        cartItems.isEmpty && _currentStep != 4 && !_isProcessing;

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
          _currentStep == 4
              ? context.loc.checkoutSuccessTitle
              : context.loc.checkoutTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: _currentStep == 4
          ? _buildSuccessView(
              cardBg,
              borderColor,
              textColor,
              textSubColor,
              isDark,
            )
          : isCartEmpty
          ? _buildEmptyCartView(
              cardBg,
              borderColor,
              textColor,
              textSubColor,
              isAr,
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppResponsive.screenPadding(context),
                14,
                AppResponsive.screenPadding(context),
                40,
              ),
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
                      child: FadeTransition(opacity: animation, child: child),
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
            AppButton(
              width: 200,
              height: 48,
              borderRadius: 12,
              icon: const Icon(
                Icons.explore_outlined,
                size: 18,
                color: Colors.white,
              ),
              label: context.loc.exploreTitle,
              fontSize: 13.5,
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacementNamed('/catalog');
                }
              },
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
        return _buildCustomerInfoStep(
          cardBg,
          inputFill,
          borderColor,
          textColor,
          isFree,
          isAr,
        );
      case 2:
        return _buildPaymentMethodStep(
          cardBg,
          inputFill,
          borderColor,
          textColor,
          isFree,
          isAr,
        );
      case 3:
        return _buildOrderConfirmationStep(
          cardBg,
          inputFill,
          borderColor,
          textColor,
          textSubColor,
          isDark,
          isFree,
          isAr,
        );
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
          _buildStepNode(
            1,
            context.loc.checkoutBuyerInfo,
            Icons.person_rounded,
            isDark,
          ),
          _buildStepLine(_currentStep >= 2, isDark),
          _buildStepNode(
            2,
            context.loc.checkoutPaymentMethod,
            Icons.credit_card_rounded,
            isDark,
          ),
          _buildStepLine(_currentStep >= 3, isDark),
          _buildStepNode(
            3,
            context.loc.checkoutReviewConfirm,
            Icons.check_circle_rounded,
            isDark,
          ),
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
                ? AppColors.emerald
                : (isActive
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.darkSurfaceMuted
                            : AppColors.surfaceMuted)),
            border: Border.all(
              color: isDone
                  ? AppColors.emerald
                  : (isActive
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.border)),
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
              color: isDone || isActive
                  ? Colors.white
                  : (isDark ? Colors.white60 : AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive || isDone
                ? FontWeight.bold
                : FontWeight.normal,
            color: isActive
                ? AppColors.primary
                : (isDone
                      ? AppColors.emerald
                      : (isDark ? Colors.white60 : AppColors.textSecondary)),
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
                ? AppColors.emerald
                : (isDark ? AppColors.darkBorder : AppColors.border),
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
                const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
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
              validator: (v) => (v == null || v.trim().length < 3)
                  ? context.loc.checkoutFullNameRequired
                  : null,
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
              validator: (v) => (v == null || v.trim().length < 8)
                  ? context.loc.checkoutPhoneRequired
                  : null,
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
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? context.loc.checkoutPostalRequired
                  : null,
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
                  color: _saveInfoForNextTime
                      ? AppColors.primaryLight
                      : inputFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _saveInfoForNextTime
                        ? AppColors.roleInstructorBorder
                        : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _saveInfoForNextTime
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: _saveInfoForNextTime
                          ? AppColors.primary
                          : AppColors.textMuted,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.loc.checkoutSaveInfo,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _saveInfoForNextTime
                              ? AppColors.primaryDark
                              : textColor,
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
            AppButton(
              height: 50,
              borderRadius: 12,
              label: isFree
                  ? context.loc.checkoutContinueFreeReview
                  : context.loc.checkoutContinueToPayment,
              fontSize: 13.5,
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_back_rounded
                    : Icons.arrow_forward_rounded,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (isFree) {
                  _goToStep(3);
                } else {
                  _goToStep(2);
                }
              },
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
              const Icon(
                Icons.credit_card_rounded,
                color: AppColors.primary,
                size: 20,
              ),
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
                color: AppColors.emeraldLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.emerald.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.emerald,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.checkoutFreeOrderBadge,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.successDark,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.loc.checkoutFreeOrderNotice,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.emerald,
                            fontFamily: 'Tajawal',
                            height: 1.3,
                          ),
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
                border: Border.all(
                  color: const Color(0xFF635BFF).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          color: Color(0xFF635BFF),
                          size: 18,
                        ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
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
            Form(
              key: _cardFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Number
                  _buildInputField(
                    controller: _cardNumberController,
                    focusNode: _cardNumberFocusNode,
                    label: context.loc.checkoutCardNumberLabel,
                    hint: '4242 4242 4242 4242',
                    icon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CardNumberFormatter()],
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    liveValidator: (v) {
                      final clean = (v ?? '').replaceAll(' ', '');
                      if (clean.isEmpty) return null;
                      final isAmex =
                          clean.startsWith('34') || clean.startsWith('37');
                      final expectedLen = isAmex ? 15 : 16;
                      if (clean.length >= expectedLen) {
                        if (!isValidLuhn(clean)) {
                          return context.loc.checkoutCardNumberInvalid;
                        }
                      }
                      return null;
                    },
                    validator: (v) {
                      final clean = (v ?? '').replaceAll(' ', '');
                      if (clean.isEmpty) {
                        return context.loc.checkoutCardNumberInvalid;
                      }
                      final isAmex =
                          clean.startsWith('34') || clean.startsWith('37');
                      final expectedLen = isAmex ? 15 : 16;
                      if (clean.length < expectedLen || !isValidLuhn(clean)) {
                        return context.loc.checkoutCardNumberInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expiry Date
                      Expanded(
                        child: _buildInputField(
                          controller: _expiryController,
                          focusNode: _expiryFocusNode,
                          label: context.loc.checkoutExpiryLabel,
                          hint: 'MM / YY',
                          icon: Icons.date_range_rounded,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [CardExpiryFormatter()],
                          inputFill: inputFill,
                          borderColor: borderColor,
                          textColor: textColor,
                          liveValidator: (v) {
                            final text = (v ?? '').trim();
                            if (text.isEmpty) return null;
                            final clean = text.replaceAll(' ', '');
                            if (clean.length >= 2) {
                              final monthPart = clean
                                  .substring(0, 2)
                                  .replaceAll('/', '');
                              final month = int.tryParse(monthPart);
                              if (month != null && (month < 1 || month > 12)) {
                                return context.loc.checkoutCardExpiredDate;
                              }
                            }
                            final parts = text.split('/');
                            if (parts.length == 2 &&
                                parts[1].trim().length == 2) {
                              final month = int.tryParse(parts[0].trim()) ?? 0;
                              final year = int.tryParse(parts[1].trim()) ?? 0;
                              final now = DateTime.now();
                              final currentYear = now.year % 100;
                              final currentMonth = now.month;

                              if (month < 1 || month > 12) {
                                return context.loc.checkoutCardExpiredDate;
                              }
                              if (year < currentYear ||
                                  (year == currentYear &&
                                      month < currentMonth) ||
                                  year > currentYear + 25) {
                                return context.loc.checkoutCardExpiredDate;
                              }
                            }
                            return null;
                          },
                          validator: (v) {
                            final text = (v ?? '').trim();
                            if (text.isEmpty) {
                              return context
                                  .loc
                                  .checkoutCardExpiryInvalidFormat;
                            }
                            final clean = text.replaceAll(' ', '');
                            if (clean.length >= 2) {
                              final monthPart = clean
                                  .substring(0, 2)
                                  .replaceAll('/', '');
                              final month = int.tryParse(monthPart);
                              if (month != null && (month < 1 || month > 12)) {
                                return context.loc.checkoutCardExpiredDate;
                              }
                            }
                            final parts = text.split('/');
                            if (parts.length != 2 ||
                                parts[0].trim().length != 2 ||
                                parts[1].trim().length != 2) {
                              return context
                                  .loc
                                  .checkoutCardExpiryInvalidFormat;
                            }
                            final month = int.tryParse(parts[0].trim()) ?? 0;
                            final year = int.tryParse(parts[1].trim()) ?? 0;
                            final now = DateTime.now();
                            final currentYear = now.year % 100;
                            final currentMonth = now.month;

                            if (month < 1 || month > 12) {
                              return context.loc.checkoutCardExpiredDate;
                            }
                            if (year < currentYear ||
                                (year == currentYear && month < currentMonth) ||
                                year > currentYear + 25) {
                              return context.loc.checkoutCardExpiredDate;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      // CVC
                      Builder(
                        builder: (context) {
                          final currentBrand = _getCardBrand(
                            _cardNumberController.text,
                          );
                          final isAmex = currentBrand == 'AMEX';
                          final expectedCvcLength = isAmex ? 4 : 3;

                          return Expanded(
                            child: _buildInputField(
                              controller: _cvcController,
                              focusNode: _cvcFocusNode,
                              label: context.loc.checkoutCVVLabel,
                              hint: isAmex ? '••••' : '•••',
                              icon: Icons.lock_outline_rounded,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                  expectedCvcLength,
                                ),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              inputFill: inputFill,
                              borderColor: borderColor,
                              textColor: textColor,
                              validator: (v) {
                                final clean = (v ?? '').trim();
                                if (clean.length != expectedCvcLength) {
                                  return context.loc.checkoutCardCvcInvalid;
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Cardholder Name
                  _buildInputField(
                    controller: _cardHolderController,
                    focusNode: _cardHolderFocusNode,
                    label: context.loc.checkoutCardHolderLabel,
                    hint: context.loc.checkoutCardHolderHint,
                    icon: Icons.badge_outlined,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(26),
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s\.\-']"),
                      ),
                    ],
                    inputFill: inputFill,
                    borderColor: borderColor,
                    textColor: textColor,
                    validator: (v) {
                      if ((v ?? '').trim().isEmpty) {
                        return context.loc.checkoutCardHolderNameRequired;
                      }
                      return null;
                    },
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
                child: AppButton(
                  height: 48,
                  borderRadius: 10,
                  outlined: true,
                  label: context.loc.registerBack,
                  fontSize: 13,
                  onPressed: () => _goToStep(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  height: 48,
                  borderRadius: 10,
                  label: context.loc.checkoutContinueToReview,
                  fontSize: 13,
                  onPressed: () {
                    if (!isFree && !_validateCardDetails()) return;
                    _goToStep(3);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 3D INTERACTIVE CREDIT CARD PREVIEW =================
  String _getCardBrand(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.startsWith('4')) return 'VISA';
    if (clean.startsWith(RegExp(r'^(5[1-5]|2[2-7])'))) return 'Mastercard';
    if (clean.startsWith(RegExp(r'^(34|37)'))) return 'AMEX';
    if (clean.startsWith(RegExp(r'^(6011|65|64[4-9])'))) return 'Discover';
    return 'VISA';
  }

  CardThemeConfig _getCardTheme(String brand) {
    switch (brand) {
      case 'Mastercard':
        return const CardThemeConfig(
          gradientColors: [
            Color(0xFF18181B),
            Color(0xFF27272A),
            Color(0xFF7F1D1D),
            Color(0xFFB91C1C),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
          shadowColor: Color(0xFFDC2626),
          accentOrb1: Color(0xFFF97316),
          accentOrb2: Color(0xFFEF4444),
          backStripeColor1: Color(0xFF09090B),
          backStripeColor2: Color(0xFF1C1917),
        );
      case 'AMEX':
        return const CardThemeConfig(
          gradientColors: [
            Color(0xFF064E3B),
            Color(0xFF065F46),
            Color(0xFF0F766E),
            Color(0xFF0D9488),
          ],
          stops: [0.0, 0.3, 0.65, 1.0],
          shadowColor: Color(0xFF0D9488),
          accentOrb1: Color(0xFF34D399),
          accentOrb2: Color(0xFF2DD4BF),
          backStripeColor1: Color(0xFF022C22),
          backStripeColor2: Color(0xFF064E3B),
        );
      case 'Discover':
        return const CardThemeConfig(
          gradientColors: [
            Color(0xFF1E1B4B),
            Color(0xFF312E81),
            Color(0xFF4338CA),
            Color(0xFFC2410C),
          ],
          stops: [0.0, 0.3, 0.65, 1.0],
          shadowColor: Color(0xFFEA580C),
          accentOrb1: Color(0xFFFB923C),
          accentOrb2: Color(0xFFF97316),
          backStripeColor1: Color(0xFF0F0E17),
          backStripeColor2: Color(0xFF1E1B4B),
        );
      case 'VISA':
      default:
        return const CardThemeConfig(
          gradientColors: [
            Color(0xFF0F172A),
            Color(0xFF1E3A8A),
            Color(0xFF1D4ED8),
            Color(0xFF2563EB),
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
          shadowColor: Color(0xFF1E3A8A),
          accentOrb1: Colors.white,
          accentOrb2: Color(0xFF38BDF8),
          backStripeColor1: Color(0xFF090D16),
          backStripeColor2: Color(0xFF181F2C),
        );
    }
  }

  Widget _buildBrandLogo(String brand, {bool small = false}) {
    if (brand == 'Mastercard') {
      return SizedBox(
        width: small ? 28 : 38,
        height: small ? 18 : 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: small ? 18 : 24,
                height: small ? 18 : 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFEB001B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: small ? 18 : 24,
                height: small ? 18 : 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (brand == 'AMEX') {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 5 : 8,
          vertical: small ? 2.5 : 4,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF007BC1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Text(
          'AMEX',
          style: TextStyle(
            color: Colors.white,
            fontSize: small ? 9 : 11,
            fontWeight: FontWeight.w900,
            fontFamily: 'Inter',
            letterSpacing: 1.1,
          ),
        ),
      );
    } else if (brand == 'Discover') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DISC',
            style: TextStyle(
              color: Colors.white,
              fontSize: small ? 10 : 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter',
              letterSpacing: 0.5,
            ),
          ),
          Container(
            width: small ? 8 : 10,
            height: small ? 8 : 10,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6000),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            'VER',
            style: TextStyle(
              color: Colors.white,
              fontSize: small ? 10 : 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter',
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }
    return Text(
      'VISA',
      style: TextStyle(
        color: Colors.white,
        fontSize: small ? 13 : 18,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        fontFamily: 'Inter',
        letterSpacing: 1.5,
        shadows: const [
          Shadow(color: Colors.black38, offset: Offset(0, 1.5), blurRadius: 2),
        ],
      ),
    );
  }

  Widget _buildEmvChip() {
    return Container(
      width: 44,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFDF7A),
            Color(0xFFD4AF37),
            Color(0xFFA67C00),
            Color(0xFFE5C158),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF8A6800).withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF7A5900), width: 0.7),
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: 0,
            bottom: 0,
            child: Container(width: 0.7, color: const Color(0xFF7A5900)),
          ),
          Positioned(
            right: 14,
            top: 0,
            bottom: 0,
            child: Container(width: 0.7, color: const Color(0xFF7A5900)),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Container(height: 0.7, color: const Color(0xFF7A5900)),
          ),
        ],
      ),
    );
  }

  // Metallic Light-Sweep Shimmer Overlay
  Widget _buildShimmerOverlay() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return IgnorePointer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 0
                  ? constraints.maxWidth
                  : 350.0;
              final shimmerOffset = _shimmerAnimation.value * width;

              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Positioned(
                      top: -60,
                      bottom: -60,
                      left: shimmerOffset,
                      child: Transform.rotate(
                        angle: 0.45,
                        child: Container(
                          width: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.03),
                                Colors.white.withValues(alpha: 0.20),
                                Colors.white.withValues(alpha: 0.03),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardFront({
    required String displayNumber,
    required String cardHolder,
    required String expiry,
    required String brand,
    bool isCardNumberFocused = false,
    bool isCardHolderFocused = false,
    bool isExpiryFocused = false,
  }) {
    final theme = _getCardTheme(brand);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
          stops: theme.stops,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.4),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.accentOrb1.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.accentOrb2.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white.withValues(alpha: 0.14),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Metallic Shimmer Light-Sweep
            Positioned.fill(child: _buildShimmerOverlay()),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildEmvChip(),
                          const SizedBox(width: 10),
                          Transform.rotate(
                            angle: math.pi / 2,
                            child: const Icon(
                              Icons.wifi_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      _buildBrandLogo(brand),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        displayNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2.6,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 1.5),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CARD HOLDER',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                cardHolder,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'VALID THRU',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              expiry,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack({
    required String cvc,
    required String brand,
    bool isCvcFocused = false,
  }) {
    final isAmex = brand == 'AMEX';
    final placeholder = isAmex ? '••••' : '•••';
    final displayCvc = cvc.isEmpty ? placeholder : cvc;
    final theme = _getCardTheme(brand);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.gradientColors[0],
            theme.gradientColors[1],
            theme.gradientColors[0],
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.backStripeColor1,
                        theme.backStripeColor2,
                        theme.backStripeColor1,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(4),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'Authorized Signature',
                                style: TextStyle(
                                  fontFamily: 'Caveat',
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blueGrey.shade700,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(4),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                displayCvc,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Inter',
                                  letterSpacing: 2,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'SECURITY CODE (CVV)',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF94A3B8),
                              Color(0xFFE2E8F0),
                              Color(0xFF64748B),
                              Color(0xFFCBD5E1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Issued by EduLab Global Payments. For customer support call +1-800-EDULAB.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 6.5,
                            height: 1.2,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildBrandLogo(brand, small: true),
                    ],
                  ),
                ),
              ],
            ),
            // Metallic Shimmer Light-Sweep
            Positioned.fill(child: _buildShimmerOverlay()),
          ],
        ),
      ),
    );
  }

  // Live 3D Flippable Credit Card Widget
  Widget _buildLiveCreditCardPreview() {
    final rawNumber = _cardNumberController.text.trim();
    final displayNumber = rawNumber.isEmpty ? '•••• •••• •••• ••••' : rawNumber;
    final cardHolder = _cardHolderController.text.trim().isEmpty
        ? 'CARDHOLDER NAME'
        : _cardHolderController.text.toUpperCase();
    final expiry = _expiryController.text.trim().isEmpty
        ? 'MM / YY'
        : _expiryController.text;
    final cvc = _cvcController.text.trim();
    final brand = _getCardBrand(displayNumber);

    final isCardNumberFocused = _cardNumberFocusNode.hasFocus;
    final isCardHolderFocused = _cardHolderFocusNode.hasFocus;
    final isExpiryFocused = _expiryFocusNode.hasFocus;
    final isCvcFocused = _cvcFocusNode.hasFocus;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (_flipController.isCompleted) {
          _flipController.reverse();
        } else {
          _flipController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          final isFront = _flipAnimation.value < 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? _buildCardFront(
                    displayNumber: displayNumber,
                    cardHolder: cardHolder,
                    expiry: expiry,
                    brand: brand,
                    isCardNumberFocused: isCardNumberFocused,
                    isCardHolderFocused: isCardHolderFocused,
                    isExpiryFocused: isExpiryFocused,
                  )
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _buildCardBack(
                      cvc: cvc,
                      brand: brand,
                      isCvcFocused: isCvcFocused,
                    ),
                  ),
          );
        },
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
    final lastFour = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : '4242';

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
              const Icon(
                Icons.assignment_turned_in_rounded,
                color: AppColors.primary,
                size: 20,
              ),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: textColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _goToStep(1),
                      child: Text(
                        context.loc.generalEdit,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${context.loc.registerFullNameLabel}: ${_nameController.text}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  '${context.loc.checkoutPhoneLabel}: ${_phoneController.text}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  '${context.loc.checkoutPostalLabel}: ${_postalCodeController.text}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFree
                            ? context.loc.checkoutFreeCheckoutTitle
                            : '${context.loc.checkoutCreditCard} (•••• $lastFour)',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isFree
                              ? const Color(0xFF059669)
                              : textSubColor,
                          fontWeight: isFree
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                      context.loc.generalEdit,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
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
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontSize: 11.5,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Pay Button with Loading state
          AppButton(
            height: 52,
            borderRadius: 14,
            backgroundColor: isFree ? const Color(0xFF059669) : null,
            isLoading: _isProcessing,
            icon: Icon(
              isFree ? Icons.card_giftcard_rounded : Icons.lock_rounded,
              size: 18,
              color: Colors.white,
            ),
            label: isFree
                ? context.loc.checkoutConfirmFreeEnrollment
                : '${context.loc.checkoutPayNow} (\$${finalPrice.toStringAsFixed(2)})',
            fontSize: 14,
            onPressed: _processPayment,
          ),
        ],
      ),
    );
  }

  // ================= 5. SUCCESS VIEW =================
  Widget _buildSuccessView(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Stack(
      children: [
        // Confetti Celebration Particles Layer
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _confettiAnimation,
              builder: (context, _) {
                return CustomPaint(
                  painter: CheckoutConfettiPainter(
                    particles: _confettiParticles,
                    progress: _confettiAnimation.value,
                  ),
                );
              },
            ),
          ),
        ),

        // Main Success Content
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Animated Spring Checkmark Badge
                _buildCelebrationBadge(isDark),
                const SizedBox(height: 24),

                // Animated Body Content (Title, Subtitle, Receipt Card, Action Buttons)
                AnimatedBuilder(
                  animation: _contentSlideAnimation,
                  builder: (context, child) {
                    final offset = _contentSlideAnimation.value;
                    final opacity = (1.0 - (offset / 35.0)).clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: Opacity(opacity: opacity, child: child),
                    );
                  },
                  child: Column(
                    children: [
                      // Success Title
                      Text(
                        context.loc.checkoutSuccessTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                          fontFamily: 'Tajawal',
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          context.loc.checkoutSuccessSubtitle,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: textSubColor,
                            fontFamily: 'Tajawal',
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Digital Receipt Card
                      _buildDigitalReceiptCard(
                        cardBg,
                        borderColor,
                        textColor,
                        textSubColor,
                        isDark,
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons
                      _buildSuccessActionButtons(textColor, borderColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationBadge(bool isDark) {
    return GestureDetector(
      onTap: _playSuccessCelebration,
      child: ScaleTransition(
        scale: _badgeScaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Soft Glow Ring
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF10B981,
                ).withValues(alpha: isDark ? 0.15 : 0.12),
              ),
            ),
            // Middle Ripple Ring
            Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF10B981,
                ).withValues(alpha: isDark ? 0.28 : 0.22),
              ),
            ),
            // Inner Solid Gradient Badge
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF34D399), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, color: Colors.white, size: 46),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalReceiptCard(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    final isFree = _paidAmount <= 0;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(_purchaseTime);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Receipt Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceMuted
                  : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.checkoutDigitalReceipt,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                // Order Reference Pill with Copy Action
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _orderNumber));
                    HapticFeedback.lightImpact();
                    setState(() => _copiedRef = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _copiedRef = false);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _copiedRef
                          ? const Color(0xFFECFDF5)
                          : (isDark ? AppColors.darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _copiedRef
                            ? const Color(0xFF10B981)
                            : borderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#$_orderNumber',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                            color: _copiedRef
                                ? const Color(0xFF059669)
                                : textColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          _copiedRef ? Icons.check_rounded : Icons.copy_rounded,
                          size: 13,
                          color: _copiedRef
                              ? const Color(0xFF059669)
                              : textSubColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 1. Transaction Date
                _buildReceiptRow(
                  icon: Icons.calendar_today_rounded,
                  label: context.loc.checkoutTransactionDate,
                  value: dateStr,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
                const SizedBox(height: 12),

                // 2. Payment Method
                _buildReceiptRow(
                  icon: isFree
                      ? Icons.card_giftcard_rounded
                      : Icons.credit_card_rounded,
                  label: context.loc.checkoutPaymentMethod,
                  value: isFree
                      ? context.loc.checkoutFreeEnrollment
                      : '$_paidCardBrand •••• $_paidLastFour',
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
                const SizedBox(height: 12),

                // 3. Purchased Items Count
                _buildReceiptRow(
                  icon: Icons.school_rounded,
                  label: context.loc.checkoutEnrolledCourses,
                  value: context.loc.checkoutCoursesCount(
                    _purchasedItemsCount.toString(),
                  ),
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
                const SizedBox(height: 12),

                // 4. Status
                _buildReceiptRow(
                  icon: Icons.verified_rounded,
                  label: context.loc.checkoutTransactionStatus,
                  customValueWidget: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.loc.checkoutStatusSuccess,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1),
                ),

                // 5. Total Paid Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.checkoutTotalPaid,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      isFree
                          ? context.loc.checkoutFreePrice
                          : '\$${_paidAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF059669),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? customValueWidget,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: textSubColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (customValueWidget != null)
          customValueWidget
        else
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
      ],
    );
  }

  Widget _buildSuccessActionButtons(Color textColor, Color borderColor) {
    return Column(
      children: [
        // Primary Button: Go to Learning
        AppButton(
          height: 52,
          borderRadius: 14,
          icon: const Icon(
            Icons.play_circle_filled_rounded,
            size: 20,
            color: Colors.white,
          ),
          label: context.loc.checkoutStartLearning,
          fontSize: 14,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/learning');
          },
        ),
        const SizedBox(height: 10),

        // Secondary Button: Back to Home
        AppButton(
          height: 50,
          borderRadius: 14,
          outlined: true,
          icon: Icon(Icons.home_rounded, size: 18, color: textColor),
          label: context.loc.checkoutBackHome,
          fontSize: 13.5,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
      ],
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
                style: TextStyle(
                  fontSize: 11,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
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
                  AppNetworkImage(
                    url: item.thumbnailUrl,
                    width: 48,
                    height: 38,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                    placeholder: Container(
                      width: 48,
                      height: 38,
                      color: isDark
                          ? AppColors.darkSurfaceMuted
                          : const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                    errorWidget: Container(
                      width: 48,
                      height: 38,
                      color: isDark
                          ? AppColors.darkSurfaceMuted
                          : const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
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
                            style: TextStyle(
                              fontSize: 10,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
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
                      color: item.totalPrice <= 0
                          ? const Color(0xFF059669)
                          : textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],

          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 10),

          // Price Calculation Rows
          _buildPriceRow(
            context.loc.cartSubtotal,
            '${subtotal.toStringAsFixed(2)} \$',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          if (discount > 0)
            _buildPriceRow(
              context.loc.cartCouponDiscount,
              '-${discount.toStringAsFixed(2)} \$',
              isDiscount: true,
              textColor: textColor,
              textSubColor: textSubColor,
            ),

          const SizedBox(height: 6),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 8),

          _buildPriceRow(
            context.loc.cartFinalTotal,
            isFree
                ? context.loc.checkoutFreeZero
                : '${finalPrice.toStringAsFixed(2)} \$',
            isTotal: true,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
    required Color textColor,
    required Color textSubColor,
  }) {
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
                  ? (value.contains('Free') ||
                            value.contains(context.loc.checkoutFreePrice)
                        ? const Color(0xFF059669)
                        : AppColors.primary)
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
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? Function(String?)? liveValidator,
    void Function(String)? onChanged,
    bool englishOnly = true,
  }) {
    final formatters = <TextInputFormatter>[
      ArabicDigitsToEnglishFormatter(),
      if (englishOnly)
        FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]')),
      if (inputFormatters != null) ...inputFormatters,
    ];

    return FormField<String>(
      validator: validator,
      initialValue: controller.text,
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: hasError ? AppColors.error : textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                if (hasError && field.errorText != null)
                  Flexible(
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                inputFormatters: formatters,
                onTap: () {
                  if (field.hasError && liveValidator == null) {
                    field.reset();
                  }
                },
                onChanged: (val) {
                  field.didChange(val);
                  onChanged?.call(val);
                  if (liveValidator != null) {
                    final liveErr = liveValidator(val);
                    if (liveErr != null) {
                      field.validate();
                    } else if (field.hasError) {
                      field.reset();
                    }
                  } else {
                    if (field.hasError) {
                      field.reset();
                    }
                  }
                },
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12.5,
                  fontFamily: 'Inter',
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputFill,
                  hintText: hint,
                  hintTextDirection: TextDirection.ltr,
                  hintStyle: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    fontFamily: 'Inter',
                  ),
                  prefixIcon: Icon(
                    icon,
                    size: 18,
                    color: hasError ? AppColors.error : AppColors.textSecondary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: hasError ? AppColors.error : borderColor,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: hasError ? AppColors.error : borderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: hasError ? AppColors.error : AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
