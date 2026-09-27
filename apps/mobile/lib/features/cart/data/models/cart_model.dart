import 'package:mobile/core/constants/api_constants.dart';

class CartItemModel {
  final int id;
  final int courseId;
  final String courseTitle;
  final double coursePrice;
  final String? thumbnailUrl;
  final String instructorName;
  final double totalPrice;

  const CartItemModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.coursePrice,
    this.thumbnailUrl,
    required this.instructorName,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawThumb =
        json['thumbnailUrl']?.toString() ??
        json['thumbnail']?.toString() ??
        json['courseThumbnailUrl']?.toString();

    final formattedThumb = ApiConstants.formatImageUrl(rawThumb);

    return CartItemModel(
      id: json['id'] as int? ?? 0,
      courseId: json['courseId'] as int? ?? 0,
      courseTitle:
          json['courseTitle']?.toString() ?? json['title']?.toString() ?? '',
      coursePrice:
          (json['coursePrice'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      thumbnailUrl: formattedThumb.isNotEmpty ? formattedThumb : null,
      instructorName:
          json['instructorName']?.toString() ??
          json['instructor']?.toString() ??
          '',
      totalPrice:
          (json['totalPrice'] as num?)?.toDouble() ??
          (json['finalPrice'] as num?)?.toDouble() ??
          (json['coursePrice'] as num?)?.toDouble() ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'coursePrice': coursePrice,
    'thumbnailUrl': thumbnailUrl,
    'instructorName': instructorName,
    'totalPrice': totalPrice,
  };
}

class CartModel {
  final int id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double discountAmount;
  final double totalPrice;
  final String? appliedCouponCode;
  final int? appliedCouponId;

  const CartModel({
    required this.id,
    required this.userId,
    this.items = const [],
    this.subtotal = 0.0,
    this.discountAmount = 0.0,
    required this.totalPrice,
    this.appliedCouponCode,
    this.appliedCouponId,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawSubtotal = (json['subtotal'] as num?)?.toDouble();
    final computedSubtotal = itemsList.fold<double>(
      0.0,
      (sum, item) =>
          sum + (item.coursePrice > 0 ? item.coursePrice : item.totalPrice),
    );
    final subtotal = (rawSubtotal != null && rawSubtotal > 0)
        ? rawSubtotal
        : computedSubtotal;

    final discountAmount = (json['discountAmount'] as num?)?.toDouble() ?? 0.0;
    final rawTotalPrice = (json['totalPrice'] as num?)?.toDouble();
    final totalPrice = rawTotalPrice ??
        (subtotal - discountAmount).clamp(0.0, double.infinity);

    return CartModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId']?.toString() ?? '',
      items: itemsList,
      subtotal: subtotal,
      discountAmount: discountAmount,
      totalPrice: totalPrice,
      appliedCouponCode: json['appliedCouponCode']?.toString(),
      appliedCouponId: json['appliedCouponId'] as int?,
    );
  }

  CartModel copyWith({
    int? id,
    String? userId,
    List<CartItemModel>? items,
    double? subtotal,
    double? discountAmount,
    double? totalPrice,
    String? appliedCouponCode,
    int? appliedCouponId,
    bool clearCoupon = false,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount:
          clearCoupon ? 0.0 : (discountAmount ?? this.discountAmount),
      totalPrice: totalPrice ?? this.totalPrice,
      appliedCouponCode:
          clearCoupon ? null : (appliedCouponCode ?? this.appliedCouponCode),
      appliedCouponId:
          clearCoupon ? null : (appliedCouponId ?? this.appliedCouponId),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'discountAmount': discountAmount,
    'totalPrice': totalPrice,
    'appliedCouponCode': appliedCouponCode,
    'appliedCouponId': appliedCouponId,
  };
}
