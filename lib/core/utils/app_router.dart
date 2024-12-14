import 'package:chat/features/profile/ui/views/edit_profile_view.dart';
import 'package:chat/features/profile/ui/views/profile_view.dart';
import 'package:chat/features/settings/ui/views/email_settings_view.dart';
import 'package:chat/features/settings/ui/views/security_settings_view.dart';
import 'package:chat/features/settings/ui/views/settings_view.dart';
import 'package:flutter/material.dart';

import '../../features/auth/ui/views/login_view.dart';
import '../../features/auth/ui/views/phone_auth_view.dart';
import '../../features/auth/ui/views/phone_otp_view.dart';
import '../../features/auth/ui/views/register_view.dart';
import '../../features/chat/models/chat_model.dart';
import '../../features/chat/ui/views/chat_view.dart';
import '../../features/chat/ui/views/chats_view.dart';
import '../../features/chat/ui/views/edit_media_view.dart';
import '../../features/chat/ui/views/video_player_view.dart';
import '../../features/users/ui/views/users_view.dart';
import '../models/edit_media_arguments_model.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
          settings: RouteSettings(name: AppRoutes.login),
        );
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView(),
          settings: RouteSettings(name: AppRoutes.register),);
      case AppRoutes.phoneAuth:
        return MaterialPageRoute(builder: (_) => const PhoneAuthView(),
          settings: RouteSettings(name: AppRoutes.phoneAuth),);
      case AppRoutes.phoneOtp:
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PhoneOtpView(verificationId: verificationId),
          settings: RouteSettings(name: AppRoutes.phoneOtp),);
      case AppRoutes.chats:
        return MaterialPageRoute(builder: (_) => const ChatsView(),
          settings: RouteSettings(name: AppRoutes.chats),);
      case AppRoutes.users:
        return MaterialPageRoute(builder: (_) => const UsersView(),
          settings: RouteSettings(name: AppRoutes.users),);
      case AppRoutes.chat:
        final chat = settings.arguments as ChatModel;
        return MaterialPageRoute(builder: (_) => ChatView(chat: chat),
          settings: RouteSettings(name: AppRoutes.chat),);
      case AppRoutes.editMedia:
        final args = settings.arguments as EditMediaArgumentsModel;
        return MaterialPageRoute(
          builder: (_) => EditMediaView(
            mediaPath: args.mediaPath,
            isVideo: args.isVideo,
            onSend: args.onSend,
          ),
          settings: RouteSettings(name: AppRoutes.editMedia),
        );

      case AppRoutes.videoPlayer:
        final videoUrl = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerView(
            videoUrl: videoUrl,
          ),
          settings: RouteSettings(name: AppRoutes.videoPlayer),
        );

      case AppRoutes.profile:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfileView(
            id: id,
          ),
          settings: RouteSettings(name: AppRoutes.profile),
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfileView(),
          settings: RouteSettings(name: AppRoutes.editProfile),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsView(),
          settings: RouteSettings(name: AppRoutes.settings),
        );
      case AppRoutes.securitySettings:
        return MaterialPageRoute(
          builder: (_) => SecuritySettingsView(),
          settings: RouteSettings(name: AppRoutes.securitySettings),
        );
      case AppRoutes.emailSettings:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EmailSettingsView(email: email),
          settings: RouteSettings(name: AppRoutes.emailSettings),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
          settings: RouteSettings(name: settings.name),
        );
    }
  }
}
