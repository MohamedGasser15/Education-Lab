import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _WishlistCourseItem {
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

  const _WishlistCourseItem({
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

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<_WishlistCourseItem> _items = [
    const _WishlistCourseItem(
      id: 'w1',
      title: 'بناء الواجهات التفاعلية الحديثة بـ React 19 و Next.js 15',
      instructor: 'م. أحمد ناصر',
      rating: 4.9,
      reviews: '8,420',
      price: 39.99,
      originalPrice: 74.99,
      hours: '28.0 ساعة',
      lectures: '190 درس',
      icon: Icons.code_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF2563EB)],
      badge: 'الأعلى تقييماً',
    ),
    const _WishlistCourseItem(
      id: 'w2',
      title: 'أساسيات وتطبيقات الذكاء الاصطناعي وتعلم الآلة الشاملة',
      instructor: 'د. يوسف الشريف',
      rating: 4.8,
      reviews: '14,200',
      price: 49.99,
      originalPrice: 89.99,
      hours: '34.5 ساعة',
      lectures: '220 درس',
      icon: Icons.psychology_outlined,
      gradient: [Color(0xFF047857), Color(0xFF10B981)],
      badge: 'الأعلى مبيعاً',
    ),
    const _WishlistCourseItem(
      id: 'w3',
      title: 'احتراف تصميم تجربة المستخدم وتصميم الأنظمة بـ Figma',
      instructor: 'سارة أحمد',
      rating: 4.9,
      reviews: '6,890',
      price: 34.99,
      originalPrice: 69.99,
      hours: '22.0 ساعة',
      lectures: '140 درس',
      icon: Icons.design_services_outlined,
      gradient: [Color(0xFF7C3AED), Color(0xFF9333EA)],
      badge: 'دورة مميزة',
    ),
  ];

  void _removeFromWishlist(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إزالة الدورة من قائمة الرغبات'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToCart(_WishlistCourseItem item) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة "${item.title}" إلى سلة المشتريات'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _items.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة الرغبات',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            if (!isEmpty)
              Text(
                '${_items.length} دورات محفوظة',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
      ),
      body: isEmpty ? _buildEmptyWishlistView() : _buildWishlistContentView(),
    );
  }

  Widget _buildWishlistContentView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
      itemCount: _items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildWishlistCard(item);
      },
    );
  }

  Widget _buildWishlistCard(_WishlistCourseItem item) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/course-details'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
                            '(${item.reviews})',
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
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
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
                      onPressed: () => _addToCart(item),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 15),
                      label: const Text(
                        'إضافة للسلة',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
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
            const Text(
              'قائمة الرغبات فارغة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'استكشف آلاف الدورات المميزة وأضف الدورات التي ترغب في دراستها لاحقاً.',
              style: TextStyle(
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
              child: const Text(
                'استكشاف الدورات الآن',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
