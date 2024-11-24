import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../logic/auth_cubit.dart';
import '../../../logic/auth_state.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.validateForm,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool Function() validateForm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        return CustomElevatedButton(
          text: AppStrings.register,
          isLoading: isLoading,
          onPressed: isLoading ? null : () => _register(context),
        );
      },
    );
  }

  _register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (validateForm()) {
      context.read<AuthCubit>().register(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
    }
  }
}
