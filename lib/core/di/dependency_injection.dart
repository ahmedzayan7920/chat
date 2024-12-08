import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data_sources/auth_data_source.dart';
import '../../features/auth/data_sources/firebase_auth_data_source.dart';
import '../../features/auth/repos/auth_repository.dart';
import '../../features/auth/repos/firebase_auth_repository.dart';
import '../../features/chat/data_sources/chat_data_source.dart';
import '../../features/chat/data_sources/chats_data_source.dart';
import '../../features/chat/data_sources/firebase_chat_data_source.dart';
import '../../features/chat/data_sources/firebase_chats_data_source.dart';
import '../../features/chat/repos/chat_repository.dart';
import '../../features/chat/repos/chats_repository.dart';
import '../../features/chat/repos/firebase_chat_repository.dart';
import '../../features/chat/repos/firebase_chats_repository.dart';
import '../../features/notification/data_sources/firebase_notification_data_source.dart';
import '../../features/notification/data_sources/local_notification_data_source.dart';
import '../../features/notification/repos/firebase_notification_repository.dart';
import '../../features/notification/repos/notification_repository.dart';
import '../../features/users/data_sources/firebase_user_data_source.dart';
import '../../features/users/data_sources/user_data_source.dart';
import '../../features/users/repos/firebase_users_repository.dart';
import '../../features/users/repos/users_repository.dart';
import '../data_sources/storage/storage_data_source.dart';
import '../data_sources/storage/supabase_storage_data_source.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Register services
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

  getIt.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
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

  getIt.registerLazySingleton<ChatDataSource>(
    () => FirebaseChatDataSource(
      firestore: getIt(),
    ),
  );

  getIt.registerLazySingleton<ChatsDataSource>(
    () => FirebaseChatsDataSource(
      firestore: getIt(),
    ),
  );

  getIt.registerLazySingleton<StorageDataSource>(
    () => SupabaseStorageDataSource(
      supabaseClient: getIt(),
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

  getIt.registerLazySingleton<UsersRepository>(
    () => FirebaseUsersRepository(
      userDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => FirebaseChatRepository(
      chatDataSource: getIt(),
      storageDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<ChatsRepository>(
    () => FirebaseChatsRepository(
      chatsDataSource: getIt(),
    ),
  );
}
