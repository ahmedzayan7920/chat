import 'package:chat/core/utils/app_phone_link_or_update.dart';
import 'package:chat/features/chat/ui/widgets/common/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../logic/chats/chats_cubit.dart';
import '../widgets/chats/chats_view_body.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppPhoneLinkOrUpdate.checkAndShowPhoneBottomSheetForLink(
          context: context,
        );
        context.read<AuthCubit>().updateUserEmail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(chatsRepository: getIt())
        ..fetchChats(
            currentUserId: (context.read<AuthCubit>().currentUser!.id)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.chats),
          titleSpacing: 0,
        ),
        body: const ChatsViewBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.users);
          },
          child: const Icon(Icons.chat_outlined),
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}
