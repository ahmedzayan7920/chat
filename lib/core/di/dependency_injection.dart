import 'package:chat/core/data_sources/user_data_source.dart';
import 'package:chat/features/auth/data_sources/auth_data_source.dart';
import 'package:chat/features/notification/data_sources/firebase_notification_data_source.dart';
import 'package:chat/features/notification/data_sources/local_notification_data_source.dart';
import 'package:chat/features/notification/repos/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/auth/data_sources/firebase_auth_data_source.dart';
import '../../features/auth/repos/auth_repository.dart';
import '../../features/auth/repos/firebase_auth_repository.dart';
import '../../features/notification/repos/firebase_notification_repository.dart';
import '../data_sources/firebase_user_data_source.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Register firebase services
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(),
  );

  getIt.registerLazySingleton<FacebookAuth>(
    () => FacebookAuth.instance,
  );

  // Register data sources
  getIt.registerLazySingleton<UserDataSource>(
    () => FirebaseUserDataSource(firestore: getIt()),
  );

  getIt.registerLazySingleton<AuthDataSource>(
    () => FirebaseAuthDataSource(
      auth: getIt(),
      googleSignIn: getIt(),
      facebookAuth: getIt(),
    ),
  );

  getIt.registerLazySingleton<LocalNotificationDataSource>(
    () => LocalNotificationDataSource(plugin: getIt()),
  );

  getIt.registerLazySingleton<FirebaseNotificationDataSource>(
    () => FirebaseNotificationDataSource(
      firestore: getIt(),
      messaging: getIt(),
    ),
  );

  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      authDataSource: getIt(),
      userDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<NotificationRepository>(
    () => FirebaseNotificationRepository(
      authDataSource: getIt(),
      firebaseDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
}
