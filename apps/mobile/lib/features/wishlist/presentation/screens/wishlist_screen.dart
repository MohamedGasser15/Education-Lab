import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('قائمة الرغبات', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'الدورات التي قمت بحفظها للرجوع إليها لاحقاً.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildWishlistItem(
            title: 'أساسيات علم البيانات والتحليل المتقدم',
            duration: '12 ساعة',
            rating: 4.8,
            price: '199 ر.س',
            level: 'مبتدئ',
            imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
          ),
          const SizedBox(height: 16),
          _buildWishlistItem(
            title: 'تصميم واجهات المستخدم (UI/UX) الاحترافية',
            duration: '24 ساعة',
            rating: 4.9,
            price: '249 ر.س',
            level: 'متوسط',
            imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=800',
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem({
    required String title,
    required String duration,
    required double rating,
    required String price,
    required String level,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                    Text(duration, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
