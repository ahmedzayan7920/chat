import 'package:chat/core/utils/app_images.dart';
import 'package:chat/core/utils/app_routes.dart';
import 'package:chat/core/utils/app_strings.dart';
import 'package:chat/core/widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/auth_cubit.dart';
import 'social_item.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const HorizontalSpace(width: 16),
            Text(
              AppStrings.loginWith,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const HorizontalSpace(width: 16),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const VerticalSpace(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialItem(
              image: AppImages.googleSvg,
              onTap: () {
                context.read<AuthCubit>().loginWithGoogle();
              },
            ),
            const HorizontalSpace(width: 16),
            SocialItem(
              image: AppImages.facebookSvg,
              onTap: () {
                context.read<AuthCubit>().loginWithFacebook();
              },
            ),
            const HorizontalSpace(width: 16),
            SocialItem(
              image: AppImages.phoneSvg,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.phoneAuth);
              },
            ),
          ],
        ),
      ],
    );
  }
}
