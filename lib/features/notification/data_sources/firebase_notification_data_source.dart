import 'package:chat/core/utils/firebase_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNotificationDataSource {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  FirebaseNotificationDataSource({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
  })  : _messaging = messaging,
        _firestore = firestore;

  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  Future<void> saveToken(String token, String userId) async {
    final userDoc = _firestore.collection(FirebaseConstants.users).doc(userId);
    await userDoc.update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  Stream<String?> onTokenRefresh() {
    return _messaging.onTokenRefresh;
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Stream<RemoteMessage?> onMessage() {
    return FirebaseMessaging.onMessage;
  }
}
