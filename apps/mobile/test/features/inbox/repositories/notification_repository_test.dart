import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/data/models/notification_summary_model.dart';
import 'package:mobile/features/inbox/data/repositories/notification_repository.dart';
import 'package:mobile/features/inbox/data/services/notification_api_service.dart';

class FakeNotificationApiService extends NotificationApiService {
  @override
  Future<Result<List<NotificationModel>>> getNotifications({
    int? type,
    int? status,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    return Success([
      NotificationModel(
        id: 1,
        title: 'New Lesson Available',
        message: 'A new lesson has been added to your course.',
        type: 2,
        status: 0,
        createdAt: DateTime(2026, 1, 1),
      ),
    ]);
  }

  @override
  Future<Result<NotificationSummaryModel>> getSummary() async {
    return const Success(
      NotificationSummaryModel(
        unreadCount: 3,
        totalCount: 10,
        systemCount: 2,
        promotionalCount: 1,
      ),
    );
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    return const Success(3);
  }

  @override
  Future<Result<bool>> markAllAsRead() async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> markAsRead(int id) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> deleteNotification(int id) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> deleteAllNotifications() async {
    return const Success(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationRepository Tests', () {
    late NotificationRepository repository;
    late FakeNotificationApiService fakeService;

    setUp(() {
      fakeService = FakeNotificationApiService();
      repository = NotificationRepository(service: fakeService);
    });

    test('getNotifications returns list of notification models', () async {
      final res = await repository.getNotifications();
      expect(res is Success<List<NotificationModel>>, isTrue);
      if (res is Success<List<NotificationModel>>) {
        expect(res.data.length, 1);
        expect(res.data.first.title, 'New Lesson Available');
      }
    });

    test('getSummary and getUnreadCount return counts', () async {
      final summaryRes = await repository.getSummary();
      expect(
        (summaryRes as Success<NotificationSummaryModel>).data.unreadCount,
        3,
      );

      final unreadRes = await repository.getUnreadCount();
      expect((unreadRes as Success<int>).data, 3);
    });

    test(
      'markAllAsRead, markAsRead, and delete methods execute successfully',
      () async {
        expect(
          ((await repository.markAllAsRead()) as Success<bool>).data,
          isTrue,
        );
        expect(
          ((await repository.markAsRead(1)) as Success<bool>).data,
          isTrue,
        );
        expect(
          ((await repository.deleteNotification(1)) as Success<bool>).data,
          isTrue,
        );
        expect(
          ((await repository.deleteAllNotifications()) as Success<bool>).data,
          isTrue,
        );
      },
    );
  });
}
