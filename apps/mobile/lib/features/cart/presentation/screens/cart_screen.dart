import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _CartCourseItem {
  final String id;
  final String title;
  final String instructor;
  final double rating;
  final String reviews;
  final double price;
  final double originalPrice;
  final String hours;
  final String lectures;
  final IconData icon;
  final List<Color> gradient;
  final String badge;

  const _CartCourseItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.originalPrice,
    required this.hours,
    required this.lectures,
    required this.icon,
    required this.gradient,
    required this.badge,
  });
}

class CartScreen extends StatefulWidget {
  final bool isTab;
  const CartScreen({super.key, this.isTab = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  double _discountPercent = 0.0;
  String? _couponError;

  final List<_CartCourseItem> _cartItems = [
    const _CartCourseItem(
      id: 'c1',
      title: 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر [2026]',
      instructor: 'م. أحمد محمد',
      rating: 4.8,
      reviews: '18,420',
      price: 49.99,
      originalPrice: 84.99,
      hours: '38.5 ساعة',
      lectures: '284 درس',
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF1D61E7), Color(0xFF2563EB)],
      badge: 'الأعلى مبيعاً',
    ),
    const _CartCourseItem(
      id: 'c2',
      title: 'تصميم واجهات وتجربة المستخدم الاحترافية من الصفر بـ Figma',
      instructor: 'سارة أحمد',
      rating: 4.9,
      reviews: '9,850',
      price: 39.99,
      originalPrice: 69.99,
      hours: '22.0 ساعة',
      lectures: '165 درس',
      icon: Icons.brush_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
      badge: 'الأعلى تقييماً',
    ),
  ];

  final List<_CartCourseItem> _recommendedCourses = [
    const _CartCourseItem(
      id: 'r1',
      title: 'احتراف بناء وتطوير تطبيقات الويب بـ Next.js 15 و Server Actions',
      instructor: 'م. كريم سامي',
      rating: 4.9,
      reviews: '1,280',
      price: 44.99,
      originalPrice: 74.99,
      hours: '26.0 ساعة',
      lectures: '175 درس',
      icon: Icons.rocket_launch_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
      badge: 'جديد وحصري',
    ),
    const _CartCourseItem(
      id: 'r2',
      title: 'المعسكر الشامل لاختبار الاختراق والأمن السيبراني الأخلاقي',
      instructor: 'م. عمر طارق',
      rating: 4.8,
      reviews: '8,900',
      price: 44.99,
      originalPrice: 79.99,
      hours: '34.0 ساعة',
      lectures: '220 درس',
      icon: Icons.security_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF334155)],
      badge: 'الأعلى مبيعاً',
    ),
    const _CartCourseItem(
      id: 'r3',
      title: 'احتراف نماذج الذكاء الاصطناعي التوليدي والتعلم العميق بـ Python',
      instructor: 'م. يوسف محمود',
      rating: 4.7,
      reviews: '6,140',
      price: 59.99,
      originalPrice: 89.99,
      hours: '29.5 ساعة',
      lectures: '190 درس',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
      badge: 'شائع ومطلوب',
    ),
    const _CartCourseItem(
      id: 'r4',
      title: 'بناء التطبيقات المؤسسية الحديثة بـ ASP.NET Core و Microservices',
      instructor: 'د. خالد العلي',
      rating: 4.8,
      reviews: '12,300',
      price: 54.99,
      originalPrice: 99.99,
      hours: '45.0 ساعة',
      lectures: '310 درس',
      icon: Icons.cloud_done_rounded,
      gradient: [Color(0xFF134BB8), Color(0xFF1D61E7)],
      badge: 'دورة شاملة',
    ),
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'EDULAB' || code == 'EDULAB2026' || code == 'SAVE20') {
      setState(() {
        _appliedCoupon = code;
        _discountPercent = 0.20;
        _couponError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.loc.cartCouponApplied} ($code - 20%)'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _couponError = context.loc.cartCouponInvalid;
      });
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountPercent = 0.0;
      _couponController.clear();
      _couponError = null;
    });
  }

  void _removeItem(int index) {
    final removedItem = _cartItems[index];
    setState(() {
      _cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${context.loc.cartRemovedSnackbar}: "${removedItem.title}"'),
        action: SnackBarAction(
          label: context.loc.cartUndo,
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _cartItems.insert(index, removedItem);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addRecommendedToCart(_CartCourseItem course) {
    final alreadyInCart = _cartItems.any((item) => item.id == course.id);
    if (alreadyInCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.cartAlreadyInCart),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _cartItems.add(course);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.cartAddedSnackbar),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  double get _subtotalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  double get _originalTotalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.originalPrice);
  }

  double get _discountAmount {
    return _subtotalPrice * _discountPercent;
  }

  double get _finalTotal {
    return _subtotalPrice - _discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _cartItems.isEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final dividerColor = isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.cartTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            if (!isEmpty)
              Text(
                context.loc.cartItemsCount(_cartItems.length),
                style: TextStyle(
                  fontSize: 11.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
      ),
      body: isEmpty
          ? _buildEmptyCartView(cardBg, textColor, textSubColor, isDark)
          : _buildCartContentView(cardBg, inputFill, borderColor, dividerColor, textColor, textSubColor, isDark),
    );
  }

  // ================= 1. CART CONTENT VIEW =================
  Widget _buildCartContentView(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
      children: [
        // Cart Items List
        for (int i = 0; i < _cartItems.length; i++) ...[
          _buildUdemyCartCard(_cartItems[i], i, cardBg, borderColor, dividerColor, textColor, textSubColor),
          if (i < _cartItems.length - 1) const SizedBox(height: 12),
        ],

        const SizedBox(height: 20),

        // Promotions & Coupons Box
        _buildCouponsBox(cardBg, inputFill, borderColor, textColor, textSubColor, isDark),

        const SizedBox(height: 20),

        // Order Summary Box with Checkout Button
        _buildOrderSummaryBox(cardBg, borderColor, dividerColor, textColor, textSubColor),

        const SizedBox(height: 28),

        // "دورات مقترحة قد تعجبك"
        _buildRecommendedSection(cardBg, borderColor, textColor, textSubColor, isDark),
      ],
    );
  }

  // Udemy Cart Card
  Widget _buildUdemyCartCard(
    _CartCourseItem item,
    int index,
    Color cardBg,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 Thumbnail
              Container(
                width: 92,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: Colors.white.withValues(alpha: 0.95),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.instructor} • ${item.hours}',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Rating Row
                    Row(
                      children: [
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFB4690E),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 3),
                        ...List.generate(5, (_) {
                          return const Icon(
                            Icons.star_rounded,
                            size: 11.5,
                            color: Color(0xFFE59819),
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '(${item.reviews})',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: textSubColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price Row
                    Row(
                      children: [
                        Text(
                          '${item.price.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${item.originalPrice.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 6),

          // Actions Row (Remove from cart)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => _removeItem(index),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.delete_outline_rounded,
                    size: 15,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.loc.cartRemove,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Promotions & Coupon Box
  Widget _buildCouponsBox(
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.discount_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                context.loc.cartCouponsTitle,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_appliedCoupon != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${context.loc.cartCouponApplied}: $_appliedCoupon (20%)',
                      style: TextStyle(
                        color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _removeCoupon,
                    child: Icon(Icons.close_rounded, color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46), size: 18),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: inputFill,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _couponController,
                      textCapitalization: TextCapitalization.characters,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12, color: textColor, fontFamily: 'Inter', fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: context.loc.cartCouponHint,
                        hintStyle: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          fontFamily: 'Tajawal',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    context.loc.cartCouponApply,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
            if (_couponError != null) ...[
              const SizedBox(height: 6),
              Text(
                _couponError!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // Order Summary Box
  Widget _buildOrderSummaryBox(
    Color cardBg,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12),
          _buildSummaryRow(
            context.loc.cartOriginalPrice,
            '${_originalTotalPrice.toStringAsFixed(2)} \$',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSummaryRow(
            context.loc.cartPlatformDiscount,
            '-${(_originalTotalPrice - _subtotalPrice).toStringAsFixed(2)} \$',
            isDiscount: true,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          if (_appliedCoupon != null)
            _buildSummaryRow(
              '${context.loc.cartCouponDiscount} (20%):',
              '-${_discountAmount.toStringAsFixed(2)} \$',
              isDiscount: true,
              textColor: textColor,
              textSubColor: textSubColor,
            ),
          const SizedBox(height: 6),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 8),
          _buildSummaryRow(
            context.loc.cartFinalTotal,
            '${_finalTotal.toStringAsFixed(2)} \$',
            isTotal: true,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.loc.cartCheckoutButton,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
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
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? textColor : textSubColor,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 12.5,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              color: isTotal
                  ? AppColors.primary
                  : (isDiscount ? const Color(0xFF059669) : textColor),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  // ================= 2. ENHANCED RECOMMENDED COURSES SECTION =================
  Widget _buildRecommendedSection(
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              context.loc.cartRecommendedTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          context.loc.cartRecommendedSubtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: textSubColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Recommended Cards
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _recommendedCourses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final course = _recommendedCourses[index];
              final isAlreadyInCart = _cartItems.any((c) => c.id == course.id);

              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 16:9 Thumbnail Box with Badge
                    Stack(
                      children: [
                        Container(
                          height: 95,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: course.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                          ),
                          child: Center(
                            child: Icon(
                              course.icon,
                              color: Colors.white.withValues(alpha: 0.95),
                              size: 34,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              course.badge,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title (2 Lines)
                          Text(
                            course.title,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Tajawal',
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),

                          // Instructor
                          Text(
                            course.instructor,
                            style: TextStyle(
                              fontSize: 10,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),

                          // Rating
                          Row(
                            children: [
                              Text(
                                course.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFB4690E),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(width: 3),
                              ...List.generate(5, (_) {
                                return const Icon(
                                  Icons.star_rounded,
                                  size: 11,
                                  color: Color(0xFFE59819),
                                );
                              }),
                              const SizedBox(width: 3),
                              Text(
                                '(${course.reviews})',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: textSubColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Price & Quick Add Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${course.price.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    '${course.originalPrice.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),

                              // Quick Add to Cart
                              GestureDetector(
                                onTap: () => _addRecommendedToCart(course),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isAlreadyInCart
                                        ? (isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5))
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                    border: isAlreadyInCart
                                        ? Border.all(color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0))
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isAlreadyInCart ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                                        size: 13,
                                        color: isAlreadyInCart ? const Color(0xFF059669) : Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isAlreadyInCart ? context.loc.cartInCartBadge : context.loc.cartAddButton,
                                        style: TextStyle(
                                          color: isAlreadyInCart ? (isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46)) : Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ],
                                  ),
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
            },
          ),
        ),
      ],
    );
  }

  // Empty State View
  Widget _buildEmptyCartView(Color cardBg, Color textColor, Color textSubColor, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.loc.cartEmptyTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.loc.cartEmptySubtitle,
              style: TextStyle(
                fontSize: 12.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                elevation: 0,
              ),
              child: Text(
                context.loc.cartExploreButton,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
