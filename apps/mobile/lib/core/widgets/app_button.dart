import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';

/// Unified App Button with gradient, smooth shadows, and animated loading spinner
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.text,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
    this.icon,
    this.trailingIcon,
    this.height = 52,
    this.width = double.infinity,
    this.borderRadius = 14,
    this.gradient,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 15,
    this.outlined = false,
    this.elevation = true,
    this.padding,
  });

  final String? label;
  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingLabel;
  final dynamic icon;
  final dynamic trailingIcon;
  final double height;
  final double? width;
  final double borderRadius;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool outlined;
  final bool elevation;
  final EdgeInsetsGeometry? padding;

  String get effectiveLabel => text ?? label ?? '';

  Widget? _resolveIcon(dynamic iconInput, Color color) {
    if (iconInput == null) return null;
    if (iconInput is Widget) return iconInput;
    if (iconInput is IconData) {
      return Icon(iconInput, size: fontSize + 4, color: color);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null && !isLoading;

    if (outlined) {
      final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
      final effectiveTextColor = isDark
          ? AppColors.darkTextPrimary
          : AppColors.textPrimary;
      final iconWidget = _resolveIcon(icon, effectiveTextColor);
      final trailingIconWidget = _resolveIcon(trailingIcon, effectiveTextColor);

      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: (isLoading || isDisabled)
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onPressed?.call();
                },
          style: OutlinedButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            foregroundColor: effectiveTextColor,
            elevation: 0,
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoadingSpinner(size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '${loadingLabel ?? effectiveLabel}...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: effectiveTextColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconWidget != null) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: iconWidget,
                      ),
                    ],
                    Text(
                      effectiveLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: effectiveTextColor,
                        height: 1.2,
                      ),
                    ),
                    if (trailingIconWidget != null) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: trailingIconWidget,
                      ),
                    ],
                  ],
                ),
        ),
      );
    }

    final effectiveGradient = backgroundColor == null
        ? (gradient ??
              const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ))
        : null;

    final iconWidget = _resolveIcon(icon, textColor);
    final trailingIconWidget = _resolveIcon(trailingIcon, textColor);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          gradient: effectiveGradient,
          boxShadow: (elevation && !isDisabled && !isLoading)
              ? [
                  BoxShadow(
                    color: (backgroundColor ?? AppColors.primary).withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: (isLoading || isDisabled)
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onPressed?.call();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: textColor,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: textColor.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLoadingSpinner(size: 20, color: textColor),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '${loadingLabel ?? effectiveLabel}...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconWidget != null) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: iconWidget,
                      ),
                    ],
                    Flexible(
                      child: Text(
                        effectiveLabel,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (trailingIconWidget != null) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: trailingIconWidget,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
