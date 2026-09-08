import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_bestsellers_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_explore_categories.dart';
import 'package:mobile/features/home/presentation/widgets/home_header.dart';
import 'package:mobile/features/home/presentation/widgets/home_new_courses_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_popular_topics.dart';
import 'package:mobile/features/home/presentation/widgets/home_promo_slider.dart';
import 'package:mobile/features/home/presentation/widgets/home_recommended_section.dart';
import 'package:mobile/features/home/presentation/widgets/home_search_bar.dart';
import 'package:mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:mobile/features/home/presentation/widgets/home_top_instructors.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:mobile/features/main/presentation/screens/main_navigation_screen.dart';
import 'package:mobile/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().fetchHomeData();
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<HomeProvider>().fetchHomeData(forceRefresh: true),
      context.read<WishlistProvider>().fetchWishlist(forceRefresh: true),
      context.read<EnrollmentProvider>().fetchEnrollments(forceRefresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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
                ),
              ),
            ),

            // 2. EduLab Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: HomeSearchBar(
                  onTap: () => MainNavigationScreen.switchToExplore(context, autoFocusSearch: true),
                ),
              ),
            ),

            // 3. EduLab Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: HomePromoSlider(
                  onExploreTap: () => MainNavigationScreen.switchToExplore(context),
                ),
              ),
            ),

            // Section 1: "Students are Viewing / Bestsellers"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: HomeBestsellersSection(
                  onSeeAllTap: () => MainNavigationScreen.switchToExplore(context, filterIndex: 2),
                ),
              ),
            ),

            // 7. Section 2: Popular Topics
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HomeSectionTitle(
                        title: context.loc.homePopularTopicsTitle,
                        subtitle: context.loc.homePopularTopicsSubtitle,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HomePopularTopics(
                      onTopicTap: (topic) => HomePopularTopics.navigateToTopic(context, topic),
                    ),
                  ],
                ),
              ),
            ),

            // 8. Section 3: "Recommended for You"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: HomeRecommendedSection(
                  onSeeAllTap: () => MainNavigationScreen.switchToExplore(context, filterIndex: 1),
                ),
              ),
            ),

            // 9. Section 4: Top Instructors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeSectionTitle(
                  title: context.loc.homeTopInstructorsTitle,
                  subtitle: context.loc.homeTopInstructorsSubtitle,
                  actionText: context.loc.homeViewAll,
                  onActionTap: () => Navigator.pushNamed(context, '/instructors'),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: HomeNewCoursesSection(
                  onSeeAllTap: () => MainNavigationScreen.switchToExplore(context, filterIndex: 0),
                ),
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
                      actionText: context.loc.homeViewAll,
                      onActionTap: () => MainNavigationScreen.switchToExplore(context),
                    ),
                    const SizedBox(height: 12),
                    HomeExploreCategories(
                      onCategoryTap: (cat) {
                        final exploreProvider = context.read<ExploreProvider>();
                        final catId = cat['id']?.toString() ?? '1';
                        final catTitle = (cat['title'] ?? '') as String;
                        final catItem = exploreProvider.findOrCreateCategory(
                          id: catId,
                          title: catTitle,
                          subtitle: (cat['subtitle'] ?? '') as String,
                          icon: (cat['icon'] as IconData?) ?? Icons.category_rounded,
                          color: (cat['color'] as Color?) ?? AppColors.primary,
                          coursesCount: (cat['courses'] ?? '') as String,
                        );
                        MainNavigationScreen.switchToExplore(context, category: catItem);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
