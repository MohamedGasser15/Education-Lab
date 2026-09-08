import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:provider/provider.dart';

class _TopicItemData {
  final String title;
  final int count;
  final List<String> keywords;

  const _TopicItemData({
    required this.title,
    required this.count,
    required this.keywords,
  });
}

class _TopicDefinition {
  final String titleEn;
  final String titleAr;
  final List<String> keywords;

  const _TopicDefinition({
    required this.titleEn,
    required this.titleAr,
    required this.keywords,
  });

  String getLocalizedTitle(BuildContext context) =>
      context.isArabic ? titleAr : titleEn;

  int countMatches(List<HomeCourseDTO> courses) {
    int matchCount = 0;
    for (final c in courses) {
      final text = '${c.title} ${c.arabicTitle} ${c.description ?? ''} ${c.categoryName ?? ''} ${c.categoryEnglishName ?? ''}'.toLowerCase();
      if (keywords.any((k) => text.contains(k.toLowerCase()))) {
        matchCount++;
      }
    }
    return matchCount;
  }
}

class HomePopularTopics extends StatelessWidget {
  const HomePopularTopics({
    super.key,
    this.topics,
    this.onTopicTap,
  });

  final List<String>? topics;
  final ValueChanged<String>? onTopicTap;

  static const List<_TopicDefinition> _candidateTopics = [
    _TopicDefinition(
      titleEn: 'Flutter',
      titleAr: 'Flutter',
      keywords: ['flutter', 'فلاتر', 'dart', 'دارت'],
    ),
    _TopicDefinition(
      titleEn: 'Python',
      titleAr: 'Python',
      keywords: ['python', 'بايثون', 'django', 'fastapi', 'flask'],
    ),
    _TopicDefinition(
      titleEn: 'React JS',
      titleAr: 'React JS',
      keywords: ['react', 'رياكت', 'next.js', 'nextjs', 'redux'],
    ),
    _TopicDefinition(
      titleEn: 'Figma',
      titleAr: 'Figma',
      keywords: ['figma', 'فيجما', 'ui/ux', 'واجهات', 'تصميم'],
    ),
    _TopicDefinition(
      titleEn: 'ASP.NET Core',
      titleAr: 'ASP.NET Core',
      keywords: ['asp.net', 'c#', 'سي شارب', '.net', 'دوت نت', 'entity framework'],
    ),
    _TopicDefinition(
      titleEn: 'Docker',
      titleAr: 'Docker',
      keywords: ['docker', 'دوكر', 'kubernetes', 'devops', 'ديف اوبس'],
    ),
    _TopicDefinition(
      titleEn: 'Machine Learning',
      titleAr: 'Machine Learning',
      keywords: ['machine learning', 'تعلم الآلة', 'deep learning', 'ذكاء اصطناعي', 'ai'],
    ),
    _TopicDefinition(
      titleEn: 'Cyber Security',
      titleAr: 'Cyber Security',
      keywords: ['cyber', 'security', 'أمن سيبراني', 'اختراق', 'ethical hacking'],
    ),
    _TopicDefinition(
      titleEn: 'Excel & PowerBI',
      titleAr: 'Excel & PowerBI',
      keywords: ['excel', 'إكسل', 'powerbi', 'power bi', 'تحليل بيانات', 'data analysis'],
    ),
    _TopicDefinition(
      titleEn: 'Node.js',
      titleAr: 'Node.js',
      keywords: ['node.js', 'nodejs', 'نود', 'express', 'nestjs', 'backend'],
    ),
    _TopicDefinition(
      titleEn: 'SQL & Databases',
      titleAr: 'SQL & Databases',
      keywords: ['sql', 'mysql', 'postgresql', 'قواعد بيانات', 'database'],
    ),
    _TopicDefinition(
      titleEn: 'JavaScript',
      titleAr: 'JavaScript',
      keywords: ['javascript', 'جافاسكريبت', 'typescript', 'js'],
    ),
    _TopicDefinition(
      titleEn: 'Java',
      titleAr: 'Java',
      keywords: ['java', 'جافا', 'spring boot', 'spring'],
    ),
    _TopicDefinition(
      titleEn: 'UI/UX Design',
      titleAr: 'UI/UX Design',
      keywords: ['ui/ux', 'تصميم واجهات', 'تجربة المستخدم', 'prototyping'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. If provider is loading courses and no courses yet, show smooth skeleton pills
    if (homeProvider.isLoadingAllCourses && homeProvider.allCourses.isEmpty && (topics == null || topics!.isEmpty)) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildSkeleton(isDark),
      );
    }

    final List<_TopicItemData> items = [];

    if (topics != null && topics!.isNotEmpty) {
      for (final t in topics!) {
        items.add(_TopicItemData(
          title: t,
          count: 0,
          keywords: [t],
        ));
      }
    } else {
      // Find candidate technical topics that have at least 1 matching course in EduLab
      final List<MapEntry<_TopicDefinition, int>> matched = [];

      for (final topicDef in _candidateTopics) {
        final count = topicDef.countMatches(homeProvider.allCourses);
        if (count > 0) {
          matched.add(MapEntry(topicDef, count));
        }
      }

      // Sort by matched course count descending
      matched.sort((a, b) => b.value.compareTo(a.value));

      for (final entry in matched) {
        items.add(_TopicItemData(
          title: entry.key.getLocalizedTitle(context),
          count: entry.value,
          keywords: entry.key.keywords,
        ));
      }

      // Fallback: If EduLab has fewer than 4 matched from candidate topics, extract skills from actual course titles
      if (items.length < 4 && homeProvider.allCourses.isNotEmpty) {
        final seen = items.map((e) => e.title.toLowerCase()).toSet();
        for (final course in homeProvider.allCourses) {
          final titleParts = '${course.title} ${course.arabicTitle}'.split(RegExp(r'[\s,:\-\[\]\(\)]+'));
          for (final part in titleParts) {
            final word = part.trim();
            if (word.length >= 3 &&
                !seen.contains(word.toLowerCase()) &&
                !_isCommonStopWord(word)) {
              seen.add(word.toLowerCase());
              items.add(_TopicItemData(
                title: word,
                count: 1,
                keywords: [word],
              ));
              if (items.length >= 10) break;
            }
          }
          if (items.length >= 10) break;
        }
      }
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Split items into 2 natural independent rows
    final List<_TopicItemData> row1 = [];
    final List<_TopicItemData> row2 = [];

    for (int i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        row1.add(items[i]);
      } else {
        row2.add(items[i]);
      }
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        key: const ValueKey('popular_topics_content'),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in row1)
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRtl ? 8.0 : 0.0,
                      right: isRtl ? 0.0 : 8.0,
                    ),
                    child: _buildTopicChip(
                      context: context,
                      homeProvider: homeProvider,
                      item: item,
                      isDark: isDark,
                    ),
                  ),
              ],
            ),
            if (row2.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final item in row2)
                    Padding(
                      padding: EdgeInsets.only(
                        left: isRtl ? 8.0 : 0.0,
                        right: isRtl ? 0.0 : 8.0,
                      ),
                      child: _buildTopicChip(
                        context: context,
                        homeProvider: homeProvider,
                        item: item,
                        isDark: isDark,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(bool isDark) {
    return const AppSkeleton(
      key: ValueKey('popular_topics_skeleton'),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 80, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 110, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 90, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 120, height: 34, borderRadius: 8),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 100, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 75, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 125, height: 34, borderRadius: 8),
                SizedBox(width: 8),
                SkeletonBox(width: 85, height: 34, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isCommonStopWord(String word) {
    final lower = word.toLowerCase();
    const stops = {
      'and', 'the', 'for', 'with', 'from', 'in', 'of', 'to', 'a', 'an',
      'دورة', 'كورس', 'شامل', 'من', 'إلى', 'في', 'على', 'مع', 'احتراف', 'دليل', 'تعلم'
    };
    return stops.contains(lower);
  }

  /// Navigates to Explore with the matching category or search query
  static void navigateToTopic(
    BuildContext context,
    String topic, {
    List<String>? keywords,
  }) {
    final exploreProvider = context.read<ExploreProvider>();
    final homeProvider = context.read<HomeProvider>();

    final clean = topic.trim().toLowerCase();

    // Map common topic keywords to database category IDs
    const topicCategoryMap = {
      'flutter': 3, // Mobile Development
      'فلاتر': 3,
      'dart': 3,
      'دارت': 3,
      'react': 2, // Web Development
      'رياكت': 2,
      'javascript': 2,
      'جافاسكريبت': 2,
      'python': 1, // Programming
      'بايثون': 1,
      'asp.net': 1,
      'c#': 1,
      'سي شارب': 1,
      'java': 1,
      'جافا': 1,
      'node': 1,
      'نود': 1,
      'figma': 31, // UI/UX Design
      'فيجما': 31,
      'ui/ux': 31,
      'تصميم واجهات': 31,
      'machine learning': 10, // AI
      'deep learning': 10,
      'ai': 10,
      'ذكاء اصطناعي': 10,
      'تعلم الآلة': 10,
      'cyber': 13, // Cyber Security
      'security': 13,
      'أمن سيبراني': 13,
      'اختراق': 13,
      'docker': 15, // Cloud & DevOps
      'دوكر': 15,
      'devops': 15,
      'ديف اوبس': 15,
      'سحابية': 15,
      'excel': 7, // Data Science
      'إكسل': 7,
      'powerbi': 7,
      'sql': 7,
      'بيانات': 7,
    };

    int? targetCatId;
    final testStrings = [clean, ...(keywords?.map((k) => k.toLowerCase()) ?? [])];
    for (final str in testStrings) {
      for (final entry in topicCategoryMap.entries) {
        if (str.contains(entry.key)) {
          targetCatId = entry.value;
          break;
        }
      }
      if (targetCatId != null) break;
    }

    CategoryItem? targetCategory;
    if (targetCatId != null) {
      for (final cat in exploreProvider.categories) {
        if (cat.id == targetCatId.toString()) {
          targetCategory = cat;
          break;
        }
      }
      if (targetCategory == null) {
        for (final cat in homeProvider.categories) {
          if (cat.id == targetCatId) {
            targetCategory = exploreProvider.findOrCreateCategory(
              id: cat.id.toString(),
              title: cat.nameAr.isNotEmpty ? cat.nameAr : cat.nameEn,
              subtitle: cat.nameEn.isNotEmpty ? cat.nameEn : cat.nameAr,
              arabicTitle: cat.nameAr,
              englishTitle: cat.nameEn,
              icon: cat.icon,
              color: cat.color,
            );
            break;
          }
        }
      }
    }

    if (targetCategory == null) {
      for (final cat in exploreProvider.categories) {
        final catTitle = cat.title.toLowerCase();
        final catSub = cat.subtitle.toLowerCase();
        if (testStrings.any((s) => catTitle.contains(s) || catSub.contains(s) || s.contains(catTitle))) {
          targetCategory = cat;
          break;
        }
      }
    }

    if (targetCategory != null) {
      MainNavigationScreen.switchToExplore(context, category: targetCategory);
    } else {
      MainNavigationScreen.switchToExplore(context, searchQuery: topic);
    }
  }

  Widget _buildTopicChip({
    required BuildContext context,
    required HomeProvider homeProvider,
    required _TopicItemData item,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          if (onTopicTap != null) {
            onTopicTap!(item.title);
          } else {
            navigateToTopic(context, item.title, keywords: item.keywords);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontFamily: 'Tajawal',
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
