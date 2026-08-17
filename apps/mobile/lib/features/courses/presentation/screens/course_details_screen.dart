import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final List<ExpansibleController> _sectionControllers = List.generate(
    3,
    (_) => ExpansibleController(),
  );
  bool isFavorite = false;

  void _collapseOthers(int index) {
    for (var i = 0; i < _sectionControllers.length; i++) {
      if (i != index) _sectionControllers[i].collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم نسخ رابط الدورة')),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // غلاف الدورة Hero Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'تطوير البرمجيات',
                    style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // عنوان الدورة والوصف
          const Text(
            'دليل النخبة في هندسة البرمجيات والتصميم المعماري',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.3),
          ),
          const SizedBox(height: 8),
          const Text(
            'تعلم كيفية بناء أنظمة برمجية قابلة للتطوير وعالية الأداء. يغطي هذا الكورس المتقدم أنماط التصميم المعماري الحديثة وأفضل الممارسات في الصناعة.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),

          // الإحصائيات (التقييم، الطلاب، المدة)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBadge(Icons.star_rounded, '4.8 (3,421 تقييم)', Colors.amber),
              _buildStatBadge(Icons.people_outline_rounded, '45,200 طالب', AppColors.primary),
              _buildStatBadge(Icons.play_circle_outline_rounded, '24 ساعة فيديو', AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 20),

          // بطاقة المدرب
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('م. طارق الخالدي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('مهندس برمجيات أول ومستشار تقني', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // المنهج الدراسي Syllabus
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('المنهج الدراسي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('12 قسم • 84 محاضرة', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          // أقسام المنهج
          _buildSyllabusSection(
            index: 0,
            number: '1',
            title: 'مقدمة في هندسة النظم',
            info: '4 محاضرات • 45 دقيقة',
          ),
          const SizedBox(height: 8),
          _buildSyllabusSection(
            index: 1,
            number: '2',
            title: 'أنماط التصميم (Design Patterns)',
            info: '8 محاضرات • ساعتان و 15 دقيقة',
          ),
          const SizedBox(height: 8),
          _buildSyllabusSection(
            index: 2,
            number: '3',
            title: 'الخدمات المصغرة (Microservices)',
            info: '12 محاضرة • 4 ساعات',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('\$129.99', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                Text('\$250.00', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
              ],
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => setState(() => isFavorite = !isFavorite),
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.red : AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/checkout'),
                child: const Text('سجل الآن'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSyllabusSection({
    required int index,
    required String number,
    required String title,
    required String info,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        controller: _sectionControllers[index],
        onExpansionChanged: (expanded) {
          if (expanded) _collapseOthers(index);
        },
        title: Text('$number. $title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(info, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        children: [
          _buildLessonRow('مفاهيم أساسية في المعمارية', '12:30', isFree: true),
          _buildLessonRow('الفرق بين التصميم والمعمارية', '15:45', isLocked: true),
          _buildLessonRow('ملف مرجعي للمصطلحات', 'PDF', isPdf: true),
        ],
      ),
    );
  }

  Widget _buildLessonRow(String title, String duration, {bool isFree = false, bool isLocked = false, bool isPdf = false}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/lesson-player'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              isPdf ? Icons.picture_as_pdf_outlined : (isLocked ? Icons.lock_outline_rounded : Icons.play_circle_fill_rounded),
              color: isLocked ? AppColors.textSecondary : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
            Text(duration, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
