import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';

class SupportHubService {
  static final SupportHubService _instance = SupportHubService._internal();
  factory SupportHubService() => _instance;
  SupportHubService._internal();

  HubConnection? _hubConnection;
  bool _isConnecting = false;

  final StreamController<SupportMessageModel> _messageController =
      StreamController<SupportMessageModel>.broadcast();
  final StreamController<int> _unreadCountController =
      StreamController<int>.broadcast();
  final StreamController<void> _conversationsChangedController =
      StreamController<void>.broadcast();
  final StreamController<HubConnectionState> _connectionStateController =
      StreamController<HubConnectionState>.broadcast();

  Stream<SupportMessageModel> get onReceiveMessage => _messageController.stream;
  Stream<int> get onUnreadCountChanged => _unreadCountController.stream;
  Stream<void> get onConversationsChanged => _conversationsChangedController.stream;
  Stream<HubConnectionState> get onConnectionStateChanged =>
      _connectionStateController.stream;

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  Future<void> connect() async {
    if (isConnected || _isConnecting) return;

    final token = await AuthStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[SupportHub] Cannot connect: No access token');
      return;
    }

    _isConnecting = true;

    try {
      if (_hubConnection != null) {
        await _hubConnection!.stop();
      }

      final hubUrl = ApiConstants.supportHubUrl;

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _hubConnection!.onclose(({error}) {
        debugPrint('[SupportHub] Connection closed. Error: $error');
        _connectionStateController.add(HubConnectionState.Disconnected);
      });

      _hubConnection!.onreconnecting(({error}) {
        debugPrint('[SupportHub] Reconnecting... Error: $error');
        _connectionStateController.add(HubConnectionState.Reconnecting);
      });

      _hubConnection!.onreconnected(({connectionId}) {
        debugPrint('[SupportHub] Reconnected! ConnectionId: $connectionId');
        _connectionStateController.add(HubConnectionState.Connected);
        _conversationsChangedController.add(null);
      });

      _hubConnection!.on('ReceiveMessage', (arguments) {
        if (arguments != null && arguments.isNotEmpty && arguments[0] != null) {
          try {
            final raw = arguments[0];
            final map = raw is Map<String, dynamic>
                ? raw
                : Map<String, dynamic>.from(raw as Map);
            final message = SupportMessageModel.fromJson(map);
            debugPrint('[SupportHub] Received message for conv ${message.conversationId}: ${message.content}');
            _messageController.add(message);
          } catch (e) {
            debugPrint('[SupportHub] Error parsing ReceiveMessage: $e');
          }
        }
      });

      _hubConnection!.on('UnreadCountChanged', (arguments) {
        if (arguments != null && arguments.isNotEmpty && arguments[0] != null) {
          final count = int.tryParse(arguments[0].toString()) ?? 0;
          debugPrint('[SupportHub] UnreadCountChanged: $count');
          _unreadCountController.add(count);
        }
      });

      _hubConnection!.on('ConversationsChanged', (arguments) {
        debugPrint('[SupportHub] ConversationsChanged received');
        _conversationsChangedController.add(null);
      });

      await _hubConnection!.start();
      _connectionStateController.add(HubConnectionState.Connected);
      debugPrint('[SupportHub] Successfully connected to SupportHub');
    } catch (e) {
      debugPrint('[SupportHub] Failed to connect: $e');
      _connectionStateController.add(HubConnectionState.Disconnected);
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> joinConversation(int conversationId) async {
    if (!isConnected) {
      await connect();
    }
    if (isConnected) {
      try {
        await _hubConnection!.invoke('JoinConversation', args: [conversationId]);
        debugPrint('[SupportHub] Joined conversation conv-$conversationId');
      } catch (e) {
        debugPrint('[SupportHub] Error joining conversation: $e');
      }
    }
  }

  Future<void> leaveConversation(int conversationId) async {
    if (isConnected) {
      try {
        await _hubConnection!.invoke('LeaveConversation', args: [conversationId]);
        debugPrint('[SupportHub] Left conversation conv-$conversationId');
      } catch (e) {
        debugPrint('[SupportHub] Error leaving conversation: $e');
      }
    }
  }

  Future<void> disconnect() async {
    try {
      if (_hubConnection != null) {
        await _hubConnection!.stop();
        _connectionStateController.add(HubConnectionState.Disconnected);
      }
    } catch (e) {
      debugPrint('[SupportHub] Error disconnecting: $e');
    }
  }

  void dispose() {
    _messageController.close();
    _unreadCountController.close();
    _conversationsChangedController.close();
    _connectionStateController.close();
  }
}
