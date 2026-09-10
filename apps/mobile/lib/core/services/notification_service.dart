import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_client.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;

  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationResponse,
  }) async {
    if (_isInitialized) return;

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse ??
          (NotificationResponse response) {
            debugPrint('Notification clicked with payload: ${response.payload}');
          },
    );

    _isInitialized = true;

    // Request permissions explicitly
    await requestPermissions();
  }

  Future<bool?> requestPermissions() async {
    if (Platform.isIOS) {
      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission();
    }
    return false;
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'education_lab_channel',
      'Education Lab Notifications',
      channelDescription: 'Notifications for Education Lab updates and alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Sends the device token to the Backend API
  Future<bool> updateDeviceTokenOnServer(String deviceToken) async {
    try {
      final response = await ApiClient().postSafe(
        '/api/Notifications/device-token',
        body: {'deviceToken': deviceToken},
      );
      if (response is Success) {
        debugPrint('[NotificationService] Device token registered on server.');
        return true;
      }
      debugPrint('[NotificationService] Failed to register token: ${(response as Failure).message}');
      return false;
    } catch (e) {
      debugPrint('[NotificationService] Error sending token to API: $e');
      return false;
    }
  }

  /// Asks backend API to trigger a test push notification to this device
  Future<bool> requestTestPushNotification() async {
    try {
      final response = await ApiClient().postSafe(
        '/api/Notifications/test-push',
      );
      return response is Success;
    } catch (e) {
      debugPrint('[NotificationService] Error requesting test push: $e');
      return false;
    }
  }
}
