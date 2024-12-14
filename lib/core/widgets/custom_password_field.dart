import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/app_validator.dart';
import 'custom_text_form_field.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
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
      textInputAction: TextInputAction.next,
      validator: AppValidator.validatePassword,
    );
  }
}
