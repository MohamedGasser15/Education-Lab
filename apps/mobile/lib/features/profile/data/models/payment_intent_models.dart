class PaymentRequestModel {
  final double amount;
  final String currency;
  final String description;
  final List<int> courseIds;
  final String? postalCode;
  final String? fullName;
  final String? phoneNumber;
  final String? paymentMethodId;

  const PaymentRequestModel({
    required this.amount,
    this.currency = 'usd',
    required this.description,
    required this.courseIds,
    this.postalCode,
    this.fullName,
    this.phoneNumber,
    this.paymentMethodId = 'temp_payment_method',
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
      'courseIds': courseIds,
      if (postalCode != null) 'postalCode': postalCode,
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'paymentMethodId': paymentMethodId ?? 'temp_payment_method',
    };
  }
}

class PaymentResponseModel {
  final bool success;
  final String? message;
  final String? paymentIntentId;
  final String? clientSecret;
  final double amount;
  final String? currency;
  final DateTime? createdAt;

  const PaymentResponseModel({
    required this.success,
    this.message,
    this.paymentIntentId,
    this.clientSecret,
    this.amount = 0.0,
    this.currency,
    this.createdAt,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['createdAt'] != null) {
      try {
        parsedDate = DateTime.parse(json['createdAt'].toString());
      } catch (_) {}
    }

    return PaymentResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? json['Message']?.toString(),
      paymentIntentId: json['paymentIntentId']?.toString() ?? json['PaymentIntentId']?.toString(),
      clientSecret: json['clientSecret']?.toString() ?? json['ClientSecret']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString(),
      createdAt: parsedDate,
    );
  }
}

class PaymentUserDataModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? postalCode;

  const PaymentUserDataModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.postalCode,
  });

  factory PaymentUserDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentUserDataModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      postalCode: json['postalCode']?.toString(),
    );
  }
}
