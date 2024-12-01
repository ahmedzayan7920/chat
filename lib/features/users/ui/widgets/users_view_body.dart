import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/users_cubit.dart';
import '../../logic/users_state.dart';
import 'users_view_success.dart';

class UsersViewBody extends StatelessWidget {
  const UsersViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersLoadedState) {
          return UsersViewSuccess(users: state.users);
        } else if (state is UsersErrorState) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}