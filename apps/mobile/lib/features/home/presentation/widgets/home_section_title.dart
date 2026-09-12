import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionTap,
  });

  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 1.5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        if (actionText != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onActionTap?.call();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4.5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : const Color(0xFFF1F5FD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : const Color(0xFFE2E8F0),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      isAr
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
