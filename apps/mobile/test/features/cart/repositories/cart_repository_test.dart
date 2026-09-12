import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository.dart';
import 'package:mobile/features/cart/data/services/cart_api_service.dart';

class FakeCartApiService extends CartApiService {
  CartModel cart = const CartModel(
    id: 1,
    userId: 'usr-1',
    totalPrice: 100,
    items: [
      CartItemModel(
        id: 1,
        courseId: 101,
        courseTitle: 'Flutter Mastery',
        coursePrice: 100,
        instructorName: 'Mohamed',
        totalPrice: 100,
      ),
    ],
  );

  @override
  Future<Result<CartModel>> getCart() async {
    return Success(cart);
  }

  @override
  Future<Result<CartModel>> addItemToCart(int courseId) async {
    return Success(CartModel(
      id: 1,
      userId: 'usr-1',
      totalPrice: 180,
      items: [
        ...cart.items,
        CartItemModel(
          id: 2,
          courseId: courseId,
          courseTitle: 'Dart In Depth',
          coursePrice: 80,
          instructorName: 'Mohamed',
          totalPrice: 80,
        ),
      ],
    ));
  }

  @override
  Future<Result<CartModel>> removeItemFromCart(int cartItemId) async {
    return const Success(CartModel(id: 1, userId: 'usr-1', totalPrice: 0, items: []));
  }

  @override
  Future<Result<bool>> clearCart() async {
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartRepository Tests', () {
    late CartRepository repository;
    late FakeCartApiService fakeService;

    setUp(() {
      fakeService = FakeCartApiService();
      repository = CartRepository(service: fakeService);
    });

    test('getCart returns cart model from api service', () async {
      final res = await repository.getCart();
      expect(res is Success<CartModel>, isTrue);
      expect((res as Success<CartModel>).data.items.length, 1);
    });

    test('addItemToCart adds item and returns updated cart', () async {
      final res = await repository.addItemToCart(102);
      expect(res is Success<CartModel>, isTrue);
      expect((res as Success<CartModel>).data.items.length, 2);
    });

    test('removeItemFromCart removes item and clearCart resets cart', () async {
      final removeRes = await repository.removeItemFromCart(1);
      expect(removeRes is Success<CartModel>, isTrue);
      expect((removeRes as Success<CartModel>).data.items, isEmpty);

      final clearRes = await repository.clearCart();
      expect(clearRes is Success<bool>, isTrue);
      expect((clearRes as Success<bool>).data, isTrue);
    });
  });
}
