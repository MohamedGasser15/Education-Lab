import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'EduLab',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
        children: [
          // شريط البحث مع زر التصفية
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن دورات، مواضيع...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.tune_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // فلاتر الفئة والمستوى والسعر
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('الكل', isSelected: true),
                _buildDropdownChip('الفئة'),
                _buildDropdownChip('المستوى'),
                _buildDropdownChip('السعر'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // رأس النتائج
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'نتائج البحث',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'تم العثور على 124 دورة',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // بطاقات الدورات في نتائج البحث
          _buildExploreCard(
            title: 'أساسيات علوم البيانات والتحليل',
            instructor: 'د. أحمد خالد',
            level: 'مبتدئ',
            levelColor: Colors.blue,
            rating: 4.8,
            duration: '12 ساعة',
            price: '199 ر.س',
            imageUrl:
                'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
            onTap: () => Navigator.pushNamed(context, '/course-details'),
          ),
          const SizedBox(height: 16),
          _buildExploreCard(
            title: 'برمجة واجهات الويب المتقدمة React',
            instructor: 'م. سارة علي',
            level: 'متقدم',
            levelColor: Colors.green,
            rating: 4.9,
            duration: '24 ساعة',
            price: '299 ر.س',
            imageUrl:
                'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800',
            onTap: () => Navigator.pushNamed(context, '/course-details'),
          ),
          const SizedBox(height: 16),
          _buildExploreCard(
            title: 'تصميم تجربة المستخدم UI/UX',
            instructor: 'أ. نورة سعد',
            level: 'متوسط',
            levelColor: Colors.orange,
            rating: 4.7,
            duration: '8 ساعات',
            price: 'مجاناً',
            imageUrl:
                'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800',
            onTap: () => Navigator.pushNamed(context, '/course-details'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdownChip(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard({
    required String title,
    required String instructor,
    required String level,
    required MaterialColor levelColor,
    required double rating,
    required String duration,
    required String price,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: levelColor.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          level,
                          style: TextStyle(
                            color: levelColor.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.bookmark_border_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
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
}
