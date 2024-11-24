import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../logic/auth_cubit.dart';
import '../../../logic/auth_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.validateForm,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool Function() validateForm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        return CustomElevatedButton(
          text: AppStrings.login,
          isLoading: isLoading,
          onPressed: isLoading ? null : () => _login(context),
        );
      },
    );
  }

  _login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (validateForm()) {
      context.read<AuthCubit>().login(
            emailController.text,
            passwordController.text,
          );
    }
  }
}
