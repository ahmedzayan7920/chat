import 'package:flutter/material.dart';
import 'package:chat/core/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../logic/auth_cubit.dart';
import '../../../logic/auth_state.dart';

class VerifyPhoneNumberButton extends StatelessWidget {
  final bool isPhoneNumberValid;
  final VoidCallback? onPressed;

  const VerifyPhoneNumberButton({
    super.key,
    required this.isPhoneNumberValid,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomElevatedButton(
          text: AppStrings.verifyPhoneNumber,
          isLoading: state is AuthLoadingState,
          onPressed: isPhoneNumberValid ? onPressed : null,
        );
      },
    );
  }
}
