import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('تحديد الكل كمقروء', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: 'تحديث الدورة',
            message: 'تمت إضافة وحدة جديدة إلى "مقدمة في علوم البيانات". ابدأ التعلم الآن للحفاظ على تقدمك.',
            time: 'الآن',
            icon: Icons.menu_book_rounded,
            color: Colors.blue,
            isUnread: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'شهادة جديدة',
            message: 'تهانينا! لقد أكملت بنجاح دورة "التسويق الرقمي المتقدم". شهادتك جاهزة للتحميل.',
            time: 'منذ ساعتين',
            icon: Icons.verified_rounded,
            color: Colors.green,
            isUnread: true,
            actionButtonText: 'عرض الشهادة',
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'عرض خاص',
            message: 'خصم 30% على جميع دورات البرمجة لفترة محدودة. استخدم الكود CODE30 عند الدفع.',
            time: 'أمس',
            icon: Icons.local_offer_rounded,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'صيانة النظام',
            message: 'سيتم إجراء صيانة مجدولة للمنصة يوم الجمعة القادم من الساعة 2 صباحاً حتى 4 صباحاً.',
            time: 'منذ 3 أيام',
            icon: Icons.settings_rounded,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required MaterialColor color,
    bool isUnread = false,
    String? actionButtonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isUnread ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.shade50,
            child: Icon(icon, color: color.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
                if (actionButtonText != null) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    child: Text(actionButtonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
