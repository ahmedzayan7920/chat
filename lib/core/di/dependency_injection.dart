import 'package:chat/core/data_sources/user_data_source.dart';
import 'package:chat/core/services/notification_service.dart';
import 'package:chat/features/auth/data_sources/auth_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data_sources/firebase_auth_data_source.dart';
import '../../features/auth/repos/auth_repository.dart';
import '../../features/auth/repos/firebase_auth_repository.dart';
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

  // Register services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(messaging: getIt(), localNotifications: getIt()),
  );

  // Register data sources
  getIt.registerLazySingleton<UserDataSource>(
    () => FirebaseUserDataSource(firestore: getIt()),
  );

  getIt.registerLazySingleton<AuthDataSource>(
    () => FirebaseAuthDataSource(auth: getIt()),
  );

  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      authDataSource: getIt(),
      userDataSource: getIt(),
    ),
  );
}
