import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chats/chats_cubit.dart';
import '../../../logic/chats/chats_state.dart';
import 'chats_view_success.dart';

class ChatsViewError extends StatelessWidget {
  const ChatsViewError({
    super.key,
    required this.currentUserId,
    required this.state,
  });

  final String currentUserId;
  final ChatsErrorState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child: Text(state.message)),
              IconButton(
                onPressed: () {
                  context
                      .read<ChatsCubit>()
                      .loadMoreChats(currentUserId: currentUserId);
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          if (state.currentChats.isNotEmpty)
            Expanded(
              child: ChatsViewSuccess(
                chats: state.currentChats,
                currentUserId: currentUserId,
                hasMore: false,
                isLoading: false,
              ),
            ),
        ],
      ),
    );
  }
}
