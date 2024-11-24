import 'package:flutter/material.dart';

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
    this.maxLength = 50,
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
  final int maxLength;
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
        border: _buildBorder(color: Colors.grey.shade400),
        disabledBorder: _buildBorder(color: Colors.grey.shade300),
        enabledBorder:
            _buildBorder(color: Theme.of(context).colorScheme.tertiary),
        focusedBorder:
            _buildBorder(color: Theme.of(context).colorScheme.primary),
        errorBorder: _buildBorder(color: Colors.red),
        focusedErrorBorder: _buildBorder(color: Colors.red),
      ),
    );
  }

  OutlineInputBorder _buildBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
        width: 2,
        style: BorderStyle.solid,
      ),
    );
  }
}
