import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:video_player/video_player.dart';

/// Interactive modal bottom sheet player for previewing free course lectures (video & article aware).
class CoursePreviewPlayerModal extends StatefulWidget {
  final CourseDetailsModel course;
  final CourseLectureModel? initialLecture;
  final VoidCallback onEnrollNow;

  const CoursePreviewPlayerModal({
    super.key,
    required this.course,
    this.initialLecture,
    required this.onEnrollNow,
  });

  @override
  State<CoursePreviewPlayerModal> createState() =>
      _CoursePreviewPlayerModalState();
}

class _CoursePreviewPlayerModalState extends State<CoursePreviewPlayerModal>
    with SingleTickerProviderStateMixin {
  late CourseLectureModel _currentLecture;
  late List<CourseSectionModel> _freeSections;
  late List<CourseLectureModel> _previewLectures;

  // Real Video Player Controller
  VideoPlayerController? _videoController;
  bool _isNativeVideo = false;
  bool _isBuffering = false;
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _showControls = true;
  double _playbackSpeed = 1.0;
  double _articleFontSize = 14.0;

  // Fallback Simulation State
  double _simulatedSeconds = 0.0;
  double _simulatedTotalSeconds = 320.0;
  Timer? _simulatedTimer;
  Timer? _controlsTimer;

  // Waveform animation
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Collect ONLY the Free Sections from backend
    final sections = widget.course.sections;
    _freeSections = sections
        .where((s) => s.isFreePreview || s.lectures.any((l) => l.isFreePreview))
        .map((s) {
          final freeLectures = s.isFreePreview
              ? s.lectures
              : s.lectures.where((l) => l.isFreePreview).toList();
          return CourseSectionModel(
            id: s.id,
            title: s.title,
            order: s.order,
            courseId: s.courseId,
            isFreePreview: true,
            lectures: freeLectures,
            isExpanded: true,
          );
        })
        .where((s) => s.lectures.isNotEmpty)
        .toList();

    _previewLectures = _freeSections.expand((s) => s.lectures).toList();

    if (_previewLectures.isEmpty && widget.initialLecture != null) {
      _previewLectures = [widget.initialLecture!];
    }

    if (_previewLectures.isNotEmpty) {
      _currentLecture = widget.initialLecture ?? _previewLectures.first;
      _initLecture(_currentLecture);
    }
    _resetControlsTimer();
  }

  String _getVideoUrl(CourseLectureModel lecture) {
    if (lecture.videoUrl != null && lecture.videoUrl!.trim().isNotEmpty) {
      return ApiConstants.formatImageUrl(lecture.videoUrl);
    }
    return '';
  }

  Future<void> _initLecture(CourseLectureModel lecture) async {
    _simulatedTimer?.cancel();
    final oldController = _videoController;

    if (lecture.isArticle) {
      // It's an Article
      if (oldController != null) {
        try {
          oldController.removeListener(_videoListener);
          await oldController.dispose();
        } catch (_) {}
      }
      _videoController = null;
      setState(() {
        _isBuffering = false;
        _isNativeVideo = false;
        _isPlaying = false;
      });
      return;
    }

    // It's a Video
    setState(() {
      _isBuffering = true;
      _isNativeVideo = false;
      _simulatedSeconds = 0.0;
      _simulatedTotalSeconds = (lecture.duration > 0 ? lecture.duration : 320)
          .toDouble();
      _isPlaying = true;
    });

    if (oldController != null) {
      try {
        oldController.removeListener(_videoListener);
        await oldController.dispose();
      } catch (_) {}
    }

    final url = _getVideoUrl(lecture);
    if (url.isEmpty) {
      setState(() {
        _isBuffering = false;
        _isNativeVideo = false;
        _isPlaying = false;
      });
      return;
    }

    bool nativeSuccess = false;

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _videoController = controller;
      await controller.initialize();

      if (mounted) {
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

    if (!nativeSuccess && mounted) {
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
            // Auto advance
            final currentIndex = _previewLectures.indexWhere(
              (l) => l.id == _currentLecture.id,
            );
            if (currentIndex != -1 &&
                currentIndex + 1 < _previewLectures.length) {
              _switchLecture(_previewLectures[currentIndex + 1]);
            }
          }
        });
      }
    });
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;
    final isPlaying = _videoController!.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    } else {
      setState(() {});
    }

    if (_videoController!.value.isInitialized &&
        _videoController!.value.position >= _videoController!.value.duration &&
        _videoController!.value.duration > Duration.zero) {
      final currentIndex = _previewLectures.indexWhere(
        (l) => l.id == _currentLecture.id,
      );
      if (currentIndex != -1 && currentIndex + 1 < _previewLectures.length) {
        _switchLecture(_previewLectures[currentIndex + 1]);
      }
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _simulatedTimer?.cancel();
    _waveController.dispose();
    if (_videoController != null) {
      try {
        _videoController!.removeListener(_videoListener);
        _videoController!.dispose();
      } catch (_) {}
    }
    super.dispose();
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

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetControlsTimer();
    }
  }

  void _togglePlayPause() {
    HapticFeedback.selectionClick();
    if (_isNativeVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        setState(() {
          _isPlaying = false;
          _showControls = true;
        });
      } else {
        _videoController!.play();
        setState(() {
          _isPlaying = true;
        });
        _resetControlsTimer();
      }
    } else {
      // Simulated Engine
      setState(() {
        _isPlaying = !_isPlaying;
        if (_isPlaying && _simulatedSeconds >= _simulatedTotalSeconds) {
          _simulatedSeconds = 0.0;
        }
      });
      if (_isPlaying) {
        _resetControlsTimer();
      } else {
        setState(() => _showControls = true);
      }
    }
  }

  void _seekRelative(int secondsDelta) {
    HapticFeedback.selectionClick();
    if (_isNativeVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      final current = _videoController!.value.position;
      final target = current + Duration(seconds: secondsDelta);
      final duration = _videoController!.value.duration;
      if (target < Duration.zero) {
        _videoController!.seekTo(Duration.zero);
      } else if (target > duration) {
        _videoController!.seekTo(duration);
      } else {
        _videoController!.seekTo(target);
      }
    } else {
      setState(() {
        _simulatedSeconds = (_simulatedSeconds + secondsDelta).clamp(
          0.0,
          _simulatedTotalSeconds,
        );
      });
    }
    _resetControlsTimer();
  }

  void _toggleSpeed() {
    HapticFeedback.selectionClick();
    double nextSpeed = 1.0;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 2.0;
    } else {
      nextSpeed = 1.0;
    }

    setState(() => _playbackSpeed = nextSpeed);
    if (_isNativeVideo && _videoController != null) {
      _videoController!.setPlaybackSpeed(nextSpeed);
    }
    _resetControlsTimer();
  }

  void _toggleMute() {
    HapticFeedback.selectionClick();
    setState(() => _isMuted = !_isMuted);
    if (_isNativeVideo && _videoController != null) {
      _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
    }
    _resetControlsTimer();
  }

  void _switchLecture(CourseLectureModel lecture) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentLecture = lecture;
      _showControls = true;
    });
    _initLecture(lecture);
  }

  String _formatDuration(Duration duration) {
    final mins = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;

    // Adaptive Theme Colors for Light & Dark Mode
    final sheetBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final currentIndex = _previewLectures.indexWhere(
      (l) => l.id == _currentLecture.id,
    );
    final hasPrevious = currentIndex > 0;
    final hasNext =
        currentIndex != -1 && currentIndex + 1 < _previewLectures.length;

    // Position & Duration (Native or Simulated)
    final Duration position = _isNativeVideo && _videoController != null
        ? _videoController!.value.position
        : Duration(milliseconds: (_simulatedSeconds * 1000).toInt());

    final Duration duration =
        _isNativeVideo &&
            _videoController != null &&
            _videoController!.value.duration > Duration.zero
        ? _videoController!.value.duration
        : Duration(seconds: _simulatedTotalSeconds.toInt());

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Drag Handle & Title Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: sheetBg,
              border: Border(bottom: BorderSide(color: borderColor)),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _currentLecture.isArticle
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _currentLecture.isArticle
                              ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _currentLecture.isArticle
                                ? Icons.menu_book_rounded
                                : Icons.play_circle_filled_rounded,
                            size: 13,
                            color: _currentLecture.isArticle
                                ? const Color(0xFF3B82F6)
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _currentLecture.isArticle
                                ? context.loc.articleLecture
                                : context.loc.freeDemoVideo,
                            style: TextStyle(
                              color: _currentLecture.isArticle
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _currentLecture.isArticle
                          ? context.loc.articleViewer
                          : context.loc.courseVideoPlayer,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: textSecondary,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // MEDIA CANVAS (VIDEO OR ARTICLE READER)
          if (_currentLecture.isArticle)
            // ================= 1. RICH ARTICLE READER =================
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Article Header Info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.article_outlined,
                                color: Color(0xFF3B82F6),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentLecture.title,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  Text(
                                    context.loc.courseDetailsEstimatedReading,
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 10.5,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Font Size Adjuster
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.text_decrease_rounded,
                                    size: 18,
                                    color: textSecondary,
                                  ),
                                  onPressed: () {
                                    if (_articleFontSize > 12) {
                                      setState(() => _articleFontSize -= 1);
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.text_increase_rounded,
                                    size: 18,
                                    color: textSecondary,
                                  ),
                                  onPressed: () {
                                    if (_articleFontSize < 20) {
                                      setState(() => _articleFontSize += 1);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: borderColor),
                        const SizedBox(height: 12),

                        // Article Body Text
                        SelectableText(
                          (_currentLecture.articleContent != null &&
                                  _currentLecture.articleContent!
                                      .trim()
                                      .isNotEmpty)
                              ? _currentLecture.articleContent!
                              : context.loc.courseDetailsSampleArticleContent,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: _articleFontSize,
                            fontFamily: 'Tajawal',
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // ================= 2. 16:9 PRO VIDEO CANVAS & CONTROLLER =================
            AspectRatio(
              aspectRatio: 16 / 9,
              child: GestureDetector(
                onTap: _toggleControlsVisibility,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Native Video Surface OR Dynamic High-Quality Video Visualizer
                      if (_isNativeVideo &&
                          _videoController != null &&
                          _videoController!.value.isInitialized)
                        Center(
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio > 0
                                ? _videoController!.value.aspectRatio
                                : (16 / 9),
                            child: VideoPlayer(_videoController!),
                          ),
                        )
                      else ...[
                        // Dynamic Video Visualizer Backdrop
                        AppNetworkImage(
                          url: widget.course.thumbnailUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: Container(
                            color: AppColors.textPrimary,
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                          ),
                        ),

                        // Subtle Dark Video Overlay
                        Container(color: Colors.black.withValues(alpha: 0.45)),

                        // Dynamic Audio/Video Equalizer Pulse
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
                                    final height =
                                        6.0 +
                                        14.0 *
                                            ((index % 2 == 0
                                                ? _waveController.value
                                                : 1.0 - _waveController.value));
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1.5,
                                      ),
                                      width: 3.5,
                                      height: height,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.9,
                                        ),
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
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                        ),

                      // 3. Dark Overlay Tint for Controls
                      if (_showControls && !_isBuffering)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          color: Colors.black.withValues(alpha: 0.52),
                        ),

                      // 4. CONTROLS OVERLAY (Auto-fading)
                      if (_showControls && !_isBuffering) ...[
                        // Top Bar info (Badge + Quality + Sound + Speed)
                        Positioned(
                          top: 10,
                          left: 12,
                          right: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: const Text(
                                  '1080p Full HD',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isMuted
                                          ? Icons.volume_off_rounded
                                          : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: _toggleMute,
                                  ),
                                  GestureDetector(
                                    onTap: _toggleSpeed,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(5),
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
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Center Playback Buttons (-10s | Play/Pause | +10s)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.replay_10_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => _seekRelative(-10),
                            ),
                            const SizedBox(width: 18),
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            IconButton(
                              icon: const Icon(
                                Icons.forward_10_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => _seekRelative(10),
                            ),
                          ],
                        ),

                        // Bottom Scrubber Bar & Timestamps
                        Positioned(
                          bottom: 4,
                          left: 10,
                          right: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3.5,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12,
                                  ),
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: Colors.white,
                                ),
                                child: Slider(
                                  value: position.inMilliseconds
                                      .toDouble()
                                      .clamp(
                                        0.0,
                                        duration.inMilliseconds.toDouble() > 0
                                            ? duration.inMilliseconds.toDouble()
                                            : 1.0,
                                      ),
                                  max: duration.inMilliseconds.toDouble() > 0
                                      ? duration.inMilliseconds.toDouble()
                                      : 1.0,
                                  onChanged: (val) {
                                    if (_isNativeVideo &&
                                        _videoController != null) {
                                      _videoController!.seekTo(
                                        Duration(milliseconds: val.toInt()),
                                      );
                                    } else {
                                      setState(() {
                                        _simulatedSeconds = val / 1000.0;
                                      });
                                    }
                                    _resetControlsTimer();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (hasPrevious)
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.skip_previous_rounded,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                            onPressed: () => _switchLecture(
                                              _previewLectures[currentIndex -
                                                  1],
                                            ),
                                          ),
                                        if (hasNext) ...[
                                          const SizedBox(width: 12),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                              Icons.skip_next_rounded,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                            onPressed: () => _switchLecture(
                                              _previewLectures[currentIndex +
                                                  1],
                                            ),
                                          ),
                                        ],
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                              context,
                                              '/lesson-player',
                                              arguments: widget.course.id,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.fullscreen_rounded,
                                            color: Colors.white,
                                            size: 22,
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
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // Current Lecture Info Tile (Themed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentLecture.title,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.course.title,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 11,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (_currentLecture.isArticle
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF10B981))
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          (_currentLecture.isArticle
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF10B981))
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _currentLecture.isArticle
                        ? context.loc.readingNow
                        : context.loc.playingNow,
                    style: TextStyle(
                      color: _currentLecture.isArticle
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FREE SECTIONS & LECTURES LIST ONLY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_freeSections.isEmpty && _previewLectures.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        context.loc.noLecturesInFreeSection,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  )
                else
                  ..._freeSections.map((section) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Free Section Header
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.folder_open_rounded,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        section.title,
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      Text(
                                        context.loc.freeLecturesCount(
                                          section.lectures.length.toString(),
                                        ),
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 10.5,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    context.loc.freeSection,
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: borderColor),

                          // Lectures in this Free Section (Video or Article Aware)
                          ...section.lectures.map((lec) {
                            final isSelected = lec.id == _currentLecture.id;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (lec.isArticle
                                          ? const Color(0xFF3B82F6).withValues(
                                              alpha: isDark ? 0.2 : 0.08,
                                            )
                                          : AppColors.primary.withValues(
                                              alpha: isDark ? 0.2 : 0.08,
                                            ))
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: lec.isArticle
                                            ? const Color(0xFF3B82F6)
                                            : AppColors.primary,
                                        width: 1.2,
                                      )
                                    : null,
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                onTap: () => _switchLecture(lec),
                                leading: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (lec.isArticle
                                              ? const Color(0xFF3B82F6)
                                              : AppColors.primary)
                                        : (isDark
                                              ? Colors.white10
                                              : const Color(0xFFE2E8F0)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    lec.isArticle
                                        ? Icons.menu_book_rounded
                                        : (isSelected && _isPlaying
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded),
                                    color: isSelected
                                        ? Colors.white
                                        : (lec.isArticle
                                              ? const Color(0xFF3B82F6)
                                              : textSecondary),
                                    size: 15,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lec.title,
                                        style: TextStyle(
                                          color: isSelected
                                          ? (lec.isArticle
                                                ? const Color(0xFF3B82F6)
                                                : AppColors.primary)
                                          : textPrimary,
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                          fontFamily: 'Tajawal',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (lec.isArticle
                                                    ? const Color(0xFF3B82F6)
                                                    : AppColors.primary)
                                                .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        lec.isArticle
                                            ? context.loc.articleWord
                                            : context.loc.videoWord,
                                        style: TextStyle(
                                          color: lec.isArticle
                                              ? const Color(0xFF3B82F6)
                                              : AppColors.primary,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  lec.formattedDuration,
                                  style: TextStyle(
                                    color: isSelected
                                        ? (lec.isArticle
                                              ? const Color(0xFF3B82F6)
                                              : AppColors.primary)
                                        : textSecondary,
                                    fontSize: 10.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 6),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          // BOTTOM ENROLLMENT CTA BAR (Themed)
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.paddingOf(context).bottom + 12,
            ),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.finalPrice == 0
                          ? context.loc.courseDetailsFree
                          : '${widget.course.finalPrice.toStringAsFixed(0)} EGP',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    if (widget.course.hasDiscount)
                      Text(
                        '${widget.course.price.toStringAsFixed(0)} EGP',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    height: 46,
                    borderRadius: 10,
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: context.loc.enrollInFullCourse,
                    fontSize: 13,
                    onPressed: widget.onEnrollNow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
