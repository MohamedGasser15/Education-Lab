import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:mobile/features/wishlist/data/repositories/wishlist_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistProvider({WishlistRepository? repository})
    : _repository = repository ?? resolveOr(() => WishlistRepository());

  List<WishlistItemModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WishlistItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool isInWishlist(int courseId) {
    return _items.any((item) => item.courseId == courseId);
  }

  Future<void> fetchWishlist({bool forceRefresh = false}) async {
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!isLoggedIn) {
      _items = [];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    if (_items.isEmpty || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.getWishlist();
    if (result is Success<List<WishlistItemModel>>) {
      _items = result.data;
      _errorMessage = null;
    } else if (result is Failure<List<WishlistItemModel>>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToWishlist(int courseId) async {
    final result = await _repository.addToWishlist(courseId);
    if (result is Success<bool>) {
      await fetchWishlist(forceRefresh: true);
      return true;
    }
    return false;
  }

  Future<bool> removeFromWishlist(int courseId) async {
    // Optimistic removal
    final index = _items.indexWhere((item) => item.courseId == courseId);
    WishlistItemModel? removedItem;
    if (index != -1) {
      removedItem = _items[index];
      _items.removeAt(index);
      notifyListeners();
    }

    final result = await _repository.removeFromWishlist(courseId);
    if (result is Success<bool>) {
      return true;
    } else {
      // Revert if failed
      if (removedItem != null) {
        _items.insert(index, removedItem);
        notifyListeners();
      }
      return false;
    }
  }

  Future<bool> toggleWishlist(int courseId) async {
    if (isInWishlist(courseId)) {
      return await removeFromWishlist(courseId);
    } else {
      return await addToWishlist(courseId);
    }
  }

  Future<bool> clearWishlist() async {
    if (_items.isEmpty) return true;
    final previousItems = List<WishlistItemModel>.from(_items);
    _items.clear();
    notifyListeners();

    try {
      final results = await Future.wait(
        previousItems.map(
          (item) => _repository.removeFromWishlist(item.courseId),
        ),
      );
      final anyFailed = results.any((res) => res is! Success<bool>);
      if (anyFailed) {
        await fetchWishlist(forceRefresh: true);
        return false;
      }
      return true;
    } catch (_) {
      _items = previousItems;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _items = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
