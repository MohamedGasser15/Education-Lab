import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/home_bestsellers_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_category_chips.dart';
import 'package:mobile/features/home/presentation/widgets/home_continue_learning.dart';
import 'package:mobile/features/home/presentation/widgets/home_explore_categories.dart';
import 'package:mobile/features/home/presentation/widgets/home_header.dart';
import 'package:mobile/features/home/presentation/widgets/home_new_courses_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_popular_topics.dart';
import 'package:mobile/features/home/presentation/widgets/home_promo_slider.dart';
import 'package:mobile/features/home/presentation/widgets/home_recommended_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_search_bar.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:mobile/features/home/presentation/widgets/home_top_instructors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.isLoggedIn = false,
    this.userName = '',
  });

  final bool isLoggedIn;
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _hasWishlistItems = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Top Status Bar Spacer (scrolls away smoothly with content)
          SliverToBoxAdapter(
            child: SizedBox(height: topPadding),
          ),

          // 1. EduLab Top Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: HomeHeader(
                isLoggedIn: widget.isLoggedIn,
                userName: widget.userName,
                hasWishlistItems: _hasWishlistItems,
              ),
            ),
          ),

          // 2. EduLab Search Bar
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: HomeSearchBar(),
            ),
          ),

          // 3. EduLab Promo Banner
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: HomePromoSlider(),
            ),
          ),

          // 4. "Continue Learning"
          if (widget.isLoggedIn)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: HomeContinueLearning(),
              ),
            ),

          // 5. Category Chips Carousel
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: HomeCategoryChips(),
            ),
          ),

          // 6. Section 1: "Students are Viewing / Bestsellers"
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: HomeBestsellersSection(),
            ),
          ),

          // 7. Section 2: Popular Topics
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeSectionTitle(
                title: context.loc.homePopularTopicsTitle,
                subtitle: context.loc.homePopularTopicsSubtitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 24),
              child: HomePopularTopics(),
            ),
          ),

          // 8. Section 3: "Recommended for You"
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: HomeRecommendedSection(),
            ),
          ),

          // 9. Section 4: Top Instructors
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeSectionTitle(
                title: context.loc.homeTopInstructorsTitle,
                subtitle: context.loc.homeTopInstructorsSubtitle,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 24),
              child: HomeTopInstructors(),
            ),
          ),

          // 10. Section 5: New Courses
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: HomeNewCoursesSection(),
            ),
          ),

          // 11. Section 6: Explore by Category
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeSectionTitle(
                    title: context.loc.homeExploreCategoriesTitle,
                    subtitle: context.loc.homeExploreCategoriesSubtitle,
                  ),
                  const SizedBox(height: 12),
                  const HomeExploreCategories(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
