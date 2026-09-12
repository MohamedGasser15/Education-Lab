import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/data/models/notification_summary_model.dart';
import 'package:mobile/features/inbox/data/services/notification_api_service.dart';

class NotificationRepository {
  final NotificationApiService _service;

  NotificationRepository({NotificationApiService? service})
    : _service = service ?? NotificationApiService();

  Future<Result<List<NotificationModel>>> getNotifications({
    int? type,
    int? status,
    int pageNumber = 1,
    int pageSize = 50,
  }) {
    return _service.getNotifications(
      type: type,
      status: status,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<Result<NotificationSummaryModel>> getSummary() {
    return _service.getSummary();
  }

  Future<Result<int>> getUnreadCount() {
    return _service.getUnreadCount();
  }

  Future<Result<bool>> markAllAsRead() {
    return _service.markAllAsRead();
  }

  Future<Result<bool>> markAsRead(int id) {
    return _service.markAsRead(id);
  }

  Future<Result<bool>> deleteNotification(int id) {
    return _service.deleteNotification(id);
  }

  Future<Result<bool>> deleteAllNotifications() {
    return _service.deleteAllNotifications();
  }
}
