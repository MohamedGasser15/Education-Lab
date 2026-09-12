import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/features/catalog/presentation/models/explore_models.dart';
import 'package:mobile/features/catalog/presentation/providers/explore_provider.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_categories_list.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_course_card.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_empty_state.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_filter_bar.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_recent_searches.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_search_bar.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_skeleton_loading.dart';
import 'package:mobile/features/catalog/presentation/widgets/explore_top_searches.dart';
import 'package:mobile/features/learning/presentation/providers/enrollment_provider.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  final bool isTab;
  final bool autoFocusSearch;
  final CategoryItem? initialCategory;
  final String? initialSearchQuery;
  final int? initialFilterIndex;

  const ExploreScreen({
    super.key,
    this.isTab = false,
    this.autoFocusSearch = false,
    this.initialCategory,
    this.initialSearchQuery,
    this.initialFilterIndex,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<ExploreProvider>();
      provider.loadRecentSearches();

      if (widget.initialCategory != null) {
        provider.selectCategory(widget.initialCategory);
      } else if (widget.initialSearchQuery != null &&
          widget.initialSearchQuery!.isNotEmpty) {
        _searchController.text = widget.initialSearchQuery!;
        provider.onSearchSubmitted(widget.initialSearchQuery!);
      } else if (widget.initialFilterIndex != null) {
        provider.showAllCoursesWithFilter(
          filterIndex: widget.initialFilterIndex!,
        );
      }

      if (widget.autoFocusSearch) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    final clean = query.trim();
    if (clean.isEmpty) return;
    context.read<ExploreProvider>().onSearchSubmitted(clean);
  }

  void _applySearchQuery(String text) {
    _searchController.text = text;
    context.read<ExploreProvider>().onSearchSubmitted(text);
  }

  void _openCategory(CategoryItem category) {
    _searchController.clear();
    context.read<ExploreProvider>().selectCategory(category);
  }

  void _clearSearchOrCategory() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<ExploreProvider>().clearFilters();
  }

  void _handleBack() {
    HapticFeedback.selectionClick();
    final provider = context.read<ExploreProvider>();
    if (provider.isViewingResults) {
      _clearSearchOrCategory();
    } else if (!widget.isTab && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExploreProvider>();
    if (provider.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
      _searchFocusNode.unfocus();
    } else if (_searchController.text != provider.searchQuery &&
        !_searchFocusNode.hasFocus) {
      _searchController.text = provider.searchQuery;
    }
    final enrollmentProvider = context.watch<EnrollmentProvider>();
    final bool hasContinueLearning = enrollmentProvider.courses.isNotEmpty;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double bottomPadding = widget.isTab
        ? (hasContinueLearning ? 180.0 : 100.0) + bottomInset
        : 24.0 + bottomInset;
    final double hPadding = AppResponsive.screenPadding(context);

    final bool isViewingResults = provider.isViewingResults;
    final List<CourseItem> results = provider.getFilteredCourses(context);
    final bgColor = AppColors.getBackground(context);
    final textColor = AppColors.getTextPrimary(context);
    return PopScope(
      canPop: !widget.isTab && !isViewingResults,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isViewingResults) {
          _clearSearchOrCategory();
          return;
        }
        if (!widget.isTab && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top App Bar & Search Input
              ExploreSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                activeCategoryName: provider.activeCategory?.getLocalizedTitle(
                  context,
                ),
                isTab: widget.isTab,
                isViewingResults: isViewingResults,
                onChanged: (val) => provider.setSearchQuery(val),
                onSubmitted: _onSearchSubmit,
                onClear: _clearSearchOrCategory,
                onBack: _handleBack,
              ),

              // Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isViewingResults
                      ? KeyedSubtree(
                          key: const ValueKey('results_view'),
                          child: Column(
                            children: [
                              ExploreFilterBar(
                                selectedIndex: provider.selectedFilterIndex,
                                onFilterSelected: (index) =>
                                    provider.selectFilterChip(index),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  hPadding,
                                  10,
                                  hPadding,
                                  4,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${context.loc.exploreAvailableResults} (${results.length})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    if (provider.activeCategory != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              provider.activeCategory!
                                                  .getLocalizedTitle(context),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () =>
                                                  provider.selectCategory(null),
                                              child: const Icon(
                                                Icons.close_rounded,
                                                size: 14,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (provider.isLoading && results.isNotEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Center(
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 260),
                                  child: provider.isLoading && results.isEmpty
                                      ? ExploreSkeletonLoading(
                                          bottomPadding: bottomPadding,
                                        )
                                      : (results.isEmpty
                                            ? ExploreEmptyState(
                                                onReset: _clearSearchOrCategory,
                                                bottomPadding: bottomPadding,
                                              )
                                            : RefreshIndicator(
                                                color: AppColors.primary,
                                                onRefresh: () => provider
                                                    .refreshCurrentResults(),
                                                child: ListView.separated(
                                                  key:
                                                      const PageStorageKey<
                                                        String
                                                      >('explore_results_list'),
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(
                                                        parent:
                                                            BouncingScrollPhysics(),
                                                      ),
                                                  padding: EdgeInsets.fromLTRB(
                                                    hPadding,
                                                    6,
                                                    hPadding,
                                                    bottomPadding,
                                                  ),
                                                  itemCount: results.length,
                                                  separatorBuilder: (_, _) =>
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                  itemBuilder: (context, index) {
                                                    return ExploreCourseCard(
                                                      course: results[index],
                                                    );
                                                  },
                                                ),
                                              )),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          key: const PageStorageKey<String>(
                            'explore_main_categories_list',
                          ),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            hPadding,
                            16,
                            hPadding,
                            bottomPadding,
                          ),
                          children: [
                            if (provider.recentSearches.isNotEmpty) ...[
                              ExploreRecentSearches(
                                searches: provider.recentSearches,
                                onSearchTap: _applySearchQuery,
                                onClearAll: () =>
                                    provider.clearRecentSearches(),
                              ),
                              const SizedBox(height: 24),
                            ],
                            ExploreTopSearches(onSearchTap: _applySearchQuery),
                            const SizedBox(height: 24),
                            ExploreCategoriesList(
                              categories: provider.categories,
                              onCategoryTap: _openCategory,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
