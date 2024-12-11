import 'package:chat/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/widgets/custom_circle_network_image.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../../auth/logic/auth_cubit.dart';
import '../../../../auth/logic/auth_state.dart';
import 'custom_drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<AuthCubit>().currentUser!;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CustomCircleNetworkImage(
                    imageUrl: currentUser.profilePictureUrl,
                    radius: 50,
                  ),
                  VerticalSpace(height: 16),
                  Text(
                    currentUser.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            const VerticalSpace(height: 24),
            CustomDrawerTile(
              title: "H O M E",
              icon: Icons.home,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            CustomDrawerTile(
              title: "P R O F I L E",
              icon: Icons.person,
              onTap: () {
                String id = context.read<AuthCubit>().currentUser!.id;
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  AppRoutes.profile,
                  arguments: id,
                );
              },
            ),
            CustomDrawerTile(
              title: "S E T T I N G S",
              icon: Icons.settings,
              onTap: () {},
            ),
            const Spacer(),
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is UnauthenticatedState) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              },
              child: CustomDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
