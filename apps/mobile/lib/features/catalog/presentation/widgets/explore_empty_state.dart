import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ExploreEmptyState extends StatelessWidget {
  const ExploreEmptyState({
    super.key,
    required this.onReset,
    this.bottomPadding = 0.0,
  });

  final VoidCallback onReset;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.search_off_rounded, size: 30, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              context.loc.exploreNoResultsTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.loc.exploreNoResultsSubtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                elevation: 0,
              ),
              child: Text(
                context.loc.exploreBackToAll,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
