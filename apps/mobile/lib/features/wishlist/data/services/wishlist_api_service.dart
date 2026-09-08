import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';

class WishlistApiService {
  final ApiClient _client;

  WishlistApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Result<List<WishlistItemModel>>> getWishlist() async {
    final result = await _client.getSafe(ApiConstants.wishlist);
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is List) {
          final items = data
              .map((item) => WishlistItemModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(items);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final items = (data['data'] as List)
              .map((item) => WishlistItemModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(items);
        }
        return const Success([]);
      } catch (e) {
        return Failure('فشل تحليل بيانات قائمة الرغبات: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ غير متوقع أثناء جلب قائمة الرغبات');
  }

  Future<Result<bool>> addToWishlist(int courseId) async {
    final result = await _client.postSafe(ApiConstants.wishlistItemPath(courseId));
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إضافة الدورة إلى قائمة الرغبات');
  }

  Future<Result<bool>> removeFromWishlist(int courseId) async {
    final result = await _client.deleteSafe(ApiConstants.wishlistItemPath(courseId));
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إزالة الدورة من قائمة الرغبات');
  }

  Future<Result<bool>> isCourseInWishlist(int courseId) async {
    final result = await _client.getSafe(ApiConstants.wishlistCheckPath(courseId));
    if (result is Success<dynamic>) {
      final data = result.data;
      if (data is Map<String, dynamic>) {
        return Success(data['isInWishlist'] as bool? ?? false);
      }
      return const Success(false);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل التحقق من حالة الدورة في قائمة الرغبات');
  }
}
