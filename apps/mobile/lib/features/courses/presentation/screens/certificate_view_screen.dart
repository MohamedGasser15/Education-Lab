import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class CertificateViewScreen extends StatelessWidget {
  const CertificateViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشهادة المعتمدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber.shade300, width: 3),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16)],
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified, size: 50, color: Colors.amber),
                  const SizedBox(height: 8),
                  const Text('CERTIFICATE OF COMPLETION', style: TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 6),
                  const Text('شهادة إتمام وتفوق معتمدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Divider(height: 24),
                  const Text('تشهد أكاديمية EduLab بأن الطالب:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('عمر أحمد الشمري', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 12),
                  const Text('قد أتم بنجاح متطلبات دورة: تطوير تطبيقات Flutter & Dart من الصفر للاحتراف بنسبة 98% امتياز', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المدرب: م. إبراهيم الخالدي', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('الرقم: EDULAB-2026-984', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text('تحميل PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: AppColors.primary),
                    label: const Text('مشاركة LinkedIn', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
