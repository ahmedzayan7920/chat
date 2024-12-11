import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_strings.dart';
import '../../logic/profile_cubit.dart';
import '../../logic/profile_cubit_registration.dart';
import '../widgets/profile/profile_view_body.dart';

class ProfileView extends StatefulWidget {
  final String id;
  const ProfileView({super.key, required this.id});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.profile),
        ),
        body: const ProfileViewBody(),
      ),
    );
  }
}
