import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/profile/data/models/payment_model.dart';
import 'package:mobile/features/profile/data/repositories/payment_repository.dart';
import 'package:mobile/features/profile/presentation/providers/payment_provider.dart';

class FakePaymentRepository extends PaymentRepository {
  final bool shouldSucceed;
  final List<PaymentModel> mockPayments;

  FakePaymentRepository({
    this.shouldSucceed = true,
    this.mockPayments = const [],
  });

  @override
  Future<Result<List<PaymentModel>>> getUserPayments() async {
    if (shouldSucceed) {
      return Success(mockPayments);
    }
    return const Failure('Error fetching payments');
  }

  @override
  Future<Result<RefundResultModel>> requestRefund({
    required int paymentId,
    required String reason,
  }) async {
    if (shouldSucceed) {
      return const Success(
        RefundResultModel(
          success: true,
          message: 'Refund submitted successfully',
          refundId: 'REF-12345',
        ),
      );
    }
    return const Failure('Failed to submit refund');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PaymentProvider Tests', () {
    final List<PaymentModel> mockList = [
      PaymentModel(
        id: 1,
        courseId: 101,
        courseTitle: 'Flutter Clean Architecture',
        amount: 49.99,
        status: 'succeeded',
        stripeSessionId: 'cs_test_123456789',
        paidAt: DateTime(2026, 9, 1),
        isRefundable: true,
      ),
    ];

    test('fetchUserPayments updates payments on success', () async {
      final fakeRepo = FakePaymentRepository(mockPayments: mockList);
      final provider = PaymentProvider(repository: fakeRepo);

      expect(provider.isLoading, false);
      expect(provider.payments, isEmpty);

      await provider.fetchUserPayments();

      expect(provider.isLoading, false);
      expect(provider.payments.length, 1);
      expect(provider.payments.first.orderNumber, isNotEmpty);
      expect(provider.errorMessage, isNull);
    });

    test('fetchUserPayments sets error message on failure', () async {
      final fakeRepo = FakePaymentRepository(shouldSucceed: false);
      final provider = PaymentProvider(repository: fakeRepo);

      await provider.fetchUserPayments();

      expect(provider.isLoading, false);
      expect(provider.payments, isEmpty);
      expect(provider.errorMessage, 'Error fetching payments');
    });

    test(
      'requestRefund submits refund and refetches payments on success',
      () async {
        final fakeRepo = FakePaymentRepository(mockPayments: mockList);
        final provider = PaymentProvider(repository: fakeRepo);

        final result = await provider.requestRefund(
          paymentId: 1,
          reason: 'Duplicate purchase',
        );

        expect(result is Success, true);
        expect(provider.payments.length, 1);
      },
    );
  });
}
