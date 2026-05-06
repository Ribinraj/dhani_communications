

import 'dart:convert';
import 'dart:developer';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level background notification tap handler for flutter_local_notifications.
/// Must be a top-level or static function and annotated as entry point if used for background.
/// This will be called for "background notification responses" (action taps when app not in foreground).
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // This runs in the background isolate for notification action taps.
  // Keep it minimal (logging / lightweight work).
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

/// PushNotifications helper (singleton).
/// Usage:
/// 1) In main() register Firebase background handler:
///    FirebaseMessaging.onBackgroundMessage(PushNotifications.backgroundMessageHandler);
/// 2) Optionally register the local notifications background response handler:
///    (flutter_local_notifications will call notificationTapBackground if provided to initialize()).
/// 3) Then initialize:
///    await PushNotifications.instance.init();
class PushNotifications {
  // Singleton
  static final PushNotifications _instance = PushNotifications._internal();
  static PushNotifications get instance => _instance;
  factory PushNotifications() => _instance;
  PushNotifications._internal();

  // Firebase Messaging and local notifications plugin instances
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Android channel (idempotent to create)
  static const AndroidNotificationChannel _androidNotificationChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize push notifications.
  /// Call this after Firebase.initializeApp() and after registering the Firebase background handler.
  Future<void> init() async {
    try {
      // Request platform permissions
      final settings = await _requestPermissions();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // iOS: ensure foreground presentation (so notifications are shown while app in foreground)
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        // Get and store token
        await _getDeviceToken();

        // Init local notifications plugin (channels + initialize)
        await _initLocalNotifications();

        // Setup listeners for messages and taps
        _setupNotificationListeners();
      } else {
        debugPrint('Notification permission not granted: ${settings.authorizationStatus}');
      }
    } catch (e, st) {
      debugPrint('PushNotifications.init error: $e\n$st');
    }
  }

  Future<NotificationSettings> _requestPermissions() async {
    return await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true, // requires iOS entitlement if used
      announcement: false,
      carPlay: false,
    );
  }

  // Get and persist device FCM token, and listen to refreshes.
  Future<String?> _getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM Device Token: $token');

      if (token != null) {
        await LocalStorage.saveFcmToken(token);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        LocalStorage.saveFcmToken(newToken);
        _updateTokenIfLoggedIn(newToken);
      });

      return token;
    } catch (e) {
      debugPrint('Error fetching FCM token: $e');
      return null;
    }
  }

  /// Update token on server if user is currently logged in.
  /// Uses a standalone Dio instance with the user's auth token.
  Future<void> _updateTokenIfLoggedIn(String fcmToken) async {
    try {
      final userToken = await LocalStorage.getToken();
      if (userToken.isEmpty) return; // Not logged in

      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userToken,
          },
        ),
      );

      final response = await dio.post(
        Endpoints.settoken,
        data: {"pushToken": fcmToken},
      );

      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
        log("FCM token updated on server (token refresh)");
      } else {
        log("Failed to update FCM token on server: ${responseData["message"]}");
      }
    } catch (e) {
      debugPrint('Failed to update token on server: $e');
    }
  }

  /// Call after user logs in successfully to send the stored FCM token to server.
  Future<void> sendTokenToServer() async {
    try {
      String? fcmToken = await LocalStorage.getFcmToken();
      log('sendTokenToServer (from local storage): $fcmToken');

      // If FCM_TOKEN is null, fetch it from Firebase now
      if (fcmToken == null) {
        fcmToken = await FirebaseMessaging.instance.getToken();
        log('sendTokenToServer (fetched from Firebase): $fcmToken');

        if (fcmToken != null) {
          await LocalStorage.saveFcmToken(fcmToken);
        }
      }

      // If still null, we can't proceed
      if (fcmToken == null) {
        log('sendTokenToServer: FCM token is still null, skipping server update');
        return;
      }

      // Get the user's auth token for the API call
      final userToken = await LocalStorage.getToken();
      if (userToken.isEmpty) {
        log('sendTokenToServer: No user token found, skipping');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userToken,
          },
        ),
      );

      final response = await dio.post(
        Endpoints.settoken,
        data: {"pushToken": fcmToken},
      );

      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
        log("FCM token sent to server successfully after login");
      } else {
        log("Failed to send FCM token to server: ${responseData["message"]}");
      }
    } catch (e) {
      debugPrint('Failed to send token to server: $e');
    }
  }

  /// Remove FCM token from the server (call during logout before clearing session).
  Future<void> removeTokenFromServer() async {
    try {
      final fcmToken = await LocalStorage.getFcmToken();
      if (fcmToken == null) {
        log('removeTokenFromServer: No FCM token found, skipping');
        return;
      }

      final userToken = await LocalStorage.getToken();
      if (userToken.isEmpty) {
        log('removeTokenFromServer: No user token found, skipping');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userToken,
          },
        ),
      );

      final response = await dio.post(
        Endpoints.removetoken,
        data: {"pushToken": fcmToken},
      );

      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
        log("FCM token removed from server successfully");
      } else {
        log("Failed to remove FCM token from server: ${responseData["message"]}");
      }
    } catch (e) {
      debugPrint('Failed to remove token from server: $e');
    }
  }

  /// Delete device token (logout flow). Cancels local notifications and deletes Android channel.
  /// Also removes the token from the server.
  Future<void> deleteDeviceToken() async {
    try {
      // First, remove token from server while we still have auth
      await removeTokenFromServer();

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNs token not available; skipping deleteToken.');
        } else {
          await _firebaseMessaging.deleteToken();
          debugPrint('iOS: FCM token deleted.');
        }
      } else {
        await _firebaseMessaging.deleteToken();
        debugPrint('Android: FCM token deleted.');
      }

      // Remove FCM token from local storage
      await LocalStorage.removeFcmToken();

      // Cancel local notifications and delete Android channel if present
      await _flutterLocalNotificationsPlugin.cancelAll();
      final androidImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        await androidImpl.deleteNotificationChannel(channelId: _androidNotificationChannel.id);
      }
    } catch (e) {
      debugPrint('Error deleting device token: $e');
    }
  }

  // Initialize flutter_local_notifications and create Android channel.
  Future<void> _initLocalNotifications() async {
    // Android settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Darwin (iOS/macOS) settings — do NOT include onDidReceiveLocalNotification (deprecated/old)
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // IMPORTANT: using iOS: and macOS: named params (matches current example APIs)
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings,
    );

    // Create the Android channel (idempotent)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);

    // Initialize plugin (modern callbacks)
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // Setup message listeners for FCM (foreground messages, taps, initial message)
  void _setupNotificationListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground FCM message received');
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('User tapped notification (app opened from background)');
      _handleTerminatedStateNotification(message);
    });

    // If app was launched from terminated state via notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App launched from terminated state by notification');
        _handleTerminatedStateNotification(message);
      }
    });
  }

  // Show a local notification for foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    final notif = message.notification;
    if (notif != null) {
      _showLocalNotification(
        title: notif.title ?? 'Notification',
        body: notif.body ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidNotificationChannel.id,
      _androidNotificationChannel.name,
      channelDescription: _androidNotificationChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: notificationDetails,



      payload: payload,
    );
  }

  // Modern notification tap handler (when app is in foreground or background)
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped (response.payload=${response.payload})');
    // TODO: implement navigation. Use a GlobalKey<NavigatorState> if you need to navigate here.
  }

  /// Firebase background message handler. Must be top-level or static. Register with:
  /// FirebaseMessaging.onBackgroundMessage(PushNotifications.backgroundMessageHandler);
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    debugPrint('Handling background FCM message in PushNotifications.backgroundMessageHandler');
    try {
      debugPrint('Background message data: ${message.data}');
    } catch (e) {
      debugPrint('Error in backgroundMessageHandler: $e');
    }
  }

  // Handle notification that opened the app from background/terminated
  void _handleTerminatedStateNotification(RemoteMessage message) {
    final notif = message.notification;
    final data = message.data;
    if (notif != null) {
      debugPrint('Notification opened app - title: ${notif.title}, body: ${notif.body}');
    }
    debugPrint('Notification opened app - data: $data');
    // TODO: route to a screen via navigatorKey if needed
  }
}

