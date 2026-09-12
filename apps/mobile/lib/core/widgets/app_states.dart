import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

/// Reusable generic Empty State widget with dark mode support.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Widget? customAction;

  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: textSubColor,
                  height: 1.5,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
            if (customAction != null) ...[
              const SizedBox(height: 20),
              customAction!,
            ] else if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              AppButton(
                height: 44,
                width: 180,
                borderRadius: 12,
                label: actionLabel!,
                fontSize: 13.5,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable generic Error State widget with retry capability.
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'إعادة المحاولة',
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'حدث خطأ غير متوقع',
      subtitle: message,
      actionLabel: retryLabel,
      onAction: onRetry,
    );
  }
}

/// Reusable full-screen or centered loading state.
class AppLoadingState extends StatelessWidget {
  final String? message;
  final double size;

  const AppLoadingState({
    super.key,
    this.message,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingSpinner(size: size, color: AppColors.primary),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: TextStyle(
                fontSize: 13,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
