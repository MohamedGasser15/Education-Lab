import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';

class SupportApiService {
  final ApiClient _client;

  SupportApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Result<List<SupportConversationModel>>> getConversations() async {
    final result = await _client.getSafe(ApiConstants.supportConversations);

    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is List) {
          final list = data
              .map((item) => SupportConversationModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final list = (data['data'] as List)
              .map((item) => SupportConversationModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        }
        return const Success([]);
      } catch (e) {
        return Failure('فشل تحليل قائمة المحادثات: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('حدث خطأ غير متوقع أثناء جلب المحادثات');
  }

  Future<Result<SupportConversationModel>> createConversation({
    required String subject,
    required String message,
  }) async {
    final result = await _client.postSafe(
      ApiConstants.supportConversations,
      body: {
        'subject': subject,
        'message': message,
      },
    );

    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          final convData = data['conversation'] is Map<String, dynamic>
              ? data['conversation'] as Map<String, dynamic>
              : data;
          return Success(SupportConversationModel.fromJson(convData));
        }
        return const Failure('بيانات المحادثة المنشأة غير صالحة');
      } catch (e) {
        return Failure('فشل تحليل المحادثة المنشأة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إنشاء المحادثة');
  }

  Future<Result<List<SupportMessageModel>>> getMessages(int conversationId) async {
    final result = await _client.getSafe(
      ApiConstants.supportConversationMessagesPath(conversationId),
    );

    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is List) {
          final list = data
              .map((item) => SupportMessageModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final list = (data['data'] as List)
              .map((item) => SupportMessageModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Success(list);
        }
        return const Success([]);
      } catch (e) {
        return Failure('فشل تحليل رسائل الدعم: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل جلب رسائل المحادثة');
  }

  Future<Result<SupportMessageModel>> sendMessage(int conversationId, String content) async {
    final result = await _client.postSafe(
      ApiConstants.supportConversationMessagesPath(conversationId),
      body: {'content': content},
    );

    if (result is Success<dynamic>) {
      try {
        final data = result.data;
        if (data is Map<String, dynamic>) {
          final msgData = data['message'] is Map<String, dynamic>
              ? data['message'] as Map<String, dynamic>
              : data;
          return Success(SupportMessageModel.fromJson(msgData));
        }
        return const Failure('بيانات الرسالة غير صالحة');
      } catch (e) {
        return Failure('فشل تحليل الرسالة المرسلة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إرسال الرسالة');
  }

  Future<Result<bool>> closeConversation(int conversationId) async {
    final result = await _client.postSafe(
      ApiConstants.supportConversationClosePath(conversationId),
    );
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إغلاق المحادثة');
  }

  Future<Result<bool>> reopenConversation(int conversationId) async {
    final result = await _client.postSafe(
      ApiConstants.supportConversationReopenPath(conversationId),
    );
    if (result is Success<dynamic>) {
      return const Success(true);
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل إعادة فتح المحادثة');
  }

  Future<Result<int>> getUnreadCount() async {
    final result = await _client.getSafe(ApiConstants.supportUnreadCount);
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
        return Failure('فشل تحليل عدد الرسائل غير المقروءة: $e');
      }
    } else if (result is Failure<dynamic>) {
      return Failure(result.message);
    }
    return const Failure('فشل جلب عدد الرسائل غير المقروءة');
  }
}
