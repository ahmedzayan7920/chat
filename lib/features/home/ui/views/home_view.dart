import 'package:chat/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../../auth/logic/auth_state.dart';
import '../../../notification/repos/notification_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is UnauthenticatedState) {
                getIt<NotificationRepository>().dispose();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home View'),
      ),
    );
  }
}
