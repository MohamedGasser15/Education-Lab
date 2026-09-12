import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/data/services/wishlist_api_service.dart';

class WishlistRepository {
  final WishlistApiService _service;

  WishlistRepository({WishlistApiService? service})
    : _service = service ?? WishlistApiService();

  Future<Result<List<WishlistItemModel>>> getWishlist() {
    return _service.getWishlist();
  }

  Future<Result<bool>> addToWishlist(int courseId) {
    return _service.addToWishlist(courseId);
  }

  Future<Result<bool>> removeFromWishlist(int courseId) {
    return _service.removeFromWishlist(courseId);
  }

  Future<Result<bool>> isCourseInWishlist(int courseId) {
    return _service.isCourseInWishlist(courseId);
  }
}
