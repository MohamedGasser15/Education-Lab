import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';
import 'api_client.dart';
import 'auth_storage_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.i(
      'Background message received: ${message.messageId}',
      tag: 'NotificationService',
    );
  } catch (e) {
    AppLogger.e(
      'Background message handler error',
      tag: 'NotificationService',
      error: e,
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _cachedToken;

  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;
  String? get cachedToken => _cachedToken;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'education_lab_channel',
    'Education Lab Notifications',
    description: 'Notifications for Education Lab updates and alerts',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationResponse,
  }) async {
    if (_isInitialized) return;

    // 1. Initialize Firebase if possible
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      AppLogger.i(
        'Firebase initialized successfully.',
        tag: 'NotificationService',
      );
    } catch (e) {
      AppLogger.w(
        'Firebase init skipped/failed',
        tag: 'NotificationService',
        error: e,
      );
    }

    // Register background message handler
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } catch (e) {
      AppLogger.e(
        'Error setting background handler',
        tag: 'NotificationService',
        error: e,
      );
    }

    // 2. Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. iOS initialization settings
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
      onDidReceiveNotificationResponse:
          onNotificationResponse ??
          (NotificationResponse response) {
            AppLogger.d(
              'Notification clicked with payload: ${response.payload}',
              tag: 'NotificationService',
            );
          },
    );

    // Create the high-importance Notification Channel on Android
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_channel);
    }

    // Set foreground notification presentation options for iOS/Android
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (_) {}

    _isInitialized = true;

    // Request permissions explicitly
    await requestPermissions();

    // Listen for foreground FCM messages
    _setupForegroundNotificationListener();

    // Listen for token refresh
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _cachedToken = newToken;
        updateDeviceTokenOnServer(newToken);
      });
    } catch (_) {}

    // Sync token if user is already logged in
    await syncDeviceTokenWithServer();
  }

  void _setupForegroundNotificationListener() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          showNotification(
            id: notification.hashCode,
            title: notification.title ?? 'Education Lab',
            body: notification.body ?? '',
            payload: message.data.toString(),
          );
        }
      });
    } catch (_) {}
  }

  Future<bool?> requestPermissions() async {
    if (Platform.isIOS) {
      try {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (_) {}

      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidImplementation?.requestNotificationsPermission();
    }
    return false;
  }

  /// Retrieves the current FCM device token
  Future<String?> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        String? apns = await FirebaseMessaging.instance.getAPNSToken();
        int attempts = 0;
        while (apns == null && attempts < 3) {
          await Future.delayed(const Duration(milliseconds: 500));
          apns = await FirebaseMessaging.instance.getAPNSToken();
          attempts++;
        }
        AppLogger.d('APNs Token: $apns', tag: 'NotificationService');
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        _cachedToken = token;
        AppLogger.i('FCM Device Token: $token', tag: 'NotificationService');
        return token;
      }
    } catch (e) {
      AppLogger.e(
        'Error getting FCM token',
        tag: 'NotificationService',
        error: e,
      );
      if (Platform.isIOS) {
        // On iOS Simulator, APNs is not provided by Apple; use a consistent development token
        _cachedToken ??= 'ios_simulator_device_token';
        AppLogger.d(
          'Using simulator token: $_cachedToken',
          tag: 'NotificationService',
        );
        return _cachedToken;
      }
    }
    return _cachedToken;
  }

  /// Syncs device token with server if user is logged in
  Future<void> syncDeviceTokenWithServer() async {
    try {
      final isLoggedIn = await AuthStorageService.isLoggedIn();
      if (!isLoggedIn) return;

      final token = await getDeviceToken();
      if (token != null && token.isNotEmpty) {
        await updateDeviceTokenOnServer(token);
      }
    } catch (e) {
      AppLogger.e(
        'Error syncing token on login',
        tag: 'NotificationService',
        error: e,
      );
    }
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
          'EduLab Notifications',
          channelDescription: 'Notifications for EduLab updates and alerts',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
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
        ApiConstants.notificationsDeviceToken,
        body: {'deviceToken': deviceToken},
      );
      if (response is Success) {
        AppLogger.i(
          'Device token registered on server.',
          tag: 'NotificationService',
        );
        return true;
      }
      AppLogger.w(
        'Failed to register token: ${(response as Failure).message}',
        tag: 'NotificationService',
      );
      return false;
    } catch (e) {
      AppLogger.e(
        'Error sending token to API',
        tag: 'NotificationService',
        error: e,
      );
      return false;
    }
  }

  /// Asks backend API to trigger a test push notification to this device
  Future<bool> requestTestPushNotification() async {
    try {
      final response = await ApiClient().postSafe(
        ApiConstants.notificationsTestPush,
      );
      return response is Success;
    } catch (e) {
      AppLogger.e(
        'Error requesting test push',
        tag: 'NotificationService',
        error: e,
      );
      return false;
    }
  }
}
