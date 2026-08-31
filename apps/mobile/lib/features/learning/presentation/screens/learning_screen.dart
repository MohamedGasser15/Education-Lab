import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'تعلمي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الدورات الحالية'),
            Tab(text: 'الشهادات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
            children: [
              _buildActiveCourseCard(
                title: 'الرياضيات المتقدمة: الجبر الخطي',
                instructor: 'البروفيسور أحمد سالم • 12 وحدة',
                progress: 0.60,
                progressText: '60%',
                imageUrl:
                    'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800',
                showContinueButton: true,
              ),
              const SizedBox(height: 16),
              _buildActiveCourseCard(
                title: 'أساسيات تصميم واجهة المستخدم (UI/UX)',
                instructor: 'سارة محمد • 8 وحدات',
                progress: 0.20,
                progressText: '20%',
                imageUrl:
                    'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=800',
                showContinueButton: true,
              ),
              const SizedBox(height: 16),
              _buildActiveCourseCard(
                title: 'مقدمة في الذكاء الاصطناعي',
                instructor: 'د. خالد عبدالله • 24 وحدة',
                progress: 0.85,
                progressText: '85%',
                imageUrl:
                    'https://images.unsplash.com/photo-1677442136019-21780efad99a?w=800',
                showContinueButton: true,
              ),
            ],
          ),
          const Center(child: Text('لا توجد شهادات صادرة حتى الآن')),
        ],
      ),
    );
  }

  Widget _buildActiveCourseCard({
    required String title,
    required String instructor,
    required double progress,
    required String progressText,
    required String imageUrl,
    bool showContinueButton = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/lesson-player'),
        borderRadius: BorderRadius.circular(20),
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
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'مستمر',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'التقدم',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        progressText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  if (showContinueButton) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/lesson-player'),
                        child: const Text('متابعة التعلم'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
