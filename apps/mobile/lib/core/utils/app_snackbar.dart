import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppSnackbarType { success, error, info }

class AppSnackbar {
  static OverlayEntry? _activeEntry;

  /// Shows the authentic bottom floating snackbar (Theme Aware)
  static void show(
    BuildContext context,
    String message, {
    bool error = false,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    showCustom(
      context,
      message: message,
      type: error ? AppSnackbarType.error : AppSnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Success Snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    showCustom(
      context,
      message: message,
      type: AppSnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Error Snackbar
  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3800),
  }) {
    showCustom(
      context,
      message: message,
      type: AppSnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Custom floating snackbar at bottom with adaptive Light / Dark theme styling
  static void showCustom(
    BuildContext context, {
    required String message,
    required AppSnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    HapticFeedback.mediumImpact();

    try {
      final overlay = Overlay.of(context, rootOverlay: true);
      _activeEntry?.remove();
      _activeEntry = null;

      late final OverlayEntry entry;
      entry = OverlayEntry(
        builder: (_) => _UdemyBottomSnackbar(
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration,
          onDismissed: () {
            if (identical(_activeEntry, entry)) _activeEntry = null;
            if (entry.mounted) entry.remove();
          },
        ),
      );
      _activeEntry = entry;
      overlay.insert(entry);
    } catch (_) {
      // Fallback
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final isSuccess = type == AppSnackbarType.success;
      final iconColor = isSuccess ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          duration: duration,
        ),
      );
    }
  }
}

class _UdemyBottomSnackbar extends StatefulWidget {
  const _UdemyBottomSnackbar({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final AppSnackbarType type;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismissed;

  @override
  State<_UdemyBottomSnackbar> createState() => _UdemyBottomSnackbarState();
}

class _UdemyBottomSnackbarState extends State<_UdemyBottomSnackbar>
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
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 240),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuccess = widget.type == AppSnackbarType.success;
    final isError = widget.type == AppSnackbarType.error;

    // Premium Clean Palette
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final Color textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final Color closeIconColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF);

    final Color primaryAccent = isSuccess
        ? (isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A))
        : (isError
            ? (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))
            : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)));

    final Color iconBadgeBg = isSuccess
        ? (isDark ? const Color(0xFF059669).withValues(alpha: 0.2) : const Color(0xFFF0FDF4))
        : (isError
            ? (isDark ? const Color(0xFFDC2626).withValues(alpha: 0.2) : const Color(0xFFFEF2F2))
            : (isDark ? const Color(0xFF2563EB).withValues(alpha: 0.2) : const Color(0xFFEFF6FF)));

    final IconData icon = isSuccess
        ? Icons.check_circle_rounded
        : (isError ? Icons.error_rounded : Icons.info_rounded);

    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      bottom: bottomPadding + 16,
      left: 16,
      right: 16,
      child: SafeArea(
        top: false,
        child: Dismissible(
          key: const Key('udemy_bottom_snackbar_dismiss'),
          direction: DismissDirection.down,
          onDismissed: (_) => widget.onDismissed(),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                          width: 1.0,
                        ),
                        boxShadow: isDark
                            ? const [
                                BoxShadow(
                                  color: Color(0x66000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          // Icon Badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: iconBadgeBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: primaryAccent,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Message Text
                          Expanded(
                            child: Text(
                              widget.message,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                                height: 1.3,
                              ),
                            ),
                          ),

                          // Optional Action Button
                          if (widget.actionLabel != null && widget.onAction != null) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                _dismiss();
                                widget.onAction!();
                              },
                              child: Text(
                                widget.actionLabel!,
                                style: const TextStyle(
                                  color: Color(0xFFA435F0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(width: 4),

                          // Close Button
                          GestureDetector(
                            onTap: _dismiss,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close_rounded,
                                color: closeIconColor,
                                size: 18,
                              ),
                            ),
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