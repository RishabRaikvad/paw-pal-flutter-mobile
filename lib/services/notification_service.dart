import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;

import 'firebase_auth_service.dart';

class NotificationService {
  Future<void> setUpInteractedMessage() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        handelNotificationClick(
          message.data.toString(),
          isFromBackGround: true,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification click : onMessageOpenedApp");
      debugPrint("===========message===$message");
      debugPrint("===========message data===${message.data}");
      handelNotificationClick(message.data.toString(), isFromBackGround: false);
    });
    enableIOSNotifications();
    await _registerNotificationListeners();
  }

  Future<void> _registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification_icon');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("🔔 Local notification clicked");
        if (details.payload != null && details.payload!.isNotEmpty) {
          handelNotificationClick(details.payload, isFromBackGround: false);
        }
      },
    );
    // onMessage i called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      // consoleLog(message, key: 'firebase_message');
      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          flutter_local_notifications.NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'ic_notification_icon',
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });
  }

  void handelNotificationClick(
    String? payload, {
    required bool isFromBackGround,
  }) {
    debugPrint("payload : $payload :: isFromBackground : $isFromBackGround");
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        showBadge: true,
      );

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
      // Required to display a heads up notification badge: true, sound: true,
    );
  }

  static Future<String> getFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("====================FCMToken $fcmToken");
      return fcmToken ?? "";
    } catch (e) {
      debugPrint("====================Error $e");
    }
    return "";
  }

  static Future<void> setupFcmTokenListener() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseService().manageFcmToken(newToken);
    });
  }

  static Future<void> updateFcmTokenOnLogin() async {
    final token = await getFcmToken();
    await FirebaseService().manageFcmToken(token);
  }
}
