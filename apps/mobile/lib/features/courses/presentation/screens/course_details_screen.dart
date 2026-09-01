import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _CurriculumLesson {
  final String title;
  final String duration;
  final bool isPreview;

  const _CurriculumLesson({
    required this.title,
    required this.duration,
    this.isPreview = false,
  });
}

class _CurriculumSection {
  final String title;
  final String lectureCount;
  final String totalDuration;
  final List<_CurriculumLesson> lessons;
  bool isExpanded;

  _CurriculumSection({
    required this.title,
    required this.lectureCount,
    required this.totalDuration,
    required this.lessons,
    this.isExpanded = false,
  });
}

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool _isWishlisted = false;
  bool _isDescriptionExpanded = false;

  final List<String> _whatYouWillLearn = [
    'بناء تطبيقات متكاملة واحترافية باستخدام Flutter و Dart من الصفر حتى النشر على المتاجر.',
    'إتقان إدارة الحالة المتقدمة باستخدام Riverpod 3.0 و Bloc Pattern.',
    'تطبيق المعمارية النظيفة (Clean Architecture) وفصل طبقات البيانات والمنطق وواجهة المستخدم.',
    'الربط مع خدمات RESTful APIs و Firebase و WebSockets بكفاءة وأمان.',
    'تصميم واجهات مستخدم مذهلة وتفاعلية تدعم الوضع الداكن واللغتين العربية والإنجليزية.',
    'كتابة اختبارات الوحدة (Unit Tests) واختبارات الواجهة (Widget Tests) لضمان جودة الكود.',
  ];

  final List<String> _requirements = [
    'معرفة أساسية بمبادئ البرمجة أو أي لغة برمجية سابقة (مستحسن وليس إجبارياً).',
    'جهاز كمبيوتر (Windows أو Mac أو Linux) قادر على تشغيل بيئة تطوير Flutter و Android Studio أو VS Code.',
    'الرغبة والشغف في تعلم بناء تطبيقات حقيقية وقابلة للتوسع.',
  ];

  final List<_CurriculumSection> _sections = [
    _CurriculumSection(
      title: 'القسم 1: البداية والإعداد وبيئة التطوير',
      lectureCount: '6 دروس',
      totalDuration: '45 دقيقة',
      isExpanded: true,
      lessons: [
        const _CurriculumLesson(title: 'مقدمة عن مسار الدورة وخارطة الطريق', duration: '05:20', isPreview: true),
        const _CurriculumLesson(title: 'تثبيت Flutter SDK وبيئة VS Code', duration: '12:40', isPreview: true),
        const _CurriculumLesson(title: 'إنشاء أول مشروع وتشغيل المحاكي (Emulator)', duration: '08:15', isPreview: false),
        const _CurriculumLesson(title: 'هيكل الملفات وتوزيع مجلدات المشروع', duration: '09:30', isPreview: false),
        const _CurriculumLesson(title: 'أهم مكتبات Dart الأساسية', duration: '09:15', isPreview: false),
      ],
    ),
    _CurriculumSection(
      title: 'القسم 2: بناء واجهات المستخدم الأساسية والمتقدمة',
      lectureCount: '12 درساً',
      totalDuration: 'ساعتان و 15 دقيقة',
      lessons: [
        const _CurriculumLesson(title: 'مفهوم Stateless و Stateful Widgets', duration: '14:20', isPreview: true),
        const _CurriculumLesson(title: 'تصميم القوائم والشبكات ListView & GridView', duration: '18:10', isPreview: false),
        const _CurriculumLesson(title: 'التعامل مع الصور والخطوط وتنسيق الألوان', duration: '15:00', isPreview: false),
        const _CurriculumLesson(title: 'الرسوم المتحركة التفاعلية والتنقل بين الشاشات', duration: '22:30', isPreview: false),
      ],
    ),
    _CurriculumSection(
      title: 'القسم 3: إدارة الحالة المتقدمة بـ Riverpod 3.0',
      lectureCount: '10 دروس',
      totalDuration: 'ساعتان و 40 دقيقة',
      lessons: [
        const _CurriculumLesson(title: 'لماذا نحتاج إدارة الحالة؟ مقارنة بين الحلول', duration: '16:00', isPreview: true),
        const _CurriculumLesson(title: 'أساسيات StateNotifierProvider و FutureProvider', duration: '20:45', isPreview: false),
        const _CurriculumLesson(title: 'بناء متجر إلكتروني متكامل باستخدام Riverpod', duration: '35:10', isPreview: false),
      ],
    ),
    _CurriculumSection(
      title: 'القسم 4: المعمارية النظيفة والربط مع الـ API',
      lectureCount: '14 درساً',
      totalDuration: '3 ساعات و 20 دقيقة',
      lessons: [
        const _CurriculumLesson(title: 'مبادئ Clean Architecture و SOLID Principles', duration: '22:00', isPreview: false),
        const _CurriculumLesson(title: 'طبقة البيانات Data Sources & Repositories', duration: '28:15', isPreview: false),
        const _CurriculumLesson(title: 'التعامل مع الأخطاء واستجابات السيرفر عبر Dio', duration: '24:50', isPreview: false),
      ],
    ),
  ];

  void _toggleWishlist() {
    HapticFeedback.lightImpact();
    setState(() => _isWishlisted = !_isWishlisted);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWishlisted ? 'تمت إضافة الدورة إلى قائمة الرغبات' : 'تمت إزالة الدورة من قائمة الرغبات'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تمت إضافة الدورة إلى سلة المشتريات'),
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

  void _buyNow() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
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
        title: Text(
          context.loc.courseDetailsTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.loc.courseDetailsShare,
            icon: Icon(Icons.share_outlined, color: textColor, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رابط الدورة بنجاح'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          IconButton(
            tooltip: context.loc.cartTitle,
            icon: Icon(Icons.shopping_cart_outlined, color: textColor, size: 22),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          _buildPreviewHero(),
          const SizedBox(height: 16),
          _buildCourseHeaderInfo(textColor, textSubColor),
          const SizedBox(height: 18),
          _buildQuickHighlights(cardBg, borderColor, textColor, textSubColor, isDark),
          const SizedBox(height: 20),
          _buildWhatYouWillLearnCard(cardBg, borderColor, textColor),
          const SizedBox(height: 20),
          _buildCurriculumSection(cardBg, borderColor, textColor, textSubColor, isDark),
          const SizedBox(height: 20),
          _buildRequirementsCard(cardBg, borderColor, textColor, textSubColor),
          const SizedBox(height: 20),
          _buildDescriptionCard(cardBg, borderColor, textColor, textSubColor),
          const SizedBox(height: 20),
          _buildInstructorCard(cardBg, borderColor, textColor, textSubColor),
          const SizedBox(height: 20),
          _buildReviewsCard(cardBg, borderColor, textColor, textSubColor, isDark),
        ],
      ),
      bottomNavigationBar: _buildStickyBottomBar(cardBg, borderColor, textColor),
    );
  }

  Widget _buildPreviewHero() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/lesson-player'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF1D61E7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.flutter_dash_rounded, size: 160, color: Colors.white.withValues(alpha: 0.08)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Center(child: Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 32)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        context.loc.courseDetailsPreviewLesson,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                child: const Text('الأعلى مبيعاً', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E), fontFamily: 'Tajawal')),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(6)),
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('38.5h', style: TextStyle(fontSize: 10.5, color: Colors.white, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeaderInfo(Color textColor, Color textSubColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر حتى الاحتراف [2026]',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Tajawal', height: 1.35),
        ),
        const SizedBox(height: 8),
        Text(
          'تعلم بناء تطبيقات عملية واحترافية بنظامي Android و iOS باستخدام أحدث إصدارات Flutter 3.x مع إدارة الحالة Riverpod والمعمارية النظيفة.',
          style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal', height: 1.45),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
            const SizedBox(width: 4),
            const Text('4.8', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFB45309), fontFamily: 'Inter')),
            const SizedBox(width: 4),
            const Text('(18,420)', style: TextStyle(fontSize: 11.5, color: AppColors.primary, fontFamily: 'Inter', decoration: TextDecoration.underline)),
            const SizedBox(width: 10),
            const Text('•', style: TextStyle(color: Color(0xFFCBD5E1))),
            const SizedBox(width: 10),
            Flexible(
              child: Text(context.loc.homeStudentsCount('45,200'), style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person_outline_rounded, size: 14, color: textSubColor),
            const SizedBox(width: 4),
            Text(context.loc.courseDetailsCreatedBy, style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
            const SizedBox(width: 4),
            const Text('م. أحمد محمد', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal')),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.update_rounded, size: 14, color: textSubColor),
            const SizedBox(width: 4),
            Text('${context.loc.courseDetailsLastUpdated} 2026', style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
            const SizedBox(width: 10),
            Icon(Icons.language_rounded, size: 14, color: textSubColor),
            const SizedBox(width: 4),
            Text(context.loc.courseDetailsLanguage, style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickHighlights(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
      child: Row(
        children: [
          _buildHighlightItem(Icons.ondemand_video_rounded, '38.5h', context.loc.courseDetailsHoursOnDemand, textColor, textSubColor),
          _buildVerticalDivider(isDark),
          _buildHighlightItem(Icons.menu_book_rounded, '284', context.loc.courseDetailsComprehensiveContent, textColor, textSubColor),
          _buildVerticalDivider(isDark),
          _buildHighlightItem(Icons.workspace_premium_outlined, context.loc.certTitle, context.loc.courseDetailsCertifiedCertificate, textColor, textSubColor),
          _buildVerticalDivider(isDark),
          _buildHighlightItem(Icons.all_inclusive_rounded, 'Lifetime', context.loc.courseDetailsFullLifetimeAccess, textColor, textSubColor),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String title, String subtitle, Color textColor, Color textSubColor) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(subtitle, style: TextStyle(fontSize: 9.5, color: textSubColor, fontFamily: 'Tajawal'), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(width: 1, height: 28, color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0));
  }

  Widget _buildWhatYouWillLearnCard(Color cardBg, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.courseDetailsWhatYouWillLearn,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _whatYouWillLearn) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_rounded, color: Color(0xFF059669), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= 5. CURRICULUM ACCORDION =================
  Widget _buildCurriculumSection(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.courseDetailsCurriculum,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                '${_sections.length} • ${context.loc.learningLecturesCount(284)}',
                style: TextStyle(
                  fontSize: 11,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sections
          for (int i = 0; i < _sections.length; i++) ...[
            _buildSectionAccordionItem(_sections[i], i, isDark, textColor, textSubColor),
            if (i < _sections.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionAccordionItem(_CurriculumSection section, int index, bool isDark, Color textColor, Color textSubColor) {
    final itemBg = isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC);
    final itemBorder = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: itemBorder),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => section.isExpanded = !section.isExpanded);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    section.isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: textSubColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${section.lectureCount} • ${section.totalDuration}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSubColor,
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

          // Expanded Lessons
          if (section.isExpanded) ...[
            Divider(height: 1, color: itemBorder),
            for (final lesson in section.lessons) ...[
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/lesson-player'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle_outline_rounded, size: 18, color: lesson.isPreview ? AppColors.primary : const Color(0xFF94A3B8)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: lesson.isPreview ? textColor : textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      if (lesson.isPreview) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            context.loc.courseDetailsPreviewLesson,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        lesson.duration,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF94A3B8),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ================= 6. REQUIREMENTS =================
  Widget _buildRequirementsCard(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.courseDetailsRequirements,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          for (final req in _requirements) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 6, left: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      req,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= 7. FULL DESCRIPTION =================
  Widget _buildDescriptionCard(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.courseDetailsDescription,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'هل ترغب في أن تصبح مطور تطبيقات محترف قادر على بناء تطبيقات للهواتف الذكية بنظامي Android و iOS باستخدام كود برمجي واحد؟ هذه الدورة صممت خصيصاً لتأخذك من الصفر تماماً وتضعك على طريق الاحتراف.\n\nستتعلم خلال هذا البرنامج التدريبي كيفية استخدام لغة Dart ومكتبات Flutter الحديثة، مع تطبيق معمارية برمجية نظيفة Clean Architecture، وتصميم واجهات تفاعلية مذهلة، والربط مع خوادم الـ API والخدمات السحابية كـ Firebase.',
            style: TextStyle(
              fontSize: 11.5,
              color: textSubColor,
              fontFamily: 'Tajawal',
              height: 1.5,
            ),
            maxLines: _isDescriptionExpanded ? null : 4,
            overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            child: Row(
              children: [
                Text(
                  _isDescriptionExpanded ? 'عرض أقل' : 'قراءة المزيد',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Icon(
                  _isDescriptionExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= 8. INSTRUCTOR CARD =================
  Widget _buildInstructorCard(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.courseDetailsInstructor,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'أ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'م. أحمد محمد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Senior Mobile Engineer & Flutter Specialist',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: textSubColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              Text('4.9', style: TextStyle(fontSize: 11, fontFamily: 'Tajawal', color: textColor)),
              const SizedBox(width: 14),
              const Icon(Icons.people_outline_rounded, size: 15, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(context.loc.homeStudentsCount('54,000+'), style: TextStyle(fontSize: 11, fontFamily: 'Tajawal', color: textColor)),
              const SizedBox(width: 14),
              const Icon(Icons.play_lesson_outlined, size: 15, color: Color(0xFF059669)),
              const SizedBox(width: 4),
              Text('6 ${context.loc.learningTitle}', style: TextStyle(fontSize: 11, fontFamily: 'Tajawal', color: textColor)),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 9. REVIEWS CARD =================
  Widget _buildReviewsCard(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.courseDetailsReviews,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 17),
                  SizedBox(width: 3),
                  Text('4.8 / 5', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildSingleReview(
            name: 'خالد عبد الله',
            time: 'منذ أسبوع',
            rating: 5,
            comment: 'دورة ممتازة جداً وشاملة، الشرح واضح ومباشر والتطبيقات العملية ممتازة ومفيدة لسوق العمل.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          Divider(height: 16, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
          _buildSingleReview(
            name: 'منار السعيد',
            time: 'منذ أسبوعين',
            rating: 5,
            comment: 'أفضل كورس فلاتر باللغة العربية! شرح إدارة الحالة والمعمارية النظيفة كان رائعاً وبسيطاً.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleReview({
    required String name,
    required String time,
    required int rating,
    required String comment,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Tajawal'),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: List.generate(
            rating,
            (index) => const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal', height: 1.35),
        ),
      ],
    );
  }

  // ================= 10. STICKY BOTTOM BAR =================
  Widget _buildStickyBottomBar(Color cardBg, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Tag
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$49.99',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const Text(
                  '\$84.99',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // Wishlist Icon Button
            IconButton(
              tooltip: context.loc.wishlistTitle,
              onPressed: _toggleWishlist,
              icon: Icon(
                _isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isWishlisted ? const Color(0xFFEF4444) : textColor,
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 10),

            // Add to Cart Button
            OutlinedButton(
              onPressed: _addToCart,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              ),
              child: Text(
                context.loc.courseDetailsAddToCart,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
            const SizedBox(width: 8),

            // Buy Now Button
            Expanded(
              child: ElevatedButton(
                onPressed: _buyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  elevation: 0,
                ),
                child: Text(
                  context.loc.courseDetailsBuyNow,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
