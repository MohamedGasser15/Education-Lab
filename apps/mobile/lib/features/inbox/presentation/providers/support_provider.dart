import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';
import 'package:mobile/features/inbox/data/repositories/support_repository.dart';
import 'package:mobile/features/inbox/data/services/support_hub_service.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository;
  final SupportHubService _hubService;

  StreamSubscription<SupportMessageModel>? _messageSub;
  StreamSubscription<int>? _unreadCountSub;
  StreamSubscription<void>? _convChangedSub;

  List<SupportConversationModel> _conversations = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Active chat state
  SupportConversationModel? _activeConversation;
  List<SupportMessageModel> _activeMessages = [];
  bool _isMessagesLoading = false;
  bool _isSending = false;
  bool _isTogglingStatus = false;

  SupportProvider({
    SupportRepository? repository,
    SupportHubService? hubService,
  }) : _repository = repository ?? resolveOr(() => SupportRepository()),
       _hubService = hubService ?? SupportHubService() {
    _initHub();
  }

  List<SupportConversationModel> get conversations => _conversations;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SupportConversationModel? get activeConversation => _activeConversation;
  List<SupportMessageModel> get activeMessages => _activeMessages;
  bool get isMessagesLoading => _isMessagesLoading;
  bool get isSending => _isSending;
  bool get isTogglingStatus => _isTogglingStatus;

  Future<void> _initHub() async {
    final isLoggedIn = await AuthStorageService.isLoggedIn();
    if (!isLoggedIn) return;

    await _hubService.connect();

    _messageSub?.cancel();
    _messageSub = _hubService.onReceiveMessage.listen(_handleIncomingMessage);

    _unreadCountSub?.cancel();
    _unreadCountSub = _hubService.onUnreadCountChanged.listen((count) {
      _unreadCount = count;
      notifyListeners();
    });

    _convChangedSub?.cancel();
    _convChangedSub = _hubService.onConversationsChanged.listen((_) {
      fetchConversations(silent: true);
    });
  }

  void _handleIncomingMessage(SupportMessageModel message) {
    // 1. If we are currently inside this conversation, append the message
    if (_activeConversation != null &&
        _activeConversation!.id == message.conversationId) {
      final exists = _activeMessages.any((m) => m.id == message.id);
      if (!exists) {
        _activeMessages = [..._activeMessages, message];
      }
    }

    // 2. Update the conversation in the conversations list (Last Message & Time & Unread)
    final index = _conversations.indexWhere(
      (c) => c.id == message.conversationId,
    );
    if (index != -1) {
      final old = _conversations[index];
      final isCurrentlyOpen = _activeConversation?.id == message.conversationId;
      final updated = old.copyWith(
        lastMessage: message.content,
        lastMessageAt: message.createdAt,
        unreadCount: isCurrentlyOpen
            ? 0
            : (!message.isUser ? old.unreadCount + 1 : old.unreadCount),
      );

      // Move the active conversation with the newest message to the top
      _conversations.removeAt(index);
      _conversations.insert(0, updated);

      if (_activeConversation?.id == message.conversationId) {
        _activeConversation = updated;
      }
    } else {
      // New conversation we don't have yet in cache
      fetchConversations(silent: true);
    }

    notifyListeners();
  }

  Future<void> fetchConversations({
    bool forceRefresh = false,
    bool silent = false,
  }) async {
    if (!silent && (_conversations.isEmpty || forceRefresh)) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    // Ensure SignalR connection is live
    _initHub();

    final results = await Future.wait([
      _repository.getConversations(),
      _repository.getUnreadCount(),
    ]);

    final convResult = results[0] as Result<List<SupportConversationModel>>;
    final countResult = results[1] as Result<int>;

    if (convResult is Success<List<SupportConversationModel>>) {
      _conversations = convResult.data;
      _errorMessage = null;

      // Join live rooms for each conversation to receive real-time last-message updates
      for (final conv in _conversations) {
        _hubService.joinConversation(conv.id);
      }

      // If there is an active conversation, update its reference
      if (_activeConversation != null) {
        final current = _conversations
            .where((c) => c.id == _activeConversation!.id)
            .firstOrNull;
        if (current != null) {
          _activeConversation = current;
        }
      }
    } else if (convResult is Failure<List<SupportConversationModel>>) {
      _errorMessage = convResult.message;
    }

    if (countResult is Success<int>) {
      _unreadCount = countResult.data;
    } else {
      _unreadCount = _conversations.fold(0, (sum, c) => sum + c.unreadCount);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> openConversation(SupportConversationModel conversation) async {
    _activeConversation = conversation;
    _activeMessages = [];
    _isMessagesLoading = true;
    notifyListeners();

    // Mark as read in local list immediately
    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
      _unreadCount = _conversations.fold(0, (sum, c) => sum + c.unreadCount);
    }

    // Join room on Hub
    await _hubService.joinConversation(conversation.id);

    // Fetch messages from API
    final result = await _repository.getMessages(conversation.id);
    if (result is Success<List<SupportMessageModel>>) {
      _activeMessages = result.data;
    }

    _isMessagesLoading = false;
    notifyListeners();
  }

  void closeActiveConversation() {
    _activeConversation = null;
    _activeMessages = [];
    _isMessagesLoading = false;
    notifyListeners();
  }

  Future<bool> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty ||
        _activeConversation == null ||
        !_activeConversation!.isOpen) {
      return false;
    }

    _isSending = true;
    notifyListeners();

    final convId = _activeConversation!.id;
    final result = await _repository.sendMessage(convId, text);

    if (result is Success<SupportMessageModel>) {
      final newMsg = result.data;
      final exists = _activeMessages.any((m) => m.id == newMsg.id);
      if (!exists) {
        _activeMessages = [..._activeMessages, newMsg];
      }

      // Update last message immediately
      final index = _conversations.indexWhere((c) => c.id == convId);
      if (index != -1) {
        final updated = _conversations[index].copyWith(
          lastMessage: newMsg.content,
          lastMessageAt: newMsg.createdAt,
        );
        _conversations.removeAt(index);
        _conversations.insert(0, updated);
        _activeConversation = updated;
      }

      _isSending = false;
      notifyListeners();
      return true;
    } else if (result is Failure<SupportMessageModel>) {
      _isSending = false;
      notifyListeners();
      return false;
    }

    _isSending = false;
    notifyListeners();
    return false;
  }

  Future<bool> toggleConversationStatus() async {
    if (_activeConversation == null || _isTogglingStatus) return false;

    _isTogglingStatus = true;
    notifyListeners();

    final convId = _activeConversation!.id;
    final isCurrentlyOpen = _activeConversation!.isOpen;

    final result = isCurrentlyOpen
        ? await _repository.closeConversation(convId)
        : await _repository.reopenConversation(convId);

    if (result is Success<bool> && result.data) {
      final newStatus = isCurrentlyOpen ? 'Closed' : 'Open';
      _activeConversation = _activeConversation!.copyWith(status: newStatus);

      final index = _conversations.indexWhere((c) => c.id == convId);
      if (index != -1) {
        _conversations[index] = _conversations[index].copyWith(
          status: newStatus,
        );
      }

      _isTogglingStatus = false;
      notifyListeners();
      return true;
    }

    _isTogglingStatus = false;
    notifyListeners();
    return false;
  }

  Future<SupportConversationModel?> createConversation({
    required String subject,
    required String message,
  }) async {
    final sub = subject.trim();
    final msg = message.trim();
    if (msg.isEmpty) return null;

    final result = await _repository.createConversation(
      subject: sub.isEmpty ? 'General support' : sub,
      message: msg,
    );

    if (result is Success<SupportConversationModel>) {
      final created = result.data.copyWith(
        lastMessage: msg,
        lastMessageAt: DateTime.now(),
      );

      _conversations.insert(0, created);
      await _hubService.joinConversation(created.id);

      notifyListeners();
      return created;
    }

    return null;
  }

  Future<void> reset() async {
    _messageSub?.cancel();
    _unreadCountSub?.cancel();
    _convChangedSub?.cancel();
    await _hubService.disconnect();
    _conversations = [];
    _unreadCount = 0;
    _isLoading = false;
    _errorMessage = null;
    _activeConversation = null;
    _activeMessages = [];
    _isMessagesLoading = false;
    _isSending = false;
    _isTogglingStatus = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageSub?.cancel();
    _unreadCountSub?.cancel();
    _convChangedSub?.cancel();
    super.dispose();
  }
}
