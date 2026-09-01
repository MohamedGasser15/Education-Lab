import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 101,
      'orderNumber': '#EDU-20260901-4821',
      'courseTitle': 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart من الصفر',
      'instructor': 'م. أحمد محمد',
      'date': '01 سبتمبر 2026',
      'amount': 49.99,
      'currency': '\$',
      'status': 'مكتملة',
      'paymentMethod': 'Stripe (Visa •••• 4242)',
      'isRefunded': false,
    },
    {
      'id': 102,
      'orderNumber': '#EDU-20260815-9310',
      'courseTitle': 'تصميم واجهات وتجربة المستخدم الاحترافية من الصفر بـ Figma',
      'instructor': 'سارة أحمد',
      'date': '15 أغسطس 2026',
      'amount': 39.99,
      'currency': '\$',
      'status': 'مكتملة',
      'paymentMethod': 'Stripe (Mastercard •••• 8841)',
      'isRefunded': false,
    },
    {
      'id': 103,
      'orderNumber': '#EDU-20260720-1102',
      'courseTitle': 'بناء وإطلاق أنظمة الذكاء الاصطناعي بلغة Python',
      'instructor': 'د. خالد العمري',
      'date': '20 يوليو 2026',
      'amount': 59.99,
      'currency': '\$',
      'status': 'تم الاسترجاع',
      'paymentMethod': 'Stripe (Visa •••• 4242)',
      'isRefunded': true,
    },
  ];

  void _showRefundDialog(Map<String, dynamic> item) {
    String selectedReason = 'المحتوى لا يطابق التوقعات';
    final reasons = [
      'المحتوى لا يطابق التوقعات',
      'تم الشراء عن طريق الخطأ',
      'مشاكل تقنية في تشغيل الفيديوهات',
      'مستوى الدورة مختلف عن المعلن',
      'سبب آخر',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.assignment_return_rounded, color: Colors.orange, size: 22),
              SizedBox(width: 8),
              Text('طلب استرجاع الأموال', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الدورة: ${item['courseTitle']}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 4),
              Text(
                'المبلغ المسترد: ${item['amount']} ${item['currency']} (ضمان 30 يوماً)',
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF059669), fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 14),
              const Text('سبب طلب الاسترجاع:', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedReason,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                  items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) => setDialogState(() => selectedReason = val!),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إرسال طلب استرجاع الطلب ${item['orderNumber']} بنجاح! سيتم فحص الطلب خلال 24 ساعة.'),
                    backgroundColor: const Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('إرسال الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
            ),
          ],
        ),
      ),
    );
  }

  void _viewInvoice(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('فاتورة الشراء الرسمية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildInvoiceRow('رقم الفاتورة:', item['orderNumber']),
            _buildInvoiceRow('الدورة المشتراة:', item['courseTitle']),
            _buildInvoiceRow('المحاضر:', item['instructor']),
            _buildInvoiceRow('تاريخ الشراء:', item['date']),
            _buildInvoiceRow('وسيلة الدفع:', item['paymentMethod']),
            _buildInvoiceRow('المبلغ الإجمالي المدفوع:', '${item['amount']} ${item['currency']}', isBold: true),
            _buildInvoiceRow('حالة الفاتورة:', item['status']),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تنزيل الفاتورة PDF في جهازك 📥'), behavior: SnackBarBehavior.floating),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('تحميل الفاتورة PDF', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'سجل المشتريات والمعاملات',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // 1. Guarantee Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: const [
                Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'جميع مدفوعاتك معالجة بأمان عبر Stripe مع ضمان استرداد كامل خلال 30 يوماً.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF1E40AF), fontWeight: FontWeight.bold, fontFamily: 'Tajawal', height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Transactions List
          for (final item in _transactions) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['orderNumber'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: AppColors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (item['isRefunded'] == true) ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: (item['isRefunded'] == true) ? Colors.redAccent : const Color(0xFF059669),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['courseTitle'] as String,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المحاضر: ${item['instructor']} • ${item['date']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'طريقة الدفع: ${item['paymentMethod']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Tajawal'),
                  ),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ: ${item['amount']} ${item['currency']}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'Inter', color: AppColors.textPrimary),
                      ),
                      Row(
                        children: [
                          if (item['isRefunded'] == false) ...[
                            OutlinedButton(
                              onPressed: () => _showRefundDialog(item),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                side: const BorderSide(color: Colors.orange),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('طلب استرجاع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            ),
                            const SizedBox(width: 8),
                          ],
                          ElevatedButton(
                            onPressed: () => _viewInvoice(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text('الفاتورة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
