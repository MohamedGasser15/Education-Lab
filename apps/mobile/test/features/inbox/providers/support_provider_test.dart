import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';
import 'package:mobile/features/inbox/data/repositories/support_repository.dart';
import 'package:mobile/features/inbox/data/services/support_hub_service.dart';
import 'package:mobile/features/inbox/presentation/providers/support_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';

class FakeSupportRepository extends SupportRepository {
  List<SupportConversationModel> conversations = [
    SupportConversationModel(
      id: 1,
      subject: 'Billing inquiry',
      status: 'Open',
      unreadCount: 2,
      lastMessage: 'How can I help you?',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  @override
  Future<Result<List<SupportConversationModel>>> getConversations() async {
    return Success(conversations);
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    return const Success(2);
  }

  @override
  Future<Result<List<SupportMessageModel>>> getMessages(int conversationId) async {
    return Success([
      SupportMessageModel(
        id: 10,
        conversationId: conversationId,
        senderId: 'usr-1',
        senderRole: 'User',
        content: 'Initial question',
        createdAt: DateTime(2026, 1, 1),
      ),
      SupportMessageModel(
        id: 11,
        conversationId: conversationId,
        senderId: 'admin-1',
        senderRole: 'Admin',
        content: 'How can I help you?',
        createdAt: DateTime(2026, 1, 1),
      ),
    ]);
  }

  @override
  Future<Result<SupportMessageModel>> sendMessage(int conversationId, String content) async {
    return Success(SupportMessageModel(
      id: 12,
      conversationId: conversationId,
      senderId: 'usr-1',
      senderRole: 'User',
      content: content,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<bool>> closeConversation(int conversationId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> reopenConversation(int conversationId) async {
    return const Success(true);
  }
}

class FakeSupportHubService implements SupportHubService {
  final _msgController = StreamController<SupportMessageModel>.broadcast();
  final _unreadController = StreamController<int>.broadcast();
  final _convController = StreamController<void>.broadcast();
  final _stateController = StreamController<HubConnectionState>.broadcast();

  @override
  Stream<SupportMessageModel> get onReceiveMessage => _msgController.stream;
  @override
  Stream<int> get onUnreadCountChanged => _unreadController.stream;
  @override
  Stream<void> get onConversationsChanged => _convController.stream;
  @override
  Stream<HubConnectionState> get onConnectionStateChanged => _stateController.stream;

  @override
  bool get isConnected => true;

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> joinConversation(int conversationId) async {}

  @override
  Future<void> leaveConversation(int conversationId) async {}

  @override
  void dispose() {
    _msgController.close();
    _unreadController.close();
    _convController.close();
    _stateController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SupportProvider Tests', () {
    late SupportProvider provider;
    late FakeSupportRepository fakeRepo;
    late FakeSupportHubService fakeHub;

    setUp(() {
      SharedPreferences.setMockInitialValues({'is_logged_in': true});
      fakeRepo = FakeSupportRepository();
      fakeHub = FakeSupportHubService();
      provider = SupportProvider(repository: fakeRepo, hubService: fakeHub);
    });

    tearDown(() {
      fakeHub.dispose();
    });

    test('fetchConversations populates conversations and unread count', () async {
      await provider.fetchConversations();

      expect(provider.conversations.length, 1);
      expect(provider.conversations.first.subject, 'Billing inquiry');
      expect(provider.unreadCount, 2);
      expect(provider.isLoading, isFalse);
    });

    test('openConversation loads active messages for conversation', () async {
      final conv = SupportConversationModel(
        id: 1,
        subject: 'Billing inquiry',
        status: 'Open',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      await provider.openConversation(conv);

      expect(provider.activeConversation?.id, 1);
      expect(provider.activeMessages.length, 2);
      expect(provider.activeMessages.first.content, 'Initial question');
      expect(provider.isMessagesLoading, isFalse);
    });

    test('sendMessage appends new message to active messages', () async {
      final conv = SupportConversationModel(
        id: 1,
        subject: 'Billing inquiry',
        status: 'Open',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      await provider.openConversation(conv);

      final success = await provider.sendMessage('Thank you!');
      expect(success, isTrue);
      expect(provider.activeMessages.length, 3);
      expect(provider.activeMessages.last.content, 'Thank you!');
    });
  });
}
