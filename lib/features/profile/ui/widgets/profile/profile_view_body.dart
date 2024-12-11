import 'package:chat/core/utils/app_strings.dart';
import 'package:chat/core/widgets/custom_elevated_button.dart';
import 'package:chat/core/widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/widgets/custom_circle_network_image.dart';
import '../../../logic/profile_cubit.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileCubit>().currentUser;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCircleNetworkImage(
            imageUrl: user.profilePictureUrl,
            radius: 60,
          ),
          VerticalSpace(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          VerticalSpace(height: 16),
          Text(
            user.status,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          VerticalSpace(height: 16),
          CustomElevatedButton(
            text: AppStrings.editProfile,
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.editProfile,
              );
            },
          ),
        ],
      ),
    );
  }
}
