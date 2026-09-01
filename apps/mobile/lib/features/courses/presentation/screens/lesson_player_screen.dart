import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _LessonItem {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isDownloaded;
  final String type; // 'video' | 'quiz' | 'article'

  const _LessonItem({
    required this.id,
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.isDownloaded = false,
    this.type = 'video',
  });

  _LessonItem copyWith({
    bool? isCompleted,
    bool? isDownloaded,
  }) {
    return _LessonItem(
      id: id,
      title: title,
      duration: duration,
      isCompleted: isCompleted ?? this.isCompleted,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      type: type,
    );
  }
}

class _SectionItem {
  final String title;
  final String totalDuration;
  final List<_LessonItem> lessons;

  const _SectionItem({
    required this.title,
    required this.totalDuration,
    required this.lessons,
  });
}

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Player State
  bool _isPlaying = true;
  double _currentPosition = 860.0; // in seconds (14:20)
  final double _totalDuration = 1725.0; // in seconds (28:45)
  double _playbackSpeed = 1.0;
  bool _showControls = true;
  int _currentSectionIndex = 0;
  int _currentLessonIndex = 1;

  // Notes State
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _notes = [
    {
      'time': '04:15',
      'text': 'شرح مهم جداً عن الفرق بين StateProvider و AsyncNotifier في Riverpod 3.0',
    },
    {
      'time': '12:40',
      'text': 'طريقة معالجة حالات الخطأ والـ Loading بسطر واحد عبر .when()',
    },
  ];

  // Course Curriculum
  late List<_SectionItem> _sections;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _sections = [
      const _SectionItem(
        title: 'القسم 1: الإعداد والتهيئة المعمارية',
        totalDuration: '4 دروس • 48 دقيقة',
        lessons: [
          _LessonItem(
            id: 'l1',
            title: '1. مقدمة الدورة وخريطة الطريق التعليمية',
            duration: '08:20 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l2',
            title: '2. تثبيت بيئة العمل وتهيئة Flutter 3.29',
            duration: '14:15 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l3',
            title: '3. هيكلة مجلدات المشروع بنمط Clean Architecture',
            duration: '18:40 د',
            isCompleted: true,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l4',
            title: '4. اختبار قصير: أساسيات المعمارية النظيفة',
            duration: '5 أسئلة',
            isCompleted: true,
            type: 'quiz',
          ),
        ],
      ),
      const _SectionItem(
        title: 'القسم 2: إدارة الحالة المتقدمة بـ Riverpod 3.0',
        totalDuration: '5 دروس • 1 ساعة و 15 دقيقة',
        lessons: [
          _LessonItem(
            id: 'l5',
            title: '5. لماذا نحتاج Riverpod 3.0 بدلاً من الحلول التقليدية؟',
            duration: '12:30 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l6',
            title: '6. تطبيق عملي: بناء Notifier و AsyncNotifier',
            duration: '28:45 د',
            isCompleted: false,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l7',
            title: '7. التحديث التلقائي وإدارة الذاكرة بـ autoDispose',
            duration: '15:10 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l8',
            title: '8. ربط الـ State بـ REST API و Caching',
            duration: '22:00 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l9',
            title: '9. تمرين عملي وتطبيق كود التحدي',
            duration: 'مقالة وتحدي',
            isCompleted: false,
            type: 'article',
          ),
        ],
      ),
      const _SectionItem(
        title: 'القسم 3: بناء الواجهات التفاعلية والرسوم المتحركة',
        totalDuration: '6 دروس • 1 ساعة و 40 دقيقة',
        lessons: [
          _LessonItem(
            id: 'l10',
            title: '10. تصميم المكونات المشتركة Reusable Widgets',
            duration: '16:20 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l11',
            title: '11. الرسوم المتحركة الدقيقة Micro-Animations بـ Flutter',
            duration: '24:10 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l12',
            title: '12. دعم الوضع المظلم واللغات المتعددة (RTL & L10n)',
            duration: '19:50 د',
            isCompleted: false,
            isDownloaded: false,
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDuration(double seconds) {
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = (seconds % 60).floor();
    final String minStr = minutes.toString().padLeft(2, '0');
    final String secStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _seekRelative(double deltaSeconds) {
    setState(() {
      _currentPosition = (_currentPosition + deltaSeconds).clamp(0.0, _totalDuration);
    });
  }

  void _toggleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });
  }

  void _selectLesson(int secIdx, int lesIdx) {
    setState(() {
      _currentSectionIndex = secIdx;
      _currentLessonIndex = lesIdx;
      _currentPosition = 0;
      _isPlaying = true;
    });
  }

  void _toggleLessonCompleted(int secIdx, int lesIdx) {
    setState(() {
      final current = _sections[secIdx].lessons[lesIdx];
      final updatedLesson = current.copyWith(isCompleted: !current.isCompleted);
      final List<_LessonItem> updatedList = List.from(_sections[secIdx].lessons);
      updatedList[lesIdx] = updatedLesson;

      _sections[secIdx] = _SectionItem(
        title: _sections[secIdx].title,
        totalDuration: _sections[secIdx].totalDuration,
        lessons: updatedList,
      );
    });
  }

  void _playNextLesson() {
    if (_currentLessonIndex < _sections[_currentSectionIndex].lessons.length - 1) {
      _selectLesson(_currentSectionIndex, _currentLessonIndex + 1);
    } else if (_currentSectionIndex < _sections.length - 1) {
      _selectLesson(_currentSectionIndex + 1, 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مبروك! لقد أكملت جميع دروس الدورة 🎉'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _playPreviousLesson() {
    if (_currentLessonIndex > 0) {
      _selectLesson(_currentSectionIndex, _currentLessonIndex - 1);
    } else if (_currentSectionIndex > 0) {
      final prevSec = _currentSectionIndex - 1;
      _selectLesson(prevSec, _sections[prevSec].lessons.length - 1);
    }
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.insert(0, {
        'time': _formatDuration(_currentPosition),
        'text': text,
      });
      _noteController.clear();
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة الملاحظة بنجاح 📝'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  _LessonItem get _currentLesson =>
      _sections[_currentSectionIndex].lessons[_currentLessonIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'الدليل الشامل لاحتراف تطبيقات Flutter و Dart',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _currentLesson.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          // Download button
          IconButton(
            tooltip: 'تنزيل الدرس',
            icon: Icon(
              _currentLesson.isDownloaded
                  ? Icons.download_done_rounded
                  : Icons.download_for_offline_outlined,
              color: _currentLesson.isDownloaded ? const Color(0xFF10B981) : Colors.white,
              size: 20,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _currentLesson.isDownloaded
                        ? 'الدرس محفوظ بالفعل للمشاهدة دون إنترنت'
                        : 'جاري تنزيل "${_currentLesson.title}"...',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Share button
          IconButton(
            tooltip: 'مشاركة',
            icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ رابط الدرس إلى الحافظة 🔗'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Options Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'cert',
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium_outlined, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('شهادة إتمام الدورة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('الإبلاغ عن مشكلة في المحتوى', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                  ],
                ),
              ),
            ],
            onSelected: (val) {
              if (val == 'cert') {
                Navigator.pushNamed(context, '/certificate_view');
              } else if (val == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('شكراً لملاحظتك، سيتم فحص الدرس من قبل الفريق الفني'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // 1. Udemy Video Player Area (16:9 Aspect Ratio)
          _buildUdemyVideoPlayer(),

          // 2. Tabs Bar (الدروس، نظرة عامة، الملاحظات، المصادر، الأسئلة)
          _buildUdemyPlayerTabs(),

          // 3. Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurriculumTabView(),
                _buildOverviewTabView(),
                _buildQnATabView(),
                _buildNotesTabView(),
              ],
            ),
          ),

          // 4. Bottom Previous / Next Lesson Bar
          _buildBottomPlayerNavBar(),
        ],
      ),
    );
  }

  // ================= 1. UDEMY VIDEO PLAYER =================
  Widget _buildUdemyVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Container(
          color: const Color(0xFF0F172A),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Mock Video Presentation Background
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _currentLesson.type == 'quiz'
                          ? Icons.quiz_rounded
                          : (_currentLesson.type == 'article'
                              ? Icons.article_rounded
                              : Icons.terminal_rounded),
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentLesson.title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Player Overlay Controls
              if (_showControls) ...[
                // Dark Backdrop
                Container(color: Colors.black.withValues(alpha: 0.45)),

                // Top Floating Badges
                Positioned(
                  top: 10,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Speed Pill
                      GestureDetector(
                        onTap: _toggleSpeed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_playbackSpeed}x',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),

                      // Quality Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1080p HD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Playback Controls (10s back, Play/Pause, 10s forward)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rewind 10s
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 30),
                      onPressed: () => _seekRelative(-10),
                    ),
                    const SizedBox(width: 20),

                    // Play/Pause Big Button
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Forward 10s
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 30),
                      onPressed: () => _seekRelative(10),
                    ),
                  ],
                ),

                // Bottom Timeline Scrubber & Duration
                Positioned(
                  bottom: 6,
                  left: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: _currentPosition,
                          max: _totalDuration,
                          onChanged: (val) => setState(() => _currentPosition = val),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 10.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ================= 2. PLAYER TABS =================
  Widget _buildUdemyPlayerTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Tajawal',
        ),
        tabs: const [
          Tab(text: 'محتوى الدورة'),
          Tab(text: 'نظرة عامة'),
          Tab(text: 'الأسئلة والأجوبة'),
          Tab(text: 'الملاحظات'),
        ],
      ),
    );
  }

  // ================= 3. TAB 1: CURRICULUM (محتوى الدورة) =================
  Widget _buildCurriculumTabView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _sections.length,
      itemBuilder: (context, secIdx) {
        final section = _sections[secIdx];

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: secIdx == _currentSectionIndex,
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              section.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            subtitle: Text(
              section.totalDuration,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
            children: [
              for (int lesIdx = 0; lesIdx < section.lessons.length; lesIdx++) ...[
                _buildLessonTile(secIdx, lesIdx),
                const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 54),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLessonTile(int secIdx, int lesIdx) {
    final lesson = _sections[secIdx].lessons[lesIdx];
    final isSelected = secIdx == _currentSectionIndex && lesIdx == _currentLessonIndex;

    return Container(
      color: isSelected ? const Color(0xFFEFF4FF) : Colors.white,
      child: ListTile(
        onTap: () => _selectLesson(secIdx, lesIdx),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: GestureDetector(
          onTap: () => _toggleLessonCompleted(secIdx, lesIdx),
          child: Icon(
            lesson.isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: lesson.isCompleted ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            size: 22,
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              lesson.type == 'quiz'
                  ? Icons.quiz_outlined
                  : (lesson.type == 'article'
                      ? Icons.article_outlined
                      : Icons.play_circle_outline_rounded),
              size: 13,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              lesson.duration,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        trailing: lesson.isDownloaded
            ? const Icon(Icons.download_done_rounded, size: 16, color: Color(0xFF059669))
            : null,
      ),
    );
  }

  // ================= 4. TAB 2: OVERVIEW (نظرة عامة) =================
  Widget _buildOverviewTabView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Course Title & Stats Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر [2026]',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.star_rounded, color: Color(0xFFE59819), size: 16),
                  SizedBox(width: 4),
                  Text(
                    '4.8 (18,420 طالب)',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '38.5 ساعة إجمالية',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Certificate Progress Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_outlined, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'شهادة الإتمام المعتمدة',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    Text(
                      'أكمل جميع الدروس للحصول على شهادتك',
                      style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/certificate_view'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 0,
                ),
                child: const Text('عرض الشهادة', style: TextStyle(fontSize: 11, fontFamily: 'Tajawal')),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Instructor Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'م. أحمد محمد',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                    Text(
                      'كبير مهندسي البرمجيات ومدرب معتمد لدى Google',
                      style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
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

  // ================= 5. TAB 3: NOTES (الملاحظات) =================
  Widget _buildNotesTabView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Add Note Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'تدوين ملاحظة عند التوقيت ${_formatDuration(_currentPosition)}',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 2,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'اكتب ملاحظتك التعليمية هنا للرجوع إليها لاحقاً...',
                  hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                  border: InputBorder.none,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _addNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 0,
                  ),
                  child: const Text('حفظ الملاحظة', style: TextStyle(fontSize: 11.5, fontFamily: 'Tajawal')),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Notes List
        const Text(
          'ملاحظاتي المسجلة',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        const SizedBox(height: 8),

        for (final note in _notes) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    note['time']!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    note['text']!,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }



  // ================= 7. TAB 5: Q&A (الأسئلة والأجوبة) =================
  Widget _buildQnATabView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأسئلة والنقاشات (24)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_comment_rounded, size: 14),
              label: const Text('طرح سؤال', style: TextStyle(fontSize: 11.5, fontFamily: 'Tajawal')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildQnACard(
          author: 'طارق السعيد',
          question: 'كيف يمكن ربط الـ Provider مع WebSocket للحصول على التحديثات اللحظية؟',
          repliesCount: '3 ردود • رد المدرب معتمد',
        ),
        const SizedBox(height: 10),
        _buildQnACard(
          author: 'منى خالد',
          question: 'هل يفضل استخدام StateNotifier أم AsyncNotifier في المشروعات الضخمة؟',
          repliesCount: '5 ردود',
        ),
      ],
    );
  }

  Widget _buildQnACard({
    required String author,
    required String question,
    required String repliesCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFFEFF4FF),
                child: Icon(Icons.person_rounded, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                author,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            question,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 6),
          Text(
            repliesCount,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }

  // ================= 8. BOTTOM PREVIOUS / NEXT LESSON BAR =================
  Widget _buildBottomPlayerNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Lesson
            TextButton.icon(
              onPressed: _playPreviousLesson,
              icon: const Icon(Icons.skip_previous_rounded, size: 18),
              label: const Text(
                'الدرس السابق',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),

            // Mark completed checkbox
            GestureDetector(
              onTap: () => _toggleLessonCompleted(_currentSectionIndex, _currentLessonIndex),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _currentLesson.isCompleted ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currentLesson.isCompleted ? const Color(0xFFA7F3D0) : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _currentLesson.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 15,
                      color: _currentLesson.isCompleted ? const Color(0xFF059669) : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentLesson.isCompleted ? 'مكتمل' : 'تحديد كمكتمل',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _currentLesson.isCompleted ? const Color(0xFF065F46) : AppColors.textPrimary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next Lesson
            ElevatedButton.icon(
              onPressed: _playNextLesson,
              icon: const Icon(Icons.skip_next_rounded, size: 18),
              label: const Text(
                'الدرس التالي',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
