import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomePopularTopics extends StatelessWidget {
  const HomePopularTopics({
    super.key,
    this.topics,
    this.onTopicTap,
  });

  final List<String>? topics;
  final ValueChanged<String>? onTopicTap;

  static const List<String> _defaultTopics = [
    'Flutter',
    'Python',
    'React JS',
    'Figma',
    'ASP.NET Core',
    'Docker & Kubernetes',
    'Machine Learning',
    'Cyber Security',
    'Excel & PowerBI',
    'Node.js',
  ];

  @override
  Widget build(BuildContext context) {
    final list = topics ?? _defaultTopics;
    final columnCount = (list.length / 2).ceil();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: columnCount,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, colIndex) {
          final topIndex = colIndex * 2;
          final bottomIndex = topIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopicChip(
                topic: list[topIndex],
                borderColor: borderColor,
                textColor: textColor,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              if (bottomIndex < list.length)
                _buildTopicChip(
                  topic: list[bottomIndex],
                  borderColor: borderColor,
                  textColor: textColor,
                  isDark: isDark,
                )
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopicChip({
    required String topic,
    required Color borderColor,
    required Color textColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTopicTap?.call(topic);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            topic,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
