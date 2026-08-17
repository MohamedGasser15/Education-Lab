import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('EduLab', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // مشغل الفيديو Video Player
          Container(
            height: 220,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=800',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withValues(alpha: 0.4)),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مقدمة في الكيمياء الحيوية المتقدمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                const Text('د. أحمد محمود', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 16),

                // أزرار تحديد كمكتمل وحفظ ومشاركة
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: const Text('تحديد كمكتمل'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border_rounded),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // تبويبات الدروس والمصادر والتعليقات
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'الدروس'),
                    Tab(text: 'المصادر'),
                    Tab(text: 'التعليقات'),
                  ],
                ),
                const SizedBox(height: 16),

                // محتوى الدروس
                const Text('محتوى الدورة - 24 درس', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),

                // قائمة الدروس
                _buildLessonItem('1. ما هي الكيمياء الحيوية؟', '15:20 دقيقة', isCompleted: true),
                const SizedBox(height: 8),
                _buildLessonItem('2. مقدمة في الكيمياء الحيوية المتقدمة', '28:45 دقيقة', isCurrent: true),
                const SizedBox(height: 8),
                _buildLessonItem('3. تركيب الخلية ووظائفها', '42:10 دقيقة', isLocked: true),
                const SizedBox(height: 8),
                _buildLessonItem('4. الجزيئات الحيوية الكبيرة', '35:00 دقيقة', isLocked: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(String title, String duration, {bool isCompleted = false, bool isCurrent = false, bool isLocked = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primaryLight : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isCurrent ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        children: [
          if (isCurrent)
            const Icon(Icons.equalizer_rounded, color: AppColors.primary)
          else if (isCompleted)
            const Icon(Icons.check_circle_rounded, color: AppColors.success)
          else
            Icon(isLocked ? Icons.lock_outline_rounded : Icons.play_circle_outline_rounded, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
          Text(duration, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
