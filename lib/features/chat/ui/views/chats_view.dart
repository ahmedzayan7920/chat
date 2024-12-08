import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../logic/chats/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../../auth/logic/auth_state.dart';
import '../widgets/chats/chats_logout_button.dart';
import '../widgets/chats/chats_view_body.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(chatsRepository: getIt())
        ..fetchChats(
            (context.read<AuthCubit>().state as AuthenticatedState).user.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.chats),
          actions: const [
            ChatsLogoutButton(),
          ],
        ),
        body: const ChatsViewBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.users);
          },
          child: const Icon(Icons.chat_outlined),
        ),
      ),
    );
  }
}
