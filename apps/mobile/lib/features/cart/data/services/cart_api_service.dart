import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';

class CartApiService {
  final ApiClient _client;

  CartApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Result<CartModel>> getCart() async {
    final result = await _client.getSafe(ApiConstants.cart);
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(CartModel.fromJson(data));
        }
        return const Success(CartModel(id: 0, userId: '', items: [], totalPrice: 0.0));
      } catch (e) {
        return Failure('فشل تحليل بيانات السلة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ غير متوقع أثناء جلب السلة');
  }

  Future<Result<CartModel>> addItemToCart(int courseId) async {
    final result = await _client.postSafe(
      ApiConstants.cartItems,
      body: {'courseId': courseId},
    );
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(CartModel.fromJson(data));
        }
        return await getCart();
      } catch (e) {
        return Failure('فشل إضافة الدورة إلى السلة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إضافة الدورة إلى السلة');
  }

  Future<Result<CartModel>> removeItemFromCart(int cartItemId) async {
    final result = await _client.deleteSafe(ApiConstants.cartItemPath(cartItemId));
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(CartModel.fromJson(data));
        }
        return await getCart();
      } catch (e) {
        return Failure('فشل حذف الدورة من السلة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل حذف الدورة من السلة');
  }

  Future<Result<bool>> clearCart() async {
    final result = await _client.deleteSafe(ApiConstants.cartClear);
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل تفريغ السلة');
  }
}
