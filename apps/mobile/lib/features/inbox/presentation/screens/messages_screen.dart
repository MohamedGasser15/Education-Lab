import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
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
        title: Text(
          context.loc.messagesTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal', fontSize: 17),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMessageTile(
            name: 'الدعم الفني - سارة',
            message: 'مرحباً! كيف يمكنني مساعدتك اليوم في الدورة؟',
            time: 'الآن',
            unreadCount: 1,
            avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          const SizedBox(height: 12),
          _buildMessageTile(
            name: 'مرشد أكاديمي - أحمد',
            message: 'تمت الموافقة على طلب تمديد موعد التسليم.',
            time: 'أمس',
            icon: Icons.school_rounded,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          const SizedBox(height: 12),
          _buildMessageTile(
            name: 'الاستفسارات العامة',
            message: 'تم إغلاق التذكرة رقم #4920.',
            time: '12 مايو',
            icon: Icons.headset_mic_rounded,
            cardBg: cardBg,
            borderColor: borderColor,
            textColor: textColor,
            textSubColor: textSubColor,
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
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          if (avatarUrl != null)
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl))
          else
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFEFF4FF),
              child: Icon(icon, color: AppColors.primary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor, fontFamily: 'Tajawal')),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(color: textSubColor, fontSize: 12, fontFamily: 'Tajawal'), maxLines: 1),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal')),
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
