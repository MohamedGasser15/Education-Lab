class PaymentModel {
  final int id;
  final double amount;
  final String status;
  final DateTime paidAt;
  final String stripeSessionId;
  final int courseId;
  final String courseTitle;
  final String? courseThumbnail;
  final bool isRefundable;
  final String? refundStatus; // 'pending' | 'accepted' | 'rejected' | null

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.paidAt,
    required this.stripeSessionId,
    required this.courseId,
    required this.courseTitle,
    this.courseThumbnail,
    this.isRefundable = false,
    this.refundStatus,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['paidAt'] != null || json['createdAt'] != null || json['date'] != null) {
      try {
        parsedDate = DateTime.parse(
          (json['paidAt'] ?? json['createdAt'] ?? json['date']).toString(),
        );
      } catch (_) {}
    }

    double parsedAmount = 0.0;
    if (json['amount'] != null) {
      parsedAmount = double.tryParse(json['amount'].toString()) ?? 0.0;
    }

    return PaymentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      amount: parsedAmount,
      status: json['status']?.toString() ?? 'succeeded',
      paidAt: parsedDate,
      stripeSessionId: json['stripeSessionId']?.toString() ?? '',
      courseId: int.tryParse(json['courseId']?.toString() ?? '0') ?? 0,
      courseTitle: json['courseTitle']?.toString() ?? 'كورس تعليمي',
      courseThumbnail: json['courseThumbnail']?.toString(),
      isRefundable: json['isRefundable'] == true,
      refundStatus: json['refundStatus']?.toString(),
    );
  }

  String get formattedDate {
    return '${paidAt.day}/${paidAt.month}/${paidAt.year}';
  }

  String get orderNumber {
    if (stripeSessionId.isNotEmpty && stripeSessionId.length > 8) {
      return 'EDU-${stripeSessionId.substring(stripeSessionId.length - 8).toUpperCase()}';
    }
    return 'EDU-${id.toString().padLeft(6, '0')}';
  }

  bool get isRefunded =>
      status.toLowerCase() == 'refunded' ||
      refundStatus?.toLowerCase() == 'accepted' ||
      refundStatus?.toLowerCase() == 'approved';

  bool get isPendingRefund => refundStatus?.toLowerCase() == 'pending';
}

class RefundResultModel {
  final bool success;
  final String message;
  final String refundId;
  final double refundedAmount;

  const RefundResultModel({
    required this.success,
    required this.message,
    this.refundId = '',
    this.refundedAmount = 0.0,
  });

  factory RefundResultModel.fromJson(Map<String, dynamic> json) {
    return RefundResultModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      refundId: json['refundId']?.toString() ?? '',
      refundedAmount: double.tryParse(json['refundedAmount']?.toString() ?? '0') ?? 0.0,
    );
  }
}
