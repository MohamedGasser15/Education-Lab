import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/notification_model.dart';
import 'package:mobile/features/inbox/data/models/notification_summary_model.dart';

class NotificationApiService {
  final ApiClient _client;

  NotificationApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Result<List<NotificationModel>>> getNotifications({
    int? type,
    int? status,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
    if (type != null) queryParams['Type'] = type;
    if (status != null) queryParams['Status'] = status;

    final result = await _client.getSafe(
      ApiConstants.notifications,
      queryParameters: queryParams,
    );

    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is List) {
          final list = data
              .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final list = (data['data'] as List)
              .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        }
        return const Success([]);
      } catch (e) {
        return Failure('فشل تحليل بيانات الإشعارات: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ غير متوقع أثناء جلب الإشعارات');
  }

  Future<Result<NotificationSummaryModel>> getSummary() async {
    final result = await _client.getSafe(ApiConstants.notificationsSummary);
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          return Success(NotificationSummaryModel.fromJson(data));
        }
        return const Failure('بيانات الملخص غير صالحة');
      } catch (e) {
        return Failure('فشل تحليل ملخص الإشعارات: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل جلب ملخص الإشعارات');
  }

  Future<Result<int>> getUnreadCount() async {
    final result = await _client.getSafe(ApiConstants.notificationsUnreadCount);
    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is num) {
          return Success(data.toInt());
        } else if (data is String) {
          return Success(int.tryParse(data) ?? 0);
        } else if (data is Map<String, dynamic>) {
          final count = data['count'] ?? data['unreadCount'] ?? data['data'];
          if (count is num) return Success(count.toInt());
        }
        return const Success(0);
      } catch (e) {
        return Failure('فشل تحليل عدد الإشعارات غير المقروءة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل جلب عدد الإشعارات غير المقروءة');
  }

  Future<Result<bool>> markAllAsRead() async {
    final result = await _client.postSafe(ApiConstants.notificationsMarkAllRead);
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل تحديد الكل كمقروء');
  }

  Future<Result<bool>> markAsRead(int id) async {
    final result = await _client.putSafe(ApiConstants.notificationMarkReadPath(id));
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل تحديد الإشعار كمقروء');
  }

  Future<Result<bool>> deleteNotification(int id) async {
    final result = await _client.deleteSafe(ApiConstants.notificationItemPath(id));
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل حذف الإشعار');
  }

  Future<Result<bool>> deleteAllNotifications() async {
    final result = await _client.deleteSafe(ApiConstants.notificationsDeleteAll);
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل مسح كافة الإشعارات');
  }
}
