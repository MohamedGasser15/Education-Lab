import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/screens/explore_screen.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:provider/provider.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  final Set<String> _wishlistedCourseIds = {'c1', 'c3'};
  late final PageController _promoPageController;
  int _currentPromoIndex = 0;
  Timer? _promoTimer;
  late final AnimationController _ambientController;
  late final AnimationController _pulseController;

  int _searchHintIndex = 0;
  Timer? _searchHintTimer;

  final List<String> _trendingSearchHints = [
    'Flutter & Dart...',
    'Python & AI...',
    'UI/UX Design & Figma...',
    'Full-Stack Web...',
    'Cyber Security...',
    'Data Science & SQL...',
  ];

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController(viewportFraction: 0.92);
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _startPromoTimer();

    _searchHintTimer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (mounted) {
        setState(() {
          _searchHintIndex = (_searchHintIndex + 1) % _trendingSearchHints.length;
        });
      }
    });
  }

  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_promoPageController.hasClients) {
        final nextIndex = (_currentPromoIndex + 1) % 3;
        _promoPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchHintTimer?.cancel();
    _promoTimer?.cancel();
    _promoPageController.dispose();
    _ambientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

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
      'students': '32,100',
      'coursesCount': 8,
      'initial': 'س',
      'color': Color(0xFF0F172A),
    },
    {
      'name': 'م. يوسف محمود',
      'role': 'AI & Machine Learning Specialist',
      'rating': 4.8,
      'students': '24,500',
      'coursesCount': 6,
      'initial': 'ي',
      'color': Color(0xFF059669),
    },
    {
      'name': 'د. خالد العلي',
      'role': 'Principal Enterprise Cloud Architect',
      'rating': 4.8,
      'students': '19,800',
      'coursesCount': 9,
      'initial': 'خ',
      'color': Color(0xFF134BB8),
    },
  ];

  final List<Map<String, dynamic>> _exploreCategories = [
    {
      'title': 'تطوير البرمجيات والويب',
      'subtitle': 'Web & Mobile',
      'icon': Icons.code_rounded,
      'courses': '140+ دورة',
      'color': Color(0xFF1D61E7),
    },
    {
      'title': 'الذكاء الاصطناعي والبيانات',
      'subtitle': 'AI & Data Science',
      'icon': Icons.psychology_rounded,
      'courses': '85+ دورة',
      'color': Color(0xFF7C3AED),
    },
    {
      'title': 'التصميم وتجربة المستخدم',
      'subtitle': 'UI/UX Design',
      'icon': Icons.palette_rounded,
      'courses': '65+ دورة',
      'color': Color(0xFFDB2777),
    },
    {
      'title': 'إدارة الأعمال والريادة',
      'subtitle': 'Business & Finance',
      'icon': Icons.business_center_rounded,
      'courses': '50+ دورة',
      'color': Color(0xFFD97706),
    },
    {
      'title': 'الأمن السيبراني والشبكات',
      'subtitle': 'Cyber Security',
      'icon': Icons.shield_rounded,
      'courses': '42+ دورة',
      'color': Color(0xFF059669),
    },
    {
      'title': 'التسويق الرقمي والنمو',
      'subtitle': 'Digital Marketing',
      'icon': Icons.campaign_rounded,
      'courses': '38+ دورة',
      'color': Color(0xFF0284C7),
    },
  ];

  void _toggleWishlist(String courseId) {
    setState(() {
      if (_wishlistedCourseIds.contains(courseId)) {
        _wishlistedCourseIds.remove(courseId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت إزالة الدورة من قائمة الرغبات'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1400),
          ),
        );
      } else {
        _wishlistedCourseIds.add(courseId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت إضافة الدورة إلى قائمة الرغبات بنجاح'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1400),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Top Status Bar Spacer (scrolls away smoothly with content)
          SliverToBoxAdapter(
            child: SizedBox(height: topPadding),
          ),

          // 1. EduLab Top Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildEduLabTopBar(textColor, textSubColor),
            ),
          ),

            // 2. EduLab Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: _buildEduLabSearchBar(inputFill, borderColor, textColor),
              ),
            ),

            // 3. EduLab Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: _buildEduLabPromoBanner(),
              ),
            ),

            // 4. "Continue Learning"
            if (widget.isLoggedIn)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _buildContinueLearningSection(cardBg, borderColor, textColor, textSubColor),
                ),
              ),

            // 5. Category Chips Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildCategoryChips(cardBg, borderColor, textColor, isDark),
              ),
            ),

            // 6. Section 1: "Students are Viewing / Bestsellers"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: context.loc.homeBestsellersTitle,
                  subtitle: context.loc.homeBestsellersSubtitle,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_bestsellerCourses, cardBg, borderColor, textColor, textSubColor, isDark),
              ),
            ),

            // 7. Section 2: Popular Topics
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: context.loc.homePopularTopicsTitle,
                  subtitle: context.loc.homePopularTopicsSubtitle,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildPopularTopicsHorizontalList(cardBg, borderColor, textColor, isDark),
              ),
            ),

            // 8. Section 3: "Recommended for You"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: context.loc.homeRecommendedTitle,
                  subtitle: context.loc.homeRecommendedSubtitle,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_recommendedCourses, cardBg, borderColor, textColor, textSubColor, isDark),
              ),
            ),

            // 9. Section 4: Top Instructors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: context.loc.homeTopInstructorsTitle,
                  subtitle: context.loc.homeTopInstructorsSubtitle,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildInstructorsHorizontalList(cardBg, borderColor, textColor, textSubColor),
              ),
            ),

            // 10. Section 5: New Courses
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(
                  title: context.loc.homeNewCoursesTitle,
                  subtitle: context.loc.homeNewCoursesSubtitle,
                  textColor: textColor,
                  textSubColor: textSubColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: _buildCoursesHorizontalList(_newCourses, cardBg, borderColor, textColor, textSubColor, isDark),
              ),
            ),

            // 11. Section 6: Explore by Category
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      title: context.loc.homeExploreCategoriesTitle,
                      subtitle: context.loc.homeExploreCategoriesSubtitle,
                      textColor: textColor,
                      textSubColor: textSubColor,
                    ),
                    const SizedBox(height: 12),
                    _buildExploreCategoriesGrid(cardBg, borderColor, textColor, textSubColor, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  // ================= 1. EDULAB TOP BAR =================
  // ================= 1. EDULAB TOP BAR =================
  Widget _buildEduLabTopBar(Color textColor, Color textSubColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final isUserLoggedIn = profileProvider.isLoggedIn || widget.isLoggedIn;
    final displayName = (profile != null && profile.displayName.isNotEmpty)
        ? profile.displayName
        : (widget.userName.trim().isNotEmpty
            ? widget.userName.trim()
            : (isUserLoggedIn ? context.loc.homeDefaultUser : context.loc.homeVisitor));

    final hasAvatar = profile != null && profile.hasAvatar;

    return Row(
      children: [
        // 1. User Avatar / Brand Icon
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pushNamed(context, '/profile');
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isUserLoggedIn
                        ? [const Color(0xFF1D61E7), const Color(0xFF3B82F6)]
                        : [const Color(0xFF475569), const Color(0xFF64748B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isUserLoggedIn ? AppColors.primary : Colors.black).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: hasAvatar
                      ? CachedNetworkImage(
                          imageUrl: profile.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/default_avatar.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/default_avatar.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              if (isUserLoggedIn)
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // 2. Greeting Headline & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isUserLoggedIn ? context.loc.homeGreeting(displayName) : 'EduLab',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (isUserLoggedIn)
                    const Icon(
                      Icons.waving_hand_rounded,
                      size: 16,
                      color: Color(0xFFF59E0B),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded, size: 11, color: AppColors.primary),
                          SizedBox(width: 3),
                          Text(
                            'Edu',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 1.5),
              Text(
                isUserLoggedIn ? context.loc.homeSubGreeting : 'منصة التعلم الذكي وتطوير المهارات',
                style: TextStyle(
                  fontSize: 11.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // 3. Action Buttons with Rounded Boxes
        _buildTopBarActionButton(
          tooltip: context.loc.profileWishlist,
          icon: Icons.favorite_border_rounded,
          badgeColor: _wishlistedCourseIds.isNotEmpty ? const Color(0xFFEF4444) : null,
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          onTap: () => Navigator.pushNamed(context, '/wishlist'),
        ),
        const SizedBox(width: 6),

        _buildTopBarActionButton(
          tooltip: context.loc.notificationsTitle,
          icon: Icons.notifications_none_rounded,
          badgeColor: AppColors.primary,
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 6),

        _buildTopBarActionButton(
          tooltip: context.loc.cartTitle,
          icon: Icons.shopping_cart_outlined,
          badgeColor: null,
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          onTap: () => Navigator.pushNamed(context, '/cart'),
        ),
      ],
    );
  }

  Widget _buildTopBarActionButton({
    required String tooltip,
    required IconData icon,
    required Color? badgeColor,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: textColor, size: 20),
                if (badgeColor != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6.5,
                      height: 6.5,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= 2. EDULAB SEARCH BAR =================
  Widget _buildEduLabSearchBar(Color inputFill, Color borderColor, Color textColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: 'app_search_bar',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openSearchScreen(context),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),

                // Animated Rotating Trending Search Hint
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.4),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      key: ValueKey<int>(_searchHintIndex),
                      children: [
                        Text(
                          '${context.loc.homeSearchHint.split('...').first.trim()}: ',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.6),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _trendingSearchHints[_searchHintIndex],
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter Action Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5.5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.loc.homeSearchFilter,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSearchScreen(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ExploreScreen(autoFocusSearch: true, isTab: false),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  // ================= 3. EDULAB PROMO BANNER (UDEMY STYLE) =================
  Widget _buildEduLabPromoBanner() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final slides = [
      // Slide 1: Big Season Sale & Discount (Udemy Flash Sale style)
      {
        'cardBgLight': const Color(0xFF0F172A),
        'cardBgDark': const Color(0xFF0F172A),
        'borderLight': const Color(0xFF1E293B),
        'borderDark': const Color(0xFF334155),
        'badgeBg': const Color(0xFF2563EB).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF3B82F6).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFF93C5FD),
        'badgeIcon': Icons.timer_outlined,
        'badgeText': context.loc.homePromo1Badge,
        'title': context.loc.homePromo1Title,
        'subtitle': context.loc.homePromo1Subtitle,
        'btnText': context.loc.homePromo1Button,
        'btnBg': const Color(0xFF2563EB),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF1E293B),
        'iconContainerBorder': const Color(0xFF334155),
        'icon': Icons.local_offer_rounded,
        'iconColor': const Color(0xFF60A5FA),
        'onTap': () {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(context, '/explore');
        },
      },
      // Slide 2: Career Roadmap & Certified Skills (Udemy Career Track style)
      {
        'cardBgLight': const Color(0xFF064E3B),
        'cardBgDark': const Color(0xFF064E3B),
        'borderLight': const Color(0xFF065F46),
        'borderDark': const Color(0xFF047857),
        'badgeBg': const Color(0xFF10B981).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF34D399).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFFA7F3D0),
        'badgeIcon': Icons.workspace_premium_rounded,
        'badgeText': context.loc.homePromo2Badge,
        'title': context.loc.homePromo2Title,
        'subtitle': context.loc.homePromo2Subtitle,
        'btnText': context.loc.homePromo2Button,
        'btnBg': const Color(0xFF059669),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF065F46),
        'iconContainerBorder': const Color(0xFF047857),
        'icon': Icons.school_rounded,
        'iconColor': const Color(0xFF6EE7B7),
        'onTap': () {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(context, '/explore');
        },
      },
      // Slide 3: Learn from Top Instructors (Udemy Instructors style)
      {
        'cardBgLight': const Color(0xFF1E1B4B),
        'cardBgDark': const Color(0xFF1E1B4B),
        'borderLight': const Color(0xFF312E81),
        'borderDark': const Color(0xFF4338CA),
        'badgeBg': const Color(0xFF6366F1).withValues(alpha: 0.25),
        'badgeBorder': const Color(0xFF818CF8).withValues(alpha: 0.4),
        'badgeTextColor': const Color(0xFFC7D2FE),
        'badgeIcon': Icons.stars_rounded,
        'badgeText': context.loc.homePromo3Badge,
        'title': context.loc.homePromo3Title,
        'subtitle': context.loc.homePromo3Subtitle,
        'btnText': context.loc.homePromo3Button,
        'btnBg': const Color(0xFF4F46E5),
        'btnTextColor': Colors.white,
        'iconContainerBg': const Color(0xFF312E81),
        'iconContainerBorder': const Color(0xFF4338CA),
        'icon': Icons.cast_for_education_rounded,
        'iconColor': const Color(0xFFA5B4FC),
        'onTap': () {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(context, '/explore');
        },
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: AnimatedBuilder(
            animation: _promoPageController,
            builder: (context, _) {
              return PageView.builder(
                controller: _promoPageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _currentPromoIndex = idx);
                  _startPromoTimer();
                },
                itemCount: slides.length,
                itemBuilder: (ctx, index) {
                  final slide = slides[index];

                  // Smooth page transition scale
                  double scale = 1.0;
                  if (_promoPageController.position.haveDimensions) {
                    final page = _promoPageController.page ?? _currentPromoIndex.toDouble();
                    final diff = (index - page).abs();
                    scale = (1.0 - (diff * 0.05)).clamp(0.95, 1.0);
                  }

                  final cardBg = (isDark ? slide['cardBgDark'] : slide['cardBgLight']) as Color;
                  final borderCol = (isDark ? slide['borderDark'] : slide['borderLight']) as Color;

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderCol,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Main Content Layout
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left side: Text & CTA Button
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                          decoration: BoxDecoration(
                                            color: slide['badgeBg'] as Color,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: slide['badgeBorder'] as Color,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                slide['badgeIcon'] as IconData,
                                                size: 12.5,
                                                color: slide['badgeTextColor'] as Color,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                slide['badgeText'] as String,
                                                style: TextStyle(
                                                  color: slide['badgeTextColor'] as Color,
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Tajawal',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Headline
                                        Text(
                                          slide['title'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Tajawal',
                                            height: 1.2,
                                          ),
                                        ),

                                        // Subtitle
                                        Text(
                                          slide['subtitle'] as String,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.82),
                                            fontSize: 11.5,
                                            fontFamily: 'Tajawal',
                                            height: 1.3,
                                          ),
                                        ),

                                        // CTA Button (Udemy Solid Pill Style)
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: slide['onTap'] as VoidCallback,
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                              decoration: BoxDecoration(
                                                color: slide['btnBg'] as Color,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: (slide['btnBg'] as Color).withValues(alpha: 0.35),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    slide['btnText'] as String,
                                                    style: TextStyle(
                                                      color: slide['btnTextColor'] as Color,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w900,
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    Directionality.of(context) == TextDirection.rtl
                                                        ? Icons.arrow_back_ios_new_rounded
                                                        : Icons.arrow_forward_ios_rounded,
                                                    size: 10,
                                                    color: slide['btnTextColor'] as Color,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // Right side: Clean Udemy-style Category / Feature Visual Card
                                  Container(
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      color: slide['iconContainerBg'] as Color,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: slide['iconContainerBorder'] as Color,
                                        width: 1.2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      slide['icon'] as IconData,
                                      size: 34,
                                      color: slide['iconColor'] as Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Dots Indicator (Clean Minimalist Udemy Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (i) {
            final isCurrent = i == _currentPromoIndex;
            return GestureDetector(
              onTap: () {
                _promoPageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: isCurrent ? 20 : 6,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ================= 4. IN-PROGRESS / MY LEARNING =================
  Widget _buildContinueLearningSection(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.homeContinueLearning,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/learning'),
              child: Text(
                context.loc.homeMyCoursesLink,
                style: const TextStyle(
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
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
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
                    Text(
                      'الدليل الشامل لتطوير تطبيقات Flutter و Dart',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'م. أحمد محمد • ${context.loc.homeLesson} 14',
                      style: TextStyle(
                        fontSize: 11,
                        color: textSubColor,
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

  List<String> _getCategories(BuildContext context) => [
    context.loc.catAll,
    context.loc.catWebDev,
    context.loc.catMobileApps,
    context.loc.catAI,
    context.loc.catUIUX,
    context.loc.catBusiness,
    context.loc.catCyberSecurity,
    context.loc.catDataScience,
  ];

  // ================= 5. CATEGORY CHIPS =================
  Widget _buildCategoryChips(Color cardBg, Color borderColor, Color textColor, bool isDark) {
    final categories = _getCategories(context);
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : borderColor,
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
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor,
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
    required Color textColor,
    required Color textSubColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: textSubColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  // ================= 7. SIGNATURE COURSE CARD =================
  Widget _buildCoursesHorizontalList(
    List<Map<String, dynamic>> courses,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final course = courses[index];
          final isWishlisted = _wishlistedCourseIds.contains(course['id']);
          final gradient = course['gradient'] as List<Color>;

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/course-details'),
            child: Container(
              width: 220,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(10),
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
                                color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                                  color: isWishlisted ? const Color(0xFFEF4444) : textColor,
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
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
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Rating Row
                        Row(
                          children: [
                            Text(
                              course['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB4690E),
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
                              style: TextStyle(
                                fontSize: 10,
                                color: textSubColor,
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
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? (course['badgeColor'] as Color).withValues(alpha: 0.2)
                                    : course['badgeColor'] as Color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                course['badgeText'] as String,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : course['badgeTextColor'] as Color,
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
            ),
          );
        },
      ),
    );
  }

  // ================= 8. POPULAR TOPICS =================
  Widget _buildPopularTopicsHorizontalList(Color cardBg, Color borderColor, Color textColor, bool isDark) {
    final columnCount = (_popularTopics.length / 2).ceil();

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: columnCount,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, colIndex) {
          final topIndex = colIndex * 2;
          final bottomIndex = topIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopicChip(_popularTopics[topIndex], cardBg, borderColor, textColor, isDark),
              const SizedBox(height: 8),
              if (bottomIndex < _popularTopics.length)
                _buildTopicChip(_popularTopics[bottomIndex], cardBg, borderColor, textColor, isDark)
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopicChip(String topic, Color cardBg, Color borderColor, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        topic,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  // ================= 9. TOP INSTRUCTORS =================
  Widget _buildInstructorsHorizontalList(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _topInstructors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final instructor = _topInstructors[index];
          final color = instructor['color'] as Color;

          return Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  instructor['role'] as String,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: textSubColor,
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
                      style: TextStyle(
                        fontSize: 10,
                        color: textSubColor,
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
  Widget _buildExploreCategoriesGrid(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: _exploreCategories.length,
      itemBuilder: (context, index) {
        final cat = _exploreCategories[index];
        final catColor = (cat['color'] as Color?) ?? AppColors.primary;

        return Material(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(context, '/explore');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Categorized Icon Container with custom accent tint
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: isDark ? 0.22 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: catColor.withValues(alpha: isDark ? 0.35 : 0.2),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      cat['icon'] as IconData,
                      color: catColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Category Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title'] as String,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            fontFamily: 'Tajawal',
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: catColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                cat['courses'] as String,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Micro Chevron
                  Icon(
                    isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                    size: 16,
                    color: textSubColor.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}