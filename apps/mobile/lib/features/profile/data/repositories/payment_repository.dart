import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/payment_model.dart';
import 'package:mobile/features/profile/data/services/payment_api_service.dart';

class PaymentRepository {
  final PaymentApiService _apiService;

  PaymentRepository({PaymentApiService? apiService})
      : _apiService = apiService ?? PaymentApiService();

  Future<Result<List<PaymentModel>>> getUserPayments() {
    return _apiService.getUserPayments();
  }

  Future<Result<RefundResultModel>> requestRefund({
    required int paymentId,
    required String reason,
  }) {
    return _apiService.requestRefund(
      paymentId: paymentId,
      reason: reason,
    );
  }
}
