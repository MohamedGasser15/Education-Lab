import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class _NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String type; // all, courses, promos
  bool isRead;
  final String? actionLabel;
  final String? route;

  _NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.type,
    this.isRead = false,
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
  final List<String> _filterTabs = ['الكل', 'الدورات والتعلم', 'العروض والتنبيهات'];

  final List<_NotificationModel> _notifications = [
    _NotificationModel(
      id: 'n1',
      title: 'تمت إضافة محتوى جديد للدورة',
      message: 'قام م. أحمد محمد بإضافة 4 دروس جديدة إلى دورة تطوير تطبيقات Flutter و Dart.',
      time: 'منذ 15 دقيقة',
      icon: Icons.play_circle_outline_rounded,
      iconColor: AppColors.primary,
      iconBgColor: Color(0xFFEFF4FF),
      type: 'courses',
      isRead: false,
      actionLabel: 'متابعة الدورة',
      route: '/lesson-player',
    ),
    _NotificationModel(
      id: 'n2',
      title: 'شهادة الإتمام جاهزة للتحميل',
      message: 'تهانينا! لقد أكملت بنجاح دورة تصميم واجهات المستخدم Figma. شهادتك المعتمدة جاهزة الآن.',
      time: 'منذ ساعتين',
      icon: Icons.workspace_premium_outlined,
      iconColor: Color(0xFF059669),
      iconBgColor: Color(0xFFECFDF5),
      type: 'courses',
      isRead: false,
      actionLabel: 'عرض الشهادة',
      route: '/certificate_view',
    ),
    _NotificationModel(
      id: 'n3',
      title: 'عرض محدود: خصم 40% على دورات الذكاء الاصطناعي',
      message: 'استفد من الخصم الخاص على مسارات التعلم الآلي وعلوم البيانات باستخدام كود EDULAB40.',
      time: 'أمس',
      icon: Icons.local_offer_outlined,
      iconColor: Color(0xFFD97706),
      iconBgColor: Color(0xFFFEF3C7),
      type: 'promos',
      isRead: true,
      actionLabel: 'استكشاف العروض',
    ),
    _NotificationModel(
      id: 'n4',
      title: 'إجابة جديدة على استفسارك في منتدى النقاش',
      message: 'أجاب المدرب على سؤالك حول إدارة الحالة باستخدام Riverpod في الدرس رقم 18.',
      time: 'منذ يومين',
      icon: Icons.forum_outlined,
      iconColor: Color(0xFF7C3AED),
      iconBgColor: Color(0xFFF5F3FF),
      type: 'courses',
      isRead: true,
      actionLabel: 'عرض الرد',
    ),
    _NotificationModel(
      id: 'n5',
      title: 'صيانة دورية للمنصة',
      message: 'سيتم إجراء تحديثات على خوادم المنصة يوم الجمعة القادم من الساعة 2 إلى 4 صباحاً.',
      time: 'منذ 3 أيام',
      icon: Icons.info_outline_rounded,
      iconColor: Color(0xFF64748B),
      iconBgColor: Color(0xFFF1F5F9),
      type: 'promos',
      isRead: true,
    ),
  ];

  List<_NotificationModel> get _filteredNotifications {
    if (_selectedFilterIndex == 1) {
      return _notifications.where((n) => n.type == 'courses').toList();
    } else if (_selectedFilterIndex == 2) {
      return _notifications.where((n) => n.type == 'promos').toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    HapticFeedback.lightImpact();
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNotification(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredNotifications;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإشعارات',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            if (unreadCount > 0)
              Text(
                'لديك $unreadCount إشعارات غير مقروءة',
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
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                'تحديد الكل كمقروء',
                style: TextStyle(
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
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Row(
              children: List.generate(_filterTabs.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(
                      _filterTabs[index],
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide.none,
                    onSelected: (selected) {
                      if (selected) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedFilterIndex = index);
                      }
                    },
                  ),
                );
              }),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

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
                      return _buildNotificationTile(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(_NotificationModel item) {
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.35),
            width: item.isRead ? 1 : 1.2,
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
                            fontWeight: item.isRead ? FontWeight.bold : FontWeight.w900,
                            color: AppColors.textPrimary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      if (!item.isRead)
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
                                const Icon(
                                  Icons.chevron_left_rounded,
                                  size: 16,
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications_off_outlined, size: 64, color: Color(0xFFCBD5E1)),
            SizedBox(height: 16),
            Text(
              'لا توجد إشعارات في هذا القسم',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'سنقوم بإشعارك فور توفر أي تحديثات جديدة لدوراتك أو عروض المنصة.',
              style: TextStyle(
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
