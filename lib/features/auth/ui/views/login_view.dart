import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/spaces.dart';
import '../widgets/login/login_bloc_listener.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/no_account_section.dart';
import '../widgets/login/social_login_section.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const LoginBlocListener(),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const VerticalSpace(height: 16),
                Text(
                  AppStrings.welcomeBack,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const VerticalSpace(height: 16),
                const LoginForm(),
                const VerticalSpace(height: 16),
                const NoAccountSection(),
                const SocialLoginSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
