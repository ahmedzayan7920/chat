import 'package:chat/core/data_sources/phone/phone_data_source.dart';
import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:chat/features/settings/data_sources/email_settings_data_source.dart';
import 'package:chat/features/settings/repos/email_settings_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app_config.dart';
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
import '../../features/settings/data_sources/firebase_email_settings_data_source.dart';
import '../../features/settings/repos/firebase_email_settings_repository.dart';
import '../data_sources/phone/firebase_phone_data_source.dart';
import '../data_sources/storage/storage_data_source.dart';
import '../data_sources/storage/supabase_storage_data_source.dart';
import '../data_sources/user/firebase_user_data_source.dart';
import '../data_sources/user/user_data_source.dart';
import '../repos/phone/firebase_phone_repository.dart';
import '../repos/storage/storage_repository.dart';
import '../repos/storage/supabase_storage_repository.dart';
import '../repos/user/firebase_user_repository.dart';
import '../repos/user/user_repository.dart';

final getIt = GetIt.instance;

setupDependencyInjection({required AppFlavor flavor}) {
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

  getIt.registerLazySingleton<AppConfig>(
    () => AppConfig(appFlavor: flavor),
  );

  getIt.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  getIt.registerLazySingleton<FirebaseAnalytics>(
    () => FirebaseAnalytics.instance,
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

  getIt.registerLazySingleton<PhoneDataSource>(
    () => FirebasePhoneDataSource(
      auth: getIt(),
    ),
  );

  getIt.registerLazySingleton<EmailSettingsDataSource>(
    () => FirebaseEmailSettingsDataSource(
      auth: getIt(),
    ),
  );

  // Register repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      authDataSource: getIt(),
      phoneDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<NotificationRepository>(
    () => FirebaseNotificationRepository(
      authDataSource: getIt(),
      firebaseDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
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

  getIt.registerLazySingleton<PhoneRepository>(
    () => FirebasePhoneRepository(
      phoneDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<StorageRepository>(
    () => SupabaseStorageRepository(
      storageDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<EmailSettingsRepository>(
    () => FirebaseEmailSettingsRepository(
      emailSettingsDataSource: getIt(),
    ),
  );
}
