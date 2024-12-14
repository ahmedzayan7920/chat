import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/app_validator.dart';
import 'custom_text_form_field.dart';

class CustomConfirmPasswordField extends StatefulWidget {
  const CustomConfirmPasswordField({
    super.key,
    required this.controller,
    required this.confirmController,
  });
  final TextEditingController controller;
  final TextEditingController confirmController;

  @override
  State<CustomConfirmPasswordField> createState() =>
      _CustomConfirmPasswordFieldState();
}

class _CustomConfirmPasswordFieldState
    extends State<CustomConfirmPasswordField> {
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
