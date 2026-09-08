import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WishlistProvider>().fetchWishlist();
      }
    });
  }

  void _handleRemove(WishlistItemModel item) async {
    HapticFeedback.mediumImpact();
    final provider = context.read<WishlistProvider>();
    final success = await provider.removeFromWishlist(item.courseId);

    if (mounted && success) {
      AppSnackbar.show(
        context,
        context.loc.wishlistRemovedSnackbar,
        actionLabel: context.loc.cartUndo,
        onAction: () => provider.addToWishlist(item.courseId),
      );
    }
  }

  void _handleAddToCart(WishlistItemModel item) async {
    HapticFeedback.mediumImpact();
    final cartProvider = context.read<CartProvider>();
    final success = await cartProvider.addToCart(item.courseId);
    if (!mounted) return;
    if (success) {
      AppSnackbar.showSuccess(
        context,
        context.loc.cartAddedSnackbar,
        actionLabel: context.loc.cartTitle,
        onAction: () => Navigator.pushNamed(context, '/cart'),
      );
    } else {
      AppSnackbar.showError(
        context,
        cartProvider.errorMessage ?? context.loc.wishlistFailedAddToCart,
      );
    }
  }

  Future<void> _showClearWishlistModal(int count) async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

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
              // Top Drag Handle
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

              // Danger Glow Badge
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3B1717) : const Color(0xFFFEE2E2),
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
                context.loc.wishlistClearAllTitle,
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
                context.loc.wishlistClearAllMessage(count.toString()),
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.loc.wishlistClearAllHint,
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx, true);
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.white),
                  label: Text(
                    context.loc.wishlistClearAllConfirm(count.toString()),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
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
      final success = await context.read<WishlistProvider>().clearWishlist();
      if (!mounted) return;
      if (success) {
        AppSnackbar.showSuccess(
          context,
          context.loc.wishlistClearedSuccess,
        );
      } else {
        AppSnackbar.showError(
          context,
          context.loc.wishlistClearFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();
    final items = provider.items;
    final isLoading = provider.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isAr = context.isArabic;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
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
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.loc.wishlistTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            if (items.isNotEmpty)
              Text(
                '${items.length} ${items.length == 1 ? context.loc.learningLesson : context.loc.profileWishlist}',
                style: TextStyle(
                  fontSize: 11,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Color(0xFFDC2626), size: 22),
              tooltip: context.loc.wishlistClearTooltip,
              onPressed: () => _showClearWishlistModal(items.length),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<WishlistProvider>().fetchWishlist(forceRefresh: true),
        child: isLoading && items.isEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                itemCount: 4,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SkeletonWishlistCard(),
                ),
              )
            : items.isEmpty
                ? _buildEmptyWishlistView(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isDark: isDark,
                    isRtl: isRtl,
                    isAr: isAr,
                  )
                : _buildWishlistContentView(items, isDark, cardBg, textColor, textSubColor, borderColor),
      ),
    );
  }

  Widget _buildWishlistContentView(
    List<WishlistItemModel> items,
    bool isDark,
    Color cardBg,
    Color textColor,
    Color textSubColor,
    Color borderColor,
  ) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildWishlistCard(item, isDark, cardBg, textColor, textSubColor, borderColor);
      },
    );
  }

  Widget _buildWishlistCard(
    WishlistItemModel item,
    bool isDark,
    Color cardBg,
    Color textColor,
    Color textSubColor,
    Color borderColor,
  ) {
    final hasDiscount = item.courseDiscount != null && item.courseDiscount! > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/course-details', arguments: item.courseId),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail with discount badge overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 92,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1D61E7), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                        ),
                        child: (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
                            ? Image.network(
                                item.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
                              ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '-${item.courseDiscount!.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Course Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.getLocalizedBadge(context),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Title
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

                      // Instructor
                      Text(
                        item.instructorName,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Rating & Stats
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 2),
                              Text(
                                item.averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              if (item.totalRatings > 0) ...[
                                const SizedBox(width: 2),
                                Text(
                                  '(${item.totalRatings})',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: textSubColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '•',
                            style: TextStyle(fontSize: 10, color: textSubColor),
                          ),
                          Text(
                            item.getFormattedDuration(context),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: textSubColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          if (item.totalLectures > 0) ...[
                            Text(
                              '•',
                              style: TextStyle(fontSize: 10, color: textSubColor),
                            ),
                            Text(
                              item.getFormattedLectures(context),
                              style: TextStyle(
                                fontSize: 10.5,
                                color: textSubColor,
                                fontFamily: 'Tajawal',
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
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 10),

          // Price & Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$${item.finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(width: 6),
                    Text(
                      '\$${item.coursePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: textSubColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ],
              ),

              // Action buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () => _handleRemove(item),
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                    tooltip: context.loc.cartRemove,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _handleAddToCart(item),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 15),
                    label: Text(
                      context.loc.courseDetailsAddToCart,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
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

  Widget _buildEmptyWishlistView({
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isRtl,
    required bool isAr,
  }) {
    final cartProvider = context.watch<CartProvider>();
    final cartCount = cartProvider.count;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final double bottomPadding = 28.0 + bottomInset;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
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
                                ? const Color(0xFFEF4444).withValues(alpha: 0.12)
                                : const Color(0xFFFEF2F2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.2 : 0.08),
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
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            border: Border.all(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 42,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        // Floating Badge 1: Top (star / favorites)
                        Positioned(
                          top: -2,
                          right: isRtl ? null : 2,
                          left: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                        // Floating Badge 2: Bottom (academy/courses)
                        Positioned(
                          bottom: 0,
                          left: isRtl ? null : 2,
                          right: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
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
                      context.loc.wishlistEmptyTitle,
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
                        context.loc.wishlistEmptySubtitle,
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
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.32),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.pushNamed(context, '/explore');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.explore_rounded, size: 20, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.loc.learningExploreButton,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                                    size: 17,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Secondary Cart Button (if items exist or quick navigation)
                        if (cartCount > 0) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.pushNamed(context, '/cart');
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: cardBg,
                                foregroundColor: textColor,
                                side: BorderSide(color: borderColor, width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_cart_outlined, size: 18, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.loc.wishlistViewCartCount(cartCount.toString()),
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.pushNamed(context, '/cart');
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                              color: textSubColor,
                            ),
                            label: Text(
                              context.loc.wishlistGoToCart,
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
