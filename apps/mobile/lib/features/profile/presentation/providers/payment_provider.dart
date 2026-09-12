import 'package:flutter/foundation.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/payment_intent_models.dart';
import 'package:mobile/features/profile/data/models/payment_model.dart';
import 'package:mobile/features/profile/data/repositories/payment_repository.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _repository;

  bool _isLoading = false;
  List<PaymentModel> _payments = [];
  String? _errorMessage;

  PaymentProvider({PaymentRepository? repository})
    : _repository = repository ?? resolveOr(() => PaymentRepository());

  bool get isLoading => _isLoading;
  List<PaymentModel> get payments => _payments;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserPayments({bool forceRefresh = false}) async {
    if (_payments.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getUserPayments();
      if (result is Success<List<PaymentModel>>) {
        _payments = result.data;
        _errorMessage = null;
      } else if (result is Failure<List<PaymentModel>>) {
        _errorMessage = result.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<PaymentUserDataModel>> getUserData() {
    return _repository.getUserData();
  }

  Future<Result<PaymentResponseModel>> createPaymentIntent(
    PaymentRequestModel request,
  ) {
    return _repository.createPaymentIntent(request);
  }

  Future<Result<PaymentResponseModel>> confirmPayment(String paymentIntentId) {
    return _repository.confirmPayment(paymentIntentId);
  }

  Future<Result<RefundResultModel>> requestRefund({
    required int paymentId,
    required String reason,
  }) async {
    final result = await _repository.requestRefund(
      paymentId: paymentId,
      reason: reason,
    );
    if (result is Success<RefundResultModel>) {
      await fetchUserPayments(forceRefresh: true);
    }
    return result;
  }
}
