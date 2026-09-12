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
  final double totalPrice;

  const CartModel({
    required this.id,
    required this.userId,
    this.items = const [],
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return CartModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId']?.toString() ?? '',
      items: itemsList,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((e) => e.toJson()).toList(),
    'totalPrice': totalPrice,
  };
}
