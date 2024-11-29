import 'dart:async';

import 'package:chat/core/utils/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../auth/data_sources/auth_data_source.dart';
import '../data_sources/firebase_notification_data_source.dart';
import '../data_sources/local_notification_data_source.dart';
import 'notification_repository.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final FirebaseNotificationDataSource _firebaseDataSource;
  final LocalNotificationDataSource _localDataSource;
  final AuthDataSource _authDataSource;

  StreamSubscription<String?>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage?>? _messageSubscription;

  FirebaseNotificationRepository({
    required FirebaseNotificationDataSource firebaseDataSource,
    required LocalNotificationDataSource localDataSource,
    required AuthDataSource authDataSource,
  })  : _firebaseDataSource = firebaseDataSource,
        _localDataSource = localDataSource,
        _authDataSource = authDataSource;

  @override
  Future<void> initialize() async {
    await _firebaseDataSource.requestPermission();

    await _localDataSource.initialize();

    _tokenRefreshSubscription =
        _firebaseDataSource.onTokenRefresh().listen((token) async {
      final user = _authDataSource.getCurrentUser();
      if (user != null && token != null) {
        await _firebaseDataSource.saveToken(token, user.uid);
      }
    });

    _messageSubscription = _firebaseDataSource.onMessage().listen((message) {
      final user = _authDataSource.getCurrentUser();
      if (user != null && message?.notification != null) {
        _localDataSource.showNotification(
          title: message!.notification!.title ?? AppStrings.noTitle,
          body: message.notification!.body ?? AppStrings.noBody,
        );
      }
    });

    final token = await _firebaseDataSource.getToken();
    await saveToken(token);
  }

  @override
  Future<void> saveToken(String? token) async {
    final user = _authDataSource.getCurrentUser();
    if (user != null && token != null) {
      await _firebaseDataSource.saveToken(token, user.uid);
    }
  }

  @override
  Future<String?> getToken() async {
    return _firebaseDataSource.getToken();
  }

  @override
  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _messageSubscription?.cancel();
  }
}

