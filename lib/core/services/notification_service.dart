import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
  })  : _messaging = messaging,
        _localNotifications = localNotifications;

  Future<void> initialize() async {
    await _messaging.requestPermission();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);
    await _localNotifications.initialize(initSettings);

    _messaging.onTokenRefresh.listen((token) {
      debugPrint("FCM Token: $token");
      saveTokenToServer(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification?.title ?? 'No Title',
          body: message.notification?.body ?? 'No Body',
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  Future<void> saveTokenToServer(String token) async {
    // TODO: save the token to firestore
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      Random().nextInt(100),
      title,
      body,
      notificationDetails,
    );
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
