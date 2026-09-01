import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'txn_1',
      'orderNumber': 'EDU-2026-89412',
      'courseTitle': 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart',
      'instructor': 'م. أحمد محمد',
      'date': '28 فبراير 2026',
      'amount': '49.99',
      'currency': 'USD',
      'paymentMethod': 'بطاقة مدى / فيزا (•••• 4242)',
      'status': 'مكتمل وناجح',
      'isRefunded': false,
    },
    {
      'id': 'txn_2',
      'orderNumber': 'EDU-2026-78104',
      'courseTitle': 'تصميم واجهات وتجربة المستخدم الاحترافية بـ Figma',
      'instructor': 'سارة أحمد',
      'date': '15 يناير 2026',
      'amount': '34.99',
      'currency': 'USD',
      'paymentMethod': 'Apple Pay',
      'status': 'مكتمل وناجح',
      'isRefunded': false,
    },
    {
      'id': 'txn_3',
      'orderNumber': 'EDU-2025-63290',
      'courseTitle': 'أساسيات لغة بايثون وعلوم البيانات للمبتدئين',
      'instructor': 'د. خالد العمري',
      'date': '10 نوفمبر 2025',
      'amount': '19.99',
      'currency': 'USD',
      'paymentMethod': 'PayPal',
      'status': 'تم الاسترداد',
      'isRefunded': true,
    },
  ];

  void _viewInvoice(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              context.loc.purchaseHistoryInvoiceCertified,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.loc.purchaseHistoryInvoiceNumber}: ${item['orderNumber']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter')),
            const SizedBox(height: 6),
            Text('${context.loc.purchaseHistoryCourse}: ${item['courseTitle']}', style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal')),
            const SizedBox(height: 4),
            Text('${context.loc.purchaseHistoryDate}: ${item['date']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
            const SizedBox(height: 4),
            Text('${context.loc.purchaseHistoryPaymentMethod}: ${item['paymentMethod']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal')),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.loc.purchaseHistoryTotalAmount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Tajawal')),
                Text('\$${item['amount']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'Inter', color: AppColors.primary)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.loc.purchaseHistoryClose, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.loc.purchaseHistoryPdfDownloaded), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: Text(context.loc.purchaseHistoryDownloadPdf, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(Map<String, dynamic> item) {
    HapticFeedback.mediumImpact();
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.loc.purchaseHistoryRefundRequestTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.purchaseHistoryRefundPolicy,
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontFamily: 'Tajawal', height: 1.3),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
              decoration: InputDecoration(
                hintText: context.loc.purchaseHistoryRefundReasonHint,
                hintStyle: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Tajawal'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.loc.commonCancel, style: const TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                item['isRefunded'] = true;
                item['status'] = 'قيد معالجة الاسترداد';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc.purchaseHistoryRefundSubmitted),
                  backgroundColor: Color(0xFF059669),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(context.loc.purchaseHistoryConfirmRefund, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

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
        centerTitle: false,
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
          context.loc.purchaseHistoryTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
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
              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.loc.checkoutMoneyBackGuarantee,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E40AF),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      height: 1.3,
                    ),
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
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
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
                          color: (item['isRefunded'] == true)
                              ? (isDark ? const Color(0xFF3B1717) : const Color(0xFFFEF2F2))
                              : (isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5)),
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
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${context.loc.purchaseHistoryInstructor}: ${item['instructor']} • ${item['date']}',
                    style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${context.loc.purchaseHistoryPaymentMethod}: ${item['paymentMethod']}',
                    style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                  ),
                  Divider(height: 18, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.loc.purchaseHistoryAmount}: ${item['amount']} ${item['currency']}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'Inter', color: textColor),
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
                              child: Text(context.loc.purchaseHistoryRequestRefundBtn, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
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
                            child: Text(context.loc.purchaseHistoryInvoiceBtn, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
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
