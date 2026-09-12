import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/utils/app_logger.dart';
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
  Stream<void> get onConversationsChanged =>
      _conversationsChangedController.stream;
  Stream<HubConnectionState> get onConnectionStateChanged =>
      _connectionStateController.stream;

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  Future<void> connect() async {
    if (isConnected || _isConnecting) return;

    final token = await AuthStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.w('Cannot connect: No access token', tag: 'SupportHub');
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
        AppLogger.w('Connection closed', tag: 'SupportHub', error: error);
        _connectionStateController.add(HubConnectionState.Disconnected);
      });

      _hubConnection!.onreconnecting(({error}) {
        AppLogger.i('Reconnecting...', tag: 'SupportHub');
        _connectionStateController.add(HubConnectionState.Reconnecting);
      });

      _hubConnection!.onreconnected(({connectionId}) {
        AppLogger.i(
          'Reconnected! ConnectionId: $connectionId',
          tag: 'SupportHub',
        );
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
            AppLogger.d(
              'Received message for conv ${message.conversationId}: ${message.content}',
              tag: 'SupportHub',
            );
            _messageController.add(message);
          } catch (e) {
            AppLogger.e(
              'Error parsing ReceiveMessage',
              tag: 'SupportHub',
              error: e,
            );
          }
        }
      });

      _hubConnection!.on('UnreadCountChanged', (arguments) {
        if (arguments != null && arguments.isNotEmpty && arguments[0] != null) {
          final count = int.tryParse(arguments[0].toString()) ?? 0;
          AppLogger.d('UnreadCountChanged: $count', tag: 'SupportHub');
          _unreadCountController.add(count);
        }
      });

      _hubConnection!.on('ConversationsChanged', (arguments) {
        AppLogger.d('ConversationsChanged received', tag: 'SupportHub');
        _conversationsChangedController.add(null);
      });

      await _hubConnection!.start();
      _connectionStateController.add(HubConnectionState.Connected);
      AppLogger.i('Successfully connected to SupportHub', tag: 'SupportHub');
    } catch (e) {
      AppLogger.e('Failed to connect', tag: 'SupportHub', error: e);
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
        await _hubConnection!.invoke(
          'JoinConversation',
          args: [conversationId],
        );
        AppLogger.d(
          'Joined conversation conv-$conversationId',
          tag: 'SupportHub',
        );
      } catch (e) {
        AppLogger.e('Error joining conversation', tag: 'SupportHub', error: e);
      }
    }
  }

  Future<void> leaveConversation(int conversationId) async {
    if (isConnected) {
      try {
        await _hubConnection!.invoke(
          'LeaveConversation',
          args: [conversationId],
        );
        AppLogger.d(
          'Left conversation conv-$conversationId',
          tag: 'SupportHub',
        );
      } catch (e) {
        AppLogger.e('Error leaving conversation', tag: 'SupportHub', error: e);
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
      AppLogger.e('Error disconnecting', tag: 'SupportHub', error: e);
    }
  }

  void dispose() {
    _messageController.close();
    _unreadCountController.close();
    _conversationsChangedController.close();
    _connectionStateController.close();
  }
}
