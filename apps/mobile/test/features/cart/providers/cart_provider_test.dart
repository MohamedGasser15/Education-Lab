import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/models/coupon_model.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';

class FakeCartRepository extends CartRepository {
  CartModel mockCart;
  bool shouldSucceed;

  FakeCartRepository({
    this.mockCart = const CartModel(
      id: 1,
      userId: 'u1',
      items: [],
      totalPrice: 0.0,
    ),
    this.shouldSucceed = true,
  });

  @override
  Future<Result<CartModel>> getCart() async {
    if (shouldSucceed) {
      return Success(mockCart);
    }
    return const Failure('Error fetching cart');
  }

  @override
  Future<Result<CartModel>> addItemToCart(int courseId) async {
    if (shouldSucceed) {
      final newItem = CartItemModel(
        id: 99,
        courseId: courseId,
        courseTitle: 'Added Course',
        coursePrice: 50.0,
        instructorName: 'Instructor',
        totalPrice: 50.0,
      );
      mockCart = CartModel(
        id: mockCart.id,
        userId: mockCart.userId,
        items: [...mockCart.items, newItem],
        totalPrice: mockCart.totalPrice + 50.0,
      );
      return Success(mockCart);
    }
    return const Failure('Failed to add item');
  }

  @override
  Future<Result<CartModel>> removeItemFromCart(int cartItemId) async {
    if (shouldSucceed) {
      final updatedItems = mockCart.items
          .where((i) => i.id != cartItemId)
          .toList();
      mockCart = CartModel(
        id: mockCart.id,
        userId: mockCart.userId,
        items: updatedItems,
        totalPrice: updatedItems.fold(0.0, (sum, i) => sum + i.totalPrice),
      );
      return Success(mockCart);
    }
    return const Failure('Failed to remove item');
  }

  @override
  Future<Result<bool>> clearCart() async {
    if (shouldSucceed) {
      mockCart = const CartModel(
        id: 1,
        userId: 'u1',
        items: [],
        totalPrice: 0.0,
      );
      return const Success(true);
    }
    return const Failure('Failed to clear cart');
  }

  @override
  Future<Result<CouponApplyResultModel>> applyCoupon(String code) async {
    if (!shouldSucceed) {
      return const Failure('Network error');
    }
    if (code == 'EDULAB' || code == 'SAVE20') {
      return const Success(
        CouponApplyResultModel(
          success: true,
          message: 'تم تطبيق الرمز بنجاح',
          code: 'EDULAB',
          subtotal: 100.0,
          discountAmount: 20.0,
          newTotal: 80.0,
          discountDescription: 'خصم 20%',
        ),
      );
    } else if (code == 'SUPER50') {
      return const Success(
        CouponApplyResultModel(
          success: true,
          message: 'تم تطبيق الرمز بنجاح',
          code: 'SUPER50',
          subtotal: 100.0,
          discountAmount: 50.0,
          newTotal: 50.0,
          discountDescription: 'خصم 50%',
        ),
      );
    }
    return const Success(
      CouponApplyResultModel(
        success: false,
        message: 'رمز القسيمة غير صحيح',
      ),
    );
  }

  @override
  Future<Result<bool>> removeCoupon() async {
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartProvider Calculations & Coupons', () {
    late CartProvider provider;
    late FakeCartRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeCartRepository(
        mockCart: const CartModel(
          id: 1,
          userId: 'user-1',
          totalPrice: 100.0,
          items: [
            CartItemModel(
              id: 1,
              courseId: 10,
              courseTitle: 'Course A',
              coursePrice: 40.0,
              instructorName: 'Inst A',
              totalPrice: 40.0,
            ),
            CartItemModel(
              id: 2,
              courseId: 20,
              courseTitle: 'Course B',
              coursePrice: 60.0,
              instructorName: 'Inst B',
              totalPrice: 60.0,
            ),
          ],
        ),
      );
      provider = CartProvider(repository: fakeRepo);
    });

    test('initial coupon state and properties', () {
      expect(provider.appliedCoupon, isNull);
      expect(provider.discountPercent, 0.0);
      expect(provider.isEmpty, isTrue);
      expect(provider.isInCart(10), isFalse);
    });

    test('applyCoupon validates known discount codes via API', () async {
      final applied20 = await provider.applyCoupon('EDULAB');
      expect(applied20.success, isTrue);
      expect(provider.appliedCoupon, 'EDULAB');
      expect(provider.discountPercent, 20.0);
      expect(provider.discountAmount, 20.0);

      final applied50 = await provider.applyCoupon('super50');
      expect(applied50.success, isTrue);
      expect(provider.appliedCoupon, 'SUPER50');
      expect(provider.discountPercent, 50.0);
      expect(provider.discountAmount, 50.0);

      final appliedInvalid = await provider.applyCoupon('INVALID_CODE');
      expect(appliedInvalid.success, isFalse);
    });

    test('removeCoupon resets applied coupon and discount', () async {
      await provider.applyCoupon('EDULAB');
      expect(provider.appliedCoupon, isNotNull);

      final removed = await provider.removeCoupon();
      expect(removed, isTrue);
      expect(provider.appliedCoupon, isNull);
      expect(provider.discountPercent, 0.0);
      expect(provider.discountAmount, 0.0);
    });

    test('reset clears cart provider state', () async {
      await provider.applyCoupon('EDULAB');
      provider.reset();

      expect(provider.cart, isNull);
      expect(provider.appliedCoupon, isNull);
      expect(provider.discountPercent, 0.0);
      expect(provider.isLoading, isFalse);
    });
  });
}
