import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:video_player/video_player.dart';

/// Full-screen video player supporting native player controls, orientation adjustments,
/// simulated playback fallback, speed toggle, and responsive seek actions.
class FullScreenVideoPlayer extends StatefulWidget {
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

  const FullScreenVideoPlayer({
    super.key,
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
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
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
    final isNative =
        widget.isNativeVideo &&
        widget.videoController != null &&
        widget.videoController!.value.isInitialized;

    double currentPos = 0.0;
    double totalDur = 300.0;
    bool isPlaying = widget.isPlaying;
    bool isBuffering = widget.isBuffering;

    if (isNative) {
      currentPos =
          widget.videoController!.value.position.inMilliseconds / 1000.0;
      totalDur = widget.videoController!.value.duration.inMilliseconds / 1000.0;
      if (totalDur <= 0) totalDur = 300.0;
      isPlaying = widget.videoController!.value.isPlaying;
      isBuffering = widget.videoController!.value.isBuffering;
    } else {
      currentPos = widget.simulatedSeconds;
      totalDur = widget.simulatedTotalSeconds > 0
          ? widget.simulatedTotalSeconds
          : 300.0;
    }

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

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
                          final height =
                              10.0 +
                              24.0 *
                                  ((index % 2 == 0
                                      ? widget.waveController.value
                                      : 1.0 - widget.waveController.value));
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
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3.5,
                ),
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
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
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
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
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
                    icon: const Icon(
                      Icons.replay_10_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
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
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(
                      Icons.forward_10_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
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
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
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
                              _isMuted
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: _handleToggleMute,
                          ),
                          const SizedBox(width: 8),
                          // Exit Fullscreen
                          IconButton(
                            icon: const Icon(
                              Icons.fullscreen_exit_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
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
      return RotatedBox(quarterTurns: 1, child: mainPlayer);
    }
    return mainPlayer;
  }
}
