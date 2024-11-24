import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/functions/show_snack_bar.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../logic/auth_cubit.dart';
import '../../../logic/auth_state.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
        } else if (state is AuthErrorState) {
          showSnackBar(context, state.message);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
