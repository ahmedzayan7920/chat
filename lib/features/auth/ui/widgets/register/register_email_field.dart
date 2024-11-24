import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: AppStrings.emailHint,
      prefixIcon: Icons.email_outlined,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: AppValidator.validateEmail,
    );
  }
}
