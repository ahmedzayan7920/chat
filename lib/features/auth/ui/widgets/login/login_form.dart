import 'package:flutter/material.dart';

import '../../../../../core/widgets/spaces.dart';
import 'login_button.dart';
import 'login_email_field.dart';
import 'login_password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
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
          LoginEmailField(controller: _emailController),
          const VerticalSpace(height: 16),
          LoginPasswordField(controller: _passwordController),
          const VerticalSpace(height: 16),
          LoginButton(
            emailController: _emailController,
            passwordController: _passwordController,
            validateForm: _validateForm,
          ),
        ],
      ),
    );
  }
}
