import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';

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

  late List<_SectionItem> _sections;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _sections = [
      const _SectionItem(
        title: 'القسم 1: البداية والإعداد وبيئة العمل',
        totalDuration: '45 دقيقة • 4 دروس',
        lessons: [
          _LessonItem(
            id: 'l1',
            title: '1. مقدمة عن مسار الدورة وخارطة الطريق',
            duration: '05:20 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l2',
            title: '2. تثبيت Flutter SDK وبيئة VS Code وتجهيز المحاكي',
            duration: '12:40 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l3',
            title: '3. إنشاء أول مشروع وفهم بنية الملفات',
            duration: '08:15 د',
            isCompleted: true,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l4',
            title: '4. اختبار قصير: أساسيات Dart',
            duration: '10 أسئلة',
            isCompleted: false,
            isDownloaded: false,
            type: 'quiz',
          ),
        ],
      ),
      const _SectionItem(
        title: 'القسم 2: بناء واجهات المستخدم المتقدمة',
        totalDuration: 'ساعتان و 15 دقيقة • 4 دروس',
        lessons: [
          _LessonItem(
            id: 'l5',
            title: '5. مفاهيم Stateless و Stateful بالتفصيل',
            duration: '14:20 د',
            isCompleted: true,
            isDownloaded: true,
          ),
          _LessonItem(
            id: 'l6',
            title: '6. تصميم شاشات متجاوبة Responsive Layouts',
            duration: '18:10 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l7',
            title: '7. الرسوم المتحركة التفاعلية والتنقل المخصص',
            duration: '22:30 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l8',
            title: '8. ملخص ومقال مرجعي لمكتبات الرسوميات',
            duration: 'قراءة 5 دقائق',
            isCompleted: false,
            isDownloaded: false,
            type: 'article',
          ),
        ],
      ),
      const _SectionItem(
        title: 'القسم 3: إدارة الحالة المتقدمة بـ Riverpod',
        totalDuration: '3 ساعات و 20 دقيقة • 4 دروس',
        lessons: [
          _LessonItem(
            id: 'l9',
            title: '9. لماذا Riverpod؟ مقارنة بين حلول إدارة الحالة',
            duration: '16:00 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l10',
            title: '10. بناء سلة المشتريات باستخدام StateNotifierProvider',
            duration: '35:10 د',
            isCompleted: false,
            isDownloaded: false,
          ),
          _LessonItem(
            id: 'l11',
            title: '11. التعامل مع الـ Streams و AsyncValue',
            duration: '24:50 د',
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
    final lesson = _sections[secIdx].lessons[lesIdx];
    final updated = lesson.copyWith(isCompleted: !lesson.isCompleted);
    setState(() {
      final updatedList = List<_LessonItem>.from(_sections[secIdx].lessons);
      updatedList[lesIdx] = updated;
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
      AppSnackbar.showSuccess(
        context,
        context.loc.lessonCompletedAll,
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
    AppSnackbar.showSuccess(
      context,
      context.loc.noteAddedSuccess,
    );
  }

  _LessonItem get _currentLesson =>
      _sections[_currentSectionIndex].lessons[_currentLessonIndex];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/main');
              }
            },
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
              AppSnackbar.show(
                context,
                _currentLesson.isDownloaded
                    ? context.loc.lessonAlreadyDownloaded
                    : 'جاري تنزيل "${_currentLesson.title}"...',
              );
            },
          ),

          // Share button
          IconButton(
            tooltip: context.loc.courseShareCopied,
            icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
            onPressed: () {
              AppSnackbar.showSuccess(
                context,
                context.loc.lessonLinkCopied,
              );
            },
          ),

          // Options Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'cert',
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(context.loc.courseCompletionCertificate, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    const Icon(Icons.flag_outlined, size: 18, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Text(context.loc.reportContentIssue, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                  ],
                ),
              ),
            ],
            onSelected: (val) {
              if (val == 'cert') {
                Navigator.pushNamed(context, '/certificate_view');
              } else if (val == 'report') {
                AppSnackbar.show(
                  context,
                  context.loc.contentReportThanks,
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

          // 2. Tabs Bar (الدروس، نظرة عامة، الملاحظات، الأسئلة)
          _buildUdemyPlayerTabs(cardBg, borderColor, textColor, textSubColor),

          // 3. Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurriculumTabView(cardBg, borderColor, textColor, textSubColor, isDark),
                _buildOverviewTabView(cardBg, borderColor, textColor, textSubColor),
                _buildQnATabView(cardBg, borderColor, textColor, textSubColor),
                _buildNotesTabView(cardBg, borderColor, textColor, textSubColor, isDark),
              ],
            ),
          ),

          // 4. Bottom Previous / Next Lesson Bar
          _buildBottomPlayerNavBar(cardBg, borderColor, textColor, textSubColor, isDark),
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
                Container(color: Colors.black.withValues(alpha: 0.45)),

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

                // Center Play/Pause & Rewind/Forward
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rewind 10s
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                      onPressed: () => _seekRelative(-10),
                    ),
                    const SizedBox(width: 20),

                    // Play / Pause Circle
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Forward 10s
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
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
  Widget _buildUdemyPlayerTabs(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        unselectedLabelColor: textSubColor,
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
        tabs: [
          Tab(text: context.loc.playerTabLessons),
          Tab(text: context.loc.playerTabOverview),
          Tab(text: context.loc.playerTabQnA),
          Tab(text: context.loc.playerTabNotes),
        ],
      ),
    );
  }

  // ================= 3. TAB 1: CURRICULUM =================
  Widget _buildCurriculumTabView(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
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
            backgroundColor: cardBg,
            collapsedBackgroundColor: cardBg,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              section.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            subtitle: Text(
              section.totalDuration,
              style: TextStyle(
                fontSize: 11,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            children: [
              for (int lesIdx = 0; lesIdx < section.lessons.length; lesIdx++) ...[
                _buildLessonTile(secIdx, lesIdx, cardBg, textColor, textSubColor, isDark),
                Divider(height: 1, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9), indent: 54),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLessonTile(int secIdx, int lesIdx, Color cardBg, Color textColor, Color textSubColor, bool isDark) {
    final lesson = _sections[secIdx].lessons[lesIdx];
    final isSelected = secIdx == _currentSectionIndex && lesIdx == _currentLessonIndex;

    return Container(
      color: isSelected
          ? (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF))
          : cardBg,
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
            color: isSelected ? AppColors.primary : textColor,
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
              color: textSubColor,
            ),
            const SizedBox(width: 4),
            Text(
              lesson.duration,
              style: TextStyle(
                fontSize: 10.5,
                color: textSubColor,
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

  // ================= 4. TAB 2: OVERVIEW =================
  Widget _buildOverviewTabView(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Course Title & Stats Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر [2026]',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFE59819), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '4.8 (18,420 طالب)',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: textColor),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.schedule_rounded, color: textSubColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '38.5 ساعة إجمالية',
                    style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
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
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
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
                  children: [
                    Text(
                      'شهادة الإتمام المعتمدة',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                    ),
                    Text(
                      'أكمل جميع الدروس للحصول على شهادتك',
                      style: TextStyle(fontSize: 10.5, color: textSubColor, fontFamily: 'Tajawal'),
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
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
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
                  children: [
                    Text(
                      'م. أحمد محمد',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                    ),
                    Text(
                      'كبير مهندسي البرمجيات ومدرب معتمد لدى Google',
                      style: TextStyle(fontSize: 10.5, color: textSubColor, fontFamily: 'Tajawal'),
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

  // ================= 5. TAB 3: NOTES =================
  Widget _buildNotesTabView(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Add Note Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
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
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 2,
                textDirection: Directionality.of(context),
                style: TextStyle(fontSize: 12, fontFamily: Directionality.of(context) == TextDirection.rtl ? 'Tajawal' : 'Inter', color: textColor),
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
        Text(
          'ملاحظاتي المسجلة',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
        ),
        const SizedBox(height: 8),

        for (final note in _notes) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
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
                    style: TextStyle(fontSize: 12, color: textColor, fontFamily: 'Tajawal'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ================= 7. TAB 4: Q&A =================
  Widget _buildQnATabView(Color cardBg, Color borderColor, Color textColor, Color textSubColor) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الأسئلة والنقاشات (24)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
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
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        const SizedBox(height: 10),
        _buildQnACard(
          author: 'منى خالد',
          question: 'هل يفضل استخدام StateNotifier أم AsyncNotifier في المشروعات الضخمة؟',
          repliesCount: '5 ردود',
          cardBg: cardBg,
          borderColor: borderColor,
          textColor: textColor,
          textSubColor: textSubColor,
        ),
      ],
    );
  }

  Widget _buildQnACard({
    required String author,
    required String question,
    required String repliesCount,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
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
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            question,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, fontFamily: 'Tajawal', color: textColor),
          ),
          const SizedBox(height: 6),
          Text(
            repliesCount,
            style: TextStyle(fontSize: 10.5, color: textSubColor, fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }

  // ================= 8. BOTTOM BAR =================
  Widget _buildBottomPlayerNavBar(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
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
                foregroundColor: textSubColor,
              ),
            ),

            // Mark completed checkbox
            GestureDetector(
              onTap: () => _toggleLessonCompleted(_currentSectionIndex, _currentLessonIndex),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _currentLesson.isCompleted
                      ? (isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5))
                      : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currentLesson.isCompleted ? const Color(0xFFA7F3D0) : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _currentLesson.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 15,
                      color: _currentLesson.isCompleted ? const Color(0xFF059669) : textSubColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentLesson.isCompleted ? context.loc.learningCompleted : 'Mark Complete',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _currentLesson.isCompleted ? const Color(0xFF059669) : textColor,
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
              label: Text(
                context.loc.playerNextLesson,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
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
