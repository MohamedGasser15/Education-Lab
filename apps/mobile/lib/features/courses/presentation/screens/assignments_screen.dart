import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/widgets/app_button.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);

    final assignments = [
      {
        'title': 'بناء تطبيق متجر متكامل مع سلة الشراء',
        'status': 'مطلوب',
        'color': Colors.orange,
        'course': 'Flutter & Dart',
      },
      {
        'title': 'تدريب نموذج انحدار خطي وتوقع الأسعار',
        'status': 'قيد المراجعة',
        'color': Colors.blue,
        'course': 'Python AI',
      },
      {
        'title': 'تصميم Design System لتطبيق تعليمي',
        'status': 'تم التقييم (98%)',
        'color': Colors.green,
        'course': 'UI/UX Design',
      },
    ];

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
          'الواجبات والمشاريع العملية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.screenPadding(context),
          vertical: 16,
        ),
        itemCount: assignments.length,
        itemBuilder: (context, idx) {
          final item = assignments[idx];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['course'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Chip(
                      label: Text(
                        item['status'] as String,
                        style: TextStyle(
                          color: item['color'] as Color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      backgroundColor: (item['color'] as Color).withValues(
                        alpha: 0.1,
                      ),
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  height: 42,
                  borderRadius: 10,
                  icon: const Icon(
                    Icons.upload_file,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: 'تسليم الكود والمشروع',
                  fontSize: 12,
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
