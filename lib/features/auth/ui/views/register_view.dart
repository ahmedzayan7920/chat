import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/spaces.dart';
import '../widgets/register/have_account_section.dart';
import '../widgets/register/register_bloc_listener.dart';
import '../widgets/register/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const RegisterBlocListener(),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const VerticalSpace(height: 16),
                Text(
                  AppStrings.registerStart,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const VerticalSpace(height: 16),
                const RegisterForm(),
                const VerticalSpace(height: 16),
                const HaveAccountSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
