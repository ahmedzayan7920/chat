import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class RegisterPasswordField extends StatefulWidget {
  const RegisterPasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<RegisterPasswordField> {
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
