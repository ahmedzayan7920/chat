import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class RegisterConfirmPasswordField extends StatefulWidget {
  const RegisterConfirmPasswordField({
    super.key,
    required this.controller,
    required this.confirmController,
  });
  final TextEditingController controller;
  final TextEditingController confirmController;

  @override
  State<RegisterConfirmPasswordField> createState() =>
      _RegisterConfirmPasswordFieldState();
}

class _RegisterConfirmPasswordFieldState
    extends State<RegisterConfirmPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: AppStrings.confirmPasswordHint,
      prefixIcon: Icons.password_rounded,
      controller: widget.confirmController,
      obscureText: _obscureText,
      suffixIcon: _obscureText
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined,
      suffixOnPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: (value) => AppValidator.validateConfirmPassword(
        widget.controller.text,
        value,
      ),
    );
  }
}
