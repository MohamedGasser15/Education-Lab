import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.isLoggedIn = false,
    this.userName = '',
  });

  final bool isLoggedIn;
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 75, 16, 150),
        children: [
          _buildGreetingRow(),
          const SizedBox(height: 24),
          _buildHeroBanner(),
          const SizedBox(height: 24),
          if (widget.isLoggedIn) ...[
            _buildContinueLearning(),
            const SizedBox(height: 24),
          ],
          _buildFeaturedCourses(),
          const SizedBox(height: 24),
          _buildCategories(),
          const SizedBox(height: 24),
          _buildNewCourses(),
          const SizedBox(height: 24),
          _buildWhyChooseUs(),
          const SizedBox(height: 24),
          _buildLearningPaths(),
          const SizedBox(height: 24),
          _buildInstructorsSection(),
          const SizedBox(height: 24),
          _buildStatistics(),
          const SizedBox(height: 24),
          _buildCTA(),
        ],
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1D61E7), Color(0xFF134BB8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: widget.isLoggedIn
                  ? Text(
                      widget.userName.isNotEmpty ? widget.userName[0] : 'م',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Icon(Icons.school, color: Colors.white, size: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isLoggedIn
                    ? (widget.userName.isNotEmpty ? 'مرحباً، ${widget.userName}' : 'مرحباً بك')
                    : 'مرحباً بك في EduLab',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Text(
                'استمر في رحلة التعلم',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (widget.isLoggedIn)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF64748B),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1D61E7).withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D61E7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'ابدأ رحلة التعلم',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اكتشف عالماً من\nالدورات والخبرات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'انضم لآلاف الطلاب وطور مهاراتك مع أفضل المدربين',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D61E7), Color(0xFF134BB8)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'استكشف الدورات',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'المسارات',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildContinueLearning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'استمر في التعلم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D61E7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Color(0xFF1D61E7),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'جاري التعلم',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'أساسيات تطوير تطبيقات Flutter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.75,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF1D61E7),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '75%',
                          style: TextStyle(
                            color: Color(0xFF1D61E7),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D61E7), Color(0xFF134BB8)],
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الدورات المميزة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'اكتشف أفضل الدورات التعليمية',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: Color(0xFF1D61E7)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final courses = [
                {
                  'title': 'تطوير تطبيقات Flutter',
                  'instructor': 'أحمد محمد',
                  'rating': 4.8,
                  'price': '\$49.99',
                  'color': const Color(0xFF1D61E7),
                },
                {
                  'title': 'تصميم UI/UX احترافي',
                  'instructor': 'سارة أحمد',
                  'rating': 4.9,
                  'price': '\$39.99',
                  'color': const Color(0xFF06B6D4),
                },
                {
                  'title': 'الذكاء الاصطناعي',
                  'instructor': 'خالد العلي',
                  'rating': 4.7,
                  'price': '\$59.99',
                  'color': const Color(0xFF8B5CF6),
                },
                {
                  'title': 'تطوير تطبيقات iOS',
                  'instructor': 'محمد سعيد',
                  'rating': 4.6,
                  'price': '\$44.99',
                  'color': const Color(0xFF059669),
                },
              ];
              final course = courses[index];
              return _CourseCard(
                title: course['title'] as String,
                instructor: course['instructor'] as String,
                rating: course['rating'] as double,
                price: course['price'] as String,
                accentColor: course['color'] as Color,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWhyChooseUs() {
    final features = [
      {
        'icon': Icons.school_outlined,
        'title': 'مدربين متخصصين',
        'subtitle': 'خبراء بخبرة عملية في مجالاتهم',
        'color': const Color(0xFF1D61E7),
        'bg': const Color(0xFFEFF4FF),
      },
      {
        'icon': Icons.schedule_outlined,
        'title': 'تعلم في أي وقت',
        'subtitle': 'وصول مدى الحياة لأي دورة',
        'color': const Color(0xFF06B6D4),
        'bg': const Color(0xFFECFEFF),
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'شهادات معتمدة',
        'subtitle': 'شهادة إتمام معتمدة دولياً',
        'color': const Color(0xFF8B5CF6),
        'bg': const Color(0xFFF5F3FF),
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'دعم مستمر',
        'subtitle': 'مساعدة على مدار الساعة',
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFECFDF5),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'لماذا تختارنا؟',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: features.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final f = features[index];
              return Container(
                width: 155,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (f['color'] as Color).withValues(alpha: 0.08),
                      (f['color'] as Color).withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (f['color'] as Color).withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: f['bg'] as Color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        f['icon'] as IconData,
                        color: f['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      f['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      f['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الدورات الجديدة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'أحدث الدورات المضافة',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: Color(0xFF06B6D4)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final courses = [
                {
                  'title': 'React Native من الصفر',
                  'instructor': 'عمر حسين',
                  'rating': 4.5,
                  'price': '\$34.99',
                  'color': const Color(0xFF06B6D4),
                },
                {
                  'title': 'تحليل البيانات',
                  'instructor': 'فاطمة خالد',
                  'rating': 4.8,
                  'price': '\$54.99',
                  'color': const Color(0xFF0EA5E9),
                },
                {
                  'title': 'أمن المعلومات',
                  'instructor': 'يوسف أحمد',
                  'rating': 4.7,
                  'price': '\$64.99',
                  'color': const Color(0xFF0284C7),
                },
                {
                  'title': 'تطوير الواجهات',
                  'instructor': 'نورا سعيد',
                  'rating': 4.4,
                  'price': '\$29.99',
                  'color': const Color(0xFF0891B2),
                },
              ];
              final course = courses[index];
              return _CourseCard(
                title: course['title'] as String,
                instructor: course['instructor'] as String,
                rating: course['rating'] as double,
                price: course['price'] as String,
                accentColor: course['color'] as Color,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPaths() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مسارات التعلم',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'مسارات منظمة لتحقيق أهدافك',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 12),
        _LearningPathCard(
          title: 'تطبيقات الموبايل',
          subtitle: 'ابنِ تطبيقات احترافية',
          coursesCount: 12,
          icon: Icons.phone_android,
          gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        ),
        const SizedBox(height: 10),
        _LearningPathCard(
          title: 'تصميم UI/UX',
          subtitle: 'صمم واجهات جذابة',
          coursesCount: 8,
          icon: Icons.design_services_outlined,
          gradientColors: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
        ),
        const SizedBox(height: 10),
        _LearningPathCard(
          title: 'تطوير الويب',
          subtitle: 'أتمتة وتطوير مواقع',
          coursesCount: 15,
          icon: Icons.web_outlined,
          gradientColors: const [Color(0xFF1D61E7), Color(0xFF134BB8)],
        ),
      ],
    );
  }

  Widget _buildInstructorsSection() {
    final instructors = [
      {'name': 'أحمد محمد', 'role': 'مطور Flutter', 'color': const Color(0xFF1D61E7), 'courses': 12, 'students': '3.2K'},
      {'name': 'سارة أحمد', 'role': 'مصممة UI/UX', 'color': const Color(0xFF06B6D4), 'courses': 8, 'students': '2.8K'},
      {'name': 'خالد العلي', 'role': 'خبير AI', 'color': const Color(0xFF8B5CF6), 'courses': 10, 'students': '4.1K'},
      {'name': 'محمد سعيد', 'role': 'مطور iOS', 'color': const Color(0xFF059669), 'courses': 6, 'students': '1.9K'},
      {'name': 'نور حسين', 'role': 'محللة بيانات', 'color': const Color(0xFFD97706), 'courses': 7, 'students': '2.3K'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'المدربون',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'تعلم من أفضل الخبراء',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: instructors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final inst = instructors[index];
              final color = inst['color'] as Color;
              return Container(
                width: 150,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.8), color],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (inst['name'] as String)[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      inst['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      inst['role'] as String,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${inst['courses']} دورة • ${inst['students']}',

                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1D61E7).withValues(alpha: 0.06),
            const Color(0xFF06B6D4).withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1D61E7).withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            number: '+10K',
            label: 'طالب مسجل',
            icon: Icons.people_outline,
            color: const Color(0xFF1D61E7),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
          _StatItem(
            number: '+50',
            label: 'دورة تدريبية',
            icon: Icons.play_circle_outline,
            color: const Color(0xFF06B6D4),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
          _StatItem(
            number: '+20',
            label: 'مدرب خبير',
            icon: Icons.school_outlined,
            color: const Color(0xFF8B5CF6),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
          _StatItem(
            number: '%98',
            label: 'نسبة الرضا',
            icon: Icons.sentiment_very_satisfied_outlined,
            color: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2563EB).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            left: -15,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF06B6D4).withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch_outlined, size: 14, color: Color(0xFF60A5FA)),
                    SizedBox(width: 6),
                    Text(
                      'مجاناً بالكامل',
                      style: TextStyle(fontSize: 12, color: Color(0xFF60A5FA), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'ابدأ رحلتك التعليمية اليوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'انضم لآلاف الطلاب وطور مهاراتك\nمع أفضل المدربين في المنطقة العربية',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'سجّل الآن مجاناً',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    'لا حاجة لبطاقة ائتمان',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.check_circle_outline, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    'وصول فوري',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      _CategoryData('تطوير الويب', Icons.web_outlined, const Color(0xFF2563EB), const Color(0xFFEFF4FF)),
      _CategoryData('تطوير الموبايل', Icons.phone_android, const Color(0xFF059669), const Color(0xFFECFDF5)),
      _CategoryData('تصميم UI/UX', Icons.design_services_outlined, const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
      _CategoryData('الذكاء الاصطناعي', Icons.psychology_outlined, const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
      _CategoryData('التسويق الرقمي', Icons.campaign_outlined, const Color(0xFFD97706), const Color(0xFFFFFBEB)),
      _CategoryData('إدارة المشاريع', Icons.task_outlined, const Color(0xFF0891B2), const Color(0xFFECFEFF)),
      _CategoryData('الأمن السيبراني', Icons.shield_outlined, const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
      _CategoryData('قواعد البيانات', Icons.storage_outlined, const Color(0xFFBE185D), const Color(0xFFFDF2F8)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'الأقسام',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: (categories.length / 2).ceil(),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final first = categories[index * 2];
              final second = (index * 2 + 1 < categories.length)
                  ? categories[index * 2 + 1]
                  : null;
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    _CategoryCard(data: first),
                    const SizedBox(height: 10),
                    if (second != null)
                      _CategoryCard(data: second)
                    else
                      const Spacer(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final double rating;
  final String price;
  final Color accentColor;

  const _CourseCard({
    required this.title,
    required this.instructor,
    required this.rating,
    required this.price,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.8),
                  accentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white.withValues(alpha: 0.9),
                size: 40,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < rating.floor()
                              ? Icons.star
                              : (index < rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                          color: const Color(0xFFFBBF24),
                          size: 14,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D61E7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningPathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int coursesCount;
  final IconData icon;
  final List<Color> gradientColors;

  const _LearningPathCard({
    required this.title,
    required this.subtitle,
    required this.coursesCount,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: gradientColors[0].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$coursesCount دورة',
              style: TextStyle(
                color: gradientColors[0],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF64748B),
          ),
        ],
      ),
    );
  }
}

class _CategoryData {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _CategoryData(this.title, this.icon, this.color, this.bgColor);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryData data;

  const _CategoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.number,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}