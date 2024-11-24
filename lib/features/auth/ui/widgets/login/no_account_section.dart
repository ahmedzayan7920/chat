import 'package:flutter/material.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_strings.dart';

class NoAccountSection extends StatelessWidget {
  const NoAccountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.noAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.register,
            );
          },
          child: Text(
            AppStrings.registerNow,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
        ),
      ],
    );
  }
}
