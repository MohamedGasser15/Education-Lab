class CouponApplyResultModel {
  final bool success;
  final String message;
  final String? code;
  final double subtotal;
  final double discountAmount;
  final double newTotal;
  final String? discountDescription;

  const CouponApplyResultModel({
    required this.success,
    required this.message,
    this.code,
    this.subtotal = 0.0,
    this.discountAmount = 0.0,
    this.newTotal = 0.0,
    this.discountDescription,
  });

  factory CouponApplyResultModel.fromJson(Map<String, dynamic> json) {
    return CouponApplyResultModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      code: json['code']?.toString(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      newTotal: (json['newTotal'] as num?)?.toDouble() ?? 0.0,
      discountDescription: json['discountDescription']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'code': code,
    'subtotal': subtotal,
    'discountAmount': discountAmount,
    'newTotal': newTotal,
    'discountDescription': discountDescription,
  };
}
