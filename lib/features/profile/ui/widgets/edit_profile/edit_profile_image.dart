import 'dart:io';

import 'package:chat/core/utils/app_media_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_circle_network_image.dart';
import '../../../logic/profile_cubit.dart';
import '../../../logic/profile_state.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({
    super.key,
  });

  _pickImage(BuildContext context) async {
    final pickedFile = await AppMediaPicker.pickMedia(isVideo: false);
    if (pickedFile != null && context.mounted) {
      context.read<ProfileCubit>().setImageFile(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profileCubit = context.read<ProfileCubit>();
        return Stack(
          children: [
            profileCubit.imageFile == null
                ? CustomCircleNetworkImage(
                    imageUrl: profileCubit.currentUser.profilePictureUrl,
                    radius: 60,
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(profileCubit.imageFile!),
                  ),
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
