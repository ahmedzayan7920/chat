import 'package:chat/features/auth/ui/views/phone_auth_view.dart';
import 'package:chat/features/auth/ui/views/phone_otp_view.dart';
import 'package:chat/features/chat/models/chat_model.dart';
import 'package:chat/features/chat/ui/views/chat_view.dart';
import 'package:chat/features/chat/ui/views/edit_media_view.dart';
import 'package:flutter/material.dart';

import '../../features/auth/ui/views/login_view.dart';
import '../../features/auth/ui/views/register_view.dart';
import '../../features/chat/ui/views/chats_view.dart';
import '../../features/chat/ui/views/video_player_view.dart';
import '../../features/users/ui/views/users_view.dart';
import '../models/edit_media_arguments_model.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.phoneAuth:
        return MaterialPageRoute(builder: (_) => const PhoneAuthView());
      case AppRoutes.phoneOtp:
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => PhoneOtpView(verificationId: verificationId));
      case AppRoutes.chats:
        return MaterialPageRoute(builder: (_) => const ChatsView());
      case AppRoutes.users:
        return MaterialPageRoute(builder: (_) => const UsersView());
      case AppRoutes.chat:
        final chat = settings.arguments as ChatModel;
        return MaterialPageRoute(builder: (_) => ChatView(chat: chat));
      case AppRoutes.editMedia:
        final args = settings.arguments as EditMediaArgumentsModel;
        return MaterialPageRoute(
          builder: (_) => EditMediaView(
            mediaPath: args.mediaPath,
            isVideo: args.isVideo,
            onSend: args.onSend,
          ),
        );

      case AppRoutes.videoPlayer:
        final videoUrl = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerView(
            videoUrl: videoUrl,
          ),
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
        );
    }
  }
}
