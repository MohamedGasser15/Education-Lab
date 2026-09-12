import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/services/cart_api_service.dart';

class CartRepository {
  final CartApiService _service;

  CartRepository({CartApiService? service})
    : _service = service ?? CartApiService();

  Future<Result<CartModel>> getCart() {
    return _service.getCart();
  }

  Future<Result<CartModel>> addItemToCart(int courseId) {
    return _service.addItemToCart(courseId);
  }

  Future<Result<CartModel>> removeItemFromCart(int cartItemId) {
    return _service.removeItemFromCart(cartItemId);
  }

  Future<Result<bool>> clearCart() {
    return _service.clearCart();
  }
}
