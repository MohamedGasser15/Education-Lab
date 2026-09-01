import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
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
        title: Text('الجدول واللقاءات الحية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.6), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.red),
                    SizedBox(width: 6),
                    Text('مباشر الآن', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Tajawal')),
                  ],
                ),
                const SizedBox(height: 8),
                Text('جلسة إرشاد ومراجعة كود Flutter Live Q&A', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
                const SizedBox(height: 4),
                Text('المدرب: م. إبراهيم الخالدي • 142 طالب متصل', style: TextStyle(fontSize: 12, color: textSubColor, fontFamily: 'Tajawal')),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call, color: Colors.white),
                  label: const Text('انضمام للبث المباشر الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
