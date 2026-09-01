import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool isTab;
  const CartScreen({super.key, this.isTab = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? _couponError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().fetchCart();
      }
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    final provider = context.read<CartProvider>();
    final success = provider.applyCoupon(code);

    if (success) {
      setState(() => _couponError = null);
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.loc.cartCouponApplied} ($code - ${provider.discountPercent.round()}%)'),
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
    final provider = context.read<CartProvider>();
    provider.removeCoupon();
    setState(() {
      _couponController.clear();
      _couponError = null;
    });
  }

  void _removeItem(CartItemModel item) async {
    HapticFeedback.mediumImpact();
    final provider = context.read<CartProvider>();
    final success = await provider.removeFromCart(item.id);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.loc.cartRemovedSnackbar}: "${item.courseTitle}"'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showClearCartDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'تفريغ السلة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف جميع الدورات من سلة الشراء؟',
          style: TextStyle(fontSize: 13, fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.loc.commonCancel,
              style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal'),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('تفريغ', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<CartProvider>().clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final isEmpty = items.isEmpty;
    final isLoading = cartProvider.isLoading;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final dividerColor = isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
                context.loc.cartItemsCount(items.length),
                style: TextStyle(
                  fontSize: 11.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
        actions: [
          if (!isEmpty)
            IconButton(
              tooltip: 'تفريغ السلة',
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 22),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => cartProvider.fetchCart(forceRefresh: true),
        child: isLoading && isEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                itemCount: 3,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SkeletonCourseCard(),
                ),
              )
            : isEmpty
                ? _buildEmptyCartView(cardBg, textColor, textSubColor, isDark)
                : _buildCartContentView(
                    cartProvider,
                    items,
                    cardBg,
                    inputFill,
                    borderColor,
                    dividerColor,
                    textColor,
                    textSubColor,
                    isDark,
                  ),
      ),
    );
  }

  // ================= 1. CART CONTENT VIEW =================
  Widget _buildCartContentView(
    CartProvider cartProvider,
    List<CartItemModel> items,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      children: [
        // Cart Items List
        for (int i = 0; i < items.length; i++) ...[
          _buildCartItemCard(items[i], cardBg, borderColor, dividerColor, textColor, textSubColor, isDark),
          if (i < items.length - 1) const SizedBox(height: 12),
        ],

        const SizedBox(height: 20),

        // Promotions & Coupons Box
        _buildCouponsBox(cartProvider, cardBg, inputFill, borderColor, textColor, textSubColor, isDark),

        const SizedBox(height: 20),

        // Order Summary Box with Checkout Button
        _buildOrderSummaryBox(cartProvider, cardBg, borderColor, dividerColor, textColor, textSubColor),
      ],
    );
  }

  // Cart Item Card
  Widget _buildCartItemCard(
    CartItemModel item,
    Color cardBg,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
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
              // Course Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 92,
                  height: 68,
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                  child: item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: AppLoadingSpinner(size: 18, color: AppColors.primary),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.school_rounded,
                              size: 28,
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: 28,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
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
                      item.courseTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    if (item.instructorName.isNotEmpty)
                      Text(
                        item.instructorName,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),

                    // Price Row
                    Row(
                      children: [
                        Text(
                          '${item.totalPrice.toStringAsFixed(2)} \$',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (item.coursePrice > item.totalPrice) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${item.coursePrice.toStringAsFixed(2)} \$',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
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
              onTap: () => _removeItem(item),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
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
          ),
        ],
      ),
    );
  }

  // Promotions & Coupon Box
  Widget _buildCouponsBox(
    CartProvider cartProvider,
    Color cardBg,
    Color inputFill,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    final applied = cartProvider.appliedCoupon;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
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

          if (applied != null)
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
                      '${context.loc.cartCouponApplied}: $applied (${cartProvider.discountPercent.round()}%)',
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
                    height: 42,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
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
    CartProvider cartProvider,
    Color cardBg,
    Color borderColor,
    Color dividerColor,
    Color textColor,
    Color textSubColor,
  ) {
    final subtotal = cartProvider.subtotal;
    final rawTotal = cartProvider.rawTotalPrice;
    final discount = cartProvider.discountAmount;
    final finalTotal = cartProvider.finalPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
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
            '${subtotal.toStringAsFixed(2)} \$',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          if (subtotal > rawTotal)
            _buildSummaryRow(
              context.loc.cartPlatformDiscount,
              '-${(subtotal - rawTotal).toStringAsFixed(2)} \$',
              isDiscount: true,
              textColor: textColor,
              textSubColor: textSubColor,
            ),
          if (cartProvider.appliedCoupon != null)
            _buildSummaryRow(
              '${context.loc.cartCouponDiscount} (${cartProvider.discountPercent.round()}%):',
              '-${discount.toStringAsFixed(2)} \$',
              isDiscount: true,
              textColor: textColor,
              textSubColor: textSubColor,
            ),
          const SizedBox(height: 6),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 8),
          _buildSummaryRow(
            context.loc.cartFinalTotal,
            '${finalTotal.toStringAsFixed(2)} \$',
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
    String title,
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
            title,
            style: TextStyle(
              fontSize: isTotal ? 13.5 : 12,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
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

  // Empty Cart View
  Widget _buildEmptyCartView(Color cardBg, Color textColor, Color textSubColor, bool isDark) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.loc.cartEmptyTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.cartEmptySubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppButton(
                  label: context.loc.learningExploreButton,
                  icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/explore'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
