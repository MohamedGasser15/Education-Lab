import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

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
  int _selectedCategoryIndex = 0;
  final Set<String> _wishlistedCourseIds = {'c1', 'c3'};

  final List<String> _categories = [
    'الكل',
    'تطوير الويب',
    'تطبيقات الموبايل',
    'الذكاء الاصطناعي',
    'تصميم UI/UX',
    'إدارة الأعمال',
    'الأمن السيبراني',
    'علوم البيانات',
  ];

  final List<String> _popularTopics = [
    'Flutter',
    'Python',
    'React JS',
    'Figma',
    'ASP.NET Core',
    'Docker & Kubernetes',
    'Machine Learning',
    'Cyber Security',
    'Excel & PowerBI',
    'Node.js',
  ];

  final List<Map<String, dynamic>> _bestsellerCourses = [
    {
      'id': 'c1',
      'title': 'The Complete Flutter & Dart Development Guide [2026]',
      'arabicTitle': 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart',
      'instructor': 'م. أحمد محمد',
      'rating': 4.8,
      'reviews': '18,420',
      'price': '49.99 \$',
      'originalPrice': '84.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى مبيعاً',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF1D61E7), Color(0xFF2563EB)],
      'icon': Icons.flutter_dash_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'c2',
      'title': 'Figma UI/UX Design Essentials: From Zero to Pro',
      'arabicTitle': 'تصميم واجهات وتجربة المستخدم من الصفر حتى الاحتراف بـ Figma',
      'instructor': 'سارة أحمد',
      'rating': 4.9,
      'reviews': '9,850',
      'price': '39.99 \$',
      'originalPrice': '69.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى تقييماً',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'icon': Icons.brush_rounded,
      'accentColor': Color(0xFF3B82F6),
    },
    {
      'id': 'c3',
      'title': 'Building Enterprise Cloud Apps with ASP.NET Core & Microservices',
      'arabicTitle': 'بناء التطبيقات المؤسسية الحديثة بـ ASP.NET Core و Microservices',
      'instructor': 'د. خالد العلي',
      'rating': 4.8,
      'reviews': '12,300',
      'price': '54.99 \$',
      'originalPrice': '99.99 \$',
      'isBestseller': false,
      'badgeText': 'جديد ومميز',
      'badgeColor': Color(0xFFECFDF5),
      'badgeTextColor': Color(0xFF065F46),
      'gradient': [Color(0xFF134BB8), Color(0xFF1D61E7)],
      'icon': Icons.cloud_done_rounded,
      'accentColor': AppColors.primaryDark,
    },
    {
      'id': 'c4',
      'title': 'Mastering LLMs, Generative AI & Deep Learning with Python',
      'arabicTitle': 'احتراف نماذج الذكاء الاصطناعي التوليدي والتعلم العميق بـ Python',
      'instructor': 'م. يوسف محمود',
      'rating': 4.7,
      'reviews': '6,140',
      'price': '59.99 \$',
      'originalPrice': '89.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى مبيعاً',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF0F172A), Color(0xFF334155)],
      'icon': Icons.auto_awesome_rounded,
      'accentColor': AppColors.primary,
    },
  ];

  final List<Map<String, dynamic>> _recommendedCourses = [
    {
      'id': 'r1',
      'title': 'Clean Architecture & Unit Testing in Modern Mobile Apps',
      'arabicTitle': 'المعمارية النظيفة Clean Architecture واختبار الكود للتطبيقات',
      'instructor': 'م. أحمد محمد',
      'rating': 4.9,
      'reviews': '4,520',
      'price': '34.99 \$',
      'originalPrice': '59.99 \$',
      'isBestseller': false,
      'badgeText': 'موصى به لك',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF1D61E7), Color(0xFF3B82F6)],
      'icon': Icons.verified_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'r2',
      'title': 'Complete Ethical Hacking & Cyber Security Bootcamp',
      'arabicTitle': 'المعسكر الشامل لاختبار الاختراق والأمن السيبراني الأخلاقي',
      'instructor': 'م. عمر طارق',
      'rating': 4.8,
      'reviews': '8,900',
      'price': '44.99 \$',
      'originalPrice': '79.99 \$',
      'isBestseller': true,
      'badgeText': 'الأعلى مبيعاً',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'icon': Icons.security_rounded,
      'accentColor': Color(0xFF10B981),
    },
    {
      'id': 'r3',
      'title': 'Data Science & Machine Learning Real-World Projects',
      'arabicTitle': 'مشاريع عملية متقدمة في علوم البيانات وتحليل الأعمال بـ Python',
      'instructor': 'د. سارة عثمان',
      'rating': 4.7,
      'reviews': '3,780',
      'price': '49.99 \$',
      'originalPrice': '84.99 \$',
      'isBestseller': false,
      'badgeText': 'تطبيقي وعملي',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF134BB8), Color(0xFF1E40AF)],
      'icon': Icons.insights_rounded,
      'accentColor': AppColors.primaryDark,
    },
  ];

  final List<Map<String, dynamic>> _newCourses = [
    {
      'id': 'n1',
      'title': 'Next.js 15 & Full-Stack Server Actions Bootcamp',
      'arabicTitle': 'احتراف تطوير تطبيقات الويب بـ Next.js 15 و React Server Actions',
      'instructor': 'م. كريم سامي',
      'rating': 4.9,
      'reviews': '1,280',
      'price': '44.99 \$',
      'originalPrice': '74.99 \$',
      'isBestseller': false,
      'badgeText': 'جديد وحصري',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'icon': Icons.rocket_launch_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'n2',
      'title': 'Advanced AI Agentic Systems with LangChain & AutoGen',
      'arabicTitle': 'بناء أنظمة الوكلاء الأذكياء AI Agents بـ LangChain و AutoGen',
      'instructor': 'م. يوسف محمود',
      'rating': 5.0,
      'reviews': '840',
      'price': '54.99 \$',
      'originalPrice': '89.99 \$',
      'isBestseller': false,
      'badgeText': 'أحدث إصدار',
      'badgeColor': Color(0xFFECFDF5),
      'badgeTextColor': Color(0xFF059669),
      'gradient': [Color(0xFF064E3B), Color(0xFF065F46)],
      'icon': Icons.auto_awesome_rounded,
      'accentColor': Color(0xFF10B981),
    },
    {
      'id': 'n3',
      'title': 'Modern Flutter State Management with Riverpod 3.0',
      'arabicTitle': 'إدارة الحالة المتقدمة في Flutter بـ Riverpod 3.0 و Architecture',
      'instructor': 'م. أحمد محمد',
      'rating': 4.9,
      'reviews': '1,920',
      'price': '39.99 \$',
      'originalPrice': '69.99 \$',
      'isBestseller': false,
      'badgeText': 'جديد ومميز',
      'badgeColor': Color(0xFFEFF4FF),
      'badgeTextColor': Color(0xFF1D61E7),
      'gradient': [Color(0xFF1D61E7), Color(0xFF2563EB)],
      'icon': Icons.flutter_dash_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'n4',
      'title': 'Hands-on Cloud DevOps & CI/CD with Kubernetes & GitHub Actions',
      'arabicTitle': 'التطبيق العملي لـ DevOps و CI/CD بـ Kubernetes و GitHub Actions',
      'instructor': 'د. خالد العلي',
      'rating': 4.8,
      'reviews': '950',
      'price': '49.99 \$',
      'originalPrice': '79.99 \$',
      'isBestseller': false,
      'badgeText': 'حديث ومكثف',
      'badgeColor': Color(0xFFFEF3C7),
      'badgeTextColor': Color(0xFF92400E),
      'gradient': [Color(0xFF134BB8), Color(0xFF1D61E7)],
      'icon': Icons.cloud_sync_rounded,
      'accentColor': AppColors.primaryDark,
    },
  ];

  final List<Map<String, dynamic>> _topInstructors = [
    {
      'name': 'م. أحمد محمد',
      'role': 'Senior Flutter & Mobile Architect',
      'rating': 4.9,
      'students': '48,200',
      'coursesCount': 12,
      'initial': 'أ',
      'color': AppColors.primary,
    },
    {
      'name': 'سارة أحمد',
      'role': 'Lead Product & UI/UX Designer',
      'rating': 4.9,
      'students': '32,400',
      'coursesCount': 8,
      'initial': 'س',
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'د. خالد العلي',
      'role': 'Cloud Architect & Microsoft MVP',
      'rating': 4.8,
      'students': '61,900',
      'coursesCount': 15,
      'initial': 'خ',
      'color': AppColors.primaryDark,
    },
    {
      'name': 'م. يوسف محمود',
      'role': 'AI & Machine Learning Specialist',
      'rating': 4.7,
      'students': '29,100',
      'coursesCount': 9,
      'initial': 'ي',
      'color': Color(0xFF0284C7),
    },
  ];

  final List<Map<String, dynamic>> _exploreCategories = [
    {'title': 'تطوير البرمجيات', 'icon': Icons.code_rounded, 'courses': '140+ دورة'},
    {'title': 'تطبيقات الموبايل', 'icon': Icons.phone_android_rounded, 'courses': '85+ دورة'},
    {'title': 'الذكاء الاصطناعي', 'icon': Icons.psychology_rounded, 'courses': '60+ دورة'},
    {'title': 'التصميم والجرافيك', 'icon': Icons.palette_rounded, 'courses': '55+ دورة'},
    {'title': 'الأعمال والريادة', 'icon': Icons.business_center_rounded, 'courses': '40+ دورة'},
    {'title': 'الأمن السيبراني', 'icon': Icons.shield_rounded, 'courses': '35+ دورة'},
  ];

  void _toggleWishlist(String id) {
    setState(() {
      if (_wishlistedCourseIds.contains(id)) {
        _wishlistedCourseIds.remove(id);
      } else {
        _wishlistedCourseIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Top Header Bar with EduLab Colors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _buildEduLabTopBar(),
              ),
            ),

            // 2. Search Box
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: _buildEduLabSearchBar(),
              ),
            ),

            // 3. EduLab Signature Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: _buildEduLabPromoBanner(),
              ),
            ),

            // 4. In-Progress Course (Continue Learning for Enrolled / Logged-in Users)
            if (widget.isLoggedIn)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _buildContinueLearningSection(),
                ),
              ),

            // 5. Horizontal Category Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildCategoryChips(),
              ),
            ),

            // 6. Section 1: "Top Bestseller Courses" (الأعلى مبيعاً)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'الدورات الأكثر مبيعاً في EduLab',
                  subtitle: 'برامج تدريبية اختارها آلاف المتعلمين',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_bestsellerCourses),
              ),
            ),

            // 7. Section 2: Popular Topics (المواضيع الشائعة - 2 rows horizontal scroll)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'المواضيع الأكثر طلباً وبحثاً',
                  subtitle: 'المهارات والتقنيات الرائجة في سوق العمل الآن',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildPopularTopicsHorizontalList(),
              ),
            ),

            // 8. Section 3: "Recommended for You" (مقترحة لك)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'دورات مقترحة خصيصاً لك',
                  subtitle: 'بناءً على اهتماماتك ومسارك التعليمي',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_recommendedCourses),
              ),
            ),

            // 9. Section 4: Top Instructors (أفضل المدربين)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'نخبة المدربين المعتمدين',
                  subtitle: 'تعلم مباشرة من كبار المتخصصين والمهندسين',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildInstructorsHorizontalList(),
              ),
            ),

            // 10. Section 5: New Courses (أحدث الدورات المضافة)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'أحدث الدورات التدريبية المضافة',
                  subtitle: 'محتوى متجدد يواكب أحدث التقنيات وأدوات العصر',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_newCourses),
              ),
            ),

            // 11. Section 6: Explore by Category (تصفح المجالات)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: 'استكشف أهم المجالات',
                  subtitle: 'اختر مجالك وابدأ رحلتك التعليمية',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                child: _buildExploreCategoriesGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 1. EDULAB TOP BAR =================
  Widget _buildEduLabTopBar() {
    final displayName = widget.userName.trim().isNotEmpty
        ? widget.userName.trim()
        : (widget.isLoggedIn ? 'طالبنا العزيز' : 'زائرنا');

    return Row(
      children: [
        // Brand Title / Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.isLoggedIn ? 'مرحباً، $displayName' : 'EduLab',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.waving_hand_rounded,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                ],
              ),
              if (widget.isLoggedIn)
                const Text(
                  'جاهز لتعلم مهارة جديدة اليوم؟',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
            ],
          ),
        ),

        // Action: Wishlist
        Stack(
          children: [
            IconButton(
              tooltip: 'قائمة الرغبات',
              onPressed: () => Navigator.pushNamed(context, '/wishlist'),
              icon: const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
            ),
            if (_wishlistedCourseIds.isNotEmpty)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 6),

        // Action: Notifications with unread indicator
        Stack(
          children: [
            IconButton(
              tooltip: 'الإشعارات',
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),

        // Action: Cart
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/cart'),
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.textPrimary,
            size: 24,
          ),
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  // ================= 2. EDULAB SEARCH BAR =================
  Widget _buildEduLabSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
          Expanded(
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن أي دورة، مسار، أو مهارة...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13.5,
                  fontFamily: 'Tajawal',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 3. EDULAB PROMO BANNER =================
  Widget _buildEduLabPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 13,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'عرض خاص لفترة محدودة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'تعلّم مهارات تفتح لك أبواب المستقبل',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              fontFamily: 'Tajawal',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'دورات تدريبية شاملة تبدأ من 29.99 \$ فقط مع نخبة المهندسين',
            style: TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 12,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'استكشف العروض الآن',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= 4. IN-PROGRESS / MY LEARNING =================
  Widget _buildContinueLearningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'استمر في التعلم',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'دوراتي',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الدليل الشامل لتطوير تطبيقات Flutter و Dart',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'م. أحمد محمد • الدرس 14',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.72,
                        backgroundColor: Color(0xFFEFF4FF),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= 5. CATEGORY CHIPS =================
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= 6. SECTION HEADER =================
  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  // ================= 7. SIGNATURE COURSE CARD =================
  Widget _buildCoursesHorizontalList(List<Map<String, dynamic>> courses) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final course = courses[index];
          final isWishlisted = _wishlistedCourseIds.contains(course['id']);
          final gradient = course['gradient'] as List<Color>;

          return Container(
            width: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 16:9 Thumbnail
                Container(
                  height: 105,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          course['icon'] as IconData,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 38,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: GestureDetector(
                          onTap: () => _toggleWishlist(course['id'] as String),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                isWishlisted ? Icons.favorite : Icons.favorite_border,
                                color: isWishlisted ? const Color(0xFFEF4444) : AppColors.textPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title (2 Lines max)
                      Text(
                        course['arabicTitle'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Tajawal',
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),

                      // Instructor
                      Text(
                        course['instructor'] as String,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Rating Row (Udemy style: Rating Number + Stars + Count)
                      Row(
                        children: [
                          Text(
                            course['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB4690E), // Udemy rating gold
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 4),
                          ...List.generate(5, (starIdx) {
                            return const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: Color(0xFFE59819),
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            '(${course['reviews']})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            course['price'] as String,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            course['originalPrice'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          // Badge (Bestseller or Highest Rated)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: course['badgeColor'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course['badgeText'] as String,
                              style: TextStyle(
                                color: course['badgeTextColor'] as Color,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= 8. POPULAR TOPICS (2-ROW HORIZONTAL SCROLL) =================
  Widget _buildPopularTopicsHorizontalList() {
    final columnCount = (_popularTopics.length / 2).ceil();

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: columnCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, colIndex) {
          final topIndex = colIndex * 2;
          final bottomIndex = topIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopicChip(_popularTopics[topIndex]),
              const SizedBox(height: 8),
              if (bottomIndex < _popularTopics.length)
                _buildTopicChip(_popularTopics[bottomIndex])
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        topic,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  // ================= 9. TOP INSTRUCTORS =================
  Widget _buildInstructorsHorizontalList() {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _topInstructors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final instructor = _topInstructors[index];
          final color = instructor['color'] as Color;

          return Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color,
                  child: Text(
                    instructor['initial'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  instructor['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  instructor['role'] as String,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 11, color: Color(0xFFE59819)),
                    const SizedBox(width: 3),
                    Text(
                      instructor['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB4690E),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${instructor['students']} طالب',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= 10. EXPLORE CATEGORIES GRID =================
  Widget _buildExploreCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemCount: _exploreCategories.length,
      itemBuilder: (context, index) {
        final cat = _exploreCategories[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(
                cat['icon'] as IconData,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat['title'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cat['courses'] as String,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}