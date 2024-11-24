import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class RegisterNameField extends StatelessWidget {
  const RegisterNameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: AppStrings.nameHint,
      prefixIcon: Icons.person_outline_rounded,
      controller: controller,
      keyboardType: TextInputType.name,
      validator: AppValidator.validateName,
    );
  }
}
