import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';
import 'package:mobile/features/inbox/data/services/support_api_service.dart';

class SupportRepository {
  final SupportApiService _service;

  SupportRepository({SupportApiService? service})
    : _service = service ?? SupportApiService();

  Future<Result<List<SupportConversationModel>>> getConversations() {
    return _service.getConversations();
  }

  Future<Result<SupportConversationModel>> createConversation({
    required String subject,
    required String message,
  }) {
    return _service.createConversation(subject: subject, message: message);
  }

  Future<Result<List<SupportMessageModel>>> getMessages(int conversationId) {
    return _service.getMessages(conversationId);
  }

  Future<Result<SupportMessageModel>> sendMessage(
    int conversationId,
    String content,
  ) {
    return _service.sendMessage(conversationId, content);
  }

  Future<Result<bool>> closeConversation(int conversationId) {
    return _service.closeConversation(conversationId);
  }

  Future<Result<bool>> reopenConversation(int conversationId) {
    return _service.reopenConversation(conversationId);
  }

  Future<Result<int>> getUnreadCount() {
    return _service.getUnreadCount();
  }
}
