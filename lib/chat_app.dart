import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:chat/features/notification/repos/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/dependency_injection.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/auth/logic/auth_state.dart';
import 'features/auth/ui/views/login_view.dart';
import 'features/chat/ui/views/chats_view.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(authRepository: getIt())..checkAuthStatus(),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              getIt<NotificationRepository>().initialize();
              return const ChatsView();
            } else {
              getIt<NotificationRepository>().dispose();
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}
