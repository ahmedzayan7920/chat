import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_confirm_password_field.dart';
import '../../../../../core/widgets/custom_password_field.dart';
import '../../../../../core/widgets/spaces.dart';
import 'register_button.dart';
import 'register_email_field.dart';
import 'register_name_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _shouldValidate = false;

  bool _validateForm() {
    setState(() {
      _shouldValidate = true;
    });
    return _formKey.currentState?.validate() == true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _shouldValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RegisterNameField(controller: _nameController),
          const VerticalSpace(height: 16),
          RegisterEmailField(controller: _emailController),
          const VerticalSpace(height: 16),
          CustomPasswordField(controller: _passwordController),
          const VerticalSpace(height: 16),
          CustomConfirmPasswordField(
            controller: _passwordController,
            confirmController: _confirmPasswordController,
          ),
          const VerticalSpace(height: 16),
          RegisterButton(
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            validateForm: _validateForm,
          ),
        ],
      ),
    );
  }
}
