import 'package:chat/core/widgets/custom_password_field.dart';
import 'package:chat/core/widgets/spaces.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:chat/features/settings/logic/email_settings/email_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/widgets/custom_confirm_password_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../logic/email_settings/email_settings_state.dart';

class EmailSettingsView extends StatefulWidget {
  const EmailSettingsView({super.key, required this.email});
  final String email;

  @override
  State<EmailSettingsView> createState() => _EmailSettingsViewState();
}

class _EmailSettingsViewState extends State<EmailSettingsView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = widget.email;
    super.initState();
  }

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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailSettingsCubit(
        emailSettingsRepository: getIt(),
        userRepository: getIt(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: BlocListener<EmailSettingsCubit, EmailSettingsState>(
        listener: (context, state) {
          if (state is EmailSettingsSuccessState) {
            context.read<AuthCubit>().syncUserData(state.updatedUser);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.popUntil(
              context,
              (route) => route.settings.name == AppRoutes.securitySettings,
            );
          } else if (state is EmailSettingsFailureState) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is EmailSettingsLogoutState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          } else if (state is EmailSettingsVerificationWaitingState) {
            _showVerificationDialog(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.email.isEmpty ? "Add Email" : "Update Email"),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: _shouldValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomTextFormField(
                    label: AppStrings.emailHint,
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.trim() == widget.email) {
                        return "Email is same as current email";
                      }
                      return AppValidator.validateEmail(value);
                    },
                  ),
                  VerticalSpace(height: 16),
                  CustomPasswordField(controller: _passwordController),
                  VerticalSpace(height: 16),
                  CustomConfirmPasswordField(
                    controller: _passwordController,
                    confirmController: _confirmPasswordController,
                  ),
                  VerticalSpace(height: 16),
                  BlocBuilder<EmailSettingsCubit, EmailSettingsState>(
                    builder: (context, state) {
                      bool isLoading = state is EmailSettingsLoadingState;
                      return CustomElevatedButton(
                        text: AppStrings.register,
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                if (_validateForm()) {
                                  if (widget.email.isEmpty) {
                                    context
                                        .read<EmailSettingsCubit>()
                                        .linkEmail(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                  } else {
                                    context
                                        .read<EmailSettingsCubit>()
                                        .updateEmail(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                  }
                                }
                              },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showVerificationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Verify Email"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "A verification email has been sent to your email address. "
                "Please verify your email to continue.",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
