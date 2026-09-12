import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/widgets/app_button.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);

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
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.screenPadding(context),
          vertical: 16,
        ),
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
                AppButton(
                  height: 46,
                  borderRadius: 12,
                  backgroundColor: Colors.red,
                  icon: const Icon(Icons.video_call, color: Colors.white, size: 20),
                  label: 'انضمام للبث المباشر الآن',
                  fontSize: 13,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
