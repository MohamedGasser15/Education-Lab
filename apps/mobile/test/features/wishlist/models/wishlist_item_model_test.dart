import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/courses/data/models/course_details_model.dart';
import 'package:mobile/features/wishlist/data/models/wishlist_item_model.dart';

void main() {
  group('WishlistItemModel Discount & Price Parsing Tests', () {
    test('Standard percentage discount (e.g. 20%) calculates finalPrice and discountPercentage', () {
      final json = {
        'id': 1,
        'courseId': 100,
        'courseTitle': 'Flutter Mastery',
        'coursePrice': 100.0,
        'courseDiscount': 20.0,
        'finalPrice': 80.0,
        'instructorName': 'Ahmed Ali',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.coursePrice, 100.0);
      expect(item.finalPrice, 80.0);
      expect(item.hasDiscount, isTrue);
      expect(item.discountPercentage, 20);
    });

    test('Stored discounted price (e.g. Price 199.99, Discount 149.99) corrects final price and calculates discount percent', () {
      // In DbInitializer and backend, some courses had Discount = 149.99 for Price = 199.99
      final json = {
        'id': 2,
        'courseId': 101,
        'courseTitle': 'C# from Zero to Hero',
        'coursePrice': 199.99,
        'courseDiscount': 149.99,
        'finalPrice': 0.0, // previously buggy backend returned 0.0
        'instructorName': 'Sara Mohamed',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.coursePrice, 199.99);
      expect(item.finalPrice, 149.99);
      expect(item.hasDiscount, isTrue);
      // ((199.99 - 149.99) / 199.99) * 100 = 25%
      expect(item.discountPercentage, 25);
    });

    test('Course with no discount has hasDiscount = false and discountPercentage = 0', () {
      final json = {
        'id': 3,
        'courseId': 102,
        'courseTitle': 'Clean Architecture',
        'coursePrice': 50.0,
        'courseDiscount': null,
        'finalPrice': 50.0,
        'instructorName': 'John Doe',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.coursePrice, 50.0);
      expect(item.finalPrice, 50.0);
      expect(item.hasDiscount, isFalse);
      expect(item.discountPercentage, 0);
    });

    test('Course with 0% discount has hasDiscount = false', () {
      final json = {
        'id': 4,
        'courseId': 103,
        'courseTitle': 'Free or Full Price',
        'coursePrice': 75.0,
        'courseDiscount': 0.0,
        'finalPrice': 75.0,
        'instructorName': 'Jane Doe',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.hasDiscount, isFalse);
      expect(item.discountPercentage, 0);
    });

    test('Swapped prices: if calcFinal is greater than price, price is normalized to higher', () {
      final json = {
        'id': 5,
        'courseId': 104,
        'courseTitle': 'Inverted API response',
        'coursePrice': 80.0,
        'courseDiscount': 20.0,
        'finalPrice': 100.0,
        'instructorName': 'Tester',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.coursePrice, 100.0);
      expect(item.finalPrice, 80.0);
      expect(item.hasDiscount, isTrue);
      expect(item.discountPercentage, 20);
    });

    test('PascalCase keys and string numbers are parsed accurately', () {
      final json = {
        'Id': 6,
        'CourseId': 105,
        'CourseTitle': 'Dart & Flutter Pro',
        'CoursePrice': '250.00',
        'CourseDiscount': '20',
        'FinalPrice': '200.00',
        'InstructorName': 'Karim Omar',
      };

      final item = WishlistItemModel.fromJson(json);

      expect(item.id, 6);
      expect(item.courseId, 105);
      expect(item.courseTitle, 'Dart & Flutter Pro');
      expect(item.coursePrice, 250.0);
      expect(item.finalPrice, 200.0);
      expect(item.hasDiscount, isTrue);
      expect(item.discountPercentage, 20);
    });

    test('WishlistItemModel and CourseDetailsModel have identical prices and discount percent for same course', () {
      const courseId = 200;
      const basePrice = 300.0;
      const discount = 20.0; // 20%

      final wishlistJson = {
        'id': 1,
        'courseId': courseId,
        'courseTitle': 'Full-stack course',
        'coursePrice': basePrice,
        'courseDiscount': discount,
        'finalPrice': 240.0,
      };

      final detailsJson = {
        'id': courseId,
        'title': 'Full-stack course',
        'price': basePrice,
        'discount': discount,
      };

      final wishlistItem = WishlistItemModel.fromJson(wishlistJson);
      final courseDetails = CourseDetailsModel.fromJson(detailsJson);

      expect(wishlistItem.coursePrice, courseDetails.price);
      expect(wishlistItem.finalPrice, courseDetails.finalPrice);
      expect(wishlistItem.hasDiscount, courseDetails.hasDiscount);
      expect(wishlistItem.discountPercentage, courseDetails.discountPercent);
      expect(wishlistItem.finalPrice, 240.0);
      expect(wishlistItem.discountPercentage, 20);
    });
  });
}
