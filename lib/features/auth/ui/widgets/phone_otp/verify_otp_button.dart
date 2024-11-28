import 'package:flutter/material.dart';
import 'package:chat/core/widgets/custom_elevated_button.dart';

import '../../../../../core/utils/app_strings.dart';

class VerifyOtpButton extends StatelessWidget {
  final bool isLoading;
  final bool isOtpValid;
  final VoidCallback? onPressed;

  const VerifyOtpButton({
    super.key,
    required this.isLoading,
    required this.isOtpValid,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: AppStrings.verifyOtp,
      isLoading: isLoading,
      onPressed: isOtpValid ? onPressed : null,
    );
  }
}
