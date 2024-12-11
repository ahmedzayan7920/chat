import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../logic/profile_cubit.dart';
import '../../../logic/profile_state.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    super.key,
    required this.nameController,
    required this.statusController,
    required this.validateForm,
  });

  final TextEditingController nameController;
  final TextEditingController statusController;
  final bool Function() validateForm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CustomElevatedButton(
          text: AppStrings.save,
          isLoading: state is ProfileLoadingState,
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (validateForm()) {
              final user = context.read<ProfileCubit>().currentUser;
              context.read<ProfileCubit>().updateUserProfile(
                    userModel: user.copyWith(
                      name: nameController.text,
                      status: statusController.text,
                    ),
                  );
            }
          },
        );
      },
    );
  }
}
