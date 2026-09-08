import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/skeleton/app_skeleton.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  Future<void> _showDeleteAllModal(int count) async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3B1717) : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: isDark ? 0.35 : 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color(0xFFDC2626),
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.loc.notificationsClearAllTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.notificationsClearAllMessage(count.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.loc.notificationsClearAllHint,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx, true);
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.white),
                  label: Text(
                    context.loc.notificationsClearAllConfirm(count.toString()),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.loc.commonCancel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && mounted) {
      final success = await context.read<NotificationProvider>().deleteAllNotifications();
      if (!mounted) return;
      if (success) {
        AppSnackbar.showSuccess(
          context,
          context.loc.notificationsClearSuccess,
        );
      } else {
        AppSnackbar.showError(
          context,
          context.read<NotificationProvider>().errorMessage ??
              context.loc.notificationsClearFailed,
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    HapticFeedback.lightImpact();
    final success = await context.read<NotificationProvider>().markAllAsRead();
    if (!mounted) return;
    if (success) {
      AppSnackbar.showSuccess(
        context,
        context.loc.notificationsMarkAllReadSnackbar,
      );
    }
  }

  void _onNotificationTap(NotificationModel item) {
    if (!item.isRead) {
      context.read<NotificationProvider>().markAsRead(item.id);
    }
    if (item.targetRoute != null) {
      if (item.routeArguments != null) {
        Navigator.pushNamed(context, item.targetRoute!, arguments: item.routeArguments);
      } else {
        Navigator.pushNamed(context, item.targetRoute!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final allNotifications = provider.notifications;
    final filteredList = provider.filteredNotifications;
    final unreadCount = provider.unreadCount;
    final isLoading = provider.isLoading;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final isAr = context.isArabic;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/main');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.loc.notificationsTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'Tajawal',
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount ${context.loc.notificationsUnread}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: context.loc.notificationsMarkAllRead,
              icon: const Icon(Icons.done_all_rounded, size: 21, color: AppColors.primary),
              onPressed: _markAllAsRead,
            ),
          if (allNotifications.isNotEmpty)
            IconButton(
              tooltip: context.loc.notificationsClearTooltip,
              icon: const Icon(Icons.delete_sweep_outlined, size: 22, color: Color(0xFFDC2626)),
              onPressed: () => _showDeleteAllModal(allNotifications.length),
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Section Selector (Segmented Tabs)
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterTab(
                    title: context.loc.notificationsTabAll,
                    count: allNotifications.length,
                    isSelected: provider.selectedFilterIndex == 0,
                    icon: Icons.notifications_active_rounded,
                    onTap: () => provider.setFilterIndex(0),
                    isDark: isDark,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab(
                    title: context.loc.notificationsTabCourses,
                    count: allNotifications.where((n) => n.type == 2 || n.type == 3).length,
                    isSelected: provider.selectedFilterIndex == 1,
                    icon: Icons.school_rounded,
                    onTap: () => provider.setFilterIndex(1),
                    isDark: isDark,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab(
                    title: context.loc.notificationsTabPromos,
                    count: allNotifications.where((n) => n.type == 1).length,
                    isSelected: provider.selectedFilterIndex == 2,
                    icon: Icons.local_offer_rounded,
                    onTap: () => provider.setFilterIndex(2),
                    isDark: isDark,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // 2. Notification List / Skeleton Loading / Empty State
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => provider.fetchNotifications(forceRefresh: true),
              child: isLoading && allNotifications.isEmpty
                  ? _buildSkeletonLoadingView(cardBg, borderColor, isDark)
                  : filteredList.isEmpty
                      ? _buildEmptyState(
                          isFiltered: allNotifications.isNotEmpty && provider.selectedFilterIndex != 0,
                          cardBg: cardBg,
                          textColor: textColor,
                          textSubColor: textSubColor,
                          isDark: isDark,
                          isAr: isAr,
                          onResetFilter: () => provider.setFilterIndex(0),
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return _buildNotificationTile(
                              item: item,
                              isDark: isDark,
                              cardBg: cardBg,
                              textColor: textColor,
                              textSubColor: textSubColor,
                              borderColor: borderColor,
                              isAr: isAr,
                              isRtl: isRtl,
                              onDelete: () => provider.deleteNotification(item.id),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required NotificationModel item,
    required bool isDark,
    required Color cardBg,
    required Color textColor,
    required Color textSubColor,
    required Color borderColor,
    required bool isAr,
    required bool isRtl,
    required VoidCallback onDelete,
  }) {
    final isRead = item.isRead;

    return Dismissible(
      key: ValueKey('notification_${item.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete();
      },
      background: Container(
        alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 22),
          ],
        ),
      ),
      child: InkWell(
        onTap: () => _onNotificationTap(item),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isRead
                ? (isDark ? AppColors.darkSurface : Colors.white)
                : (isDark ? const Color(0xFF1E2638) : const Color(0xFFF0F6FF)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead ? borderColor : AppColors.primary.withValues(alpha: 0.4),
              width: isRead ? 1 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.iconBgColor(isDark),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.iconData, color: item.iconColor, size: 21),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 12, color: textSubColor.withValues(alpha: 0.7)),
                            const SizedBox(width: 4),
                            Text(
                              item.timeAgo(isAr: isAr, context: context),
                              style: TextStyle(
                                fontSize: 11,
                                color: textSubColor.withValues(alpha: 0.8),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        if (item.targetRoute != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.loc.notificationsViewDetails,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                isRtl ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
                                size: 11,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required String title,
    required int count,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurfaceMuted : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required bool isFiltered,
    required Color cardBg,
    required Color textColor,
    required Color textSubColor,
    required bool isDark,
    required bool isAr,
    required VoidCallback onResetFilter,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFiltered ? Icons.filter_alt_off_rounded : Icons.notifications_off_outlined,
                        size: 38,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isFiltered
                          ? context.loc.notificationsEmptyCategoryTitle
                          : context.loc.notificationsEmptyTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isFiltered
                          ? context.loc.notificationsEmptyCategorySubtitle
                          : context.loc.notificationsEmptyAllSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                        height: 1.4,
                      ),
                    ),
                    if (isFiltered) ...[
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: onResetFilter,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(
                          context.loc.notificationsViewAll,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoadingView(Color cardBg, Color borderColor, bool isDark) {
    return AppSkeleton(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox.circle(size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(width: 140, height: 14),
                    const SizedBox(height: 8),
                    const SkeletonBox(width: double.infinity, height: 11),
                    const SizedBox(height: 5),
                    const SkeletonBox(width: 180, height: 11),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SkeletonBox(width: 70, height: 10),
                        SkeletonBox(width: 80, height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
