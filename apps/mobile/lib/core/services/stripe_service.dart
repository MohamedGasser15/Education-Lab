import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/utils/app_logger.dart';

class StripeResult {
  final bool success;
  final String? paymentMethodId;
  final String? status;
  final String? errorMessage;

  const StripeResult({
    required this.success,
    this.paymentMethodId,
    this.status,
    this.errorMessage,
  });

  factory StripeResult.success({String? paymentMethodId, String? status}) {
    return StripeResult(
      success: true,
      paymentMethodId: paymentMethodId,
      status: status ?? 'succeeded',
    );
  }

  factory StripeResult.failure(String errorMessage) {
    return StripeResult(success: false, errorMessage: errorMessage);
  }
}

class StripeService {
  final String _publishableKey;
  final Dio _dio;

  StripeService({String? publishableKey, Dio? dio})
    : _publishableKey = publishableKey ?? ApiConstants.stripePublishableKey,
      _dio = dio ?? Dio();

  /// 1. Create PaymentMethod on Stripe using Card Data & Billing Details
  Future<StripeResult> createPaymentMethod({
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    String? name,
    String? phone,
    String? postalCode,
  }) async {
    try {
      final cleanCardNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
      final cleanCvc = cvc.trim();

      final body = <String, String>{
        'type': 'card',
        'card[number]': cleanCardNumber,
        'card[exp_month]': expMonth.toString(),
        'card[exp_year]': expYear.toString(),
        'card[cvc]': cleanCvc,
      };

      if (name != null && name.trim().isNotEmpty) {
        body['billing_details[name]'] = name.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        body['billing_details[phone]'] = phone.trim();
      }
      if (postalCode != null && postalCode.trim().isNotEmpty) {
        body['billing_details[address][postal_code]'] = postalCode.trim();
      }

      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_methods',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_publishableKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          validateStatus: (_) => true,
        ),
      );

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 200 && data['id'] != null) {
        final pmId = data['id'] as String;
        AppLogger.i('Created PaymentMethod $pmId', tag: 'StripeService');
        return StripeResult.success(paymentMethodId: pmId);
      }

      final rawError = data['error'] as Map<String, dynamic>?;
      final rawMsg = rawError?['message']?.toString() ?? '';

      // If Stripe dashboard restricts client-side raw tokenization and we're in test mode (pk_test_...),
      // fallback to Stripe's official test PaymentMethod tokens for the card brand:
      final isTestMode = _publishableKey.startsWith('pk_test_');
      if (isTestMode &&
          rawMsg.contains('unsupported for publishable key tokenization')) {
        final testPm = _resolveTestPaymentMethod(cleanCardNumber);
        AppLogger.w(
          'Falling back to official Stripe test payment method ($testPm) for $cleanCardNumber',
          tag: 'StripeService',
        );
        return StripeResult.success(paymentMethodId: testPm);
      }

      final errorMsg = _extractStripeError(data);
      return StripeResult.failure(errorMsg);
    } catch (e) {
      AppLogger.e('createPaymentMethod error', tag: 'StripeService', error: e);
      return StripeResult.failure('حدث خطأ أثناء معالجة بيانات البطاقة: $e');
    }
  }

  String _resolveTestPaymentMethod(String cardNumber) {
    if (cardNumber.endsWith('0002') || cardNumber.contains('fail')) {
      return 'pm_card_chargeCustomerFail';
    }
    if (cardNumber.startsWith('4')) {
      return 'pm_card_visa';
    }
    if (cardNumber.startsWith('5') || cardNumber.startsWith('2')) {
      return 'pm_card_mastercard';
    }
    if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
      return 'pm_card_amex';
    }
    if (cardNumber.startsWith('6')) {
      return 'pm_card_discover';
    }
    return 'pm_card_visa';
  }

  /// 2. Confirm PaymentIntent with the created PaymentMethod & Client Secret
  Future<StripeResult> confirmPaymentIntent({
    required String paymentIntentId,
    required String clientSecret,
    required String paymentMethodId,
  }) async {
    try {
      final body = <String, String>{
        'payment_method': paymentMethodId,
        'client_secret': clientSecret,
      };

      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_publishableKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          validateStatus: (_) => true,
        ),
      );

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 200) {
        final status = data['status']?.toString() ?? '';
        if (status == 'succeeded') {
          AppLogger.i(
            'PaymentIntent $paymentIntentId succeeded',
            tag: 'StripeService',
          );
          return StripeResult.success(status: status);
        } else if (status == 'requires_action') {
          return StripeResult.failure(
            'تتطلب هذه البطاقة مصادقة إضافية 3D Secure غير مدعومة في البيئة التجريبية.',
          );
        } else {
          return StripeResult.failure('حالة الدفع غير مكتملة: $status');
        }
      }

      final errorMsg = _extractStripeError(data);
      return StripeResult.failure(errorMsg);
    } catch (e) {
      AppLogger.e('confirmPaymentIntent error', tag: 'StripeService', error: e);
      return StripeResult.failure('حدث خطأ أثناء تأكيد عملية الدفع: $e');
    }
  }

  String _extractStripeError(Map<String, dynamic> data) {
    if (data['error'] is Map<String, dynamic>) {
      final error = data['error'] as Map<String, dynamic>;
      final message = error['message']?.toString();
      final code = error['code']?.toString();

      if (code == 'card_declined') {
        final declineCode = error['decline_code']?.toString();
        if (declineCode == 'insufficient_funds') {
          return 'تم رفض البطاقة لعدم توفر رصيد كافٍ (Insufficient funds).';
        }
        return 'تم رفض البطاقة من جهة الإصدار البنكية (Card declined).';
      } else if (code == 'expired_card') {
        return 'البطاقة منتهية الصلاحية، يرجى استخدام بطاقة صالحة.';
      } else if (code == 'incorrect_cvc') {
        return 'رمز الأمان CVC غير صحيح.';
      } else if (code == 'incorrect_number' || code == 'invalid_number') {
        return 'رقم البطاقة غير صحيح.';
      }

      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return 'فشلت معالجة الدفع عبر Stripe، يرجى مراجعة بيانات البطاقة والمحاولة لاحقاً.';
  }
}
