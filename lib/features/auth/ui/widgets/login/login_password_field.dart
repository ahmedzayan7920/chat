import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class LoginPasswordField extends StatefulWidget {
  const LoginPasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: AppStrings.passwordHint,
      prefixIcon: Icons.password_outlined,
      controller: widget.controller,
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
      validator: AppValidator.validatePassword,

    );
  }
}
