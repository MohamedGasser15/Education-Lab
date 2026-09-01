import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _WishlistItem {
  final String id;
  final String title;
  final String instructor;
  final double rating;
  final int reviewsCount;
  final double price;
  final double originalPrice;
  final String hours;
  final String lectures;
  final IconData icon;
  final List<Color> gradient;
  final String badge;

  const _WishlistItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.originalPrice,
    required this.hours,
    required this.lectures,
    required this.icon,
    required this.gradient,
    required this.badge,
  });
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<_WishlistItem> _items = [
    const _WishlistItem(
      id: 'w1',
      title: 'بناء تطبيقات Flutter متقدمة مع Clean Architecture',
      instructor: 'م. أحمد محمد',
      rating: 4.9,
      reviewsCount: 3420,
      price: 39.99,
      originalPrice: 79.99,
      hours: '32.5 ساعة',
      lectures: '185 محاضرة',
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF1D61E7), Color(0xFF2563EB)],
      badge: 'الأعلى تقييماً',
    ),
    const _WishlistItem(
      id: 'w2',
      title: 'دورة الذكاء الاصطناعي وتعلم الآلة مع Python و TensorFlow',
      instructor: 'م. يوسف محمود',
      rating: 4.8,
      reviewsCount: 2150,
      price: 49.99,
      originalPrice: 99.99,
      hours: '45 ساعة',
      lectures: '240 محاضرة',
      icon: Icons.psychology_rounded,
      gradient: [Color(0xFF059669), Color(0xFF10B981)],
      badge: 'الأكثر مبيعاً',
    ),
    const _WishlistItem(
      id: 'w3',
      title: 'تصميم واجهات وتجربة المستخدم الاحترافية مع Figma [2026]',
      instructor: 'سارة أحمد',
      rating: 4.9,
      reviewsCount: 4890,
      price: 34.99,
      originalPrice: 69.99,
      hours: '28 ساعة',
      lectures: '142 محاضرة',
      icon: Icons.palette_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF1E293B)],
      badge: 'موصى به',
    ),
    const _WishlistItem(
      id: 'w4',
      title: 'احتراف هندسة البرمجيات السحابية مع AWS و DevOps',
      instructor: 'د. خالد العلي',
      rating: 4.8,
      reviewsCount: 1820,
      price: 54.99,
      originalPrice: 119.99,
      hours: '50 ساعة',
      lectures: '290 محاضرة',
      icon: Icons.cloud_sync_rounded,
      gradient: [Color(0xFF134BB8), Color(0xFF1D61E7)],
      badge: 'دورة مميزة',
    ),
  ];

  void _removeFromWishlist(String id) {
    HapticFeedback.mediumImpact();
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex == -1) return;
    final item = _items[itemIndex];

    setState(() {
      _items.removeAt(itemIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.wishlistRemovedSnackbar),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: context.loc.cartUndo,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _items.insert(itemIndex, item);
            });
          },
        ),
      ),
    );
  }

  void _addToCart(String id) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.cartAddedSnackbar),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: context.loc.cartTitle,
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _items.isEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
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
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (!isEmpty)
              Text(
                context.loc.learningLecturesCount(_items.length),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
      ),
      body: isEmpty ? _buildEmptyWishlistView() : _buildWishlistContentView(isDark, cardBg, textColor, borderColor),
    );
  }

  Widget _buildWishlistContentView(bool isDark, Color cardBg, Color textColor, Color borderColor) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
      itemCount: _items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildWishlistCard(item, isDark, cardBg, textColor, borderColor);
      },
    );
  }

  Widget _buildWishlistCard(_WishlistItem item, bool isDark, Color cardBg, Color textColor, Color borderColor) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/course-details'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail / Badge
                Container(
                  width: 88,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(item.icon, color: Colors.white, size: 32),
                  ),
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
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.badge,
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
                        item.title,
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
                        item.instructor,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Rating & Stats
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 3),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${item.reviewsCount})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.hours,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
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

            const SizedBox(height: 12),
            Divider(height: 1, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
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
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '\$${item.originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),

                // Actions (Add to cart & Remove)
                Row(
                  children: [
                    IconButton(
                      tooltip: 'إزالة من المفضلة',
                      icon: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444), size: 20),
                      onPressed: () => _removeFromWishlist(item.id),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _addToCart(item.id),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 15),
                      label: Text(
                        context.loc.wishlistAddToCart,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWishlistView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              context.loc.wishlistEmptyTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.loc.wishlistEmptySubtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/main'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: Text(
                context.loc.learningExploreButton,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
