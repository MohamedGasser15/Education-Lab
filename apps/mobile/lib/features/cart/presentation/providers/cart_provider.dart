import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider({CartRepository? repository})
    : _repository = repository ?? resolveOr(() => CartRepository());

  CartModel? _cart;
  bool _isLoading = false;
  String? _errorMessage;

  String? _appliedCoupon;
  double _discountPercent = 0.0;

  CartModel? get cart => _cart;
  List<CartItemModel> get items => _cart?.items ?? [];
  int get count => items.length;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get rawTotalPrice => _cart?.totalPrice ?? 0.0;
  double get subtotal => items.fold(
    0.0,
    (sum, item) =>
        sum + (item.coursePrice > 0 ? item.coursePrice : item.totalPrice),
  );
  double get discountAmount =>
      _discountPercent > 0 ? (rawTotalPrice * (_discountPercent / 100)) : 0.0;
  double get finalPrice =>
      (rawTotalPrice - discountAmount).clamp(0.0, double.infinity);

  String? get appliedCoupon => _appliedCoupon;
  double get discountPercent => _discountPercent;

  bool isInCart(int courseId) {
    return items.any((item) => item.courseId == courseId);
  }

  Future<void> fetchCart({bool forceRefresh = false}) async {
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!isLoggedIn) {
      _cart = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    if (_cart == null || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.getCart();
    if (result is Success<CartModel>) {
      _cart = result.data;
      _errorMessage = null;
    } else if (result is Failure<CartModel>) {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToCart(int courseId) async {
    final result = await _repository.addItemToCart(courseId);
    if (result is Success<CartModel>) {
      _cart = result.data;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else if (result is Failure<CartModel>) {
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> removeFromCart(int cartItemId) async {
    final result = await _repository.removeItemFromCart(cartItemId);
    if (result is Success<CartModel>) {
      _cart = result.data;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else if (result is Failure<CartModel>) {
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> clearCart() async {
    final previousCart = _cart;
    final previousCoupon = _appliedCoupon;
    final previousDiscount = _discountPercent;

    // Optimistic update
    _cart = const CartModel(id: 0, userId: '', items: [], totalPrice: 0.0);
    _appliedCoupon = null;
    _discountPercent = 0.0;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.clearCart();
    if (result is Success<bool>) {
      return true;
    } else if (result is Failure<bool>) {
      _cart = previousCart;
      _appliedCoupon = previousCoupon;
      _discountPercent = previousDiscount;
      _errorMessage = result.message;
      notifyListeners();
      return false;
    }
    return false;
  }

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'EDULAB' ||
        cleanCode == 'EDULAB2026' ||
        cleanCode == 'SAVE20') {
      _appliedCoupon = cleanCode;
      _discountPercent = 20.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'SAVE10' || cleanCode == 'WELCOME10') {
      _appliedCoupon = cleanCode;
      _discountPercent = 10.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'SUPER50') {
      _appliedCoupon = cleanCode;
      _discountPercent = 50.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discountPercent = 0.0;
    notifyListeners();
  }

  void reset() {
    _cart = null;
    _appliedCoupon = null;
    _discountPercent = 0.0;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
