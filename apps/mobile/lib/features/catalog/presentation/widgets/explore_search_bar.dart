import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.activeCategoryName,
    this.isTab = false,
    this.isViewingResults = false,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? activeCategoryName;
  final bool isTab;
  final bool isViewingResults;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final inputFill = isDark
        ? AppColors.darkSurfaceMuted
        : AppColors.background;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final searchBox = Container(
      height: 50,
      decoration: BoxDecoration(
        color: inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textDirection: Directionality.of(context),
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.primary,
              cursorWidth: 2.0,
              cursorRadius: const Radius.circular(2),
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontSize: 13.5,
                color: textColor,
                fontFamily: isRtl ? 'Tajawal' : 'Inter',
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: context.loc.exploreSearchHint,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontFamily: isRtl ? 'Tajawal' : 'Inter',
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (controller.text.isNotEmpty || isViewingResults)
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onClear?.call();
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              splashRadius: 18,
            ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.surfaceMuted,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category indicator if category selected
          if (activeCategoryName != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.folder_open_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      activeCategoryName!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Search Field Row with Unified Back Button
          Row(
            children: [
              if ((!isTab && Navigator.of(context).canPop()) ||
                  isViewingResults) ...[
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    if (onBack != null) {
                      onBack!();
                    } else if (isViewingResults) {
                      onClear?.call();
                    } else if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    isRtl
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    color: textColor,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: isTab
                    ? Material(color: Colors.transparent, child: searchBox)
                    : Hero(
                        tag: 'app_search_bar',
                        child: Material(
                          color: Colors.transparent,
                          child: searchBox,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
