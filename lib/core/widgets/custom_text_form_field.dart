import 'package:flutter/material.dart';

import '../functions/build_field_border.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixOnPressed,
    this.validator,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.maxLines = 1,
  });
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final void Function()? suffixOnPressed;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        counterText: "",
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixOnPressed,
                icon: Icon(suffixIcon),
                color: Theme.of(context).colorScheme.onSecondary,
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: buildFieldBorder(color: Colors.grey.shade400),
        disabledBorder: buildFieldBorder(color: Colors.grey.shade300),
        enabledBorder:
            buildFieldBorder(color: Theme.of(context).colorScheme.tertiary),
        focusedBorder:
            buildFieldBorder(color: Theme.of(context).colorScheme.primary),
        errorBorder: buildFieldBorder(color: Colors.red),
        focusedErrorBorder: buildFieldBorder(color: Colors.red),
      ),
    );
  }
}
