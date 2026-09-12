import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/features/courses/data/models/course_rating_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/courses/presentation/screens/certificate_view_screen.dart';
import 'package:mobile/features/learning/data/models/lecture_comment_model.dart';
import 'package:mobile/features/learning/presentation/providers/course_learning_provider.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';

class LessonPlayerScreen extends StatefulWidget {
  final int? courseId;
  final int? initialLectureId;

  const LessonPlayerScreen({
    super.key,
    this.courseId,
    this.initialLectureId,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;

  // Real Video Player Controller State
  VideoPlayerController? _videoController;
  bool _isNativeVideo = false;
  bool _isBuffering = false;
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _showControls = true;
  double _playbackSpeed = 1.0;

  // Fallback Simulation State
  double _simulatedSeconds = 0.0;
  double _simulatedTotalSeconds = 300.0;
  Timer? _simulatedTimer;
  Timer? _controlsTimer;

  // Waveform animation
  late AnimationController _waveController;

  // Current Playing Tracking
  int? _currentPlayingLectureId;

  // Comment & Reply & Rating Inputs
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _ratingReviewController = TextEditingController();
  int _userRatingValue = 5;
  bool _isEditingExistingRating = false;
  int? _replyingToCommentId;
  bool _isDescriptionExpanded = false;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 4, vsync: this);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _resetControlsTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _videoController?.pause();
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  void deactivate() {
    _videoController?.pause();
    _simulatedTimer?.cancel();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _initCourseData();
    }
  }

  void _initCourseData() {
    int? targetCourseId = widget.courseId;
    int? targetLectureId = widget.initialLectureId;

    // Check Route Arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs != null) {
      if (routeArgs is int) {
        targetCourseId = routeArgs;
      } else if (routeArgs is Map) {
        targetCourseId = int.tryParse(routeArgs['courseId']?.toString() ?? '');
        targetLectureId = int.tryParse(routeArgs['lectureId']?.toString() ?? '');
      }
    }

    // Fallback: If no courseId, take first enrolled course from EnrollmentProvider
    if (targetCourseId == null || targetCourseId <= 0) {
      final enrollments = context.read<EnrollmentProvider>().courses;
      if (enrollments.isNotEmpty) {
        targetCourseId = enrollments.first.courseId > 0
            ? enrollments.first.courseId
            : enrollments.first.id;
      }
    }

    if (targetCourseId != null && targetCourseId > 0) {
      context.read<CourseLearningProvider>().loadCourse(
            targetCourseId,
            initialLectureId: targetLectureId,
          );
    }
  }

  void _syncWithLecture(CourseLectureModel? lecture) {
    if (lecture == null) return;
    if (_currentPlayingLectureId == lecture.id) return;
    _currentPlayingLectureId = lecture.id;
    _initVideoForLecture(lecture);
  }

  Future<void> _disposeVideoController() async {
    if (_videoController != null) {
      try {
        _videoController!.removeListener(_videoListener);
        await _videoController!.dispose();
      } catch (_) {}
      _videoController = null;
    }
  }

  Future<void> _initVideoForLecture(CourseLectureModel lecture) async {
    _simulatedTimer?.cancel();
    await _disposeVideoController();

    if (lecture.isArticle) {
      if (mounted) {
        setState(() {
          _isBuffering = false;
          _isNativeVideo = false;
          _isPlaying = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isBuffering = true;
        _isNativeVideo = false;
        _simulatedSeconds = 0.0;
        _simulatedTotalSeconds = (lecture.duration > 0 ? lecture.duration : 300).toDouble();
        _isPlaying = true;
      });
    }

    final rawUrl = lecture.videoUrl?.trim() ?? '';
    final url = rawUrl.isNotEmpty ? ApiConstants.formatImageUrl(rawUrl) : '';

    bool nativeSuccess = false;
    if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
      try {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        _videoController = controller;
        await controller.initialize();
        if (mounted && _currentPlayingLectureId == lecture.id) {
          controller.addListener(_videoListener);
          await controller.setPlaybackSpeed(_playbackSpeed);
          await controller.setVolume(_isMuted ? 0.0 : 1.0);
          await controller.play();
          setState(() {
            _isNativeVideo = true;
            _isBuffering = false;
            _isPlaying = true;
          });
          nativeSuccess = true;
        }
      } catch (_) {
        nativeSuccess = false;
      }
    }

    if (!nativeSuccess && mounted && _currentPlayingLectureId == lecture.id) {
      setState(() {
        _isNativeVideo = false;
        _isBuffering = false;
        _isPlaying = true;
      });
      _startSimulatedEngine();
    }

    _resetControlsTimer();
  }

  void _startSimulatedEngine() {
    _simulatedTimer?.cancel();
    _simulatedTimer = Timer.periodic(const Duration(milliseconds: 250), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_isPlaying && !_isBuffering) {
        setState(() {
          _simulatedSeconds += 0.25 * _playbackSpeed;
          if (_simulatedSeconds >= _simulatedTotalSeconds) {
            _simulatedSeconds = _simulatedTotalSeconds;
            _isPlaying = false;
            _onVideoCompleted();
          }
        });
      }
    });
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;
    final isPlaying = _videoController!.value.isPlaying;
    final isBuffering = _videoController!.value.isBuffering;

    if (isPlaying != _isPlaying || isBuffering != _isBuffering) {
      setState(() {
        _isPlaying = isPlaying;
        _isBuffering = isBuffering;
      });
    } else {
      setState(() {});
    }

    if (_videoController!.value.isInitialized &&
        _videoController!.value.position >= _videoController!.value.duration &&
        _videoController!.value.duration > Duration.zero) {
      _onVideoCompleted();
    }
  }

  void _onVideoCompleted() {
    final provider = context.read<CourseLearningProvider>();
    final current = provider.currentLecture;
    if (current != null && !provider.isLectureCompleted(current.id)) {
      provider.toggleLectureCompletion(current.id, courseId: provider.course?.id ?? 0);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controlsTimer?.cancel();
    _simulatedTimer?.cancel();
    _waveController.dispose();
    _tabController.dispose();
    _commentController.dispose();
    _replyController.dispose();
    _ratingReviewController.dispose();
    if (_videoController != null) {
      try {
        _videoController!.pause();
        _videoController!.removeListener(_videoListener);
        _videoController!.dispose();
      } catch (_) {}
      _videoController = null;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _openFullScreen(
    BuildContext context,
    CourseDetailsModel course,
    CourseLectureModel lecture,
    bool isAr,
  ) async {
    HapticFeedback.mediumImpact();
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (_) {}

    if (!context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (fullCtx) => _FullScreenVideoPlayer(
          course: course,
          lecture: lecture,
          videoController: _videoController,
          isNativeVideo: _isNativeVideo,
          isBuffering: _isBuffering,
          isPlaying: _isPlaying,
          isMuted: _isMuted,
          playbackSpeed: _playbackSpeed,
          simulatedSeconds: _simulatedSeconds,
          simulatedTotalSeconds: _simulatedTotalSeconds,
          waveController: _waveController,
          isAr: isAr,
          onTogglePlayPause: _togglePlayPause,
          onSeekRelative: _seekRelative,
          onSeekTo: _seekTo,
          onSpeedChanged: (speed) {
            _setPlaybackSpeed(speed);
          },
          onMuteChanged: (muted) {
            _setMuted(muted);
          },
          onExitFullscreen: () => Navigator.of(fullCtx).maybePop(),
        ),
      ),
    );

    // Restore portrait on return
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (_) {}

    if (mounted) {
      setState(() {});
      _resetControlsTimer();
    }
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (_isPlaying) {
      _controlsTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  String _formatDuration(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _togglePlayPause() {
    HapticFeedback.selectionClick();
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    } else {
      setState(() => _isPlaying = !_isPlaying);
    }
    _resetControlsTimer();
  }

  void _seekRelative(int seconds) {
    HapticFeedback.selectionClick();
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      final cur = _videoController!.value.position;
      final target = cur + Duration(seconds: seconds);
      _videoController!.seekTo(target < Duration.zero ? Duration.zero : target);
    } else {
      setState(() {
        _simulatedSeconds = (_simulatedSeconds + seconds).clamp(0.0, _simulatedTotalSeconds);
      });
    }
    _resetControlsTimer();
  }

  void _seekTo(double seconds) {
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      _videoController!.seekTo(Duration(milliseconds: (seconds * 1000).toInt()));
    } else {
      setState(() => _simulatedSeconds = seconds);
    }
    _resetControlsTimer();
  }

  void _setPlaybackSpeed(double nextSpeed) async {
    setState(() => _playbackSpeed = nextSpeed);
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      await _videoController!.setPlaybackSpeed(nextSpeed);
    }
  }

  void _setMuted(bool muted) async {
    setState(() => _isMuted = muted);
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      await _videoController!.setVolume(muted ? 0.0 : 1.0);
    }
  }

  void _toggleSpeed() {
    HapticFeedback.selectionClick();
    double nextSpeed;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 2.0;
    } else if (_playbackSpeed == 2.0) {
      nextSpeed = 0.75;
    } else {
      nextSpeed = 1.0;
    }
    _setPlaybackSpeed(nextSpeed);
    _resetControlsTimer();
  }

  void _toggleMute() {
    HapticFeedback.selectionClick();
    _setMuted(!_isMuted);
    _resetControlsTimer();
  }

  void _selectLecture(CourseLearningProvider provider, int secIdx, int lesIdx) {
    HapticFeedback.selectionClick();
    provider.selectLecture(secIdx, lesIdx);
  }

  void _toggleLectureCompletion(CourseLearningProvider provider, int lectureId) async {
    HapticFeedback.mediumImpact();
    final courseId = provider.course?.id ?? 0;
    final success = await provider.toggleLectureCompletion(lectureId, courseId: courseId);
    if (!mounted) return;
    if (success) {
      // Also refresh EnrollmentProvider in background
      context.read<EnrollmentProvider>().fetchEnrollments();
      final isComp = provider.isLectureCompleted(lectureId);
      AppSnackbar.showSuccess(
        context,
        isComp ? context.loc.playerLessonMarkedCompleted : context.loc.playerLessonMarkedIncomplete,
      );
    }
  }

  void _playNextLesson(CourseLearningProvider provider) {
    HapticFeedback.selectionClick();
    final hasNext = provider.playNextLesson();
    if (hasNext) {
      setState(() {
        _simulatedSeconds = 0;
        _isPlaying = true;
      });
    } else {
      AppSnackbar.showSuccess(
        context,
        context.loc.lessonCompletedAll,
      );
    }
  }

  void _playPreviousLesson(CourseLearningProvider provider) {
    HapticFeedback.selectionClick();
    final hasPrev = provider.playPreviousLesson();
    if (hasPrev) {
      setState(() {
        _simulatedSeconds = 0;
        _isPlaying = true;
      });
    }
  }

  void _addComment(CourseLearningProvider provider) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.selectionClick();
    final success = await provider.addComment(text);
    if (!mounted) return;
    if (success) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      AppSnackbar.showSuccess(
        context,
        context.loc.playerCommentPostedSuccess,
      );
    } else {
      AppSnackbar.showError(
        context,
        context.loc.playerCommentPostFailed,
      );
    }
  }

  void _replyToComment(CourseLearningProvider provider, int commentId) async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.selectionClick();
    final success = await provider.replyToComment(commentId, text);
    if (!mounted) return;
    if (success) {
      _replyController.clear();
      setState(() => _replyingToCommentId = null);
      FocusScope.of(context).unfocus();
      AppSnackbar.showSuccess(
        context,
        context.loc.playerReplyPostedSuccess,
      );
    } else {
      AppSnackbar.showError(
        context,
        context.loc.playerReplyPostFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseLearningProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);

    final course = provider.course;

    if (provider.isLoading && course == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: _buildSkeletonLoading(cardBg, borderColor, isDark),
      );
    }

    if (course == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school_outlined, size: 64, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  context.loc.playerCourseNotFound,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? context.loc.playerCheckEnrollmentPrompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: textSubColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 180,
                  child: AppButton(
                    label: context.loc.playerReturnToCourses,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentLecture = provider.currentLecture;
    _syncWithLecture(currentLecture);
    final isLectureCompleted = currentLecture != null && provider.isLectureCompleted(currentLecture.id);

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    if (isLandscape && currentLecture != null && !currentLecture.isArticle) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          _videoController?.pause();
          _simulatedTimer?.cancel();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _FullScreenVideoPlayer(
            course: course,
            lecture: currentLecture,
            videoController: _videoController,
            isNativeVideo: _isNativeVideo,
            isBuffering: _isBuffering,
            isPlaying: _isPlaying,
            isMuted: _isMuted,
            playbackSpeed: _playbackSpeed,
            simulatedSeconds: _simulatedSeconds,
            simulatedTotalSeconds: _simulatedTotalSeconds,
            waveController: _waveController,
            isAr: isAr,
            onTogglePlayPause: _togglePlayPause,
            onSeekRelative: _seekRelative,
            onSeekTo: _seekTo,
            onSpeedChanged: _setPlaybackSpeed,
            onMuteChanged: _setMuted,
            onExitFullscreen: () async {
              try {
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              } catch (_) {}
            },
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _videoController?.pause();
        _simulatedTimer?.cancel();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                _videoController?.pause();
                _simulatedTimer?.cancel();
                Navigator.of(context).maybePop();
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              currentLecture?.title ?? context.loc.playerWatchLecture,
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
          // Certificate button
          if (provider.certificate != null || provider.progressPercentage >= 100)
            IconButton(
              tooltip: context.loc.playerCertificateTooltip,
              icon: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 22),
              onPressed: () {
                if (provider.certificate != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CertificateViewScreen(initialCertificate: provider.certificate),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, '/certificates');
                }
              },
            ),

          // Rating Action
          IconButton(
            tooltip: context.loc.playerRateCourseTooltip,
            icon: Icon(
              provider.myRating != null ? Icons.star_rounded : Icons.star_outline_rounded,
              color: const Color(0xFFF59E0B),
              size: 22,
            ),
            onPressed: () {
              _tabController.animateTo(3);
            },
          ),

          // Share / Info Action
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
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // 1. Interactive Video / Article Player (16:9 Aspect Ratio)
          _buildPlayerArea(course, currentLecture, isDark, isAr),

          // 2. Tabs Bar (الدروس، نظرة عامة، الأسئلة، التقييمات)
          _buildPlayerTabs(cardBg, borderColor, textColor, textSubColor, isAr),

          // 3. Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurriculumTabView(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                _buildOverviewTabView(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                _buildQnATabView(provider, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
                _buildCourseRatingsTabView(provider, course, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
              ],
            ),
          ),

          // 4. Bottom Previous / Next Lesson Bar
          _buildBottomPlayerNavBar(provider, currentLecture, isLectureCompleted, cardBg, borderColor, textColor, textSubColor, isDark, isAr),
        ],
      ),
    ),
  );
}

  // ================= 1. PLAYER AREA (VIDEO / ARTICLE) =================
  Widget _buildPlayerArea(
    CourseDetailsModel course,
    CourseLectureModel? lecture,
    bool isDark,
    bool isAr,
  ) {
    if (lecture == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: const Color(0xFF0F172A),
          child: const Center(
            child: Icon(Icons.school_rounded, color: Colors.white54, size: 48),
          ),
        ),
      );
    }

    // A. Article Lecture
    if (lecture.isArticle) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF065F46)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.article_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                lecture.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    context.loc.playerReadingArticleBadge,
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Tajawal'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.loc.playerReadFullTextBelow,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Current position and total duration in seconds
    double currentPosSeconds = 0.0;
    double totalDurationSeconds = 300.0;
    if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized) {
      currentPosSeconds = _videoController!.value.position.inMilliseconds / 1000.0;
      totalDurationSeconds = _videoController!.value.duration.inMilliseconds / 1000.0;
      if (totalDurationSeconds <= 0) totalDurationSeconds = 300.0;
    } else {
      currentPosSeconds = _simulatedSeconds;
      totalDurationSeconds = _simulatedTotalSeconds > 0 ? _simulatedTotalSeconds : 300.0;
    }

    // B. Video Lecture with Full Controls
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls) _resetControlsTimer();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Native Video Surface
              if (_isNativeVideo && _videoController != null && _videoController!.value.isInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio > 0
                        ? _videoController!.value.aspectRatio
                        : (16 / 9),
                    child: VideoPlayer(_videoController!),
                  ),
                )
              else ...[
                // Video Background / Thumbnail fallback
                if (course.thumbnailUrl.isNotEmpty)
                  Opacity(
                    opacity: 0.45,
                    child: AppNetworkImage(
                      url: course.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: const SizedBox.shrink(),
                    ),
                  ),

                // Equalizer Pulse when playing simulated video
                if (_isPlaying && !_isBuffering)
                  Positioned(
                    bottom: 48,
                    right: isAr ? 14 : null,
                    left: isAr ? null : 14,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, _) {
                        return Row(
                          children: List.generate(5, (index) {
                            final height = 6.0 + 14.0 * ((index % 2 == 0 ? _waveController.value : 1.0 - _waveController.value));
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              width: 3.5,
                              height: height,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
              ],

              // 2. Buffering Spinner
              if (_isBuffering)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
                ),

              // 3. Mini Play/Pause Indicator when controls hidden
              if (!_showControls && !_isBuffering)
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isPlaying ? 0.0 : 0.85,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              // 4. Full Controls Overlay
              if (_showControls && !_isBuffering) ...[
                Container(color: Colors.black.withValues(alpha: 0.45)),

                // Center Controls: Rewind 10s | Play/Pause | Forward 10s
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 30),
                      onPressed: () => _seekRelative(-10),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 54,
                        height: 54,
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
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 30),
                      onPressed: () => _seekRelative(10),
                    ),
                  ],
                ),

                // Bottom Timeline Scrubber, Speed, Mute & Fullscreen
                Positioned(
                  bottom: 6,
                  left: 10,
                  right: 10,
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
                          value: currentPosSeconds.clamp(0.0, totalDurationSeconds),
                          max: totalDurationSeconds > 0 ? totalDurationSeconds : 300.0,
                          onChanged: (val) => _seekTo(val),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Text(
                              '${_formatDuration(currentPosSeconds)} / ${_formatDuration(totalDurationSeconds)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Spacer(),
                            // Speed Pill
                            GestureDetector(
                              onTap: _toggleSpeed,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Mute Toggle
                            GestureDetector(
                              onTap: _toggleMute,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Fullscreen Button
                            GestureDetector(
                              onTap: () => _openFullScreen(context, course, lecture, isAr),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.fullscreen_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
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
  Widget _buildPlayerTabs(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isAr) {
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
          Tab(text: context.loc.playerTabReviews),
        ],
      ),
    );
  }

  // ================= 3. TAB 1: CURRICULUM =================
  Widget _buildCurriculumTabView(
    CourseLearningProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    if (course.sections.isEmpty) {
      return Center(
        child: Text(
          context.loc.playerNoSectionsAvailable,
          style: TextStyle(fontSize: 13, color: textSubColor, fontFamily: 'Tajawal'),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: course.sections.length,
      itemBuilder: (context, secIdx) {
        final section = course.sections[secIdx];
        final isCurrentSection = secIdx == provider.currentSectionIndex;

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isCurrentSection,
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
              '${section.getFormattedDuration(context)} • ${context.loc.playerLessonsCount(section.lectures.length.toString())}',
              style: TextStyle(
                fontSize: 11,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            children: [
              for (int lesIdx = 0; lesIdx < section.lectures.length; lesIdx++) ...[
                _buildCurriculumLectureTile(provider, secIdx, lesIdx, cardBg, textColor, textSubColor, isDark, isAr),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9),
                  indent: 54,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurriculumLectureTile(
    CourseLearningProvider provider,
    int secIdx,
    int lesIdx,
    Color cardBg,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final section = provider.course!.sections[secIdx];
    final lecture = section.lectures[lesIdx];
    final isSelected = secIdx == provider.currentSectionIndex && lesIdx == provider.currentLectureIndex;
    final isCompleted = provider.isLectureCompleted(lecture.id);

    return Container(
      color: isSelected
          ? (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF))
          : cardBg,
      child: ListTile(
        onTap: () => _selectLecture(provider, secIdx, lesIdx),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: GestureDetector(
          onTap: () => _toggleLectureCompletion(provider, lecture.id),
          child: Icon(
            isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: isCompleted ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            size: 22,
          ),
        ),
        title: Text(
          lecture.title,
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
              lecture.isArticle
                  ? Icons.article_outlined
                  : Icons.play_circle_outline_rounded,
              size: 13,
              color: textSubColor,
            ),
            const SizedBox(width: 4),
            Text(
              lecture.formattedDuration,
              style: TextStyle(
                fontSize: 10.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.loc.playerPlayingBadge,
                  style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              )
            : null,
      ),
    );
  }

  // ================= 4. TAB 2: OVERVIEW =================
  Widget _buildOverviewTabView(
    CourseLearningProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final lecture = provider.currentLecture;
    final section = (provider.currentSectionIndex >= 0 && provider.currentSectionIndex < course.sections.length)
        ? course.sections[provider.currentSectionIndex]
        : null;

    final hasDescription = course.description.trim().isNotEmpty || course.shortDescription.trim().isNotEmpty;
    final descriptionText = course.description.trim().isNotEmpty ? course.description.trim() : course.shortDescription.trim();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Current Lecture Context Header Card
        if (lecture != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            lecture.isArticle ? Icons.article_rounded : Icons.play_circle_filled_rounded,
                            color: AppColors.primary,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lecture.isArticle ? context.loc.playerArticleBadge : context.loc.playerVideoBadge,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (section != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          section.title,
                          style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const SizedBox(width: 6),
                    Text(
                      lecture.formattedDuration,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSubColor, fontFamily: 'Inter'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lecture.title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 2. Article Reader Card (If active lecture is an Article)
        if (lecture != null && lecture.isArticle) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.15 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Color(0xFF10B981), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.playerFullArticleContent,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: borderColor),
                const SizedBox(height: 10),
                Text(
                  (lecture.articleContent != null && lecture.articleContent!.trim().isNotEmpty)
                      ? lecture.articleContent!
                      : context.loc.playerArticlePlaceholder,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                    height: 1.65,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 3. Course Description / Overview Card
        if (hasDescription) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.playerAboutCourseTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  descriptionText,
                  maxLines: _isDescriptionExpanded ? null : 3,
                  overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: textSubColor,
                    height: 1.55,
                    fontFamily: 'Tajawal',
                  ),
                ),
                if (descriptionText.length > 220) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isDescriptionExpanded
                                ? context.loc.playerShowLess
                                : context.loc.playerReadMore,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Icon(
                            _isDescriptionExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 4. What You Will Learn Card
        if (course.learnings.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.playerWhatYouWillLearn,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...course.learnings.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF10B981),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: textColor,
                              height: 1.4,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 5. Course Details Highlights (4-Grid)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.playerCourseInfoTitle,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoFeatureTile(
                      icon: Icons.schedule_rounded,
                      title: context.loc.playerTotalDurationTitle,
                      value: course.getFormattedDuration(context),
                      textColor: textColor,
                      textSubColor: textSubColor,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoFeatureTile(
                      icon: Icons.play_lesson_rounded,
                      title: context.loc.playerTotalLessonsTitle,
                      value: context.loc.playerLessonsNumber(course.calculatedTotalLectures.toString()),
                      textColor: textColor,
                      textSubColor: textSubColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoFeatureTile(
                      icon: Icons.bar_chart_rounded,
                      title: context.loc.playerLevelTitle,
                      value: course.level.isNotEmpty ? course.level : context.loc.playerAllLevels,
                      textColor: textColor,
                      textSubColor: textSubColor,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoFeatureTile(
                      icon: Icons.language_rounded,
                      title: context.loc.playerLanguageTitle,
                      value: course.language.isNotEmpty ? course.language : context.loc.playerLanguageArabic,
                      textColor: textColor,
                      textSubColor: textSubColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 6. Requirements Card (if any)
        if (course.requirements.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.rule_rounded, color: Color(0xFFF59E0B), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.playerPrerequisitesTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...course.requirements.map((req) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: textSubColor,
                              height: 1.4,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 7. Verified Certificate Progress Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: provider.progressPercentage >= 100
                  ? const Color(0xFF10B981)
                  : borderColor,
              width: provider.progressPercentage >= 100 ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: provider.progressPercentage >= 100
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFEFF4FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: provider.progressPercentage >= 100
                          ? const Color(0xFF10B981)
                          : AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.playerCertificateCardTitle,
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                        ),
                        Text(
                          provider.progressPercentage >= 100
                              ? context.loc.playerCourseCompletedSuccess
                              : '${context.loc.playerProgressLabel}: ${provider.completedLecturesCount}/${provider.totalLecturesCount} ${context.loc.playerLessonsCount(provider.totalLecturesCount.toString())} (${provider.progressPercentage}%)',
                          style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ),
                  if (provider.certificate != null || provider.progressPercentage >= 100)
                    AppButton(
                      text: context.loc.playerViewCertificateBtn,
                      width: null,
                      backgroundColor: const Color(0xFF10B981),
                      height: 32,
                      fontSize: 11,
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: () {
                        if (provider.certificate != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CertificateViewScreen(initialCertificate: provider.certificate),
                            ),
                          );
                        } else {
                          Navigator.pushNamed(context, '/certificates');
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (provider.progressPercentage / 100).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    provider.progressPercentage >= 100 ? const Color(0xFF10B981) : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 8. Instructor Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryDark,
                    backgroundImage: course.instructorAvatarUrl.isNotEmpty
                        ? CachedNetworkImageProvider(course.instructorAvatarUrl)
                        : null,
                    child: course.instructorAvatarUrl.isEmpty
                        ? const Icon(Icons.person_rounded, color: Colors.white, size: 26)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.instructorName,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                        ),
                        Text(
                          course.instructorTitle ?? context.loc.playerCertifiedInstructor,
                          style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (course.instructorAbout != null && course.instructorAbout!.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  course.instructorAbout!.trim(),
                  style: TextStyle(fontSize: 12, color: textSubColor, height: 1.45, fontFamily: 'Tajawal'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoFeatureTile({
    required IconData icon,
    required String title,
    required String value,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Tajawal')),
                Text(
                  value,
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= 5. TAB 3: Q&A / DISCUSSIONS =================
  Widget _buildQnATabView(
    CourseLearningProvider provider,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final allComments = provider.comments;

    return Column(
      children: [
        // 1. Discussions Count Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Text(
            context.loc.playerDiscussionsCount(allComments.length.toString()),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ),

        // 2. Simple & Clean Add Question Input Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor.withValues(alpha: 0.6)),
                  ),
                  child: TextField(
                    controller: _commentController,
                    minLines: 1,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                    decoration: InputDecoration(
                      hintText: context.loc.playerAskQuestionHint,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                text: context.loc.playerPostBtn,
                width: null,
                height: 38,
                fontSize: 12,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                isLoading: provider.isSubmittingComment,
                onPressed: () => _addComment(provider),
              ),
            ],
          ),
        ),

        // 3. Comments List
        Expanded(
          child: provider.isLoadingComments && allComments.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : allComments.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.forum_outlined,
                              size: 44,
                              color: textSubColor.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              context.loc.playerNoDiscussionsTitle,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.loc.playerNoDiscussionsSubtitle,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: textSubColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(14),
                      itemCount: allComments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final comment = allComments[index];
                        return _buildCommentCard(provider, comment, cardBg, borderColor, textColor, textSubColor, isDark, isAr);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildCommentCard(
    CourseLearningProvider provider,
    LectureCommentModel comment,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final isReplying = _replyingToCommentId == comment.id;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Instructor Badge, Time
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFEFF4FF),
                backgroundImage: comment.formattedAvatarUrl.isNotEmpty
                    ? CachedNetworkImageProvider(comment.formattedAvatarUrl)
                    : null,
                child: comment.formattedAvatarUrl.isEmpty
                    ? Text(
                        comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.userName,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (comment.isInstructorReply) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 10, color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              context.loc.playerInstructorBadge,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                comment.displayTimeAgo,
                style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Inter'),
              ),
            ],
          ),
          const SizedBox(height: 9),
          // Question Content
          Text(
            comment.content,
            style: TextStyle(fontSize: 12.5, color: textColor, fontFamily: 'Tajawal', height: 1.4),
          ),
          const SizedBox(height: 10),
          // Action Buttons: Reply button & replies count
          Row(
            children: [
              // Reply Button
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _replyingToCommentId = isReplying ? null : comment.id;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: isReplying
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : (isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isReplying ? AppColors.primary : borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isReplying ? Icons.close_rounded : Icons.reply_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isReplying ? context.loc.playerCancelReply : context.loc.playerReplyAction,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
              ),
              if (comment.replies.isNotEmpty) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    context.loc.playerRepliesCount(comment.replies.length.toString()),
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: textSubColor, fontFamily: 'Tajawal'),
                  ),
                ),
              ],
            ],
          ),

          // Replies Thread List
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: comment.replies.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          child: Text(
                            reply.userName.isNotEmpty ? reply.userName[0].toUpperCase() : 'R',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    reply.userName,
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                                  ),
                                  if (reply.isInstructorReply) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        context.loc.playerInstructorBadge,
                                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reply.content,
                                style: TextStyle(fontSize: 11.5, color: textColor, fontFamily: 'Tajawal', height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Inline Reply Input Box
          if (isReplying) ...[
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      autofocus: true,
                      style: TextStyle(fontSize: 12, color: textColor, fontFamily: 'Tajawal'),
                      decoration: InputDecoration(
                        hintText: context.loc.playerWriteReplyHint,
                        hintStyle: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AppButton(
                    text: context.loc.playerSendReplyBtn,
                    width: null,
                    height: 30,
                    fontSize: 11,
                    borderRadius: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () => _replyToComment(provider, comment.id),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= 6. TAB 4: COURSE RATINGS & REVIEWS =================
  Widget _buildCourseRatingsTabView(
    CourseLearningProvider provider,
    CourseDetailsModel course,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final allRatings = provider.courseRatings;
    final summary = (provider.ratingSummary != null &&
            (provider.ratingSummary!.fiveStarCount +
                    provider.ratingSummary!.fourStarCount +
                    provider.ratingSummary!.threeStarCount +
                    provider.ratingSummary!.twoStarCount +
                    provider.ratingSummary!.oneStarCount >
                0))
        ? provider.ratingSummary!
        : CourseRatingSummaryModel.fromRatingsList(
            allRatings,
            fallbackAvg: course.averageRating > 0 ? course.averageRating : provider.ratingSummary?.averageRating,
            fallbackTotal: course.totalRatings > 0 ? course.totalRatings : provider.ratingSummary?.totalRatings,
          );
    final myRating = provider.myRating;
    final progress = provider.progressPercentage;
    final canRate = provider.canRate || progress >= 80;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Rating Summary Header Card (Udemy & EduLab MVC style)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.playerCourseFeedbackTitle,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Big rating circle / score
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          summary.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          context.loc.playerOutOf5,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Rating Breakdown Bars (5★ to 1★)
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBarRow(5, summary.fiveStarRatio, summary.fiveStarCount, textColor, textSubColor, isDark),
                        const SizedBox(height: 4),
                        _buildRatingBarRow(4, summary.fourStarRatio, summary.fourStarCount, textColor, textSubColor, isDark),
                        const SizedBox(height: 4),
                        _buildRatingBarRow(3, summary.threeStarRatio, summary.threeStarCount, textColor, textSubColor, isDark),
                        const SizedBox(height: 4),
                        _buildRatingBarRow(2, summary.twoStarRatio, summary.twoStarCount, textColor, textSubColor, isDark),
                        const SizedBox(height: 4),
                        _buildRatingBarRow(1, summary.oneStarRatio, summary.oneStarCount, textColor, textSubColor, isDark),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  context.loc.playerRatingsFromEnrolledCount(summary.totalRatings.toString()),
                  style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Student Rating Box (Incentive / Existing Rating / New Rating Form)
        // Case A: User has not reached 80% and hasn't rated yet
        if (!canRate && myRating == null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Color(0xFF2563EB), size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  context.loc.playerKeepLearningToRate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.loc.playerRateAfter80Hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF3B82F6),
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.playerCurrentProgressLabel,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF), fontFamily: 'Tajawal'),
                    ),
                    Text(
                      '$progress%',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF), fontFamily: 'Inter'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (progress / 100.0).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: const Color(0xFFBFDBFE),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Case B: User already rated and not currently in edit mode
        if (myRating != null && !_isEditingExistingRating) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFF16A34A), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      context.loc.playerYourCurrentRating,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${myRating.rating.toStringAsFixed(0)} / 5',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < myRating.rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 20,
                    );
                  }),
                ),
                if (myRating.comment != null && myRating.comment!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      myRating.comment!,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userRatingValue = myRating.rating.round().clamp(1, 5);
                            _ratingReviewController.text = myRating.comment ?? '';
                            _isEditingExistingRating = true;
                          });
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(
                          context.loc.playerEditRating,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: context.loc.playerDeleteRatingTooltip,
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                      onPressed: () => _confirmDeleteRating(provider, isAr),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Case C: Eligible to rate OR currently editing
        if ((canRate && myRating == null) || _isEditingExistingRating) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isEditingExistingRating ? Icons.edit_note_rounded : Icons.rate_review_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isEditingExistingRating
                          ? context.loc.playerUpdateRatingTitle
                          : context.loc.playerRateCourseTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      final isSelected = starValue <= _userRatingValue;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _userRatingValue = starValue);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 34,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    _getRatingLabelText(_userRatingValue, isAr),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF59E0B),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: _ratingReviewController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 12.5, color: textColor, fontFamily: 'Tajawal'),
                    decoration: InputDecoration(
                      hintText: context.loc.playerWriteReviewHint,
                      hintStyle: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: _isEditingExistingRating
                            ? context.loc.playerSaveChangesBtn
                            : context.loc.playerSubmitReviewBtn,
                        isLoading: provider.isSubmittingRating,
                        height: 40,
                        fontSize: 12.5,
                        borderRadius: 10,
                        onPressed: () async {
                          final success = await provider.submitRating(
                            _userRatingValue,
                            _ratingReviewController.text.trim(),
                          );
                          if (!mounted) return;
                          if (success) {
                            setState(() => _isEditingExistingRating = false);
                            AppSnackbar.showSuccess(
                              context,
                              context.loc.playerRatingSubmitSuccess,
                            );
                          } else {
                            AppSnackbar.showError(
                              context,
                              context.loc.playerRatingSubmitFailed,
                            );
                          }
                        },
                      ),
                    ),
                    if (_isEditingExistingRating) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => setState(() => _isEditingExistingRating = false),
                        child: Text(
                          context.loc.playerCancelReply,
                          style: TextStyle(fontSize: 12, color: textSubColor, fontFamily: 'Tajawal'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 3. Student Reviews List Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.playerLearnerReviewsTitle,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
            ),
            if (allRatings.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.loc.playerReviewsCount(allRatings.length.toString()),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSubColor, fontFamily: 'Tajawal'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (provider.isLoadingRatings && allRatings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          )
        else if (allRatings.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_outline_rounded, size: 40, color: textSubColor.withValues(alpha: 0.4)),
                const SizedBox(height: 8),
                Text(
                  context.loc.playerNoWrittenReviewsTitle,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 4),
                Text(
                  context.loc.playerNoWrittenReviewsSubtitle,
                  style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                ),
              ],
            ),
          )
        else
          Column(
            children: allRatings.map((rating) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          backgroundImage: rating.avatarUrl.isNotEmpty
                              ? CachedNetworkImageProvider(rating.avatarUrl)
                              : null,
                          child: rating.avatarUrl.isEmpty
                              ? Text(
                                  rating.userName.isNotEmpty ? rating.userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rating.userName,
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: textColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (sIdx) {
                                      return Icon(
                                        sIdx < rating.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                        size: 13,
                                        color: const Color(0xFFF59E0B),
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    rating.formattedDate,
                                    style: TextStyle(fontSize: 10, color: textSubColor, fontFamily: 'Inter'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (rating.comment != null && rating.comment!.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        rating.comment!,
                        style: TextStyle(fontSize: 12.5, color: textColor, fontFamily: 'Tajawal', height: 1.4),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRatingBarRow(int stars, double ratio, int count, Color textColor, Color textSubColor, bool isDark) {
    final percentage = (ratio * 100).round();
    return Row(
      children: [
        SizedBox(
          width: 12,
          child: Text(
            '$stars',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Inter'),
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: percentage > 0 ? textColor : textSubColor,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  String _getRatingLabelText(int stars, bool isAr) {
    switch (stars) {
      case 5:
        return context.loc.playerRatingLabel5;
      case 4:
        return context.loc.playerRatingLabel4;
      case 3:
        return context.loc.playerRatingLabel3;
      case 2:
        return context.loc.playerRatingLabel2;
      case 1:
      default:
        return context.loc.playerRatingLabel1;
    }
  }

  void _confirmDeleteRating(CourseLearningProvider provider, bool isAr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.loc.playerDeleteRatingDialogTitle, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
        content: Text(
          context.loc.playerDeleteRatingDialogMessage,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.loc.playerCancelReply, style: const TextStyle(fontFamily: 'Tajawal')),
          ),
          AppButton(
            text: context.loc.playerDeleteConfirmBtn,
            width: null,
            backgroundColor: const Color(0xFFEF4444),
            height: 36,
            fontSize: 12,
            borderRadius: 8,
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteRating();
              if (mounted && success) {
                AppSnackbar.showSuccess(context, context.loc.playerRatingDeleteSuccess);
              }
            },
          ),
        ],
      ),
    );
  }

  // ================= 7. BOTTOM NAVIGATION BAR =================
  Widget _buildBottomPlayerNavBar(
    CourseLearningProvider provider,
    CourseLectureModel? currentLecture,
    bool isCompleted,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
    bool isAr,
  ) {
    final hasPrev = provider.hasPreviousLesson;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 1. Previous Lesson Button
            Expanded(
              child: Opacity(
                opacity: hasPrev ? 1.0 : 0.45,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: hasPrev ? () => _playPreviousLesson(provider) : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
                          size: 14,
                          color: hasPrev ? textColor : textSubColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.loc.playerPreviousLesson,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                            color: hasPrev ? textColor : textSubColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. Next Lesson Button
            Expanded(
              child: AppButton(
                text: context.loc.playerNextLesson,
                height: 44,
                fontSize: 12.5,
                borderRadius: 12,
                icon: isAr ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                onPressed: () => _playNextLesson(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading(Color cardBg, Color borderColor, bool isDark) {
    return AppSkeleton(
      child: Column(
        children: [
          const SkeletonBox(width: double.infinity, height: 210, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                4,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SkeletonBox(width: double.infinity, height: 60, borderRadius: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenVideoPlayer extends StatefulWidget {
  final CourseDetailsModel course;
  final CourseLectureModel lecture;
  final VideoPlayerController? videoController;
  final bool isNativeVideo;
  final bool isBuffering;
  final bool isPlaying;
  final bool isMuted;
  final double playbackSpeed;
  final double simulatedSeconds;
  final double simulatedTotalSeconds;
  final AnimationController waveController;
  final bool isAr;
  final VoidCallback onTogglePlayPause;
  final void Function(int) onSeekRelative;
  final void Function(double) onSeekTo;
  final void Function(double) onSpeedChanged;
  final void Function(bool) onMuteChanged;
  final VoidCallback? onExitFullscreen;

  const _FullScreenVideoPlayer({
    required this.course,
    required this.lecture,
    required this.videoController,
    required this.isNativeVideo,
    required this.isBuffering,
    required this.isPlaying,
    required this.isMuted,
    required this.playbackSpeed,
    required this.simulatedSeconds,
    required this.simulatedTotalSeconds,
    required this.waveController,
    required this.isAr,
    required this.onTogglePlayPause,
    required this.onSeekRelative,
    required this.onSeekTo,
    required this.onSpeedChanged,
    required this.onMuteChanged,
    this.onExitFullscreen,
  });

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  bool _showControls = true;
  Timer? _controlsTimer;
  late double _playbackSpeed;
  late bool _isMuted;

  @override
  void initState() {
    super.initState();
    _playbackSpeed = widget.playbackSpeed;
    _isMuted = widget.isMuted;
    widget.videoController?.addListener(_onVideoTick);
    _resetControlsTimer();
  }

  void _onVideoTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    widget.videoController?.removeListener(_onVideoTick);
    super.dispose();
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _handleToggleSpeed() {
    HapticFeedback.selectionClick();
    double nextSpeed;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 2.0;
    } else if (_playbackSpeed == 2.0) {
      nextSpeed = 0.75;
    } else {
      nextSpeed = 1.0;
    }
    setState(() => _playbackSpeed = nextSpeed);
    widget.onSpeedChanged(nextSpeed);
    _resetControlsTimer();
  }

  void _handleToggleMute() {
    HapticFeedback.selectionClick();
    setState(() => _isMuted = !_isMuted);
    widget.onMuteChanged(_isMuted);
    _resetControlsTimer();
  }

  void _handleExit() {
    if (widget.onExitFullscreen != null) {
      widget.onExitFullscreen!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  String _formatDuration(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isNative = widget.isNativeVideo &&
        widget.videoController != null &&
        widget.videoController!.value.isInitialized;

    double currentPos = 0.0;
    double totalDur = 300.0;
    bool isPlaying = widget.isPlaying;
    bool isBuffering = widget.isBuffering;

    if (isNative) {
      currentPos = widget.videoController!.value.position.inMilliseconds / 1000.0;
      totalDur = widget.videoController!.value.duration.inMilliseconds / 1000.0;
      if (totalDur <= 0) totalDur = 300.0;
      isPlaying = widget.videoController!.value.isPlaying;
      isBuffering = widget.videoController!.value.isBuffering;
    } else {
      currentPos = widget.simulatedSeconds;
      totalDur = widget.simulatedTotalSeconds > 0 ? widget.simulatedTotalSeconds : 300.0;
    }

    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    Widget mainPlayer = Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls) _resetControlsTimer();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Video Surface
            if (isNative)
              Center(
                child: AspectRatio(
                  aspectRatio: widget.videoController!.value.aspectRatio > 0
                      ? widget.videoController!.value.aspectRatio
                      : (16 / 9),
                  child: VideoPlayer(widget.videoController!),
                ),
              )
            else ...[
              if (widget.course.thumbnailUrl.isNotEmpty)
                Opacity(
                  opacity: 0.4,
                  child: AppNetworkImage(
                    url: widget.course.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              if (isPlaying && !isBuffering)
                Center(
                  child: AnimatedBuilder(
                    animation: widget.waveController,
                    builder: (context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(7, (index) {
                          final height = 10.0 + 24.0 * ((index % 2 == 0 ? widget.waveController.value : 1.0 - widget.waveController.value));
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            width: 5,
                            height: height,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
            ],

            // 2. Buffering Spinner
            if (isBuffering)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3.5),
              ),

            // 3. Mini Play Icon when controls hidden
            if (!_showControls && !isBuffering && !isPlaying)
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
                ),
              ),

            // 4. Controls Overlay
            if (_showControls && !isBuffering) ...[
              Container(color: Colors.black.withValues(alpha: 0.45)),

              // Top Bar: Back button & Titles
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                      onPressed: _handleExit,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.course.title,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.lecture.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Center controls: Rewind 10s | Play/Pause | Forward 10s
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 38),
                    onPressed: () {
                      widget.onSeekRelative(-10);
                      setState(() {});
                      _resetControlsTimer();
                    },
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      widget.onTogglePlayPause();
                      setState(() {});
                      _resetControlsTimer();
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 38),
                    onPressed: () {
                      widget.onSeekRelative(10);
                      setState(() {});
                      _resetControlsTimer();
                    },
                  ),
                ],
              ),

              // Bottom Timeline Scrubber, Duration, Speed, Mute & Exit Fullscreen
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: currentPos.clamp(0.0, totalDur),
                        max: totalDur > 0 ? totalDur : 300.0,
                        onChanged: (val) {
                          widget.onSeekTo(val);
                          setState(() {});
                          _resetControlsTimer();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            '${_formatDuration(currentPos)} / ${_formatDuration(totalDur)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          // Speed Pill
                          GestureDetector(
                            onTap: _handleToggleSpeed,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_playbackSpeed}x',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Mute Toggle
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: _handleToggleMute,
                          ),
                          const SizedBox(width: 8),
                          // Exit Fullscreen
                          IconButton(
                            icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white, size: 26),
                            tooltip: context.loc.playerExitFullscreenTooltip,
                            onPressed: _handleExit,
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
    );

    if (isPortrait) {
      return RotatedBox(
        quarterTurns: 1,
        child: mainPlayer,
      );
    }
    return mainPlayer;
  }
}
