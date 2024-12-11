import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/functions/show_snack_bar.dart';
import '../../../../core/utils/app_strings.dart';
import '../../logic/profile_cubit.dart';
import '../../logic/profile_cubit_registration.dart';
import '../../logic/profile_state.dart';
import '../widgets/edit_profile/edit_profile_body.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with ProfileCubitRegistration {
  @override
  void initState() {
    super.initState();
    registerProfileCubit(context);
  }

  @override
  void dispose() {
    unregisterProfileCubit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccessState) {
            Navigator.of(context).pop();
          } else if (state is ProfileFailureState) {
            showSnackBar(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.editProfile),
          ),
          body: const EditProfileBody(),
        ),
      ),
    );
  }
}
