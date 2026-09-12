import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';

void main() {
  group('CartItemModel', () {
    test('fromJson parses correctly with standard fields', () {
      final json = {
        'id': 101,
        'courseId': 501,
        'courseTitle': 'Flutter Masterclass',
        'coursePrice': 49.99,
        'thumbnailUrl': 'https://example.com/thumb.jpg',
        'instructorName': 'Eng. Mohamed',
        'totalPrice': 49.99,
      };

      final item = CartItemModel.fromJson(json);

      expect(item.id, 101);
      expect(item.courseId, 501);
      expect(item.courseTitle, 'Flutter Masterclass');
      expect(item.coursePrice, 49.99);
      expect(item.thumbnailUrl, contains('thumb.jpg'));
      expect(item.instructorName, 'Eng. Mohamed');
      expect(item.totalPrice, 49.99);
    });

    test('fromJson handles fallback field names and nulls gracefully', () {
      final json = {
        'title': 'Dart Basics',
        'price': 20.0,
        'instructor': 'Ahmed',
        'finalPrice': 15.0,
      };

      final item = CartItemModel.fromJson(json);

      expect(item.id, 0);
      expect(item.courseTitle, 'Dart Basics');
      expect(item.coursePrice, 20.0);
      expect(item.instructorName, 'Ahmed');
      expect(item.totalPrice, 15.0);
      expect(item.thumbnailUrl, isNull);
    });

    test('toJson produces expected map structure', () {
      const item = CartItemModel(
        id: 1,
        courseId: 2,
        courseTitle: 'Testing in Flutter',
        coursePrice: 30.0,
        thumbnailUrl: 'https://example.com/pic.png',
        instructorName: 'Teacher',
        totalPrice: 30.0,
      );

      final json = item.toJson();

      expect(json['id'], 1);
      expect(json['courseId'], 2);
      expect(json['courseTitle'], 'Testing in Flutter');
      expect(json['coursePrice'], 30.0);
      expect(json['thumbnailUrl'], 'https://example.com/pic.png');
      expect(json['instructorName'], 'Teacher');
      expect(json['totalPrice'], 30.0);
    });
  });

  group('CartModel', () {
    test('fromJson parses cart model with list of items', () {
      final json = {
        'id': 10,
        'userId': 'user-123',
        'totalPrice': 100.0,
        'items': [
          {
            'id': 1,
            'courseId': 10,
            'courseTitle': 'Course 1',
            'coursePrice': 40.0,
            'instructorName': 'Inst 1',
            'totalPrice': 40.0,
          },
          {
            'id': 2,
            'courseId': 11,
            'courseTitle': 'Course 2',
            'coursePrice': 60.0,
            'instructorName': 'Inst 2',
            'totalPrice': 60.0,
          },
        ],
      };

      final cart = CartModel.fromJson(json);

      expect(cart.id, 10);
      expect(cart.userId, 'user-123');
      expect(cart.totalPrice, 100.0);
      expect(cart.items.length, 2);
      expect(cart.items.first.courseTitle, 'Course 1');
      expect(cart.items.last.courseTitle, 'Course 2');
    });

    test('toJson serializes cart with all items', () {
      const cart = CartModel(
        id: 5,
        userId: 'user-abc',
        totalPrice: 50.0,
        items: [
          CartItemModel(
            id: 1,
            courseId: 100,
            courseTitle: 'Architecture',
            coursePrice: 50.0,
            instructorName: 'Inst',
            totalPrice: 50.0,
          ),
        ],
      );

      final json = cart.toJson();

      expect(json['id'], 5);
      expect(json['userId'], 'user-abc');
      expect(json['totalPrice'], 50.0);
      expect(json['items'], isA<List>());
      expect((json['items'] as List).length, 1);
    });
  });
}
