import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_strings.dart';
import '../../logic/users_cubit.dart';
import '../widgets/users_view_body.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UsersCubit(usersRepository: getIt())..fetchAllUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.users),
        ),
        body: const UsersViewBody(),
      ),
    );
  }
}
