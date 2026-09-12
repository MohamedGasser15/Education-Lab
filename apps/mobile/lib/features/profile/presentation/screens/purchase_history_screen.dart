import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/profile/data/models/payment_model.dart';
import 'package:mobile/features/profile/presentation/providers/payment_provider.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchUserPayments();
    });
  }

  Future<void> _loadPayments() async {
    await context.read<PaymentProvider>().fetchUserPayments(forceRefresh: true);
  }

  // ================= VIEW INVOICE MODAL =================
  void _viewInvoice(PaymentModel item) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceMuted
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.purchaseHistoryInvoiceCertified,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.loc.purchaseHistoryTaxInvoiceCertified,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: textSubColor),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Invoice Details Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceMuted
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInvoiceRow(
                    context.loc.purchaseHistoryInvoiceNumberLabel,
                    item.orderNumber,
                    isHighlight: true,
                    isLtr: true,
                  ),
                  Divider(
                    height: 20,
                    color: isDark ? AppColors.darkDivider : AppColors.border,
                  ),
                  _buildInvoiceRow(
                    context.loc.purchaseHistoryCourseNameLabel,
                    item.courseTitle,
                  ),
                  const SizedBox(height: 10),
                  _buildInvoiceRow(
                    context.loc.purchaseHistoryPurchaseDateLabel,
                    item.formattedDate,
                  ),
                  const SizedBox(height: 10),
                  _buildInvoiceRow(
                    context.loc.purchaseHistoryPaymentMethodLabel,
                    context.loc.purchaseHistoryPaymentMethodValue,
                  ),
                  const SizedBox(height: 10),
                  _buildInvoiceRow(
                    context.loc.purchaseHistoryOrderStatusLabel,
                    item.isRefunded
                        ? context.loc.purchaseHistoryStatusRefunded
                        : (item.isPendingRefund
                              ? context.loc.purchaseHistoryStatusPendingReview
                              : context.loc.purchaseHistoryStatusCompleted),
                  ),
                  Divider(
                    height: 20,
                    color: isDark ? AppColors.darkDivider : AppColors.border,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.purchaseHistoryTotalAmount,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        '\$${item.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Actions
            AppButton(
              label: context.loc.purchaseHistoryCopyInvoiceBtn,
              icon: const Icon(
                Icons.copy_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item.orderNumber));
                Navigator.pop(ctx);
                AppSnackbar.showSuccess(
                  context,
                  '${context.loc.purchaseHistoryInvoiceNumber}: ${item.orderNumber}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(
    String label,
    String value, {
    bool isHighlight = false,
    bool isLtr = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: textSubColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.bold,
              color: isHighlight ? AppColors.primary : textColor,
              fontFamily: isLtr ? 'Inter' : 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  // ================= REFUND REQUEST MODAL =================
  void _showRefundDialog(PaymentModel item) {
    HapticFeedback.mediumImpact();
    final reasonController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSubColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                top: 12,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkRoleStudentBg
                                : AppColors.goldLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.replay_rounded,
                            color: isDark
                                ? AppColors.darkRoleStudent
                                : AppColors.goldDark,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.purchaseHistoryRefundRequestTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.courseTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSubColor,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: textSubColor),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Guarantee Notice
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkRoleStudentBg
                            : AppColors.goldLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkRoleStudentBorder
                              : AppColors.goldBorder,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: isDark
                                ? AppColors.darkRoleStudent
                                : AppColors.goldDark,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.loc.purchaseHistoryRefundPolicy,
                              style: TextStyle(
                                fontSize: 11.5,
                                height: 1.4,
                                color: isDark
                                    ? AppColors.darkRoleStudent
                                    : AppColors.warningDark,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      context.loc.purchaseHistoryRefundReasonLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontFamily: 'Tajawal',
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: context.loc.purchaseHistoryRefundReasonHint,
                        hintStyle: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          fontFamily: 'Tajawal',
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurfaceMuted
                            : AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Submit Refund Button
                    AppButton(
                      label: context.loc.purchaseHistoryConfirmRefund,
                      loadingLabel: context.loc.purchaseHistorySubmittingRefund,
                      isLoading: isSubmitting,
                      backgroundColor: AppColors.goldDark,
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final reason = reasonController.text.trim();
                        if (reason.isEmpty) {
                          AppSnackbar.showError(
                            context,
                            context.loc.purchaseHistoryRefundReasonEmptyError,
                          );
                          return;
                        }

                        setModalState(() => isSubmitting = true);
                        final res = await context
                            .read<PaymentProvider>()
                            .requestRefund(paymentId: item.id, reason: reason);

                        if (!ctx.mounted) return;
                        setModalState(() => isSubmitting = false);

                        if (res is Success<RefundResultModel>) {
                          Navigator.pop(ctx);
                          if (mounted) {
                            AppSnackbar.showSuccess(
                              context,
                              context.loc.purchaseHistoryRefundSubmitted,
                            );
                          }
                        } else if (res is Failure<RefundResultModel>) {
                          if (mounted) {
                            AppSnackbar.showError(context, res.message);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final isLoading = paymentProvider.isLoading;
    final payments = paymentProvider.payments;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
      body: RefreshIndicator(
        onRefresh: _loadPayments,
        color: AppColors.primary,
        child: isLoading && payments.isEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.screenPadding(context),
                  16,
                  AppResponsive.screenPadding(context),
                  120,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const SkeletonPurchaseCard(),
              )
            : payments.isEmpty
            ? _buildEmptyState(textColor, textSubColor, isDark)
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.screenPadding(context),
                  16,
                  AppResponsive.screenPadding(context),
                  120,
                ),
                children: [
                  // 1. Guarantee Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceMuted
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.roleInstructorBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.loc.checkoutMoneyBackGuarantee,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.primaryDark,
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
                  for (final item in payments) ...[
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
                                item.orderNumber,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  color: AppColors.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: item.isRefunded
                                      ? (isDark
                                            ? AppColors.darkRoleAdminBg
                                            : AppColors.roleAdminBg)
                                      : (item.isPendingRefund
                                            ? (isDark
                                                  ? AppColors.darkRoleStudentBg
                                                  : AppColors.goldLight)
                                            : (isDark
                                                  ? const Color(0xFF0D3320)
                                                  : AppColors.emeraldLight)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.isRefunded
                                      ? context
                                            .loc
                                            .purchaseHistoryStatusRefunded
                                      : (item.isPendingRefund
                                            ? context
                                                  .loc
                                                  .purchaseHistoryStatusPendingReview
                                            : context
                                                  .loc
                                                  .purchaseHistoryStatusCompleted),
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: item.isRefunded
                                        ? (isDark
                                              ? AppColors.darkRoleAdmin
                                              : AppColors.roleAdmin)
                                        : (item.isPendingRefund
                                              ? (isDark
                                                    ? AppColors.darkRoleStudent
                                                    : AppColors.goldDark)
                                              : AppColors.emerald),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.courseThumbnail != null &&
                                  item.courseThumbnail!.isNotEmpty) ...[
                                AppNetworkImage(
                                  url: item.courseThumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(8),
                                  errorWidget: Container(
                                    width: 50,
                                    height: 50,
                                    color: isDark
                                        ? AppColors.darkSurfaceMuted
                                        : AppColors.primaryLight,
                                    child: const Icon(
                                      Icons.school_rounded,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.courseTitle,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${context.loc.purchaseHistoryPaidDate}: ${item.formattedDate}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: textSubColor,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Divider(
                            height: 18,
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.surfaceMuted,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${context.loc.purchaseHistoryAmount}: \$${item.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Inter',
                                  color: textColor,
                                ),
                              ),
                              Row(
                                children: [
                                  if (item.isRefundable &&
                                      !item.isRefunded &&
                                      !item.isPendingRefund) ...[
                                    OutlinedButton(
                                      onPressed: () => _showRefundDialog(item),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.goldDark,
                                        side: const BorderSide(
                                          color: AppColors.goldDark,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        context
                                            .loc
                                            .purchaseHistoryRequestRefundBtn,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  AppButton(
                                    text: context.loc.purchaseHistoryInvoiceBtn,
                                    width: null,
                                    height: 30,
                                    fontSize: 11,
                                    borderRadius: 8,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    onPressed: () => _viewInvoice(item),
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
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color textSubColor, bool isDark) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceMuted
                      : AppColors.primaryLight,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.loc.purchaseHistoryEmptyTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.loc.purchaseHistoryEmptyDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 220,
                child: AppButton(
                  label: context.loc.purchaseHistoryExploreCourses,
                  icon: const Icon(
                    Icons.explore_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
