import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';

class _NotificationItemData {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String type; // 'courses' | 'promos'
  final String? actionLabel;
  final String? route;

  const _NotificationItemData({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.type,
    this.actionLabel,
    this.route,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Courses, 2: Promotions
  final Set<String> _readIds = {'n3', 'n4', 'n5'};
  final Set<String> _deletedIds = {};

  List<_NotificationItemData> _getNotifications(BuildContext context) {
    return [
      _NotificationItemData(
        id: 'n1',
        title: context.loc.notification1Title,
        message: context.loc.notification1Message,
        time: context.loc.notification1Time,
        icon: Icons.play_circle_outline_rounded,
        iconColor: AppColors.primary,
        iconBgColor: const Color(0xFFEFF4FF),
        type: 'courses',
        actionLabel: context.loc.notification1Action,
        route: '/lesson-player',
      ),
      _NotificationItemData(
        id: 'n2',
        title: context.loc.notification2Title,
        message: context.loc.notification2Message,
        time: context.loc.notification2Time,
        icon: Icons.workspace_premium_outlined,
        iconColor: const Color(0xFF059669),
        iconBgColor: const Color(0xFFECFDF5),
        type: 'courses',
        actionLabel: context.loc.notification2Action,
        route: '/certificate_view',
      ),
      _NotificationItemData(
        id: 'n3',
        title: context.loc.notification3Title,
        message: context.loc.notification3Message,
        time: context.loc.notification3Time,
        icon: Icons.local_offer_outlined,
        iconColor: const Color(0xFFD97706),
        iconBgColor: const Color(0xFFFEF3C7),
        type: 'promos',
        actionLabel: context.loc.notification3Action,
        route: '/main',
      ),
      _NotificationItemData(
        id: 'n4',
        title: context.loc.notification4Title,
        message: context.loc.notification4Message,
        time: context.loc.notification4Time,
        icon: Icons.forum_outlined,
        iconColor: const Color(0xFF7C3AED),
        iconBgColor: const Color(0xFFF5F3FF),
        type: 'courses',
        actionLabel: context.loc.notification4Action,
        route: '/lesson-player',
      ),
      _NotificationItemData(
        id: 'n5',
        title: context.loc.notification5Title,
        message: context.loc.notification5Message,
        time: context.loc.notification5Time,
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF64748B),
        iconBgColor: const Color(0xFFF1F5F9),
        type: 'promos',
      ),
    ];
  }

  void _markAllAsRead(List<_NotificationItemData> allNotifications) {
    HapticFeedback.lightImpact();
    setState(() {
      _readIds.addAll(allNotifications.map((n) => n.id));
    });
    AppSnackbar.show(
      context,
      context.loc.notificationsMarkAllReadSnackbar,
    );
  }

  void _deleteNotification(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _deletedIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allNotifications = _getNotifications(context).where((n) => !_deletedIds.contains(n.id)).toList();
    final filteredList = _selectedFilterIndex == 1
        ? allNotifications.where((n) => n.type == 'courses').toList()
        : _selectedFilterIndex == 2
            ? allNotifications.where((n) => n.type == 'promos').toList()
            : allNotifications;
    final unreadCount = allNotifications.where((n) => !_readIds.contains(n.id)).length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

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
                  color: AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: () => _markAllAsRead(allNotifications),
              icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.primary),
              label: Text(
                context.loc.notificationsMarkAllRead,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Filter Chips Header (Udemy Style)
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Row(
              children: [
                _buildFilterChip(0, context.loc.notificationsTabAll, isDark),
                const SizedBox(width: 8),
                _buildFilterChip(1, context.loc.notificationsTabCourses, isDark),
                const SizedBox(width: 8),
                _buildFilterChip(2, context.loc.notificationsTabPromos, isDark),
              ],
            ),
          ),

          Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),

          // 2. Notification List or Empty State
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isRead = _readIds.contains(item.id);
                      return _buildNotificationTile(item, isRead, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(_NotificationItemData item, bool isRead, bool isDark) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(item.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _readIds.add(item.id);
          });
          if (item.route != null) {
            Navigator.pushNamed(context, item.route!);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead ? (isDark ? AppColors.darkBorder : AppColors.border) : AppColors.primary.withValues(alpha: 0.35),
              width: isRead ? 1 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
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
                              fontSize: 13,
                              fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.message,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Tajawal',
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF94A3B8),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        if (item.actionLabel != null)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _readIds.add(item.id);
                              });
                              if (item.route != null) {
                                Navigator.pushNamed(context, item.route!);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    item.actionLabel!,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Directionality.of(context) == TextDirection.rtl
                                        ? Icons.arrow_back_ios_rounded
                                        : Icons.arrow_forward_ios_rounded,
                                    size: 11,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildFilterChip(int index, String label, bool isDark) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          fontFamily: 'Tajawal',
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
      onSelected: (selected) {
        if (selected) {
          HapticFeedback.selectionClick();
          setState(() => _selectedFilterIndex = index);
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off_outlined, size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(
              context.loc.notificationsEmptyTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.loc.learningEmptySubtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
