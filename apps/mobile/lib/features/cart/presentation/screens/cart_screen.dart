import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
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
      if (mounted && context.read<ProfileProvider>().isLoggedIn) {
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
      AppSnackbar.showSuccess(
        context,
        '${context.loc.cartCouponApplied} ($code - ${provider.discountPercent.round()}%)',
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
      AppSnackbar.show(
        context,
        '${context.loc.cartRemovedSnackbar}: "${item.courseTitle}"',
      );
    }
  }

  Future<void> _showClearCartDialog() async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final count = context.read<CartProvider>().items.length;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3B1717)
                      : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: isDark ? 0.35 : 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color(0xFFDC2626),
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              // Title
              Text(
                context.loc.cartClearAllTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),

              // Message
              Text(
                context.loc.cartClearAllMessage(count.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),

              // Reassurance Note Box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceMuted
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFDC2626),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.loc.cartClearAllHint,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Red Confirm Button
              AppButton(
                height: 50,
                borderRadius: 14,
                backgroundColor: const Color(0xFFDC2626),
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: context.loc.cartClearAllConfirm(count.toString()),
                fontSize: 15,
                onPressed: () {
                  Navigator.pop(ctx, true);
                },
              ),
              const SizedBox(height: 10),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.loc.commonCancel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && mounted) {
      final success = await context.read<CartProvider>().clearCart();
      if (!mounted) return;
      if (success) {
        AppSnackbar.showSuccess(context, context.loc.cartClearedSuccess);
      } else {
        AppSnackbar.showError(
          context,
          context.read<CartProvider>().errorMessage ??
              context.loc.cartClearFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoggedIn = profileProvider.isLoggedIn;
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final isEmpty = items.isEmpty;
    final isLoading = cartProvider.isLoading;

    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final bool hasContinueLearning =
        isLoggedIn && enrollmentProvider.courses.isNotEmpty;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double bottomPadding = widget.isTab
        ? (hasContinueLearning ? 190.0 : 110.0) + bottomInset
        : 32.0 + bottomInset;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.background;
    final borderColor = AppColors.getBorder(context);
    final dividerColor = AppColors.getDivider(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isAr = context.isArabic;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: (!widget.isTab && Navigator.of(context).canPop())
            ? IconButton(
                icon: Icon(
                  isRtl
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            if (isLoggedIn && !isEmpty)
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
          if (isLoggedIn && !isEmpty)
            IconButton(
              tooltip: context.loc.cartClearDialogTitle,
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Color(0xFFDC2626),
                size: 22,
              ),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: !isLoggedIn
          ? _buildGuestCartView(
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
              textSubColor: textSubColor,
              isDark: isDark,
              isRtl: isRtl,
              isAr: isAr,
              bottomPadding: bottomPadding,
            )
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => cartProvider.fetchCart(forceRefresh: true),
              child: isLoading && isEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                      itemCount: 3,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SkeletonCourseCard(),
                      ),
                    )
                  : isEmpty
                  ? _buildEmptyCartView(
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      textSubColor: textSubColor,
                      isDark: isDark,
                      isRtl: isRtl,
                      isAr: isAr,
                      bottomPadding: bottomPadding,
                    )
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
                      bottomPadding: bottomPadding,
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
    bool isDark, {
    required double bottomPadding,
  }) {
    final hPadding = AppResponsive.screenPadding(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(hPadding, 14, hPadding, bottomPadding),
      children: [
        // Cart Items List
        for (int i = 0; i < items.length; i++) ...[
          _buildCartItemCard(
            items[i],
            cardBg,
            borderColor,
            dividerColor,
            textColor,
            textSubColor,
            isDark,
          ),
          if (i < items.length - 1) const SizedBox(height: 12),
        ],

        const SizedBox(height: 20),

        // Promotions & Coupons Box
        _buildCouponsBox(
          cartProvider,
          cardBg,
          inputFill,
          borderColor,
          textColor,
          textSubColor,
          isDark,
        ),

        const SizedBox(height: 20),

        // Order Summary Box with Checkout Button
        _buildOrderSummaryBox(
          cartProvider,
          cardBg,
          borderColor,
          dividerColor,
          textColor,
          textSubColor,
        ),
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
              AppNetworkImage(
                url: item.thumbnailUrl,
                width: 92,
                height: 68,
                borderRadius: BorderRadius.circular(10),
                fit: BoxFit.cover,
                memCacheWidth: 250,
                errorWidget: Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 28,
                    color: AppColors.primary.withValues(alpha: 0.6),
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
              const Icon(
                Icons.discount_outlined,
                color: AppColors.primary,
                size: 18,
              ),
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
                color: isDark
                    ? const Color(0xFF0D3320)
                    : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF059669)
                      : const Color(0xFFA7F3D0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF059669),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${context.loc.cartCouponApplied}: $applied (${cartProvider.discountPercent.round()}%)',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFF065F46),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _removeCoupon,
                    child: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFF065F46),
                      size: 18,
                    ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: context.loc.cartCouponHint,
                        hintStyle: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          fontFamily: 'Tajawal',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                AppButton(
                  width: 90,
                  height: 42,
                  borderRadius: 8,
                  label: context.loc.cartCouponApply,
                  fontSize: 12,
                  onPressed: _applyCoupon,
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
          AppButton(
            height: 50,
            borderRadius: 12,
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              size: 16,
              color: Colors.white,
            ),
            label: context.loc.cartCheckoutButton,
            fontSize: 14,
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
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

  // ================= GUEST CART VIEW =================
  Widget _buildGuestCartView({
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isRtl,
    required bool isAr,
    required double bottomPadding,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Layered Decorative Lock/Cart Icon
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Outer soft glow
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : const Color(0xFFEFF6FF),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: isDark ? 0.2 : 0.08,
                                ),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        // Inner Circle
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // Floating Lock Badge
                        Positioned(
                          bottom: 0,
                          right: isRtl ? null : 2,
                          left: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkSurface
                                    : Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      context.loc.cartGuestTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        context.loc.cartGuestSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Bottom Action Area
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Sign In Button
                        AppButton(
                          height: 52,
                          borderRadius: 16,
                          icon: const Icon(
                            Icons.login_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: context.loc.loginTabLogin,
                          fontSize: 15,
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        const SizedBox(height: 12),

                        // Secondary Browse Button
                        AppButton(
                          height: 48,
                          borderRadius: 14,
                          outlined: true,
                          icon: Icon(
                            Icons.explore_outlined,
                            size: 19,
                            color: textColor,
                          ),
                          label: context.loc.learningExploreButton,
                          fontSize: 14,
                          onPressed: () {
                            Navigator.pushNamed(context, '/explore');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= 2. EMPTY CART VIEW =================
  Widget _buildEmptyCartView({
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isRtl,
    required bool isAr,
    required double bottomPadding,
  }) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final wishlistCount = wishlistProvider.items.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Layered Decorative Icon
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Outer soft glow
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : const Color(0xFFEFF6FF),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: isDark ? 0.2 : 0.08,
                                ),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        // Inner Circle
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 42,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // Floating Badge 1: Top (offers)
                        Positioned(
                          top: -2,
                          right: isRtl ? null : 2,
                          left: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_offer_rounded,
                              size: 14,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                        // Floating Badge 2: Bottom (academy/graduation)
                        Positioned(
                          bottom: 0,
                          left: isRtl ? null : 2,
                          right: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      context.loc.cartEmptyTitle,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        context.loc.cartEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Bottom Action Area
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Explore Button
                        AppButton(
                          height: 52,
                          borderRadius: 16,
                          icon: const Icon(
                            Icons.explore_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: context.loc.learningExploreButton,
                          fontSize: 15,
                          onPressed: () {
                            Navigator.pushNamed(context, '/explore');
                          },
                        ),

                        // Secondary Wishlist Button (if items exist or quick navigation)
                        if (wishlistCount > 0) ...[
                          const SizedBox(height: 12),
                          AppButton(
                            height: 48,
                            borderRadius: 14,
                            outlined: true,
                            icon: const Icon(
                              Icons.favorite_rounded,
                              size: 18,
                              color: Color(0xFFEF4444),
                            ),
                            label: context.loc.cartViewWishlistCount(
                              wishlistCount.toString(),
                            ),
                            fontSize: 13.5,
                            onPressed: () {
                              Navigator.pushNamed(context, '/wishlist');
                            },
                          ),
                        ] else ...[
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.pushNamed(context, '/wishlist');
                            },
                            icon: Icon(
                              Icons.favorite_border_rounded,
                              size: 16,
                              color: textSubColor,
                            ),
                            label: Text(
                              context.loc.cartGoToWishlist,
                              style: TextStyle(
                                fontSize: 13,
                                color: textSubColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
