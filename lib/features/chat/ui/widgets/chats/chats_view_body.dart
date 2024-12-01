import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../logic/chats/chats_cubit.dart';
import '../../../logic/chats/chats_state.dart';
import 'chats_view_success.dart';

class ChatsViewBody extends StatelessWidget {
  const ChatsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        if (state is ChatsLoadedState) {
          if (state.chats.isEmpty) {
            return const Center(
              child: Text(AppStrings.noChats),
            );
          }
          return ChatsViewSuccess(chats: state.chats);
        } else if (state is ChatsErrorState) {
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
