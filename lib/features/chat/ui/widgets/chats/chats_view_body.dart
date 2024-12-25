import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/logic/auth_cubit.dart';
import '../../../logic/chats/chats_cubit.dart';
import '../../../logic/chats/chats_state.dart';
import 'chats_view_error.dart';
import 'chats_view_success.dart';

class ChatsViewBody extends StatelessWidget {
  const ChatsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        final currentUserId = (context.read<AuthCubit>().currentUser!.id);
        return switch (state) {
          ChatsErrorState() => ChatsViewError(
              currentUserId: currentUserId,
              state: state,
            ),
          ChatsLoadingState(isLoadingMore: false) =>
            const Center(child: CircularProgressIndicator()),
          ChatsLoadingState(isLoadingMore: true) => ChatsViewSuccess(
              chats: state.currentChats,
              currentUserId: currentUserId,
              hasMore: true,
              isLoading: true,
            ),
          ChatsLoadedState() => ChatsViewSuccess(
              chats: state.chats,
              currentUserId: currentUserId,
              hasMore: state.hasMore,
              isLoading: false,
            ),
          ChatsInitialState() =>
            const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}
