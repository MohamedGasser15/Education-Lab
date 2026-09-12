import 'dart:convert';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:mobile/features/profile/data/models/payment_intent_models.dart';
import 'package:mobile/features/profile/data/models/payment_model.dart';

class PaymentApiService {
  final ApiClient _apiClient;

  PaymentApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// GET /api/Payment/user-data
  Future<Result<PaymentUserDataModel>> getUserData() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.paymentUserData);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          return Success(PaymentUserDataModel.fromJson(data));
        }
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب بيانات المستخدم');
    } catch (e) {
      AppLogger.e('getUserData error', tag: 'PaymentApiService', error: e);
      return Failure('حدث خطأ أثناء جلب بيانات المستخدم: $e', error: e);
    }
  }

  /// POST /api/Payment/create-payment-intent
  Future<Result<PaymentResponseModel>> createPaymentIntent(
    PaymentRequestModel request,
  ) async {
    try {
      final result = await _apiClient.postSafe(
        ApiConstants.createPaymentIntent,
        body: request.toJson(),
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          return Success(PaymentResponseModel.fromJson(data));
        }
        return const Success(PaymentResponseModel(success: true));
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر إنشاء طلب الدفع');
    } catch (e) {
      AppLogger.e(
        'createPaymentIntent error',
        tag: 'PaymentApiService',
        error: e,
      );
      return Failure('حدث خطأ أثناء إنشاء طلب الدفع: $e', error: e);
    }
  }

  /// POST /api/Payment/confirm-payment
  Future<Result<PaymentResponseModel>> confirmPayment(
    String paymentIntentId,
  ) async {
    try {
      // Backend expects [FromBody] string paymentIntentId which in ASP.NET Core is a JSON-encoded string
      final body = json.encode(paymentIntentId);

      final result = await _apiClient.postSafe(
        ApiConstants.confirmPayment,
        body: body,
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          return Success(PaymentResponseModel.fromJson(data));
        }
        return const Success(
          PaymentResponseModel(success: true, message: 'تم تأكيد الدفع بنجاح'),
        );
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل تأكيد عملية الدفع بالسيرفر');
    } catch (e) {
      AppLogger.e('confirmPayment error', tag: 'PaymentApiService', error: e);
      return Failure('حدث خطأ أثناء تأكيد عملية الدفع: $e', error: e);
    }
  }

  /// GET /api/Payment/user-payments
  Future<Result<List<PaymentModel>>> getUserPayments() async {
    try {
      final result = await _apiClient.getSafe(ApiConstants.userPayments);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        List<dynamic> list = [];
        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            list = data['data'] as List;
          } else if (data['result'] is List) {
            list = data['result'] as List;
          }
        }

        final payments = list
            .map((item) => PaymentModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return Success(payments);
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('تعذر جلب سجل المشتريات');
    } catch (e) {
      AppLogger.e('getUserPayments error', tag: 'PaymentApiService', error: e);
      return Failure('حدث خطأ أثناء جلب سجل المشتريات: $e', error: e);
    }
  }

  /// POST /api/Payment/refund
  Future<Result<RefundResultModel>> requestRefund({
    required int paymentId,
    required String reason,
  }) async {
    try {
      final body = {'paymentId': paymentId, 'reason': reason.trim()};

      final result = await _apiClient.postSafe(ApiConstants.refund, body: body);

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }
        if (data is Map<String, dynamic>) {
          return Success(RefundResultModel.fromJson(data));
        }
        return const Success(
          RefundResultModel(
            success: true,
            message: 'تم إرسال طلب الاسترداد بنجاح',
          ),
        );
      } else if (result is Failure) {
        return Failure(_extractErrorMessage(result), error: result.error);
      }
      return const Failure('فشل إرسال طلب الاسترداد');
    } catch (e) {
      AppLogger.e('requestRefund error', tag: 'PaymentApiService', error: e);
      return Failure('حدث خطأ أثناء إرسال طلب الاسترداد: $e', error: e);
    }
  }

  String _extractErrorMessage(Failure failure) {
    String msg = failure.message;
    try {
      if (failure.error is ApiException) {
        final rawBody = (failure.error as ApiException).responseBody;
        final decoded = json.decode(rawBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] != null) {
            return decoded['message'].toString();
          }
          if (decoded['Message'] != null) {
            return decoded['Message'].toString();
          }
          if (decoded['errors'] is Map<String, dynamic>) {
            final errors = decoded['errors'] as Map<String, dynamic>;
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              return firstVal.first.toString();
            }
            return firstVal.toString();
          }
        }
      }
    } catch (_) {}
    return msg;
  }
}
