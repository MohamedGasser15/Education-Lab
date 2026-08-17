import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('الرسائل الأخيرة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMessageTile(
            name: 'الدعم الفني - سارة',
            message: 'مرحباً! كيف يمكنني مساعدتك اليوم في دورة ا...',
            time: 'الآن',
            unreadCount: 1,
            avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
          ),
          const SizedBox(height: 12),
          _buildMessageTile(
            name: 'مرشد أكاديمي - أحمد',
            message: 'تمت الموافقة على طلب تمديد موعد التسليم.',
            time: 'أمس',
            icon: Icons.school_rounded,
          ),
          const SizedBox(height: 12),
          _buildMessageTile(
            name: 'الاستفسارات العامة',
            message: 'تم إغلاق التذكرة رقم #4920.',
            time: '12 مايو',
            icon: Icons.headset_mic_rounded,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildMessageTile({
    required String name,
    required String message,
    required String time,
    int? unreadCount,
    String? avatarUrl,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (avatarUrl != null)
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl))
          else
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryLight,
              child: Icon(icon, color: AppColors.primary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 1),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              if (unreadCount != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
