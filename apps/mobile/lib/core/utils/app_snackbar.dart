import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppSnackbar {
  static OverlayEntry? _activeEntry;

  static void show(
    BuildContext context,
    String message, {
    bool error = false,
    String? title,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _activeEntry?.remove();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopToast(
        message: message,
        error: error,
        title: title,
        duration: duration,
        onDismissed: () {
          if (identical(_activeEntry, entry)) _activeEntry = null;
          if (entry.mounted) entry.remove();
        },
      ),
    );
    _activeEntry = entry;
    overlay.insert(entry);
  }
}

class _TopToast extends StatefulWidget {
  const _TopToast({
    required this.message,
    required this.error,
    required this.duration,
    required this.onDismissed,
    this.title,
  });

  final String message;
  final bool error;
  final String? title;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _slide = Tween(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(curved);
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color main = widget.error ? AppColors.error : AppColors.success;
    final Color tint = widget.error
        ? AppColors.errorLight
        : AppColors.successLight;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        14,
                        12,
                        4,
                        12,
                      ),
                      decoration: BoxDecoration(
                        color: tint,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: main.withValues(alpha: 0.22)),
                        boxShadow: [
                          BoxShadow(
                            color: main.withValues(alpha: 0.2),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: main,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: main.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.error
                                  ? Icons.close_rounded
                                  : Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.title != null) ...[
                                  Text(
                                    widget.title!,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: main,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                                Text(
                                  widget.message,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _dismiss,
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 17,
                              color: AppColors.textSecondary,
                            ),
                            splashRadius: 18,
                            visualDensity: VisualDensity.compact,
                            tooltip: 'إغلاق',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
