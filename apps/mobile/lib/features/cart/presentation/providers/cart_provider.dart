import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/models/coupon_model.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider({CartRepository? repository})
    : _repository = repository ?? resolveOr(() => CartRepository());

  CartModel? _cart;
  bool _isLoading = false;
  bool _isApplyingCoupon = false;
  String? _errorMessage;

  String? _appliedCoupon;
  double _discountPercent = 0.0;

  CartModel? get cart => _cart;
  List<CartItemModel> get items => _cart?.items ?? [];
  int get count => items.length;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get isApplyingCoupon => _isApplyingCoupon;
  String? get errorMessage => _errorMessage;

  double get rawTotalPrice => _cart?.totalPrice ?? 0.0;
  double get subtotal {
    if (_cart != null && _cart!.subtotal > 0) return _cart!.subtotal;
    return items.fold(
      0.0,
      (sum, item) =>
          sum + (item.coursePrice > 0 ? item.coursePrice : item.totalPrice),
    );
  }

  double get discountAmount {
    if (_cart != null && _cart!.discountAmount > 0) {
      return _cart!.discountAmount;
    }
    return _discountPercent > 0 ? (subtotal * (_discountPercent / 100)) : 0.0;
  }

  double get finalPrice {
    if (_cart != null) return _cart!.totalPrice;
    return (subtotal - discountAmount).clamp(0.0, double.infinity);
  }

  String? get appliedCoupon => _cart?.appliedCouponCode ?? _appliedCoupon;
  double get discountPercent {
    if (subtotal > 0 && discountAmount > 0) {
      return (discountAmount / subtotal) * 100;
    }
    return _discountPercent;
  }

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
      if (_cart?.appliedCouponCode != null) {
        _appliedCoupon = _cart!.appliedCouponCode;
      } else {
        _appliedCoupon = null;
      }
      if (subtotal > 0 && discountAmount > 0) {
        _discountPercent = (discountAmount / subtotal) * 100;
      } else {
        _discountPercent = 0.0;
      }
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
      if (_cart?.appliedCouponCode != null) {
        _appliedCoupon = _cart!.appliedCouponCode;
      }
      if (subtotal > 0 && discountAmount > 0) {
        _discountPercent = (discountAmount / subtotal) * 100;
      }
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
      if (_cart?.appliedCouponCode != null) {
        _appliedCoupon = _cart!.appliedCouponCode;
      } else {
        _appliedCoupon = null;
      }
      if (subtotal > 0 && discountAmount > 0) {
        _discountPercent = (discountAmount / subtotal) * 100;
      } else {
        _discountPercent = 0.0;
      }
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

  Future<({bool success, String message})> applyCoupon(String code) async {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return (success: false, message: 'يرجى إدخال رمز الخصم');
    }

    _isApplyingCoupon = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.applyCoupon(cleanCode);
      _isApplyingCoupon = false;

      if (result is Success<CouponApplyResultModel>) {
        final data = result.data;
        if (data.success) {
          _appliedCoupon = data.code ?? cleanCode;
          if (_cart != null) {
            _cart = _cart!.copyWith(
              subtotal: data.subtotal > 0 ? data.subtotal : _cart!.subtotal,
              discountAmount: data.discountAmount,
              totalPrice: data.newTotal,
              appliedCouponCode: _appliedCoupon,
            );
          } else {
            _cart = CartModel(
              id: 0,
              userId: '',
              subtotal: data.subtotal,
              discountAmount: data.discountAmount,
              totalPrice: data.newTotal,
              appliedCouponCode: _appliedCoupon,
            );
          }
          if (data.subtotal > 0 && data.discountAmount > 0) {
            _discountPercent = (data.discountAmount / data.subtotal) * 100;
          } else if (subtotal > 0 && discountAmount > 0) {
            _discountPercent = (discountAmount / subtotal) * 100;
          }
          notifyListeners();

          // Background sync to ensure full consistency with API
          _repository.getCart().then((cartRes) {
            if (cartRes is Success<CartModel>) {
              _cart = cartRes.data;
              if (_cart?.appliedCouponCode != null) {
                _appliedCoupon = _cart!.appliedCouponCode;
              }
              notifyListeners();
            }
          });

          return (success: true, message: data.message);
        } else {
          notifyListeners();
          return (success: false, message: data.message);
        }
      } else if (result is Failure<CouponApplyResultModel>) {
        notifyListeners();
        return (success: false, message: result.message);
      }

      notifyListeners();
      return (success: false, message: 'فشل تطبيق رمز الخصم');
    } catch (e) {
      _isApplyingCoupon = false;
      notifyListeners();
      return (
        success: false,
        message: 'حدث خطأ غير متوقع أثناء تطبيق الرمز الترويجي',
      );
    }
  }

  Future<bool> removeCoupon() async {
    _isApplyingCoupon = true;
    notifyListeners();

    try {
      final result = await _repository.removeCoupon();
      _isApplyingCoupon = false;

      if (result is Success<bool> && result.data) {
        _appliedCoupon = null;
        _discountPercent = 0.0;
        if (_cart != null) {
          _cart = _cart!.copyWith(
            clearCoupon: true,
            totalPrice: _cart!.subtotal,
          );
        }
        notifyListeners();

        // Background sync with API
        _repository.getCart().then((cartRes) {
          if (cartRes is Success<CartModel>) {
            _cart = cartRes.data;
            _appliedCoupon = _cart?.appliedCouponCode;
            notifyListeners();
          }
        });
        return true;
      }
    } catch (_) {}

    _isApplyingCoupon = false;
    notifyListeners();
    return false;
  }

  void reset() {
    _cart = null;
    _appliedCoupon = null;
    _discountPercent = 0.0;
    _isLoading = false;
    _isApplyingCoupon = false;
    _errorMessage = null;
    notifyListeners();
  }
}
