import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/presentation/providers/notification_provider.dart';

void main() {
  group('NotificationProvider Filtering and State', () {
    late NotificationProvider provider;

    setUp(() {
      provider = NotificationProvider();
    });

    test('initial state is correct', () {
      expect(provider.notifications, isEmpty);
      expect(provider.unreadCount, 0);
      expect(provider.selectedFilterIndex, 0);
      expect(provider.isLoading, isFalse);
    });

    test('setFilterIndex changes current filter category', () {
      provider.setFilterIndex(1);
      expect(provider.selectedFilterIndex, 1);

      provider.setFilterIndex(2);
      expect(provider.selectedFilterIndex, 2);
    });

    test('reset clears notifications and restores filter to 0', () {
      provider.setFilterIndex(3);
      provider.reset();

      expect(provider.notifications, isEmpty);
      expect(provider.unreadCount, 0);
      expect(provider.selectedFilterIndex, 0);
      expect(provider.isLoading, isFalse);
    });
  });

  group('NotificationModel Data Parsing', () {
    test('fromJson parses standard fields and isRead getter accurately', () {
      final json = {
        'id': 1,
        'title': 'New Course Published',
        'message': 'Check out the new Flutter 3.0 course!',
        'type': 2,
        'status': 0, // Unread
        'createdAt': '2026-09-12T10:00:00.000Z',
      };

      final notif = NotificationModel.fromJson(json);

      expect(notif.id, 1);
      expect(notif.title, 'New Course Published');
      expect(notif.isRead, isFalse);
      expect(notif.type, 2);
    });

    test('isRead returns true when status == 1 or readAt is populated', () {
      final jsonRead = {
        'id': 2,
        'title': 'Welcome discount',
        'message': 'Get 20% off',
        'type': 1,
        'status': 1,
        'readAt': '2026-09-12T11:00:00.000Z',
      };

      final notif = NotificationModel.fromJson(jsonRead);

      expect(notif.isRead, isTrue);
    });
  });
}
