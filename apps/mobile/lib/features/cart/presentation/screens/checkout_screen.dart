import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _CheckoutItem {
  final String id;
  final String title;
  final String instructor;
  final double price;
  final double originalPrice;
  final IconData icon;
  final List<Color> gradient;

  const _CheckoutItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.price,
    required this.originalPrice,
    required this.icon,
    required this.gradient,
  });
}

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

  // Form Controllers (Matching MVC Profile & Payment Models)
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: 'عمر أحمد الشمري');
  final TextEditingController _phoneController =
      TextEditingController(text: '+966 50 123 4567');
  final TextEditingController _postalCodeController =
      TextEditingController(text: '11564');
  bool _saveInfoForNextTime = true;

  // Payment Form Controllers (Stripe Integration)
  final TextEditingController _cardNumberController =
      TextEditingController(text: '4242 4242 4242 4242');
  final TextEditingController _expiryController =
      TextEditingController(text: '12 / 28');
  final TextEditingController _cvcController =
      TextEditingController(text: '888');
  final TextEditingController _cardHolderController =
      TextEditingController(text: 'OMAR AHMED');
  bool _isProcessing = false;
  String? _orderNumber;

  // Checkout Items (Passed or defaults)
  final List<_CheckoutItem> _cartItems = const [
    _CheckoutItem(
      id: 'c1',
      title: 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر [2026]',
      instructor: 'م. أحمد محمد',
      price: 49.99,
      originalPrice: 84.99,
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF1D61E7), Color(0xFF2563EB)],
    ),
    _CheckoutItem(
      id: 'c2',
      title: 'تصميم واجهات وتجربة المستخدم الاحترافية من الصفر بـ Figma',
      instructor: 'سارة أحمد',
      price: 39.99,
      originalPrice: 69.99,
      icon: Icons.brush_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ),
  ];

  final double _couponDiscountPercent = 0.20; // 20% discount (EDULAB2026)

  double get _originalTotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.originalPrice);

  double get _subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price);

  double get _couponDiscount => _subtotal * _couponDiscountPercent;

  double get _finalTotal => _subtotal - _couponDiscount;

  @override
  void initState() {
    super.initState();
    // Listen for real-time live card preview updates
    _cardNumberController.addListener(() => setState(() {}));
    _expiryController.addListener(() => setState(() {}));
    _cardHolderController.addListener(() => setState(() {}));
    _cvcController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
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
    if (step == 2) {
      // Validate Step 1 (Customer Info)
      if (!_formKey.currentState!.validate()) {
        HapticFeedback.heavyImpact();
        return;
      }
    }
    HapticFeedback.lightImpact();
    setState(() {
      _previousStep = _currentStep;
      _currentStep = step;
    });
  }

  void _processPayment() async {
    HapticFeedback.mediumImpact();
    setState(() => _isProcessing = true);

    // Simulate MVC CreatePaymentIntent and ConfirmPayment AJAX flow
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    HapticFeedback.heavyImpact();
    setState(() {
      _isProcessing = false;
      _currentStep = 4; // Success
      _orderNumber = 'EDU${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isForward = _currentStep >= _previousStep;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: _currentStep == 4
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  if (_currentStep > 1) {
                    _goToStep(_currentStep - 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
        title: Text(
          _currentStep == 4 ? 'تم تأكيد الطلب' : 'إتمام الشراء والطلب',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: _currentStep == 4
          ? _buildSuccessView()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
              children: [
                // 1. MVC Animated Stepper Header (بيانات المشتري ➔ الدفع ➔ التأكيد)
                _buildStepperHeader(),

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
                    child: _buildCurrentStepWidget(),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Udemy Order Summary & Guarantee Card
                _buildOrderSummaryCard(),
              ],
            ),
    );
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case 1:
        return _buildCustomerInfoStep();
      case 2:
        return _buildPaymentMethodStep();
      case 3:
        return _buildOrderConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ================= 1. SMOOTH ANIMATED STEPPER HEADER =================
  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepNode(1, 'بيانات المشتري', Icons.person_rounded),
              _buildStepLine(_currentStep >= 2),
              _buildStepNode(2, 'طريقة الدفع', Icons.credit_card_rounded),
              _buildStepLine(_currentStep >= 3),
              _buildStepNode(3, 'مراجعة وتأكيد', Icons.check_circle_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(int stepNum, String title, IconData icon) {
    final isActive = _currentStep == stepNum;
    final isDone = _currentStep > stepNum;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDone
                ? const Color(0xFF059669)
                : (isActive ? AppColors.primary : const Color(0xFFF1F5F9)),
            shape: BoxShape.circle,
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isDone ? Icons.check_rounded : icon,
                key: ValueKey('icon_${stepNum}_${isDone}_$isActive'),
                size: 18,
                color: (isDone || isActive) ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 240),
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : (isDone ? const Color(0xFF059669) : AppColors.textSecondary),
            fontFamily: 'Tajawal',
          ),
          child: Text(title),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isFilled) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18, left: 6, right: 6),
        height: 3.0,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              widthFactor: isFilled ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 2. STEP 1: CUSTOMER INFO =================
  Widget _buildCustomerInfoStep() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                SizedBox(width: 6),
                Text(
                  'البيانات الشخصية للمشتري',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Full Name Input
            _buildInputField(
              controller: _nameController,
              label: 'الاسم الكامل *',
              hint: 'أدخل اسمك الثلاثي المعتمد',
              icon: Icons.person_rounded,
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'يرجى إدخال اسمك الكامل' : null,
            ),
            const SizedBox(height: 12),

            // Phone Number Input
            _buildInputField(
              controller: _phoneController,
              label: 'رقم الهاتف الجوال *',
              hint: '+966 50 123 4567',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.trim().length < 8) ? 'يرجى إدخال رقم هاتف صحيح' : null,
            ),
            const SizedBox(height: 12),

            // Postal Code Input
            _buildInputField(
              controller: _postalCodeController,
              label: 'الرمز البريدي / المدينة *',
              hint: '11564',
              icon: Icons.location_on_rounded,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'يرجى إدخال الرمز البريدي' : null,
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
                  color: _saveInfoForNextTime ? const Color(0xFFEFF4FF) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _saveInfoForNextTime ? const Color(0xFFDBEAFE) : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _saveInfoForNextTime
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'حفظ بياناتي تلقائياً لتسريع عمليات الشراء القادمة',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _goToStep(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'المتابعة إلى وسيلة الدفع',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 16),
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
  Widget _buildPaymentMethodStep() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.credit_card_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'اختر وسيلة الدفع الآمنة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

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
                Row(
                  children: const [
                    Icon(Icons.lock_rounded, color: Color(0xFF635BFF), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'بوابة الدفع المشفرة الآمنة',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4338CA),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
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
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Number
                _buildInputField(
                  controller: _cardNumberController,
                  label: 'رقم البطاقة *',
                  hint: '4242 4242 4242 4242',
                  icon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_CardNumberFormatter()],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    // Expiry Date
                    Expanded(
                      child: _buildInputField(
                        controller: _expiryController,
                        label: 'تاريخ الانتهاء *',
                        hint: 'MM / YY',
                        icon: Icons.date_range_rounded,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [_CardExpiryFormatter()],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // CVC
                    Expanded(
                      child: _buildInputField(
                        controller: _cvcController,
                        label: 'رمز الأمان (CVC) *',
                        hint: '•••',
                        icon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Cardholder Name
                _buildInputField(
                  controller: _cardHolderController,
                  label: 'اسم حامل البطاقة *',
                  hint: 'الاسم بالإنجليزية كما يظهر على البطاقة',
                  icon: Icons.badge_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToStep(1),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('الرجوع للبيانات', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _goToStep(3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                  ),
                  child: const Text('مراجعة الطلب ➔', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Live Credit Card Widget (Fluid Gradient & Micro chip)
  Widget _buildLiveCreditCardPreview() {
    final rawNumber = _cardNumberController.text.trim();
    final displayNumber = rawNumber.isEmpty ? '•••• •••• •••• 4242' : rawNumber;
    final cardHolder = _cardHolderController.text.trim().isEmpty ? 'CARDHOLDER NAME' : _cardHolderController.text.toUpperCase();
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
              Column(
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
  Widget _buildOrderConfirmationStep() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'مراجعة وتأكيد بيانات الطلب',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'بيانات المشتري',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    GestureDetector(
                      onTap: () => _goToStep(1),
                      child: const Text('تعديل', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('الاسم: ${_nameController.text}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
                Text('الجوال: ${_phoneController.text}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
                Text('الرمز البريدي: ${_postalCodeController.text}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Payment Info Box (Stripe Focused)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('وسيلة الدفع المعتمدة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                    SizedBox(height: 4),
                    Text(
                      'بطاقة ائتمان / خصم عبر بوابة Stripe (تشفير 256-Bit SSL)',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _goToStep(2),
                  child: const Text('تعديل', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Security Trust Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_rounded, color: Color(0xFF059669), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'عملية الشراء مشفرة ومؤمنة بالكامل بضمان استرجاع الأموال خلال 30 يوماً.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF065F46),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Final Confirm & Pay Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'جاري تأكيد الدفع والاشتراك...',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'تأكيد الطلب ودفع ${_finalTotal.toStringAsFixed(2)} \$',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 5. STEP 4: ORDER SUCCESS VIEW =================
  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 54,
                  color: Color(0xFF059669),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'تهانينا! تم إتمام الشراء والاشتراك بنجاح 🎉',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'رقم الطلب المرجعي: $_orderNumber\nتم إرسال فاتورة وتفاصيل الدورة إلى بريدك الإلكتروني.',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
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
                child: const Text(
                  'بدء التعلم ومشاهدة دوراتي ➔',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
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
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'العودة للرئيسية',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: AppColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 6. UDEMY ORDER SUMMARY CARD =================
  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الدورات والطلب',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),

          // Course items
          for (final item in _cartItems) ...[
            Row(
              children: [
                Container(
                  width: 44,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Icon(item.icon, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.instructor,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item.price.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Price Calculation Rows
          _buildPriceRow('السعر الأصلي:', '${_originalTotal.toStringAsFixed(2)} \$'),
          _buildPriceRow('خصم المنصة:', '-${(_originalTotal - _subtotal).toStringAsFixed(2)} \$', isDiscount: true),
          _buildPriceRow('خصم الكوبون (20%):', '-${_couponDiscount.toStringAsFixed(2)} \$', isDiscount: true),

          const SizedBox(height: 6),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          _buildPriceRow('الإجمالي النهائي للدفع:', '${_finalTotal.toStringAsFixed(2)} \$', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
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
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 12,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              color: isTotal
                  ? AppColors.primary
                  : (isDiscount ? const Color(0xFF059669) : AppColors.textPrimary),
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
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            style: const TextStyle(fontSize: 12.5, fontFamily: 'Tajawal'),
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
