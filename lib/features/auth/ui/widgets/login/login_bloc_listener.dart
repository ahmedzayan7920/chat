import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/functions/show_snack_bar.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../notification/repos/notification_repository.dart';
import '../../../logic/auth_cubit.dart';
import '../../../logic/auth_state.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          getIt<NotificationRepository>().initialize();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.chats,
            (route) => false,
          );
        } else if (state is AuthErrorState) {
          showSnackBar(context, state.message);
        } else if (state is OtpSentState) {
          Navigator.of(context).pushNamed(
            AppRoutes.phoneOtp,
            arguments: state.verificationId,
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
