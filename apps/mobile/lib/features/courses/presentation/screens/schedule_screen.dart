import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الجدول واللقاءات الحية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Colors.redAccent, width: 1.5)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(radius: 4, backgroundColor: Colors.red),
                      SizedBox(width: 6),
                      Text('مباشر الآن', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('جلسة إرشاد ومراجعة كود Flutter Live Q&A', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('المدرب: م. إبراهيم الخالدي • 142 طالب متصل', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.video_call, color: Colors.white),
                    label: const Text('انضمام للبث المباشر الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
